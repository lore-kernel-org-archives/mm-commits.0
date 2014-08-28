From: akpm@linux-foundation.org
Subject: + staging-wlan-ng-use-%pehp-to-print-sn.patch added to -mm tree
Date: Thu, 28 Aug 2014 14:09:15 -0700
Message-ID: <53ff9a7b.9kxfj0FR6Q0WObx7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:37098 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaH1WFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Aug 2014 18:05:52 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so427760igd.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Aug 2014 15:05:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: wlan-ng: use %*pEhp to print SN
has been added to the -mm tree.  Its filename is
     staging-wlan-ng-use-%pehp-to-print-sn.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/staging-wlan-ng-use-%pehp-to-print-sn.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/staging-wlan-ng-use-%pehp-to-print-sn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch
linux-next.patch

