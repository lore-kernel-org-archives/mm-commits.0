From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-memcg-fix-potential-undefined-behavior-in-mem=5Fcgro?=
 =?US-ASCII?Q?up=5Fevent=5Fratelimit.patch?= removed from -mm tree
Date: Tue, 11 Jul 2017 12:24:06 -0700
Message-ID: <20170711192406.CDbnOIMy3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbdGKTYH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alicef@gentoo.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: fix potential undefined behavior in mem_cgroup_event_ratelimit()
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memcg: fix potential undefined behavior in mem_cgroup_event_ratelimit()

Alice has reported the following UBSAN splat:
kernel: UBSAN: Undefined behaviour in mm/memcontrol.c:661:17
kernel: signed integer overflow:
kernel: -2147483644 - 2147483525 cannot be represented in type 'long int'
kernel: CPU: 1 PID: 11758 Comm: mybibtex2filena Tainted: P           O 4.9.25-gentoo #4
kernel: Hardware name: XXXXXX, BIOS YYYYYY
kernel: e9a3bd64 d1f444f2 00000007 e9a3bd94 7fffff85 e9a3bd74 d1fc8ffe e9a3bd74
kernel: d2b4ef1c e9a3bdf8 d1fc934b d28b15c0 e9a3bd98 0000002d e9a3bdc0 d2b4ef1c
kernel: 0000002d 00000002 3431322d 33383437 00343436 d1700ca2 00000000 ecb4effc
kernel: Call Trace:
kernel: [<d1f444f2>] dump_stack+0x59/0x87
kernel: [<d1fc8ffe>] ubsan_epilogue+0xe/0x40
kernel: [<d1fc934b>] handle_overflow+0xbb/0xf0
kernel: [<d1700ca2>] ? update_curr+0xe2/0x500
kernel: [<d1fc93b2>] __ubsan_handle_sub_overflow+0x12/0x20
kernel: [<d196a553>] memcg_check_events.isra.36+0x223/0x360
kernel: [<d1f44281>] ? cpumask_any_but+0x31/0x60
kernel: [<d19709c5>] mem_cgroup_commit_charge+0x55/0x140
kernel: [<d1925b42>] ? ptep_clear_flush+0x72/0xb0
kernel: [<d19017de>] wp_page_copy+0x34e/0xb80
kernel: [<d19037a6>] do_wp_page+0x1e6/0x1300
kernel: [<d16f0350>] ? check_preempt_curr+0x110/0x230
kernel: [<d1695de6>] ? kmap_atomic_prot+0x126/0x210
kernel: [<d1909b3b>] handle_mm_fault+0x88b/0x1990
kernel: [<d16a1905>] ? _do_fork+0x155/0x5b0
kernel: [<d1689e3e>] __do_page_fault+0x2de/0x8a0
kernel: [<d16a1e27>] ? SyS_clone+0x27/0x30
kernel: [<d168a400>] ? __do_page_fault+0x8a0/0x8a0
kernel: [<d168a41a>] do_page_fault+0x1a/0x20
kernel: [<d265a35b>] error_code+0x67/0x6c

The reason is that we subtract two signed types.  Let's fix this by truly
mimicing time_after and cast the result of the subtraction.

Link: http://lkml.kernel.org/r/20170616150057.GQ30580@dhcp22.suse.cz
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Alice Ferrazzi <alicef@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit
+++ a/mm/memcontrol.c
@@ -631,7 +631,7 @@ static bool mem_cgroup_event_ratelimit(s
 	val = __this_cpu_read(memcg->stat->nr_page_events);
 	next = __this_cpu_read(memcg->stat->targets[target]);
 	/* from time_after() in jiffies.h */
-	if ((long)next - (long)val < 0) {
+	if ((long)(next - val) < 0) {
 		switch (target) {
 		case MEM_CGROUP_TARGET_THRESH:
 			next = val + THRESHOLDS_EVENTS_TARGET;
_

Patches currently in -mm which might be from mhocko@suse.com are

netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

