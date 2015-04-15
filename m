From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch removed from -mm tree
Date: Wed, 15 Apr 2015 15:43:52 -0700
Message-ID: <552ee9a8.4/BcuI9EIHh/cfK7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbDOWnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, kirill@shutemov.name, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch

This patch was dropped because it was folded into mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix

use pr_alert, per Kirill

Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix mm/memory.c
--- a/mm/memory.c~mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix
+++ a/mm/memory.c
@@ -690,12 +690,11 @@ static void print_bad_pte(struct vm_area
 	/*
 	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
 	 */
-	printk(KERN_ALERT
-		"file:%pD fault:%pf mmap:%pf readpage:%pf\n",
-		vma->vm_file,
-		vma->vm_ops ? vma->vm_ops->fault : NULL,
-		vma->vm_file ? vma->vm_file->f_op->mmap : NULL,
-		mapping ? mapping->a_ops->readpage : NULL);
+	pr_alert("file:%pD fault:%pf mmap:%pf readpage:%pf\n",
+		 vma->vm_file,
+		 vma->vm_ops ? vma->vm_ops->fault : NULL,
+		 vma->vm_file ? vma->vm_file->f_op->mmap : NULL,
+		 mapping ? mapping->a_ops->readpage : NULL);
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

