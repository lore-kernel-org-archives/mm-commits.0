From: akpm@linux-foundation.org
Subject: + drivers-edac-pci-broken-parity-regression.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:28:14 -0800
Message-ID: <200801100527.m0A5RsLk006777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbYAJF23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b1@omega71.com, dougthompson@xmisson.com


The patch titled
     drivers/edac: pci: broken parity regression
has been added to the -mm tree.  Its filename is
     drivers-edac-pci-broken-parity-regression.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/edac: pci: broken parity regression
From: Bryan Boatright <b1@omega71.com>

Using the EDAC code in kernel.org kernel version 2.6.23.8 I am seeing the
following problem:

    In the kernel there is a pci device attribute located in sysfs that is
    checked by the EDAC PCI scanning code. If that attribute is set,
    PCI parity/error scannining is skipped for that device. The attribute
    is:

            broken_parity_status

    as is located in /sys/devices/pci<XXX>/0000:XX:YY.Z directorys for
    PCI devices.

I don't think this check was actually implemented.  I have a misbehaved card
that reports a parity error every 1000 ms:

Nov 25 07:28:43 beta kernel: EDAC PCI: Master Data Parity Error on 0000:05:01.0
Nov 25 07:28:44 beta kernel: EDAC PCI: Master Data Parity Error on 0000:05:01.0
Nov 25 07:28:45 beta kernel: EDAC PCI: Master Data Parity Error on 0000:05:01.0

Setting that card's broken_parity_status bit did not mask the error:

echo "1" > /sys/bus/pci/devices/0000:05:01.0/broken_parity_status

I looked through the EDAC code and did not readily see any reference to
broken_parity_status at all (which makes sense based on the behavior I am
seeing).  I applied the following patch as a proof-of-concept and now EDAC's
PCI parity error reporting behaves as documented:

bryan

Good regression find, bryan. It used to work. sigh.
I added more logic to your patch, for more coverage of the error.

Doug T

Signed-off-by: Bryan Boatright <b1@omega71.com>
Signed-off-by: Doug Thompson <dougthompson@xmisson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_pci_sysfs.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/edac/edac_pci_sysfs.c~drivers-edac-pci-broken-parity-regression drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~drivers-edac-pci-broken-parity-regression
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -558,8 +558,10 @@ static void edac_pci_dev_parity_test(str
 
 	debugf4("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
-	/* check the status reg for errors */
-	if (status) {
+	/* check the status reg for errors on boards NOT marked as broken
+	 * if broken, we cannot trust any of the status bits
+	 */
+	if (status && !dev->broken_parity_status) {
 		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
 				"Signaled System Error on %s\n",
@@ -593,8 +595,10 @@ static void edac_pci_dev_parity_test(str
 
 		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
-		/* check the secondary status reg for errors */
-		if (status) {
+		/* check the secondary status reg for errors,
+		 * on NOT broken boards
+		 */
+		if (status && !dev->broken_parity_status) {
 			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
 					"Signaled System Error on %s\n",
_

Patches currently in -mm which might be from b1@omega71.com are

drivers-edac-pci-broken-parity-regression.patch
