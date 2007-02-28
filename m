From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:16:18 -0800
Message-ID: <200702282316.l1SNGIDd030050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47197 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbXB1XQV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:16:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/Makefile            |    4 ++--
 arch/i386/boot/compressed/Makefile |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/i386/boot/Makefile~xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386 arch/i386/boot/Makefile
--- a/arch/i386/boot/Makefile~xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386
+++ a/arch/i386/boot/Makefile
@@ -36,9 +36,9 @@ HOSTCFLAGS_build.o := $(LINUXINCLUDE)
 # ---------------------------------------------------------------------------
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-$(obj)/zImage:  EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_AFLAGS := -traditional $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
diff -puN arch/i386/boot/compressed/Makefile~xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386 arch/i386/boot/compressed/Makefile
--- a/arch/i386/boot/compressed/Makefile~xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386
+++ a/arch/i386/boot/compressed/Makefile
@@ -6,7 +6,6 @@
 
 targets		:= vmlinux vmlinux.bin vmlinux.bin.gz head.o misc.o piggy.o \
 			vmlinux.bin.all vmlinux.relocs
-EXTRA_AFLAGS	:= -traditional
 
 LDFLAGS_vmlinux := -T
 CFLAGS_misc.o += -fPIC
_

Patches currently in -mm which might be from jeremy@goop.org are

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
