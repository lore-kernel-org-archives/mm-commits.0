From: akpm@osdl.org
Subject: + m32r-fix-kernel-entry-address-of-vmlinux.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:11:45 -0800
Message-ID: <200612142111.kBELBkf0026066@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58795 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917AbWLNVMT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org


The patch titled
     m32r: fix kernel entry address of vmlinux
has been added to the -mm tree.  Its filename is
     m32r-fix-kernel-entry-address-of-vmlinux.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: fix kernel entry address of vmlinux
From: Hirokazu Takata <takata@linux-m32r.org>

This patch fixes the kernel entry point address of vmlinux.

The m32r kernel entry address is 0x08002000 (physical).
But, so far, the ENTRY point written in vmlinux.lds.S was not point
the correct kernel entry address.

(before fix)
    $ objdump -x vmlinux
    vmlinux:     file format elf32-m32r-linux
    vmlinux
    architecture: m32r2, flags 0x00000112:
    EXEC_P, HAS_SYMS, D_PAGED
    start address 0x88002090	/* NG */
        :
    Sections:
    Idx Name          Size      VMA       LMA       File off  Algn
      0 .empty_zero_page 00001000  88001000  88001000  00001000  2**12
                      CONTENTS, ALLOC, LOAD, DATA
      1 .boot         0000008c  88002000  88002000  00002000  2**2
                      CONTENTS, ALLOC, LOAD, READONLY, CODE
      2 .text         001ab694  88002090  88002090  00002090  2**4
                      CONTENTS, ALLOC, LOAD, READONLY, CODE
        :

(after fix)
    $ objdump -x vmlinux
    vmlinux:     file format elf32-m32r-linux
    vmlinux
    architecture: m32r2, flags 0x00000112:
    EXEC_P, HAS_SYMS, D_PAGED
    start address 0x08002000	/* OK */
        :

This fix also remedies the following GDB error message (of gdb-6.4 or after)
at the first operation of kernel debugging:
"Previous frame identical to this frame (corrupt stack?)".

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m32r/Makefile             |    2 +-
 arch/m32r/kernel/vmlinux.lds.S |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/m32r/Makefile~m32r-fix-kernel-entry-address-of-vmlinux arch/m32r/Makefile
--- a/arch/m32r/Makefile~m32r-fix-kernel-entry-address-of-vmlinux
+++ a/arch/m32r/Makefile
@@ -7,7 +7,7 @@
 
 LDFLAGS		:=
 OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
-LDFLAGS_vmlinux	:= -e startup_32
+LDFLAGS_vmlinux	:=
 
 CFLAGS += -pipe -fno-schedule-insns
 CFLAGS_KERNEL += -mmodel=medium
diff -puN arch/m32r/kernel/vmlinux.lds.S~m32r-fix-kernel-entry-address-of-vmlinux arch/m32r/kernel/vmlinux.lds.S
--- a/arch/m32r/kernel/vmlinux.lds.S~m32r-fix-kernel-entry-address-of-vmlinux
+++ a/arch/m32r/kernel/vmlinux.lds.S
@@ -6,12 +6,15 @@
 #include <asm/page.h>
 
 OUTPUT_ARCH(m32r)
-ENTRY(startup_32)
 #if defined(__LITTLE_ENDIAN__)
        jiffies = jiffies_64;
 #else
        jiffies = jiffies_64 + 4;
 #endif
+
+kernel_entry = boot - 0x80000000;
+ENTRY(kernel_entry)
+
 SECTIONS
 {
   . = CONFIG_MEMORY_START + __PAGE_OFFSET;
_

Patches currently in -mm which might be from takata@linux-m32r.org are

m32r-build-fix-for-processors-without-isa_dsp_level2.patch
m32r-fix-do_page_fault-and-update_mmu_cache.patch
m32r-update-defconfig-files-for-v2619.patch
m32r-fix-kernel-entry-address-of-vmlinux.patch
m32r-cosmetic-updates-and-trivial-fixes.patch

