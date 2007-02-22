From: akpm@linux-foundation.org
Subject: - xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch removed from -mm tree
Date: Wed, 21 Feb 2007 18:36:27 -0800
Message-ID: <200702220236.l1M2aR7w002017@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34288 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXBVChY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:37:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, ak@suse.de, chrisw@sous-sol.org, ian.pratt@xensource.com, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     Xen-paravirt: add XEN config options and disable unsupported config options
has been removed from the -mm tree.  Its filename was
     xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch

This patch was dropped because an updated version will be merged

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
@@ -217,6 +217,8 @@ config PARAVIRT
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
 
+source "arch/i386/xen/Kconfig"
+
 config VMI
 	bool "VMI Paravirt-ops support"
 	depends on PARAVIRT && !NO_HZ
@@ -352,12 +354,12 @@ config X86_UP_IOAPIC
 
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
@@ -797,6 +799,7 @@ source kernel/Kconfig.hz
 
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

xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-core-xen-implementation-fix.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
