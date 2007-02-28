From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-add-xen-config-options.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:15:50 -0800
Message-ID: <200702282315.l1SNFocp030014@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47247 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbXB1XQk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:16:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, chrisw@sous-sol.org, ian.pratt@xensource.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-add-xen-config-options.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>


The XEN config option enables the Xen paravirt_ops interface, which is
installed when the kernel finds itself running under Xen.

Xen is no longer a sub-architecture, so the X86_XEN subarch config
option has gone.

Xen is currently incompatible with:
- PREEMPT
- HZ: set to 100Hz for now, to cut down on VCPU context switch rate.
  This will be adapted to use tickless later.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig     |    2 ++
 arch/i386/xen/Kconfig |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff -puN arch/i386/Kconfig~xen-paravirt_ops-add-xen-config-options arch/i386/Kconfig
--- a/arch/i386/Kconfig~xen-paravirt_ops-add-xen-config-options
+++ a/arch/i386/Kconfig
@@ -218,6 +218,8 @@ config PARAVIRT
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
 
+source "arch/i386/xen/Kconfig"
+
 config VMI
 	bool "VMI Paravirt-ops support"
 	depends on PARAVIRT && !NO_HZ
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
+	depends on PARAVIRT && HZ_100 && !PREEMPT && !NO_HZ
+	default y
+	help
+	  This is the Linux Xen port.
_

Patches currently in -mm which might be from jeremy@goop.org are

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
