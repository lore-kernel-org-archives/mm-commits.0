From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 mm-memcontrol-handle-div0-crash-race-condition-in-memorylow.patch removed
 from -mm tree
Date: Fri, 26 Jun 2020 20:33:46 -0700
Message-ID: <20200627033346.uM9eRcQFS%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgF0Ddr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:47 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm: memcontrol: handle div0 crash race condition in memory.low
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-handle-div0-crash-race-condition-in-memorylow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: handle div0 crash race condition in memory.low

Tejun reports seeing rare div0 crashes in memory.low stress testing:

[37228.504582] RIP: 0010:mem_cgroup_calculate_protection+0xed/0x150
[37228.505059] Code: 0f 46 d1 4c 39 d8 72 57 f6 05 16 d6 42 01 40 74 1f 4c 39 d8 76 1a 4c 39 d1 76 15 4c 29 d1 4c 29 d8 4d 29 d9 31 d2 48 0f af c1 <49> f7 f1 49 01 c2 4c 89 96 38 01 00 00 5d c3 48 0f af c7 31 d2 49
[37228.506254] RSP: 0018:ffffa14e01d6fcd0 EFLAGS: 00010246
[37228.506769] RAX: 000000000243e384 RBX: 0000000000000000 RCX: 0000000000008f4b
[37228.507319] RDX: 0000000000000000 RSI: ffff8b89bee84000 RDI: 0000000000000000
[37228.507869] RBP: ffffa14e01d6fcd0 R08: ffff8b89ca7d40f8 R09: 0000000000000000
[37228.508376] R10: 0000000000000000 R11: 00000000006422f7 R12: 0000000000000000
[37228.508881] R13: ffff8b89d9617000 R14: ffff8b89bee84000 R15: ffffa14e01d6fdb8
[37228.509397] FS:  0000000000000000(0000) GS:ffff8b8a1f1c0000(0000) knlGS:0000000000000000
[37228.509917] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37228.510442] CR2: 00007f93b1fc175b CR3: 000000016100a000 CR4: 0000000000340ea0
[37228.511076] Call Trace:
[37228.511561]  shrink_node+0x1e5/0x6c0
[37228.512044]  balance_pgdat+0x32d/0x5f0
[37228.512521]  kswapd+0x1d7/0x3d0
[37228.513346]  ? wait_woken+0x80/0x80
[37228.514170]  kthread+0x11c/0x160
[37228.514983]  ? balance_pgdat+0x5f0/0x5f0
[37228.515797]  ? kthread_park+0x90/0x90
[37228.516593]  ret_from_fork+0x1f/0x30

This happens when parent_usage == siblings_protected.  We check that usage
is bigger than protected, which should imply parent_usage being bigger
than siblings_protected.  However, we don't read (or even update) these
values atomically, and they can be out of sync as the memory state changes
under us.  A bit of fluctuation around the target protection isn't a big
deal, but we need to handle the div0 case.

Check the parent state explicitly to make sure we have a reasonable
positive value for the divisor.

Link: http://lkml.kernel.org/r/20200615140658.601684-1-hannes@cmpxchg.org
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-handle-div0-crash-race-condition-in-memorylow
+++ a/mm/memcontrol.c
@@ -6360,11 +6360,16 @@ static unsigned long effective_protectio
 	 * We're using unprotected memory for the weight so that if
 	 * some cgroups DO claim explicit protection, we don't protect
 	 * the same bytes twice.
+	 *
+	 * Check both usage and parent_usage against the respective
+	 * protected values. One should imply the other, but they
+	 * aren't read atomically - make sure the division is sane.
 	 */
 	if (!(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT))
 		return ep;
