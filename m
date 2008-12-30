From: akpm@linux-foundation.org
Subject: + x86-provide-_sdata-in-the-vmlinux_ldss-files.patch added to -mm tree
Date: Mon, 29 Dec 2008 16:23:05 -0800
Message-ID: <200812300023.mBU0N5AB006071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbYL3AXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, mingo@elte.hu


The patch titled
     x86: provide _sdata in the vmlinux_*.lds.S files
has been added to the -mm tree.  Its filename is
     x86-provide-_sdata-in-the-vmlinux_ldss-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-add-the-vmalloc-memory-allocation-freeing-hooks.patch
kmemleak-add-kmemleak_alloc-callback-from-alloc_large_system_hash.patch
kmemleak-add-modules-support.patch
x86-provide-_sdata-in-the-vmlinux_ldss-files.patch
arm-provide-_sdata-and-__bss_stop-in-the-vmlinuxldss-file.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
kmemleak-enable-the-building-of-the-memory-leak-detector.patch
kmemleak-simple-testing-module-for-kmemleak.patch
kmemleak-add-the-corresponding-maintainers-entry.patch

