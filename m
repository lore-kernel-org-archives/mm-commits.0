From: akpm@linux-foundation.org
Subject: - make-map_vm_area-static.patch removed from -mm tree
Date: Wed, 30 May 2007 17:42:05 -0700
Message-ID: <200705310045.l4V0jUCp008992@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbXEaApr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 20:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, hugh@veritas.com, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Make map_vm_area() static
has been removed from the -mm tree.  Its filename was
     make-map_vm_area-static.patch

This patch was dropped because lguest uses it

------------------------------------------------------
Subject: Make map_vm_area() static
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

map_vm_area() is only ever used inside of mm/vmalloc.c. This makes
it static and removes the prototype.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
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

do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
make-map_vm_area-static.patch
8xx-fix-whitespace-and-indentation.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
