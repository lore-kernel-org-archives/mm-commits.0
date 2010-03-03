From: akpm@linux-foundation.org
Subject: + timbgpio-fix-build.patch added to -mm tree
Date: Wed, 03 Mar 2010 15:34:11 -0800
Message-ID: <201003032334.o23NYBCn005360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab0CCXeV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 18:34:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, richard.rojfors@pelagicore.com


The patch titled
     timbgpio: fix build
has been added to the -mm tree.  Its filename is
     timbgpio-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
timbgpio-fix-build.patch
linux-next.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-net.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
phonet-use-for_each_set_bit.patch
ll-temac-driver-add-non-virtex-5-support.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
obsolete-config-in-kernel-source-hso_autopm.patch
sunrpc-use-formatting-of-module-name-in-sunrpc.patch
staging-rt2860-correct-onstack-wait_queue_head-declaration.patch
vfs-o_-bit-numbers-uniqueness-check.patch
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
nodemaskh-remove-macro-any_online_node.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.=
patch
console-limit-the-range-of-vgacon_soft_scrollback_size.patch
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
