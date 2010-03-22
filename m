From: akpm@linux-foundation.org
Subject: + hpet-pass-physical-address-not-entire-hpet_data-to-hpet_is_known.patch added to -mm tree
Date: Mon, 22 Mar 2010 16:39:02 -0700
Message-ID: <201003222339.o2MNd2jT001701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376Ab0CVXjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 19:39:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, clemens@ladisch.de, venki@google.com


The patch titled
     hpet: pass physical address, not entire hpet_data, to hpet_is_known()
has been added to the -mm tree.  Its filename is
     hpet-pass-physical-address-not-entire-hpet_data-to-hpet_is_known.patch

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
Subject: hpet: pass physical address, not entire hpet_data, to hpet_is_known()
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

No functional change; hpet_is_known() only needs the physical address, so
supplying that instead of the whole struct hpet_data makes the callers a
little simpler.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/char/hpet.c~hpet-pass-physical-address-not-entire-hpet_data-to-hpet_is_known drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-pass-physical-address-not-entire-hpet_data-to-hpet_is_known
+++ a/drivers/char/hpet.c
@@ -700,12 +700,12 @@ static const struct file_operations hpet
 	.mmap = hpet_mmap,
 };
 
-static int hpet_is_known(struct hpet_data *hdp)
+static int hpet_is_known(unsigned long phys_address)
 {
 	struct hpets *hpetp;
 
 	for (hpetp = hpets; hpetp; hpetp = hpetp->hp_next)
-		if (hpetp->hp_hpet_phys == hdp->hd_phys_address)
+		if (hpetp->hp_hpet_phys == phys_address)
 			return 1;
 
 	return 0;
@@ -826,7 +826,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	 * If platform dependent code has allocated the hpet that
 	 * ACPI has also reported, then we catch it here.
 	 */
-	if (hpet_is_known(hdp)) {
+	if (hpet_is_known(hdp->hd_phys_address)) {
 		printk(KERN_DEBUG "%s: duplicate HPET ignored\n",
 			__func__);
 		return 0;
@@ -954,12 +954,7 @@ static int hpet_pnp_add(struct pnp_dev *
 	memset(&data, 0, sizeof(data));
 
 	mem = pnp_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!mem)
-		return -ENODEV;
-
-	data.hd_phys_address = mem->start;
-
-	if (hpet_is_known(&data))
+	if (!mem || hpet_is_known(mem->start))
 		return -ENODEV;
 
 	i = 0;
@@ -971,6 +966,7 @@ static int hpet_pnp_add(struct pnp_dev *
 	if (!data.hd_nirqs)
 		return -ENODEV;
 
+	data.hd_phys_address = mem->start;
 	data.hd_address = ioremap(mem->start, resource_size(mem));
 
 	return hpet_alloc(&data);
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

