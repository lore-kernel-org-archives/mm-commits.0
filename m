From: akpm@linux-foundation.org
Subject: - pci-quirks-dont-mark-one-netmos-as-class-other.patch removed from -mm tree
Date: Thu, 11 Dec 2008 11:15:13 -0800
Message-ID: <200812111915.mBBJFDYR008313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977AbYLKTPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 14:15:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     PCI: quirks, don't mark one netmos as class other
has been removed from the -mm tree.  Its filename was
     pci-quirks-dont-mark-one-netmos-as-class-other.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI: quirks, don't mark one netmos as class other
From: Jiri Slaby <jirislaby@gmail.com>

Let it as serial, since it doesn't have subdevice in the form of 0x00PS.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/pci/quirks.c~pci-quirks-dont-mark-one-netmos-as-class-other drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-quirks-dont-mark-one-netmos-as-class-other
+++ a/drivers/pci/quirks.c
@@ -1660,9 +1660,13 @@ static void __devinit quirk_netmos(struc
 	 * of parallel ports and <S> is the number of serial ports.
 	 */
 	switch (dev->device) {
+	case PCI_DEVICE_ID_NETMOS_9835:
+		/* Well, this rule doesn't hold for the following 9835 device */
+		if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+				dev->subsystem_device == 0x0299)
+			return;
 	case PCI_DEVICE_ID_NETMOS_9735:
 	case PCI_DEVICE_ID_NETMOS_9745:
-	case PCI_DEVICE_ID_NETMOS_9835:
 	case PCI_DEVICE_ID_NETMOS_9845:
 	case PCI_DEVICE_ID_NETMOS_9855:
 		if ((dev->class >> 8) == PCI_CLASS_COMMUNICATION_SERIAL &&
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
8250_pci-add-support-for-netmos-9835.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

