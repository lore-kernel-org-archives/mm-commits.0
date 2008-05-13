From: akpm@linux-foundation.org
Subject: - pnp-set-irq-index-in-sysfs-set-irq-interface.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:39 -0700
Message-ID: <200805132133.m4DLXdc0000842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762170AbYEMVeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     PNP: set IRQ index in sysfs "set irq" interface
has been removed from the -mm tree.  Its filename was
     pnp-set-irq-index-in-sysfs-set-irq-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: set IRQ index in sysfs "set irq" interface
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

We have to set the ISAPNP register index when setting an IRQ via the sysfs
interface.  We already do it for IO, MEM, and DMA resources; I just missed the
IRQ one.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pnp/interface.c~pnp-set-irq-index-in-sysfs-set-irq-interface drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-set-irq-index-in-sysfs-set-irq-interface
+++ a/drivers/pnp/interface.c
@@ -424,7 +424,7 @@ pnp_set_current_resources(struct device 
 				start = simple_strtoul(buf, &buf, 0);
 				pnp_res = pnp_add_irq_resource(dev, start, 0);
 				if (pnp_res)
-					nirq++;
+					pnp_res->index = nirq++;
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-cleanup-pnp_fixup_device.patch
pnp-add-pnp_build_option-to-the-api.patch
pnp-add-isapnp-mpu-option-quirks.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
make-pnp_add_card_id-static.patch

