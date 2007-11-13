From: akpm@linux-foundation.org
Subject: + arch_rebalance_pgtables-call.patch added to -mm tree
Date: Mon, 12 Nov 2007 18:09:03 -0800
Message-ID: <200711130209.lAD293oT021305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601AbXKMCJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 21:09:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwidefsky@de.ibm.com, benh@kernel.crashing.org, linux-arch@vger.kernel.org


The patch titled
     arch_rebalance_pgtables call
has been added to the -mm tree.  Its filename is
     arch_rebalance_pgtables-call.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arch_rebalance_pgtables call
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

In order to change the layout of the page tables after an mmap has crossed the
adress space limit of the current page table layout a architecture hook in
get_unmapped_area is needed.  The arguments are the address of the new mapping
and the length of it.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~arch_rebalance_pgtables-call mm/mmap.c
--- a/mm/mmap.c~arch_rebalance_pgtables-call
+++ a/mm/mmap.c
@@ -36,6 +36,10 @@
 #define arch_mmap_check(addr, len, flags)	(0)
 #endif
 
+#ifndef arch_rebalance_pgtables
+#define arch_rebalance_pgtables(addr, len)		(addr)
+#endif
+
 static void unmap_region(struct mm_struct *mm,
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
@@ -1421,7 +1425,7 @@ get_unmapped_area(struct file *file, uns
 	if (addr & ~PAGE_MASK)
 		return -EINVAL;
 
-	return addr;
+	return arch_rebalance_pgtables(addr, len);
 }
 
 EXPORT_SYMBOL(get_unmapped_area);
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

git-s390.patch
s390-cmm-remove-unused-binary-sysctls.patch
git-scsi-misc.patch
add-mm-argument-to-pte-pmd-pud-pgd_free.patch
config_highpte-vs-sub-page-page-tables.patch
arch_rebalance_pgtables-call.patch
taskstats-scaled-time-cleanup.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-s390.patch
