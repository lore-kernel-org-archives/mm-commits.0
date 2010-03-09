From: akpm@linux-foundation.org
Subject: [merged] timbgpio-fix-build.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:02:52 -0800
Message-ID: <201003091902.o29J2qHY030904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755336Ab0CITDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, richard.rojfors@pelagicore.com, mm-commits@vger.kernel.org


The patch titled
     timbgpio: fix build
has been removed from the -mm tree.  Its filename was
     timbgpio-fix-build.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: timbgpio: fix build
=46rom: David Miller <davem@davemloft.net>

Use of get_irq_chip_data() et al.  requires including linux/irq.h

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/timbgpio.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/timbgpio.c~timbgpio-fix-build drivers/gpio/timbg=
pio.c
--- a/drivers/gpio/timbgpio.c~timbgpio-fix-build
+++ a/drivers/gpio/timbgpio.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
+#include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/timb_gpio.h>
 #include <linux/interrupt.h>
_

Patches currently in -mm which might be from davem@davemloft.net are

linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
phonet-use-for_each_set_bit.patch
ll-temac-driver-add-non-virtex-5-support.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
obsolete-config-in-kernel-source-hso_autopm.patch
sunrpc-use-formatting-of-module-name-in-sunrpc.patch
vfs-o_-bit-numbers-uniqueness-check.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
dma-mappingh-add-the-dma_unmap-state-api-fix.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
ssb-remove-the-ssb-dma-api.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
