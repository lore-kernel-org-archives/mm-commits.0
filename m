From: akpm@linux-foundation.org
Subject: - ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:02:47 -0700
Message-ID: <200710160402.l9G42lmd007774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011AbXJPEDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@gmail.com, apw@shadowen.org, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function fix
has been removed from the -mm tree.  Its filename was
     ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch

This patch was dropped because it was folded into ppc64-sparsemem_vmemmap-support.patch

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

 arch/powerpc/mm/init_64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix
+++ a/arch/powerpc/mm/init_64.c
@@ -192,10 +192,9 @@ void pgtable_cache_init(void)
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

ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops-fix.patch
mem-controller-gfp-mask-fix.patch
