From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported.patch
 removed from -mm tree
Date: Thu, 25 May 2017 15:45:10 -0700
Message-ID: <59275e76.oxFkDgUw7WvaC8iZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45086 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165891AbdEYWpL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, cl@linux.com, iamjoonsoo.kim@lge.com, liwanp@linux.vnet.ibm.com, manoj.iyer@canonical.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: fix refcount handling when !hugepage_migration_supported()
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm/migrate.c: fix refcount handling when !hugepage_migration_supported()

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

Fix this by dropping the ref-count decrement in unmap_and_move_hugepage()
when !hugepage_migration_supported().

Link: http://lkml.kernel.org/r/20170524154728.2492-1-punit.agrawal@arm.com
Fixes: 32665f2bbfed ("mm/migrate: correct failure handling if !hugepage_migration_support()")
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reported-by: Manoj Iyer <manoj.iyer@canonical.com>
Tested-By: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/migrate.c~mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported mm/migrate.c
--- a/mm/migrate.c~mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported
+++ a/mm/migrate.c
@@ -1201,10 +1201,8 @@ static int unmap_and_move_huge_page(new_
 	 * tables or check whether the hugepage is pmd-based or not before
 	 * kicking migration.
 	 */
-	if (!hugepage_migration_supported(page_hstate(hpage))) {
-		putback_active_hugepage(hpage);
+	if (!hugepage_migration_supported(page_hstate(hpage)))
 		return -ENOSYS;
-	}
 
 	new_hpage = get_new_page(hpage, private, &result);
 	if (!new_hpage)
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

