From: akpm@linux-foundation.org
Subject: [folded-merged] mm-mmapc-use-while-instead-of-ifgoto-fix.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 15:39:25 -0700
Message-ID: <552ee89d.FIjAtXx+LYsLiYDF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbbDOWjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gorcunov@openvz.org, hughd@google.com, kirill.shutemov@linux.intel.com, klamm@yandex-team.ru, linux@rasmusvillemoes.dk, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmapc-use-while-instead-of-ifgoto-fix
has been removed from the -mm tree.  Its filename was
     mm-mmapc-use-while-instead-of-ifgoto-fix.patch

This patch was dropped because it was folded into mm-mmapc-use-while-instead-of-ifgoto.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmapc-use-while-instead-of-ifgoto-fix

fix 80-col overflows

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-use-while-instead-of-ifgoto-fix
+++ a/mm/mmap.c
@@ -1551,7 +1551,8 @@ unsigned long mmap_region(struct file *f
 
 	/* Clear old maps */
 	error = -ENOMEM;
-	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
+			      &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
 	}
@@ -1569,7 +1570,8 @@ unsigned long mmap_region(struct file *f
 	/*
 	 * Can we just expand an old mapping?
 	 */
-	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff, NULL);
+	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff,
+			NULL);
 	if (vma)
 		goto out;
 
@@ -2737,7 +2739,8 @@ static unsigned long do_brk(unsigned lon
 	/*
 	 * Clear old maps.  this also does some error checking for us
 	 */
-	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
+	while (find_vma_links(mm, addr, addr + len, &prev, &rb_link,
+			      &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

