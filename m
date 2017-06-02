From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch removed from -mm tree
Date: Fri, 02 Jun 2017 14:41:32 -0700
Message-ID: <5931db8c.rPjfzEj+9Ndu7E3O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49444 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVle (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, manoj.iyer@canonical.com, mgorman@techsingularity.net, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, wanpeng.li@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2-fix.patch

This patch was dropped because it was folded into mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2.patch

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
mm-migrate-fix-ref-count-handling-when-hugepage_migration_supported-v2.patch
mm-hugetlb-report-ehwpoison-not-efault-when-foll_hwpoison-is-specified-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

