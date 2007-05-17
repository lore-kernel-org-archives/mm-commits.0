From: akpm@linux-foundation.org
Subject: + make-map_vm_area-static.patch added to -mm tree
Date: Thu, 17 May 2007 11:39:27 -0700
Message-ID: <200705171839.l4HIdRTC030172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752AbXEQSkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org


The patch titled
     Make map_vm_area() static
has been added to the -mm tree.  Its filename is
     make-map_vm_area-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make map_vm_area() static
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

map_vm_area() is only ever used inside of mm/vmalloc.c.  This makes it static
and removes the prototype.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 --
 mm/vmalloc.c            |    3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/vmalloc.h~make-map_vm_area-static include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~make-map_vm_area-static
+++ a/include/linux/vmalloc.h
@@ -66,8 +66,6 @@ extern struct vm_struct *get_vm_area_nod
 					  gfp_t gfp_mask);
 extern struct vm_struct *remove_vm_area(void *addr);
 
-extern int map_vm_area(struct vm_struct *area, pgprot_t prot,
-			struct page ***pages);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
 
 /*
diff -puN mm/vmalloc.c~make-map_vm_area-static mm/vmalloc.c
--- a/mm/vmalloc.c~make-map_vm_area-static
+++ a/mm/vmalloc.c
@@ -140,7 +140,8 @@ static inline int vmap_pud_range(pgd_t *
 	return 0;
 }
 
-int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
+static int map_vm_area(struct vm_struct *area, pgprot_t prot,
+		       struct page ***pages)
 {
 	pgd_t *pgd;
 	unsigned long next;
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

make-__vunmap-static.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
8xx-mpc885ads-pcmcia-support-fix.patch
8xx-fix-whitespace-and-indentation.patch
dts-kill-hardcoded-phandles.patch
unmap_vm_area-becomes-unmap_kernel_range.patch
make-map_vm_area-static.patch
