From: akpm@linux-foundation.org
Subject: + mm-early_ioremap-use-offset_in_page-macro.patch added to -mm
 tree
Date: Tue, 15 Sep 2015 15:22:41 -0700
Message-ID: <55f89a31.qmZIpJjy9Kvr4Vel%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbIOWWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/early_ioremap: use offset_in_page macro
has been added to the -mm tree.  Its filename is
     mm-early_ioremap-use-offset_in_page-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-early_ioremap-use-offset_in_page-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-early_ioremap-use-offset_in_page-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/early_ioremap: use offset_in_page macro

linux/mm.h provides offset_in_page() macro.  Let's use already predefined
macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/early_ioremap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/early_ioremap.c~mm-early_ioremap-use-offset_in_page-macro mm/early_ioremap.c
--- a/mm/early_ioremap.c~mm-early_ioremap-use-offset_in_page-macro
+++ a/mm/early_ioremap.c
@@ -126,7 +126,7 @@ __early_ioremap(resource_size_t phys_add
 	/*
 	 * Mappings have to be page-aligned
 	 */
-	offset = phys_addr & ~PAGE_MASK;
+	offset = offset_in_page(phys_addr);
 	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
@@ -189,7 +189,7 @@ void __init early_iounmap(void __iomem *
 	if (WARN_ON(virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)))
 		return;
 
-	offset = virt_addr & ~PAGE_MASK;
+	offset = offset_in_page(virt_addr);
 	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
 
 	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
@@ -234,7 +234,7 @@ void __init copy_from_early_mem(void *de
 	char *p;
 
 	while (size) {
-		slop = src & ~PAGE_MASK;
+		slop = offset_in_page(src);
 		clen = size;
 		if (clen > MAX_MAP_CHUNK - slop)
 			clen = MAX_MAP_CHUNK - slop;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

