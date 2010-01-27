From: akpm@linux-foundation.org
Subject: [merged] pci-hotplug-cpcihp-fix-pci-device-refcounting.patch removed from -mm tree
Date: Wed, 27 Jan 2010 13:34:31 -0800
Message-ID: <201001272134.o0RLYV6d000763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab0A0Vei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 16:34:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, jbarnes@virtuousgeek.org, scott@spiteful.org, mm-commits@vger.kernel.org


The patch titled
     pci: hotplug/cpcihp, fix pci device refcounting
has been removed from the -mm tree.  Its filename was
     pci-hotplug-cpcihp-fix-pci-device-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: hotplug/cpcihp, fix pci device refcounting
From: Jiri Slaby <jslaby@suse.cz>

Stanse found an ommitted pci_dev_put on one error path in
cpcihp_generic_init.  The path is taken on !dev, but also when
dev->hdr_type != PCI_HEADER_TYPE_BRIDGE.  However it omits to pci_dev_put
on the latter.

As it is fine to pass NULL to pci_dev_put, put it in there uncoditionally.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Scott Murray <scott@spiteful.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpcihp_generic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/hotplug/cpcihp_generic.c~pci-hotplug-cpcihp-fix-pci-device-refcounting drivers/pci/hotplug/cpcihp_generic.c
--- a/drivers/pci/hotplug/cpcihp_generic.c~pci-hotplug-cpcihp-fix-pci-device-refcounting
+++ a/drivers/pci/hotplug/cpcihp_generic.c
@@ -162,6 +162,7 @@ static int __init cpcihp_generic_init(vo
 	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
 	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
 		err("Invalid bridge device %s", bridge);
+		pci_dev_put(dev);
 		return -EINVAL;
 	}
 	bus = dev->subordinate;
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
gpu-drm-i915-fix-potential-null-dereference.patch
infiniband-use-rlimit-helpers.patch
mtd-chips-cfi-remove-unneeded-null-checks.patch
video-backlight-progear-fix-pci-device-refcounting.patch
mm-use-rlimit-helpers.patch
bootmem-avoid-dma32-zone-by-default.patch
fs-use-rlimit-helpers.patch
ipc-use-rlimit-helpers.patch

