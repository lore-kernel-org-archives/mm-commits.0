From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 18 Apr 2017 14:39:56 -0700
Message-ID: <58f687ac.XzyIRddZixQRD0BI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38032 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbdDRVj5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 17:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, brouer@redhat.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#19: 
patch, the result wiill be to revert 374ad05ab64d and try again at a later

ERROR: space prohibited before that close parenthesis ')'
#120: FILE: mm/page_alloc.c:2722:
+	if (likely(order == 0) && !(in_irq() || irqs_disabled()) ) {

total: 2 errors, 0 warnings, 75 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -2719,7 +2719,7 @@ struct page *rmqueue(struct zone *prefer
 	 * Exclude (hard) IRQ and NMI context from using the pcplists.
 	 * But allow softirq context, via disabling BH.
 	 */
-	if (likely(order == 0) && !(in_irq() || irqs_disabled()) ) {
+	if (likely(order == 0) && !(in_irq() || irqs_disabled())) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
 				gfp_flags, migratetype);
 		goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

