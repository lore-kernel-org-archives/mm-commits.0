From: akpm@linux-foundation.org
Subject: - lguest-the-guest-code-tidyups-update.patch removed from -mm tree
Date: Thu, 07 Jun 2007 23:13:51 -0700
Message-ID: <200706080613.l586Dp9w020960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754903AbXFHGOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 02:14:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     lguest: guest tidyups
has been removed from the -mm tree.  Its filename was
     lguest-the-guest-code-tidyups-update.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: lguest: guest tidyups
From: Rusty Russell <rusty@rustcorp.com.au>

Jeff Garzik argued forcefully that __pa() should not appear in
drivers, and that struct netdevice's irq field should not be used.
Christoph Hellwig suggested that I run sparse, and provide an
lguest-specific wrapper for mapping/unmapping virtual device memory.

Results:
1) send-dma and bind-dma hypercall wrappers for drivers to use,
2) formalization of the convention that devices can use the irq
   corresponding to their index on the lguest_bus.
3) Helper to map and unmap virtual device memory (not classic __iomem).
4) lguest.c should include "lguest_bus.h" for lguest_devices declaration.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c     |   13 +++++++++++++
 drivers/lguest/lguest_bus.c |    2 +-
 include/linux/lguest_bus.h  |    4 ++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-tidyups-update drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-tidyups-update
+++ a/drivers/lguest/lguest.c
@@ -36,6 +36,7 @@
 #include <asm/setup.h>
 #include <asm/e820.h>
 #include <asm/mce.h>
+#include <asm/io.h>
 
 /* Declarations for definitions in lguest_guest.S */
 extern char lguest_noirq_start[], lguest_noirq_end[];
@@ -122,6 +123,18 @@ void lguest_unbind_dma(unsigned long key
 	hcall(LHCALL_BIND_DMA, key, __pa(dmas), 0);
 }
 
+/* For guests, device memory can be used as normal memory, so we cast away the
+ * __iomem to quieten sparse. */
+void *lguest_map(unsigned long phys_addr, unsigned long pages)
+{
+	return (__force void *)ioremap(phys_addr, PAGE_SIZE*pages);
+}
+
+void lguest_unmap(void *addr)
+{
+	iounmap((__force void __iomem *)addr);
+}
+
 static unsigned long save_fl(void)
 {
 	return lguest_data.irq_enabled;
diff -puN drivers/lguest/lguest_bus.c~lguest-the-guest-code-tidyups-update drivers/lguest/lguest_bus.c
--- a/drivers/lguest/lguest_bus.c~lguest-the-guest-code-tidyups-update
+++ a/drivers/lguest/lguest_bus.c
@@ -136,7 +136,7 @@ static int __init lguest_bus_init(void)
 		return 0;
 
 	/* Devices are in page above top of "normal" mem. */
-	lguest_devices = (__force void*)ioremap(max_pfn<<PAGE_SHIFT,PAGE_SIZE);
+	lguest_devices = lguest_map(max_pfn<<PAGE_SHIFT, 1);
 
 	if (bus_register(&lguest_bus.bus) != 0
 	    || device_register(&lguest_bus.dev) != 0)
diff -puN include/linux/lguest_bus.h~lguest-the-guest-code-tidyups-update include/linux/lguest_bus.h
--- a/include/linux/lguest_bus.h~lguest-the-guest-code-tidyups-update
+++ a/include/linux/lguest_bus.h
@@ -27,6 +27,10 @@ int lguest_bind_dma(unsigned long key, s
 		    unsigned int num, u8 irq);
 void lguest_unbind_dma(unsigned long key, struct lguest_dma *dmas);
 
+/* Map the virtual device space */
+void *lguest_map(unsigned long phys_addr, unsigned long pages);
+void lguest_unmap(void *);
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
