From: akpm@linux-foundation.org
Subject: + hpet-clean-up-io-mapping-when-hpet_alloc-fails.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:39:06 -0700
Message-ID: <201003222339.o2MNd6wN001704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab0CVXjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, clemens@ladisch.de, venki@google.com


The patch titled
     hpet: clean up io mapping when hpet_alloc() fails
has been added to the -mm tree.  Its filename is
     hpet-clean-up-io-mapping-when-hpet_alloc-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
hpet-convert-from-acpi-to-pnp-driver.patch
hpet-pass-physical-address-not-entire-hpet_data-to-hpet_is_known.patch
hpet-clean-up-io-mapping-when-hpet_alloc-fails.patch
maintainers-remove-obsolete-hpet-acpi-entry.patch
ipmi-raise-precedence-of-pnp-based-discovery-mechanisms-acpi-pci.patch
ipmi-convert-tracking-of-the-acpi-device-pointer-to-a-pnp-device.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs.patch

