From: akpm@linux-foundation.org
Subject: + workaround-for-a-pci-restoring-bug.patch added to -mm tree
Date: Mon, 14 May 2007 13:14:37 -0700
Message-ID: <200705142014.l4EKEbJj025156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759760AbXENUPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 16:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torvalds@linux-foundation.org, greg@kroah.com


The patch titled
     pci: test for unexpectedly disabled bridges
has been added to the -mm tree.  Its filename is
     workaround-for-a-pci-restoring-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: test for unexpectedly disabled bridges
From: Linus Torvalds <torvalds@linux-foundation.org>

The all-ones value is not just a "device didn't exist" case, it's also
potentially a quite valid value, so not restoring it would be wrong.

What *would* be interesting is to hear where the bad values came from in
the first place.  It sounds like the device state is saved after the PCI
bus controller in front of the device has been crapped on, resulting in the
PCI config cycles never reaching the device at all.

Something along this patch (together with suspend/resume debugging output)
migth help pinpoint it.  But it really sounds like something totally
brokenly turned off the PCI bridge (some ACPI shutdown crud?  I wouldn't be
entirely surprised)

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN drivers/pci/pci.c~workaround-for-a-pci-restoring-bug drivers/pci/pci.c
--- a/drivers/pci/pci.c~workaround-for-a-pci-restoring-bug
+++ a/drivers/pci/pci.c
@@ -635,6 +635,15 @@ int
 pci_save_state(struct pci_dev *dev)
 {
 	int i;
+	u32 val;
+
+	/* Unable to read PCI device/manufacturer state? Something is seriously wrong! */
+	if (pci_read_config_dword(dev, 0, &val) || val == 0xffffffff) {
+		printk("Broken read from PCI device %s\n", pci_name(dev));
+		WARN_ON(1);
+		return -1;
+	}
+
 	/* XXX: 100% dword access ok here? */
 	for (i = 0; i < 16; i++)
 		pci_read_config_dword(dev, i * 4,&dev->saved_config_space[i]);
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch
workaround-for-a-pci-restoring-bug.patch
