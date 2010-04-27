From: akpm@linux-foundation.org
Subject: [to-be-updated] g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch removed from -mm tree
Date: Tue, 27 Apr 2010 14:22:35 -0700
Message-ID: <201004272122.o3RLMZmC020680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059Ab0D0VXA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 17:23:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     g_NCR5380: fix missing pnp_device_detach and scsi_unregister on rmmod
has been removed from the -mm tree.  Its filename was
     g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: g_NCR5380: fix missing pnp_device_detach and scsi_unregister on rmmod
From: Ondrej Zary <linux@rainbow-software.org>

Add missing pnp_device_detach() and scsi_unregister() at rmmod time.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/g_NCR5380.c |    7 ++++++-
 drivers/scsi/g_NCR5380.h |    5 +++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/g_NCR5380.c~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod
+++ a/drivers/scsi/g_NCR5380.c
@@ -290,6 +290,7 @@ int __init generic_NCR5380_detect(struct
 #ifndef SCSI_G_NCR5380_MEM
 	int i;
 	unsigned long region_size = 16;
+	struct pnp_dev *pnpdevs[NO_OVERRIDES];
 #endif
 	static unsigned int __initdata ncr_53c400a_ports[] = {
 		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
@@ -337,6 +338,7 @@ int __init generic_NCR5380_detect(struct
 				pnp_device_detach(dev);
 				continue;
 			}
+			pnpdevs[count] = dev;
 			if (pnp_irq_valid(dev, 0))
 				overrides[count].irq = pnp_irq(dev, 0);
 			else
@@ -449,6 +451,7 @@ int __init generic_NCR5380_detect(struct
 		instance->NCR5380_instance_name = overrides[current_override].NCR5380_map_name;
 #ifndef SCSI_G_NCR5380_MEM
 		instance->n_io_port = region_size;
+		((struct NCR5380_hostdata *)instance->hostdata)->pnpdev = pnpdevs[current_override];
 #else
 		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
 #endif
@@ -520,12 +523,14 @@ int generic_NCR5380_release_resources(st
 
 #ifndef SCSI_G_NCR5380_MEM
 	release_region(instance->NCR5380_instance_name, instance->n_io_port);
+	if (((struct NCR5380_hostdata *)instance->hostdata)->pnpdev)
+		pnp_device_detach(((struct NCR5380_hostdata *)instance->hostdata)->pnpdev);
 #else
 	iounmap(((struct NCR5380_hostdata *)instance->hostdata)->iomem);
 	release_mem_region(instance->NCR5380_instance_name, NCR5380_region_size);
 #endif
 
-
+	scsi_unregister(instance);
 	return 0;
 }
 
diff -puN drivers/scsi/g_NCR5380.h~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod drivers/scsi/g_NCR5380.h
--- a/drivers/scsi/g_NCR5380.h~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod
+++ a/drivers/scsi/g_NCR5380.h
@@ -82,10 +82,11 @@ static const char* generic_NCR5380_info(
 #define NCR5380_write(reg, value) (outb((value), (NCR5380_map_name + (reg))))
 
 #define NCR5380_implementation_fields \
-    NCR5380_map_type NCR5380_map_name
+    NCR5380_map_type NCR5380_map_name; \
+    struct pnp_dev *pnpdev;
 
 #define NCR5380_local_declare() \
-    register NCR5380_implementation_fields
+    NCR5380_map_type NCR5380_map_name
 
 #define NCR5380_setup(instance) \
     NCR5380_map_name = (NCR5380_map_type)((instance)->NCR5380_instance_name)
_

Patches currently in -mm which might be from linux@rainbow-software.org are

linux-next.patch
usbtouchscreen-support-bigger-inexio-touchscreens.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.patch

