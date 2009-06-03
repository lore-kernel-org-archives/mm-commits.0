From: akpm@linux-foundation.org
Subject: [merged] usb-cdc-acm-quirk-for-alcatel-ot-i650.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:37 -0700
Message-ID: <200906032002.n53K2bvB001891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820AbZFCUC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kir@openvz.org, greg@kroah.com, oliver@neukum.org, mm-commits@vger.kernel.org


The patch titled
     usb: cdc-acm: quirk for Alcatel OT-I650
has been removed from the -mm tree.  Its filename was
     usb-cdc-acm-quirk-for-alcatel-ot-i650.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: cdc-acm: quirk for Alcatel OT-I650
From: Kir Kolyshkin <kir@openvz.org>

This mobile phone fails to work as a modem, failing with:
 cdc_acm: Zero length descriptor references
 cdc_acm: probe of 1-6.1.3:1.1 failed with error -22

Tested to work fine with this patch.

Signed-off-by: Kir Kolyshkin <kir@openvz.org>
Cc: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/usb/class/cdc-acm.c~usb-cdc-acm-quirk-for-alcatel-ot-i650 drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~usb-cdc-acm-quirk-for-alcatel-ot-i650
+++ a/drivers/usb/class/cdc-acm.c
@@ -1451,6 +1451,9 @@ static struct usb_device_id acm_ids[] = 
 					   Maybe we should define a new
 					   quirk for this. */
 	},
+	{ USB_DEVICE(0x1bbb, 0x0003), /* Alcatel OT-I650 */
+	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
+	},
 
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
_

Patches currently in -mm which might be from kir@openvz.org are

linux-next.patch

