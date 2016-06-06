From: akpm@linux-foundation.org
Subject: [merged] mm-fix-overflow-in-vm_map_ram.patch removed from -mm
 tree
Date: Mon, 06 Jun 2016 12:06:38 -0700
Message-ID: <5755c9be.PLy3FX/q+GM36ixP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbcFFTGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 15:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guillermo.julian@naudit.es, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix overflow in vm_map_ram()
has been removed from the -mm tree.  Its filename was
     mm-fix-overflow-in-vm_map_ram.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Guillermo Juli=E1n Moreno <guillermo.julian@naudit.es>
Subject: mm: fix overflow in vm_map_ram()

When remapping pages accounting for 4G or more memory space, the
operation 'count << PAGE_SHIFT' overflows as it is performed on an
integer. Solution: cast before doing the bitshift.

[akpm@linux-foundation.org: fix vm_unmap_ram() also]
[akpm@linux-foundation.org: fix vmap() as well, per Guillermo]
Link: http://lkml.kernel.org/r/etPan.57175fb3.7a271c6b.2bd@naudit.es
Signed-off-by: Guillermo Juli=E1n Moreno <guillermo.julian@naudit.es>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-fix-overflow-in-vm_map_ram mm/vmalloc.c
--- a/mm/vmalloc.c~mm-fix-overflow-in-vm_map_ram
+++ a/mm/vmalloc.c
@@ -1105,7 +1105,7 @@ EXPORT_SYMBOL_GPL(vm_unmap_aliases);
  */
 void vm_unmap_ram(const void *mem, unsigned int count)
 {
-	unsigned long size =3D count << PAGE_SHIFT;
+	unsigned long size =3D (unsigned long)count << PAGE_SHIFT;
 	unsigned long addr =3D (unsigned long)mem;
=20
 	BUG_ON(!addr);
@@ -1140,7 +1140,7 @@ EXPORT_SYMBOL(vm_unmap_ram);
  */
 void *vm_map_ram(struct page **pages, unsigned int count, int node, pg=
prot_t prot)
 {
-	unsigned long size =3D count << PAGE_SHIFT;
+	unsigned long size =3D (unsigned long)count << PAGE_SHIFT;
 	unsigned long addr;
 	void *mem;
=20
@@ -1574,14 +1574,15 @@ void *vmap(struct page **pages, unsigned
 		unsigned long flags, pgprot_t prot)
 {
 	struct vm_struct *area;
+	unsigned long size;		/* In bytes */
=20
 	might_sleep();
=20
 	if (count > totalram_pages)
 		return NULL;
=20
-	area =3D get_vm_area_caller((count << PAGE_SHIFT), flags,
-					__builtin_return_address(0));
+	size =3D (unsigned long)count << PAGE_SHIFT;
+	area =3D get_vm_area_caller(size, flags, __builtin_return_address(0))=
;
 	if (!area)
 		return NULL;
=20
_

Patches currently in -mm which might be from guillermo.julian@naudit.es=
 are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
