From: akpm@linux-foundation.org
Subject: + lguest-makefile.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:28 -0800
Message-ID: <200702130703.l1D73S2m024551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbXBMHDf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: Makefile
has been added to the -mm tree.  Its filename is
     lguest-makefile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: Makefile
From: Rusty Russell <rusty@rustcorp.com.au>

Finally, we put in the Makefile, so it will build.

Linking the switcher code (hypervisor.S) ready to be copied into the top of
memory is the only non-trivial thing here.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Makefile        |    1 +
 arch/i386/lguest/Makefile |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff -puN arch/i386/Makefile~lguest-makefile arch/i386/Makefile
--- a/arch/i386/Makefile~lguest-makefile
+++ a/arch/i386/Makefile
@@ -108,6 +108,7 @@ drivers-$(CONFIG_PCI)			+= arch/i386/pci
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE)		+= arch/i386/oprofile/
 drivers-$(CONFIG_PM)			+= arch/i386/power/
+drivers-$(CONFIG_LGUEST_GUEST)		+= arch/i386/lguest/
 
 CFLAGS += $(mflags-y)
 AFLAGS += $(mflags-y)
diff -puN /dev/null arch/i386/lguest/Makefile
--- /dev/null
+++ a/arch/i386/lguest/Makefile
@@ -0,0 +1,22 @@
+# Guest requires the paravirt_ops replacement and the bus driver.
+obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_bus.o
+
+# Host requires the other files, which can be a module.
+obj-$(CONFIG_LGUEST)	+= lg.o
+lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+	segments.o io.o lguest_user.o
+
+# We use top 4MB for guest traps page, then hypervisor. */
+HYPE_ADDR := (0xFFC00000+4096)
+# The data is only 1k (256 interrupt handler pointers)
+HYPE_DATA_SIZE := 1024
+CFLAGS += -DHYPE_ADDR="$(HYPE_ADDR)" -DHYPE_DATA_SIZE="$(HYPE_DATA_SIZE)"
+
+$(obj)/core.o: $(obj)/hypervisor-blob.c
+# This links the hypervisor in the right place and turns it into a C array.
+$(obj)/hypervisor-raw: $(obj)/hypervisor.o
+	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
+$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
+	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@
+
+clean-files := hypervisor-blob.c hypervisor-raw
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
