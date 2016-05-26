From: akpm@linux-foundation.org
Subject: + mm-fix-overflow-in-vm_map_ram.patch added to -mm tree
Date: Thu, 26 May 2016 14:28:50 -0700
Message-ID: <57476a92.hV/kxNqp0tubMd8N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbcEZV2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 17:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guillermo.julian@naudit.es, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix overflow in vm_map_ram()
has been added to the -mm tree.  Its filename is
     mm-fix-overflow-in-vm_map_ram.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-overflow-in-vm_map_=
ram.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-overflow-in-vm_map_=
ram.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Guillermo Juli=E1n Moreno <guillermo.julian@naudit.es>
Subject: mm: fix overflow in vm_map_ram()

When remapping pages accounting for 4G or more memory space, the
operation 'count << PAGE_SHIFT' overflows as it is performed on an
integer. Solution: cast before doing the bitshift.

[akpm@linux-foundation.org: fix vm_unmap_ram() also]
Link: http://lkml.kernel.org/r/etPan.57175fb3.7a271c6b.2bd@naudit.es
Signed-off-by: Guillermo Juli=E1n Moreno <guillermo.julian@naudit.es>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
_

Patches currently in -mm which might be from guillermo.julian@naudit.es=
 are

mm-fix-overflow-in-vm_map_ram.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
