From: akpm@linux-foundation.org
Subject: + xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch added to -mm tree
Date: Thu, 15 Feb 2007 23:00:24 -0800
Message-ID: <200702160700.l1G70OVb022644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55215 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293AbXBPHBT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, ak@suse.de, chrisw@sous-sol.org, ian.pratt@xensource.com, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     Xen-paravirt: add XEN config options and disable unsupported config options
has been added to the -mm tree.  Its filename is
     xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen-paravirt: add XEN config options and disable unsupported config options
From: Jeremy Fitzhardinge <jeremy@goop.org>

The XEN config option enables the Xen paravirt_ops interface, which is
installed when the kernel finds itself running under Xen.  (By some as-yet
fully defined mechanism, implemented in a future patch.)

Xen is no longer a sub-architecture, so the X86_XEN subarch config option has
gone.

The disabled config options are:
- PREEMPT: Xen doesn't support it
- HZ: set to 100Hz for now, to cut down on VCPU context switch rate.
  This will be adapted to use tickless later.
- kexec: not yet supported

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig       |    7 +++++--
 arch/i386/Kconfig.debug |    1 +
 arch/i386/xen/Kconfig   |   10 ++++++++++
 kernel/Kconfig.hz       |    4 ++--
 kernel/Kconfig.preempt  |    1 +
 5 files changed, 19 insertions(+), 4 deletions(-)

diff -puN arch/i386/Kconfig~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options arch/i386/Kconfig
--- a/arch/i386/Kconfig~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options
+++ a/arch/i386/Kconfig
@@ -203,6 +203,8 @@ config PARAVIRT
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
 
+source "arch/i386/xen/Kconfig"
+
 config VMI
 	bool "VMI Paravirt-ops support"
 	depends on PARAVIRT
@@ -338,12 +340,12 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	bool
-	depends on X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH
+	depends on X86_UP_APIC || (((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH)
 	default y
 
 config X86_IO_APIC
 	bool
-	depends on X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH
+	depends on X86_UP_IOAPIC || ((SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH)
 	default y
 
 config X86_VISWS_APIC
@@ -783,6 +785,7 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
+	depends on !XEN
 	help
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff -puN arch/i386/Kconfig.debug~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options arch/i386/Kconfig.debug
--- a/arch/i386/Kconfig.debug~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options
+++ a/arch/i386/Kconfig.debug
@@ -79,6 +79,7 @@ config X86_MPPARSE
 config DOUBLEFAULT
 	default y
 	bool "Enable doublefault exception handler" if EMBEDDED
+	depends on !XEN
 	help
           This option allows trapping of rare doublefault exceptions that
           would otherwise cause a system to silently reboot. Disabling this
diff -puN /dev/null arch/i386/xen/Kconfig
--- /dev/null
+++ a/arch/i386/xen/Kconfig
@@ -0,0 +1,10 @@
+#
+# This Kconfig describes xen options
+#
+
+config XEN
+	bool "Enable support for Xen hypervisor"
+	depends PARAVIRT
+	default y
+	help
+	  This is the Linux Xen port.
diff -puN kernel/Kconfig.hz~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options kernel/Kconfig.hz
--- a/kernel/Kconfig.hz~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options
+++ a/kernel/Kconfig.hz
@@ -3,7 +3,7 @@
 #
 
 choice
-	prompt "Timer frequency"
+	prompt "Timer frequency" if !XEN
 	default HZ_250
 	help
 	 Allows the configuration of the timer frequency. It is customary
@@ -49,7 +49,7 @@ endchoice
 
 config HZ
 	int
-	default 100 if HZ_100
+	default 100 if HZ_100 || XEN
 	default 250 if HZ_250
 	default 300 if HZ_300
 	default 1000 if HZ_1000
diff -puN kernel/Kconfig.preempt~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options kernel/Kconfig.preempt
--- a/kernel/Kconfig.preempt~xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options
+++ a/kernel/Kconfig.preempt
@@ -35,6 +35,7 @@ config PREEMPT_VOLUNTARY
 
 config PREEMPT
 	bool "Preemptible Kernel (Low-Latency Desktop)"
+	depends on !XEN
 	help
 	  This option reduces the latency of the kernel by making
 	  all kernel code (that is not executing in a critical section)
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
uninline-jiffiesh-functions.patch
