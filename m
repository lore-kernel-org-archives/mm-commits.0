From: akpm@linux-foundation.org
Subject: [folded-merged] mm-fix-overflow-in-vm_map_ram-fix.patch removed
 from -mm tree
Date: Fri, 03 Jun 2016 14:49:18 -0700
Message-ID: <5751fb5e.Kgtv7tRJMsDRiWVe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161151AbcFCVtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guillermo.julian@naudit.es, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-overflow-in-vm_map_ram-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-overflow-in-vm_map_ram-fix.patch

This patch was dropped because it was folded into mm-fix-overflow-in-vm=
_map_ram.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-overflow-in-vm_map_ram-fix

fix vmap() as well, per Guillermo

Cc: Guillermo Juli=E1n Moreno <guillermo.julian@naudit.es>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-fix-overflow-in-vm_map_ram-fix mm/vmalloc.c
--- a/mm/vmalloc.c~mm-fix-overflow-in-vm_map_ram-fix
+++ a/mm/vmalloc.c
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

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-fix-overflow-in-vm_map_ram.patch
revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.p=
atch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patc=
h
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
