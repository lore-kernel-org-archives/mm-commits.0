From: akpm@linux-foundation.org
Subject: + lguest-the-makefile-and-kconfig.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:03:55 -0700
Message-ID: <200704102203.l3AM3tPl018738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbXDJWEE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:04:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: the Makefile and Kconfig
has been added to the -mm tree.  Its filename is
     lguest-the-makefile-and-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: the Makefile and Kconfig
From: Rusty Russell <rusty@rustcorp.com.au>

This is the Kconfig and Makefile to allow lguest to actually be
compiled.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Kconfig         |    2 ++
 drivers/Makefile        |    1 +
 drivers/lguest/Kconfig  |   20 ++++++++++++++++++++
 drivers/lguest/Makefile |    7 +++++++
 4 files changed, 30 insertions(+)

diff -puN drivers/Kconfig~lguest-the-makefile-and-kconfig drivers/Kconfig
--- a/drivers/Kconfig~lguest-the-makefile-and-kconfig
+++ a/drivers/Kconfig
@@ -87,4 +87,6 @@ source "drivers/auxdisplay/Kconfig"
 source "drivers/kvm/Kconfig"
 
 source "drivers/uio/Kconfig"
+
+source "drivers/lguest/Kconfig"
 endmenu
diff -puN drivers/Makefile~lguest-the-makefile-and-kconfig drivers/Makefile
--- a/drivers/Makefile~lguest-the-makefile-and-kconfig
+++ a/drivers/Makefile
@@ -86,3 +86,4 @@ obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_SSB)		+= ssb/
+obj-$(CONFIG_LGUEST_GUEST)	+= lguest/
diff -puN /dev/null drivers/lguest/Kconfig
--- /dev/null
+++ a/drivers/lguest/Kconfig
@@ -0,0 +1,20 @@
+config LGUEST
+	tristate "Linux hypervisor example code"
+	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
+	select LGUEST_GUEST
+	select HVC_DRIVER
+	---help---
+	  This is a very simple module which allows you to run
+	  multiple instances of the same Linux kernel, using the
+	  "lguest" command found in the Documentation/lguest directory.
+	  Note that "lguest" is pronounced to rhyme with "fell quest",
+	  not "rustyvisor".  See Documentation/lguest/lguest.txt.
+
+	  If unsure, say N.  If curious, say M.  If masochistic, say Y.
+
+config LGUEST_GUEST
+	bool
+	help
+	  The guest needs code built-in, even if the host has lguest
+	  support as a module.  The drivers are tiny, so we build them
+	  in too.
diff -puN /dev/null drivers/lguest/Makefile
--- /dev/null
+++ a/drivers/lguest/Makefile
@@ -0,0 +1,7 @@
+# Guest requires the paravirt_ops replacement and the bus driver.
+obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_asm.o lguest_bus.o
+
+# Host requires the other files, which can be a module.
+obj-$(CONFIG_LGUEST)	+= lg.o
+lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+	segments.o io.o lguest_user.o switcher.o
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

fix-kernel-oops-with-badly-formatted-module-option.patch
git-kbuild.patch
git-net.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-add-common-patching-machinery.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
allow-per-cpu-variables-to-be-page-aligned.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
expose-range-checking-functions-from-arch-specific.patch
____call_usermodehelper-dont-flush_signals.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
