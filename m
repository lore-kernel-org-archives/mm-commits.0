From: akpm@linux-foundation.org
Subject: [merged] staging-wlan-ng-use-%pehp-to-print-sn.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:23:02 -0700
Message-ID: <543d6a06.FQo+7I4Xi51tcyW1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: wlan-ng: use %*pEhp to print SN
has been removed from the -mm tree.  Its filename was
     staging-wlan-ng-use-%pehp-to-print-sn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: staging: wlan-ng: use %*pEhp to print SN

This is a generic specifier to print an escaped buffer by given criteria. 
Let's use it instead of custom approach.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/wlan-ng/prism2sta.c |   28 +-------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff -puN drivers/staging/wlan-ng/prism2sta.c~staging-wlan-ng-use-%pehp-to-print-sn drivers/staging/wlan-ng/prism2sta.c
--- a/drivers/staging/wlan-ng/prism2sta.c~staging-wlan-ng-use-%pehp-to-print-sn
+++ a/drivers/staging/wlan-ng/prism2sta.c
@@ -60,7 +60,6 @@
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
 #include <linux/byteorder/generic.h>
-#include <linux/ctype.h>
 
 #include <linux/io.h>
 #include <linux/delay.h>
@@ -81,27 +80,6 @@
 #include "hfa384x.h"
 #include "prism2mgmt.h"
 
-/* Create a string of printable chars from something that might not be */
-/* It's recommended that the str be 4*len + 1 bytes long */
-#define wlan_mkprintstr(buf, buflen, str, strlen) \
-{ \
-	int i = 0; \
-	int j = 0; \
-	memset(str, 0, (strlen)); \
-	for (i = 0; i < (buflen); i++) { \
-		if (isprint((buf)[i])) { \
-			(str)[j] = (buf)[i]; \
-			j++; \
-		} else { \
-			(str)[j] = '\\'; \
-			(str)[j+1] = 'x'; \
-			(str)[j+2] = hex_asc_hi((buf)[i]); \
-			(str)[j+3] = hex_asc_lo((buf)[i]); \
-			j += 4; \
-		} \
-	} \
-}
-
 static char *dev_info = "prism2_usb";
 static wlandevice_t *create_wlan(void);
 
@@ -607,7 +585,6 @@ static int prism2sta_getcardinfo(wlandev
 	hfa384x_t *hw = (hfa384x_t *) wlandev->priv;
 	u16 temp;
 	u8 snum[HFA384x_RID_NICSERIALNUMBER_LEN];
-	char pstr[(HFA384x_RID_NICSERIALNUMBER_LEN * 4) + 1];
 
 	/* Collect version and compatibility info */
 	/*  Some are critical, some are not */
@@ -862,9 +839,8 @@ static int prism2sta_getcardinfo(wlandev
 	result = hfa384x_drvr_getconfig(hw, HFA384x_RID_NICSERIALNUMBER,
 					snum, HFA384x_RID_NICSERIALNUMBER_LEN);
 	if (!result) {
-		wlan_mkprintstr(snum, HFA384x_RID_NICSERIALNUMBER_LEN,
-				pstr, sizeof(pstr));
-		netdev_info(wlandev->netdev, "Prism2 card SN: %s\n", pstr);
+		netdev_info(wlandev->netdev, "Prism2 card SN: %*pEhp\n",
+			    HFA384x_RID_NICSERIALNUMBER_LEN, snum);
 	} else {
 		netdev_err(wlandev->netdev, "Failed to retrieve Prism2 Card SN\n");
 		goto failed;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

