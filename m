From: akpm@linux-foundation.org
Subject: + ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch added to -mm tree
Date: Tue, 25 Sep 2007 15:16:50 -0700
Message-ID: <200709252216.l8PMGppf007053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbXIYWSa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 18:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@gmail.com, apw@shadowen.org, pbadari@us.ibm.com


The patch titled
     ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function fix
has been added to the -mm tree.  Its filename is
     ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function fix
From: Badari Pulavarty <pbadari@gmail.com>

arch/powerpc/mm/init_64.c: In function `vmemmap_populated':
arch/powerpc/mm/init_64.c:211: warning: passing arg 1 of `vmemmap_section_start' makes pointer from integer without a cast

vmemmap_section_start() gets called with an argument which is unsigned long.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix
+++ a/arch/powerpc/mm/init_64.c
@@ -190,10 +190,9 @@ void pgtable_cache_init(void)
  * do this by hand as the proffered address may not be correctly aligned.
  * Subtraction of non-aligned pointers produces undefined results.
  */
-unsigned long __meminit vmemmap_section_start(struct page *page)
+unsigned long __meminit vmemmap_section_start(unsigned long page)
 {
-	unsigned long offset = ((unsigned long)page) -
-						((unsigned long)(vmemmap));
+	unsigned long offset = page - ((unsigned long)(vmemmap));
 
 	/* Return the pfn of the start of the section. */
 	return (offset / sizeof(struct page)) & PAGE_SECTION_MASK;
_

Patches currently in -mm which might be from pbadari@gmail.com are

ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch
mem-controller-gfp-mask-fix.patch
