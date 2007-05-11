From: akpm@linux-foundation.org
Subject: + lguest-the-guest-code-tidyups.patch added to -mm tree
Date: Thu, 10 May 2007 20:50:50 -0700
Message-ID: <200705110350.l4B3ooPl005524@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbXEKDu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 23:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest guest feedback tidyups
has been added to the -mm tree.  Its filename is
     lguest-the-guest-code-tidyups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
powerpc-fixup-hard_irq_disable-semantics.patch
add-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
use-menuconfig-objects-ii-module-menu.patch
module_author-dont-advice-putting-in-an-email-address.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-documentation-example-launcher.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
