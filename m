From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:53:45 -0800
Message-ID: <200702220253.l1M2rjuL002509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34636 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbXBVCyK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:54:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com, kraxel@suse.de


The patch titled
     From: Jeremy Fitzhardinge <jeremy@goop.org>
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Jeremy Fitzhardinge <jeremy@goop.org>
From: Gerd Hoffmann <kraxel@suse.de>

Implement a Xen back-end for hvc console.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/Kconfig         |    1
 arch/i386/xen/events.c        |    3
 drivers/xen/console/Makefile  |    3
 include/xen/events.h          |    1

===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/Kconfig      |    1 
 arch/i386/xen/events.c     |    3 
 drivers/Makefile           |    3 
 drivers/char/hvc_console.c |    4 +
 drivers/xen/Makefile       |    1 
 drivers/xen/hvc-console.c  |  134 +++++++++++++++++++++++++++++++++++
 include/xen/events.h       |    1 
 7 files changed, 146 insertions(+), 1 deletion(-)

diff -puN arch/i386/xen/Kconfig~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console arch/i386/xen/Kconfig
--- a/arch/i386/xen/Kconfig~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console
+++ a/arch/i386/xen/Kconfig
@@ -5,6 +5,7 @@
 config XEN
 	bool "Enable support for Xen hypervisor"
 	depends on PARAVIRT && HZ_100 && !PREEMPT && !NO_HZ
+	select HVC_DRIVER
 	default y
 	help
 	  This is the Linux Xen port.
diff -puN arch/i386/xen/events.c~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console arch/i386/xen/events.c
--- a/arch/i386/xen/events.c~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console
+++ a/arch/i386/xen/events.c
@@ -209,7 +209,7 @@ static int find_unbound_irq(void)
 	return irq;
 }
 
-static int bind_evtchn_to_irq(unsigned int evtchn)
+int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
 
@@ -233,6 +233,7 @@ static int bind_evtchn_to_irq(unsigned i
 
 	return irq;
 }
+EXPORT_SYMBOL_GPL(bind_evtchn_to_irq);
 
 static int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 {
diff -puN drivers/Makefile~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console drivers/Makefile
--- a/drivers/Makefile~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console
+++ a/drivers/Makefile
@@ -15,6 +15,9 @@ obj-$(CONFIG_ACPI)		+= acpi/
 obj-$(CONFIG_PNP)		+= pnp/
 obj-$(CONFIG_ARM_AMBA)		+= amba/
 
+# Xen is the default console when running as a guest
+obj-$(CONFIG_XEN)		+= xen/
+
 # char/ comes before serial/ etc so that the VT console is the boot-time
 # default.
 obj-y				+= char/
diff -puN drivers/char/hvc_console.c~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console drivers/char/hvc_console.c
--- a/drivers/char/hvc_console.c~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console
+++ a/drivers/char/hvc_console.c
@@ -53,6 +53,10 @@
 #define NO_IRQ 0
 #endif
 
+#ifndef NO_IRQ
+#define NO_IRQ 0
+#endif
+
 /*
  * Wait this long per iteration while trying to push buffered data to the
  * hypervisor before allowing the tty to complete a close operation.
diff -puN /dev/null drivers/xen/Makefile
--- /dev/null
+++ a/drivers/xen/Makefile
@@ -0,0 +1 @@
+obj-y	+= hvc-console.o
diff -puN /dev/null drivers/xen/hvc-console.c
--- /dev/null
+++ a/drivers/xen/hvc-console.c
@@ -0,0 +1,134 @@
+/*
+ * xen console driver interface to hvc_console.c
+ *
+ * (c) 2007 Gerd Hoffmann <kraxel@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/types.h>
+
+#include <asm/xen/hypervisor.h>
+#include <xen/page.h>
+#include <xen/events.h>
+#include <xen/interface/io/console.h>
+
+#include "../char/hvc_console.h"
+
+#define HVC_COOKIE   0x58656e /* "Xen" in hex */
+
+static struct hvc_struct *hvc;
+static int xencons_irq;
+
+/* ------------------------------------------------------------------ */
+
+static inline struct xencons_interface *xencons_interface(void)
+{
+	return mfn_to_virt(xen_start_info->console.domU.mfn);
+}
+
+static inline void notify_daemon(void)
+{
+	/* Use evtchn: this is called early, before irq is set up. */
+	notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
+}
+
+static int write_console(uint32_t vtermno, const char *data, int len)
+{
+	struct xencons_interface *intf = xencons_interface();
+	XENCONS_RING_IDX cons, prod;
+	int sent = 0;
+
+	cons = intf->out_cons;
+	prod = intf->out_prod;
+	mb();
+	BUG_ON((prod - cons) > sizeof(intf->out));
+
+	while ((sent < len) && ((prod - cons) < sizeof(intf->out)))
+		intf->out[MASK_XENCONS_IDX(prod++, intf->out)] = data[sent++];
+
+	wmb();
+	intf->out_prod = prod;
+
+	notify_daemon();
+	return sent;
+}
+
+static int read_console(uint32_t vtermno, char *buf, int len)
+{
+	struct xencons_interface *intf = xencons_interface();
+	XENCONS_RING_IDX cons, prod;
+	int recv = 0;
+
+	cons = intf->in_cons;
+	prod = intf->in_prod;
+	mb();
+	BUG_ON((prod - cons) > sizeof(intf->in));
+
+	while (cons != prod && recv < len)
+		buf[recv++] = intf->in[MASK_XENCONS_IDX(cons++,intf->in)];
+
+	mb();
+	intf->in_cons = cons;
+
+	notify_daemon();
+	return recv;
+}
+
+static struct hv_ops hvc_ops = {
+	.get_chars = read_console,
+	.put_chars = write_console,
+};
+
+static int __init xen_init(void)
+{
+	struct hvc_struct *hp;
+
+	if (!is_running_on_xen())
+		return 0;
+
+	xencons_irq = bind_evtchn_to_irq(xen_start_info->console.domU.evtchn);
+	if (xencons_irq < 0)
+		xencons_irq = 0 /* NO_IRQ */;
+	hp = hvc_alloc(HVC_COOKIE, xencons_irq, &hvc_ops, 256);
+	if (IS_ERR(hp))
+		return PTR_ERR(hp);
+
+	hvc = hp;
+	return 0;
+}
+
+static void __exit xen_fini(void)
+{
+	if (hvc)
+		hvc_remove(hvc);
+}
+
+static int xen_cons_init(void)
+{
+	if (!is_running_on_xen())
+		return 0;
+
+	hvc_instantiate(HVC_COOKIE, 0, &hvc_ops);
+	return 0;
+}
+
+module_init(xen_init);
+module_exit(xen_fini);
+console_initcall(xen_cons_init);
diff -puN include/xen/events.h~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console include/xen/events.h
--- a/include/xen/events.h~xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console
+++ a/include/xen/events.h
@@ -3,6 +3,7 @@
 
 #include <linux/irq.h>
 
+int bind_evtchn_to_irq(unsigned int evtchn);
 int bind_evtchn_to_irqhandler(unsigned int evtchn,
 			      irqreturn_t (*handler)(int, void *),
 			      unsigned long irqflags, const char *devname,
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-some-generic-early-printk-boot-console-fixups.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
