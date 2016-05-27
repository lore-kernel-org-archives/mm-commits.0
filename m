From: akpm@linux-foundation.org
Subject: + mm-fix-overflow-in-vm_map_ram-fix.patch added to -mm tree
Date: Fri, 27 May 2016 13:20:39 -0700
Message-ID: <5748ac17.j7af5TPiut7zSqdi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbcE0UUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guillermo.julian@naudit.es, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-overflow-in-vm_map_ram-fix
has been added to the -mm tree.  Its filename is
     mm-fix-overflow-in-vm_map_ram-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-overflow-in-vm_map_=
ram-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-overflow-in-vm_map_=
ram-fix.patch

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
oom_reaper-close-race-with-exiting-task-fix.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
