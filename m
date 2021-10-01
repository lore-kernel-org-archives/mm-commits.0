Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E12EC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 22:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30ED261AF7
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 22:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356088AbhJAWw3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 18:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356089AbhJAWw2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 18:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3ACD61B03;
        Fri,  1 Oct 2021 22:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633128644;
        bh=rv+1BDFDs5g1B1ynqbt2oV/WYEiLzamQaoTiMAvNoOc=;
        h=Date:From:To:Subject:From;
        b=gCqZhbfSTnA8B16no89+m58Gjfy2hXpfITdX85pgQ87A9660Vvf8WvFexRXssNDf8
         Dem2yRSrhBkJGZjEQyeLmckQHnNaR8YIr3ln+JguwOcm1F9I92h4QLL3HMxCD3c61K
         F2xYhfYCB2+0HUO7oSkc1+ww6eHZ2zz0uJbH2pks=
Date:   Fri, 01 Oct 2021 15:50:43 -0700
From:   akpm@linux-foundation.org
To:     edumazet@google.com, mgorman@suse.de, mm-commits@vger.kernel.org,
        syzkaller@googlegroups.com, ying.huang@intel.com
Subject:  +
 =?US-ASCII?Q?mm-mempolicy-do-not-allow-illegal-mpol=5Ff=5Fnuma=5Fbalanci?=
 =?US-ASCII?Q?ng-mpol=5Flocal-in-mbind.patch?= added to -mm tree
Message-ID: <20211001225043.TfQYALm7E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: do not allow illegal MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/mempolicy: do not allow illegal MPOL_F_NUMA_BALANCING | MPOL_LOCAL in mbind()

syzbot reported access to unitialized memory in mbind() [1]

Issue came with commit bda420b98505 ("numa balancing: migrate on fault
among multiple bound nodes")

This commit added a new bit in MPOL_MODE_FLAGS, but only checked valid
combination (MPOL_F_NUMA_BALANCING can only be used with MPOL_BIND) in
do_set_mempolicy()

This patch moves the check in sanitize_mpol_flags() so that it is also
used by mbind()

[1]
BUG: KMSAN: uninit-value in __mpol_equal+0x567/0x590 mm/mempolicy.c:2260
 __mpol_equal+0x567/0x590 mm/mempolicy.c:2260
 mpol_equal include/linux/mempolicy.h:105 [inline]
 vma_merge+0x4a1/0x1e60 mm/mmap.c:1190
 mbind_range+0xcc8/0x1e80 mm/mempolicy.c:811
 do_mbind+0xf42/0x15f0 mm/mempolicy.c:1333
 kernel_mbind mm/mempolicy.c:1483 [inline]
 __do_sys_mbind mm/mempolicy.c:1490 [inline]
 __se_sys_mbind+0x437/0xb80 mm/mempolicy.c:1486
 __x64_sys_mbind+0x19d/0x200 mm/mempolicy.c:1486
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_alloc_node mm/slub.c:3221 [inline]
 slab_alloc mm/slub.c:3230 [inline]
 kmem_cache_alloc+0x751/0xff0 mm/slub.c:3235
 mpol_new mm/mempolicy.c:293 [inline]
 do_mbind+0x912/0x15f0 mm/mempolicy.c:1289
 kernel_mbind mm/mempolicy.c:1483 [inline]
 __do_sys_mbind mm/mempolicy.c:1490 [inline]
 __se_sys_mbind+0x437/0xb80 mm/mempolicy.c:1486
 __x64_sys_mbind+0x19d/0x200 mm/mempolicy.c:1486
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
=====================================================
Kernel panic - not syncing: panic_on_kmsan set ...
CPU: 0 PID: 15049 Comm: syz-executor.0 Tainted: G    B             5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ff/0x28e lib/dump_stack.c:106
 dump_stack+0x25/0x28 lib/dump_stack.c:113
 panic+0x44f/0xdeb kernel/panic.c:232
 kmsan_report+0x2ee/0x300 mm/kmsan/report.c:186
 __msan_warning+0xd7/0x150 mm/kmsan/instrumentation.c:208
 __mpol_equal+0x567/0x590 mm/mempolicy.c:2260
 mpol_equal include/linux/mempolicy.h:105 [inline]
 vma_merge+0x4a1/0x1e60 mm/mmap.c:1190
 mbind_range+0xcc8/0x1e80 mm/mempolicy.c:811
 do_mbind+0xf42/0x15f0 mm/mempolicy.c:1333
 kernel_mbind mm/mempolicy.c:1483 [inline]
 __do_sys_mbind mm/mempolicy.c:1490 [inline]
 __se_sys_mbind+0x437/0xb80 mm/mempolicy.c:1486
 __x64_sys_mbind+0x19d/0x200 mm/mempolicy.c:1486
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4a41b2c709
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4a3f0a3188 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
RAX: ffffffffffffffda RBX: 00007f4a41c30f60 RCX: 00007f4a41b2c709
RDX: 0000000000002001 RSI: 0000000000c00007 RDI: 0000000020012000
RBP: 00007f4a41b86cb4 R08: 0000000000000000 R09: 0000010000000002
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4a42164b2f R14: 00007f4a3f0a3300 R15: 0000000000022000

Link: https://lkml.kernel.org/r/20211001215630.810592-1-eric.dumazet@gmail.com
Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind
+++ a/mm/mempolicy.c
@@ -856,16 +856,6 @@ static long do_set_mempolicy(unsigned sh
 		goto out;
 	}
 
-	if (flags & MPOL_F_NUMA_BALANCING) {
-		if (new && new->mode == MPOL_BIND) {
-			new->flags |= (MPOL_F_MOF | MPOL_F_MORON);
-		} else {
-			ret = -EINVAL;
-			mpol_put(new);
-			goto out;
-		}
-	}
-
 	ret = mpol_set_nodemask(new, nodes, scratch);
 	if (ret) {
 		mpol_put(new);
@@ -1458,7 +1448,11 @@ static inline int sanitize_mpol_flags(in
 		return -EINVAL;
 	if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
 		return -EINVAL;
-
+	if (*flags & MPOL_F_NUMA_BALANCING) {
+		if (*mode != MPOL_BIND)
+			return -EINVAL;
+		*flags |= (MPOL_F_MOF | MPOL_F_MORON);
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from edumazet@google.com are

mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind.patch
mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch
mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch

