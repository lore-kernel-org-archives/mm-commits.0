From: akpm@osdl.org
Subject: - mips-fix-cow-d-cache-aliasing-on-fork.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:21:04 -0800
Message-ID: <200612140621.kBE6L3K3002418@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbWLNGVb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MIPS: Fix COW D-cache aliasing on fork
has been removed from the -mm tree.  Its filename was
     mips-fix-cow-d-cache-aliasing-on-fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MIPS: Fix COW D-cache aliasing on fork
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Provide a custom copy_user_highpage() to deal with aliasing issues on
MIPS.  It uses kmap_coherent() to map an user page for kernel with same
color.  Rewrite copy_to_user_page() and copy_from_user_page() with the
new interfaces to avoid extra cache flushing.

The main part of this patch was originally written by Ralf Baechle;
Atushi Nemoto did the the debugging.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/mm/init.c     |   25 +++++++++++++++++++++++++
 include/asm-mips/page.h |   16 ++++++----------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff -puN arch/mips/mm/init.c~mips-fix-cow-d-cache-aliasing-on-fork arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mips-fix-cow-d-cache-aliasing-on-fork
+++ a/arch/mips/mm/init.c
@@ -203,6 +203,31 @@ static inline void kunmap_coherent(struc
 	preempt_check_resched();
 }
 
+void copy_user_highpage(struct page *to, struct page *from,
+	unsigned long vaddr, struct vm_area_struct *vma)
+{
+	void *vfrom, *vto;
+
+	vto = kmap_atomic(to, KM_USER1);
+	if (cpu_has_dc_aliases) {
+		vfrom = kmap_coherent(from, vaddr);
+		copy_page(vto, vfrom);
+		kunmap_coherent(from);
+	} else {
+		vfrom = kmap_atomic(from, KM_USER0);
+		copy_page(vto, vfrom);
+		kunmap_atomic(vfrom, KM_USER0);
+	}
+	if (((vma->vm_flags & VM_EXEC) && !cpu_has_ic_fills_f_dc) ||
+	    pages_do_alias((unsigned long)vto, vaddr & PAGE_MASK))
+		flush_data_cache_page((unsigned long)vto);
+	kunmap_atomic(vto, KM_USER1);
+	/* Make sure this page is cleared on other CPU's too before using it */
+	smp_wmb();
+}
+
+EXPORT_SYMBOL(copy_user_highpage);
+
 void copy_to_user_page(struct vm_area_struct *vma,
 	struct page *page, unsigned long vaddr, void *dst, const void *src,
 	unsigned long len)
diff -puN include/asm-mips/page.h~mips-fix-cow-d-cache-aliasing-on-fork include/asm-mips/page.h
--- a/include/asm-mips/page.h~mips-fix-cow-d-cache-aliasing-on-fork
+++ a/include/asm-mips/page.h
@@ -35,7 +35,6 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/pfn.h>
-#include <asm/cpu-features.h>
 #include <asm/io.h>
 
 extern void clear_page(void * page);
@@ -61,16 +60,13 @@ static inline void clear_user_page(void 
 		flush_data_cache_page((unsigned long)addr);
 }
 
-static inline void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
-	struct page *to)
-{
-	extern void (*flush_data_cache_page)(unsigned long addr);
+extern void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
+	struct page *to);
+struct vm_area_struct;
+extern void copy_user_highpage(struct page *to, struct page *from,
+	unsigned long vaddr, struct vm_area_struct *vma);
 
-	copy_page(vto, vfrom);
-	if (!cpu_has_ic_fills_f_dc ||
-	    pages_do_alias((unsigned long)vto, vaddr & PAGE_MASK))
-		flush_data_cache_page((unsigned long)vto);
-}
+#define __HAVE_ARCH_COPY_USER_HIGHPAGE
 
 /*
  * These are used to make use of C type-checking..
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are


