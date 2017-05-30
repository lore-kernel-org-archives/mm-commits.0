From: akpm@linux-foundation.org
Subject: +
 mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch added to -mm tree
Date: Tue, 30 May 2017 12:35:55 -0700
Message-ID: <592dc99b.O07EDKshzPByrdLe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdE3Tf4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 15:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, manoj.iyer@canonical.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix

remove dead comment, per Naoya

Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>
Cc: Wanpeng Li <wanpeng.li@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/memory-failure.c~mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix
+++ a/mm/memory-failure.c
@@ -1595,11 +1595,6 @@ static int soft_offline_huge_page(struct
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx (%pGp)\n",
 			pfn, ret, page->flags, &page->flags);
-		/*
-		 * We know that soft_offline_huge_page() tries to migrate
-		 * only one hugepage pointed to by hpage, so we need not
-		 * run through the pagelist here.
-		 */
 		if (!list_empty(&pagelist))
 			putback_movable_pages(&pagelist);
 		if (ret > 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-make-kswapd-try-harder-to-keep-active-pages-in-cache-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

