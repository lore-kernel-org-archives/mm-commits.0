From: akpm@linux-foundation.org
Subject: - x86-provide-_sdata-in-the-vmlinux_ldss-files.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:10 -0800
Message-ID: <200901082246.n08MkANQ025699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042AbZAHWvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: provide _sdata in the vmlinux_*.lds.S files
has been removed from the -mm tree.  Its filename was
     x86-provide-_sdata-in-the-vmlinux_ldss-files.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: provide _sdata in the vmlinux_*.lds.S files
From: Catalin Marinas <catalin.marinas@arm.com>

_sdata is a common symbol defined by many architectures and made available
to the kernel via asm-generic/sections.h.  Kmemleak uses this symbol when
scanning the data sections.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 arch/x86/kernel/vmlinux_64.lds.S |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/x86/kernel/vmlinux_32.lds.S~x86-provide-_sdata-in-the-vmlinux_ldss-files arch/x86/kernel/vmlinux_32.lds.S
--- a/arch/x86/kernel/vmlinux_32.lds.S~x86-provide-_sdata-in-the-vmlinux_ldss-files
+++ a/arch/x86/kernel/vmlinux_32.lds.S
@@ -63,6 +63,7 @@ SECTIONS
 
   /* writeable */
   . = ALIGN(PAGE_SIZE);
+  _sdata = .;			/* Start of data section */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
 	CONSTRUCTORS
diff -puN arch/x86/kernel/vmlinux_64.lds.S~x86-provide-_sdata-in-the-vmlinux_ldss-files arch/x86/kernel/vmlinux_64.lds.S
--- a/arch/x86/kernel/vmlinux_64.lds.S~x86-provide-_sdata-in-the-vmlinux_ldss-files
+++ a/arch/x86/kernel/vmlinux_64.lds.S
@@ -53,6 +53,7 @@ SECTIONS
   RODATA
 
   . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
+  _sdata = .;			/* Start of data section */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

