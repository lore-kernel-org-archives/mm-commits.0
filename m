From: akpm@linux-foundation.org
Subject: - lguest-the-guest-code-tidyups.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:13:48 -0700
Message-ID: <200706080613.l586DmJu020957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbXFHGN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest guest feedback tidyups
has been removed from the -mm tree.  Its filename was
     lguest-the-guest-code-tidyups.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: lguest guest feedback tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

1) send-dma and bind-dma hypercall wrappers for drivers to use,
2) formalization of the convention that devices can use the irq
   corresponding to their index on the lguest_bus.
3) ___force to shut up sparse: guests *can* use ioremap as virtual mem.
4) lguest.c should include "lguest_bus.h" for lguest_devices declaration.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c     |   20 ++++++++++++++++++++
 drivers/lguest/lguest_bus.c |    2 +-
 include/linux/lguest_bus.h  |   13 ++++++++++++-
 3 files changed, 33 insertions(+), 2 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-tidyups drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-tidyups
+++ a/drivers/lguest/lguest.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
+#include <linux/lguest_bus.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -102,6 +103,25 @@ void async_hcall(unsigned long call,
 	local_irq_restore(flags);
 }
 
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma)
+{
+	dma->used_len = 0;
+	hcall(LHCALL_SEND_DMA, key, __pa(dma), 0);
+}
+
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq)
+{
+	if (!hcall(LHCALL_BIND_DMA, key, __pa(dmas), (num << 8) | irq))
+		return -ENOMEM;
+	return 0;
+}
+
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas)
+{
+	hcall(LHCALL_BIND_DMA, key, __pa(dmas), 0);
+}
+
 static unsigned long save_fl(void)
 {
 	return lguest_data.irq_enabled;
diff -puN drivers/lguest/lguest_bus.c~lguest-the-guest-code-tidyups drivers/lguest/lguest_bus.c
--- a/drivers/lguest/lguest_bus.c~lguest-the-guest-code-tidyups
+++ a/drivers/lguest/lguest_bus.c
@@ -136,7 +136,7 @@ static int __init lguest_bus_init(void)
 		return 0;
 
 	/* Devices are in page above top of "normal" mem. */
-	lguest_devices = ioremap(max_pfn << PAGE_SHIFT, PAGE_SIZE);
+	lguest_devices = (__force void*)ioremap(max_pfn<<PAGE_SHIFT,PAGE_SIZE);
 
 	if (bus_register(&lguest_bus.bus) != 0
 	    || device_register(&lguest_bus.dev) != 0)
diff -puN include/linux/lguest_bus.h~lguest-the-guest-code-tidyups include/linux/lguest_bus.h
--- a/include/linux/lguest_bus.h~lguest-the-guest-code-tidyups
+++ a/include/linux/lguest_bus.h
@@ -7,7 +7,6 @@
 
 struct lguest_device {
 	/* Unique busid, and index into lguest_page->devices[] */
-	/* By convention, each device can use irq index+1 if it wants to. */
 	unsigned int index;
 
 	struct device dev;
@@ -16,6 +15,18 @@ struct lguest_device {
 	void *private;
 };
 
+/* By convention, each device can use irq index+1 if it wants to. */
+static inline int lgdev_irq(const struct lguest_device *dev)
+{
+	return dev->index + 1;
+}
+
+/* dma args must not be vmalloced! */
+void lguest_send_dma(unsigned long key, struct lguest_dma *dma);
+int lguest_bind_dma(unsigned long key, struct lguest_dma *dmas,
+		    unsigned int num, u8 irq);
+void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas);
+
 struct lguest_driver {
 	const char *name;
 	struct module *owner;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
lguest-speed-up-paravirt_lazy_flush-handling.patch
lguest-more-lazy_hcalls.patch
lguest-the-guest-code-tsc-fix.patch
lguest-the-guest-code-suppress-ide-probing.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
lguest-documentation-infrastructure-and-chapter-i.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
