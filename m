From: akpm@linux-foundation.org
Subject: + make-map_vm_area-static.patch added to -mm tree
Date: Thu, 24 May 2007 15:21:05 -0700
Message-ID: <200705242221.l4OML5W5004741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbXEXWVr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:21:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, hugh@veritas.com, nickpiggin@yahoo.com.au


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

map_vm_area() is only ever used inside of mm/vmalloc.c. This makes
it static and removes the prototype.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
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
 
 /* Allocate/destroy a 'vmalloc' VM area. */
diff -puN mm/vmalloc.c~make-map_vm_area-static mm/vmalloc.c
--- a/mm/vmalloc.c~make-map_vm_area-static
+++ a/mm/vmalloc.c
@@ -145,7 +145,8 @@ static inline int vmap_pud_range(pgd_t *
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

origin.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
make-map_vm_area-static.patch
8xx-fix-whitespace-and-indentation.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
