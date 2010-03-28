From: akpm@linux-foundation.org
Subject: [to-be-updated] hpet-clean-up-io-mapping-when-hpet_alloc-fails.patch removed from -mm tree
Date: Sun, 28 Mar 2010 13:34:32 -0400
Message-ID: <201003282035.o2SKZaXV003492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190Ab0C1Ufq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Mar 2010 16:35:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, clemens@ladisch.de, venki@google.com, mm-commits@vger.kernel.org


The patch titled
     hpet: clean up io mapping when hpet_alloc() fails
has been removed from the -mm tree.  Its filename was
     hpet-clean-up-io-mapping-when-hpet_alloc-fails.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: clean up io mapping when hpet_alloc() fails
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When hpet_alloc() fails, we should iounmap() the timer so we don't leak
the mapping.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/char/hpet.c~hpet-clean-up-io-mapping-when-hpet_alloc-fails drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-clean-up-io-mapping-when-hpet_alloc-fails
+++ a/drivers/char/hpet.c
@@ -949,7 +949,7 @@ static int hpet_pnp_add(struct pnp_dev *
 {
 	struct hpet_data data;
 	struct resource *mem, *irq;
-	int i;
+	int i, ret;
 
 	memset(&data, 0, sizeof(data));
 
@@ -969,7 +969,11 @@ static int hpet_pnp_add(struct pnp_dev *
 	data.hd_phys_address = mem->start;
 	data.hd_address = ioremap(mem->start, resource_size(mem));
 
-	return hpet_alloc(&data);
+	ret = hpet_alloc(&data);
+	if (ret)
+		iounmap(data.hd_address);
+
+	return ret;
 }
 
 static void hpet_pnp_remove(struct pnp_dev *dev)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
hpet-clean-up-io-mapping-when-hpet_alloc-fails.patch
maintainers-remove-obsolete-hpet-acpi-entry.patch
ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch
ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch

