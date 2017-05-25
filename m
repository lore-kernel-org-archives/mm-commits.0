From: akpm@linux-foundation.org
Subject: +
 mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2.patch added to -mm tree
Date: Thu, 25 May 2017 15:46:23 -0700
Message-ID: <59275ebf.J2Z9kk9uuHWKdJS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030517AbdEYWqc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, cl@linux.com, iamjoonsoo.kim@lge.com, manoj.iyer@canonical.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix refcount handling when !hugepage_migration_supported()
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm/migrate: fix refcount handling when !hugepage_migration_supported()

On failing to migrate a page, soft_offline_huge_page() performs the
necessary update to the hugepage ref-count.  When
!hugepage_migration_supported() , unmap_and_move_hugepage() also
decrements the page ref-count for the hugepage.  The combined behaviour
leaves the ref-count in an inconsistent state.

This leads to soft lockups when running the overcommitted hugepage test
from mce-tests suite.

Soft offlining pfn 0x83ed600 at process virtual address 0x400000000000
soft offline: 0x83ed600: migration failed 1, type
1fffc00000008008 (uptodate|head)
INFO: rcu_preempt detected stalls on CPUs/tasks:
 Tasks blocked on level-0 rcu_node (CPUs 0-7): P2715
  (detected by 7, t=5254 jiffies, g=963, c=962, q=321)
  thugetlb_overco R  running task        0  2715   2685 0x00000008
  Call trace:
  [<ffff000008089f90>] dump_backtrace+0x0/0x268
  [<ffff00000808a2d4>] show_stack+0x24/0x30
  [<ffff000008100d34>] sched_show_task+0x134/0x180
  [<ffff0000081c90fc>] rcu_print_detail_task_stall_rnp+0x54/0x7c
  [<ffff00000813cfd4>] rcu_check_callbacks+0xa74/0xb08
  [<ffff000008143a3c>] update_process_times+0x34/0x60
  [<ffff0000081550e8>] tick_sched_handle.isra.7+0x38/0x70
  [<ffff00000815516c>] tick_sched_timer+0x4c/0x98
  [<ffff0000081442e0>] __hrtimer_run_queues+0xc0/0x300
  [<ffff000008144fa4>] hrtimer_interrupt+0xac/0x228
  [<ffff0000089a56d4>] arch_timer_handler_phys+0x3c/0x50
  [<ffff00000812f1bc>] handle_percpu_devid_irq+0x8c/0x290
  [<ffff0000081297fc>] generic_handle_irq+0x34/0x50
  [<ffff000008129f00>] __handle_domain_irq+0x68/0xc0
  [<ffff0000080816b4>] gic_handle_irq+0x5c/0xb0

Address this by changing the putback_active_hugepage() in
soft_offline_huge_page() to putback_movable_pages().

Link: http://lkml.kernel.org/r/20170525135146.32011-1-punit.agrawal@arm.com
Reported-by: Manoj Iyer <manoj.iyer@canonical.com>
Tested-by: Manoj Iyer <manoj.iyer@canonical.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[3.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2 mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2
+++ a/mm/memory-failure.c
@@ -1600,7 +1600,8 @@ static int soft_offline_huge_page(struct
 		 * only one hugepage pointed to by hpage, so we need not
 		 * run through the pagelist here.
 		 */
-		putback_active_hugepage(hpage);
+		if (!list_empty(&pagelist))
+			putback_movable_pages(&pagelist);
 		if (ret > 0)
 			ret = -EIO;
 	} else {
_

Patches currently in -mm which might be from punit.agrawal@arm.com are

mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2.patch
mm-gup-ensure-real-head-page-is-ref-counted-when-using-hugepages.patch
mm-hugetlb-add-size-parameter-to-huge_pte_offset.patch
mm-hugetlb-allow-architectures-to-override-huge_pte_clear.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v4.patch
mm-hugetlb-introduce-set_huge_swap_pte_at-helper-v41.patch
mm-rmap-use-correct-helper-when-poisoning-hugepages.patch

