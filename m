From: akpm@linux-foundation.org
Subject: - uml-update-address-space-affected-by-pud_clear.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:40 -0800
Message-ID: <200711152108.lAFL8eWr015378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbXKOVRO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: update address space affected by pud_clear
has been removed from the -mm tree.  Its filename was
     uml-update-address-space-affected-by-pud_clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: update address space affected by pud_clear
From: Jeff Dike <jdike@addtoit.com>

pud_clear wasn't setting the _PAGE_NEWPAGE bit, fooling tlb_flush into
thinking that this area of the address space was up-to-date and not unmapping
whatever was covered by the pud.

This manifested itself as ldconfig on x86_64 complaining about the first
library it looked at not being a valid ELF file.  A config file is mapped at
0x4000000, as the only thing mapped under its pud, and unmapped.  The
unmapping caused a pud_clear, which, due to this bug, didn't actually unmap
the config file data on the host.  The first library is then mapped at the
same location, but is not actually mapped on the host because accesses to it
cause no page faults.  As a result, ldconfig sees the old config file data.

[akpm@linux-foundation.org: coding-style cleanups]
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/pgtable-3level.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-um/pgtable-3level.h~uml-update-address-space-affected-by-pud_clear include/asm-um/pgtable-3level.h
--- a/include/asm-um/pgtable-3level.h~uml-update-address-space-affected-by-pud_clear
+++ a/include/asm-um/pgtable-3level.h
@@ -1,3 +1,4 @@
+
 /*
  * Copyright 2003 PathScale Inc
  * Derived from include/asm-i386/pgtable.h
@@ -71,7 +72,7 @@ static inline pmd_t *pmd_alloc_one(struc
 
 static inline void pud_clear (pud_t *pud)
 {
-        set_pud(pud, __pud(0));
+	set_pud(pud, __pud(_PAGE_NEWPAGE));
 }
 
 #define pud_page(pud) phys_to_page(pud_val(pud) & PAGE_MASK)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
