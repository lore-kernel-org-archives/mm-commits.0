From: akpm@linux-foundation.org
Subject: - mn10300-fix-application-of-kernel-module-relocations.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:28:43 -0800
Message-ID: <200812032028.mB3KShDT028075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948AbYLCU3k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:29:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: fix application of kernel module relocations
has been removed from the -mm tree.  Its filename was
     mn10300-fix-application-of-kernel-module-relocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: fix application of kernel module relocations
From: Mark Salter <msalter@redhat.com>

This fixes the MN10300 kernel module linking to match the toolchain.  RELA
relocs don't use the value at the location being relocated.  This has been
working because the tools always leave the value at the target location
cleared.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/module.c |   35 ++++++---------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff -puN arch/mn10300/kernel/module.c~mn10300-fix-application-of-kernel-module-relocations arch/mn10300/kernel/module.c
--- a/arch/mn10300/kernel/module.c~mn10300-fix-application-of-kernel-module-relocations
+++ a/arch/mn10300/kernel/module.c
@@ -1,6 +1,6 @@
 /* MN10300 Kernel module helper routines
  *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2007, 2008 Red Hat, Inc. All Rights Reserved.
  * Written by Mark Salter (msalter@redhat.com)
  * - Derived from arch/i386/kernel/module.c
  *
@@ -64,21 +64,6 @@ int module_frob_arch_sections(Elf_Ehdr *
 	return 0;
 }
 
-static uint32_t reloc_get16(uint8_t *p)
-{
-	return p[0] | (p[1] << 8);
-}
-
-static uint32_t reloc_get24(uint8_t *p)
-{
-	return reloc_get16(p) | (p[2] << 16);
-}
-
-static uint32_t reloc_get32(uint8_t *p)
-{
-	return reloc_get16(p) | (reloc_get16(p+2) << 16);
-}
-
 static void reloc_put16(uint8_t *p, uint32_t val)
 {
 	p[0] = val & 0xff;
@@ -144,25 +129,19 @@ int apply_relocate_add(Elf32_Shdr *sechd
 		relocation = sym->st_value + rel[i].r_addend;
 
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
-			/* for the first four relocation types, we add the
-			 * adjustment into the value at the location given */
+			/* for the first four relocation types, we simply
+			 * store the adjustment at the location given */
 		case R_MN10300_32:
-			value = reloc_get32(location);
-			value += relocation;
-			reloc_put32(location, value);
+			reloc_put32(location, relocation);
 			break;
 		case R_MN10300_24:
-			value = reloc_get24(location);
-			value += relocation;
-			reloc_put24(location, value);
+			reloc_put24(location, relocation);
 			break;
 		case R_MN10300_16:
-			value = reloc_get16(location);
-			value += relocation;
-			reloc_put16(location, value);
+			reloc_put16(location, relocation);
 			break;
 		case R_MN10300_8:
-			*location += relocation;
+			*location = relocation;
 			break;
 
 			/* for the next three relocation types, we write the
_

Patches currently in -mm which might be from msalter@redhat.com are

origin.patch

