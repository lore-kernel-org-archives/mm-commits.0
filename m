From: akpm@linux-foundation.org
Subject: + drivers-scsi-use-newly-introduced-hex_to_bin-method.patch added to -mm tree
Date: Fri, 18 Jun 2010 13:57:49 -0700
Message-ID: <201006182057.o5IKvndS022995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950Ab0FRU7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 16:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, James.Bottomley@suse.de, aacraid@adaptec.com, james.smart@emulex.com


The patch titled
     drivers: scsi: use newly introduced hex_to_bin() method
has been added to the -mm tree.  Its filename is
     drivers-scsi-use-newly-introduced-hex_to_bin-method.patch

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
Subject: drivers: scsi: use newly introduced hex_to_bin() method
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: James Smart <james.smart@emulex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/rx.c        |    5 ++---
 drivers/scsi/lpfc/lpfc_attr.c    |   23 +++++++++++------------
 drivers/scsi/scsi_transport_fc.c |   12 ++++++------
 3 files changed, 19 insertions(+), 21 deletions(-)

diff -puN drivers/scsi/aacraid/rx.c~drivers-scsi-use-newly-introduced-hex_to_bin-method drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~drivers-scsi-use-newly-introduced-hex_to_bin-method
+++ a/drivers/scsi/aacraid/rx.c
@@ -352,9 +352,8 @@ static int aac_rx_check_health(struct aa
 		pci_free_consistent(dev->pdev, sizeof(struct POSTSTATUS),
 		  post, paddr);
 		if (likely((buffer[0] == '0') && ((buffer[1] == 'x') || (buffer[1] == 'X')))) {
-			ret = (buffer[2] <= '9') ? (buffer[2] - '0') : (buffer[2] - 'A' + 10);
-			ret <<= 4;
-			ret += (buffer[3] <= '9') ? (buffer[3] - '0') : (buffer[3] - 'A' + 10);
+			ret = (hex_to_bin(buffer[2]) << 4) +
+				hex_to_bin(buffer[3]);
 		}
 		pci_free_consistent(dev->pdev, 512, buffer, baddr);
 		return ret;
diff -puN drivers/scsi/lpfc/lpfc_attr.c~drivers-scsi-use-newly-introduced-hex_to_bin-method drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c~drivers-scsi-use-newly-introduced-hex_to_bin-method
+++ a/drivers/scsi/lpfc/lpfc_attr.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/gfp.h>
+#include <linux/kernel.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -1795,12 +1796,11 @@ lpfc_soft_wwpn_store(struct device *dev,
 
 	/* Validate and store the new name */
 	for (i=0, j=0; i < 16; i++) {
-		if ((*buf >= 'a') && (*buf <= 'f'))
-			j = ((j << 4) | ((*buf++ -'a') + 10));
-		else if ((*buf >= 'A') && (*buf <= 'F'))
-			j = ((j << 4) | ((*buf++ -'A') + 10));
-		else if ((*buf >= '0') && (*buf <= '9'))
-			j = ((j << 4) | (*buf++ -'0'));
+		int value;
+
+		value = hex_to_bin(*buf++);
+		if (value >= 0)
+			j = (j << 4) | value;
 		else
 			return -EINVAL;
 		if (i % 2) {
@@ -1888,12 +1888,11 @@ lpfc_soft_wwnn_store(struct device *dev,
 
 	/* Validate and store the new name */
 	for (i=0, j=0; i < 16; i++) {
-		if ((*buf >= 'a') && (*buf <= 'f'))
-			j = ((j << 4) | ((*buf++ -'a') + 10));
-		else if ((*buf >= 'A') && (*buf <= 'F'))
-			j = ((j << 4) | ((*buf++ -'A') + 10));
-		else if ((*buf >= '0') && (*buf <= '9'))
-			j = ((j << 4) | (*buf++ -'0'));
+		int value;
+
+		value = hex_to_bin(*buf++);
+		if (value >= 0)
+			j = (j << 4) | value;
 		else
 			return -EINVAL;
 		if (i % 2) {
diff -puN drivers/scsi/scsi_transport_fc.c~drivers-scsi-use-newly-introduced-hex_to_bin-method drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c~drivers-scsi-use-newly-introduced-hex_to_bin-method
+++ a/drivers/scsi/scsi_transport_fc.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/kernel.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -1730,12 +1731,11 @@ fc_parse_wwn(const char *ns, u64 *nm)
 
 	/* Validate and store the new name */
 	for (i=0, j=0; i < 16; i++) {
-		if ((*ns >= 'a') && (*ns <= 'f'))
-			j = ((j << 4) | ((*ns++ -'a') + 10));
-		else if ((*ns >= 'A') && (*ns <= 'F'))
-			j = ((j << 4) | ((*ns++ -'A') + 10));
-		else if ((*ns >= '0') && (*ns <= '9'))
-			j = ((j << 4) | (*ns++ -'0'));
+		int value;
+
+		value = hex_to_bin(*ns++);
+		if (value >= 0)
+			j = (j << 4) | value;
 		else
 			return -EINVAL;
 		if (i % 2) {
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
drivers-net-cxgb3-t3_hwc-use-new-hex_to_bin-method.patch
drivers-scsi-use-newly-introduced-hex_to_bin-method.patch

