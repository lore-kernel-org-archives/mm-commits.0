From: akpm@linux-foundation.org
Subject: + drivers-wireless-use-new-hex_to_bin-method.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:22 -0700
Message-ID: <201004301902.o3UJ2Mhx005923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933345Ab0D3TEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, linville@tuxdriver.com


The patch titled
     drivers: wireless: use new hex_to_bin() method
has been added to the -mm tree.  Its filename is
     drivers-wireless-use-new-hex_to_bin-method.patch

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
Subject: drivers: wireless: use new hex_to_bin() method
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation involve hex_to_bin() function.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Acked-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/airo.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/net/wireless/airo.c~drivers-wireless-use-new-hex_to_bin-method drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c~drivers-wireless-use-new-hex_to_bin-method
+++ a/drivers/net/wireless/airo.c
@@ -5162,13 +5162,6 @@ static void proc_SSID_on_close(struct in
 	enable_MAC(ai, 1);
 }
 
-static inline u8 hexVal(char c) {
-	if (c>='0' && c<='9') return c -= '0';
-	if (c>='a' && c<='f') return c -= 'a'-10;
-	if (c>='A' && c<='F') return c -= 'A'-10;
-	return 0;
-}
-
 static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	struct proc_data *data = (struct proc_data *)file->private_data;
 	struct proc_dir_entry *dp = PDE(inode);
@@ -5188,11 +5181,11 @@ static void proc_APList_on_close( struct
 			switch(j%3) {
 			case 0:
 				APList_rid.ap[i][j/3]=
-					hexVal(data->wbuffer[j+i*6*3])<<4;
+					hex_to_bin(data->wbuffer[j+i*6*3])<<4;
 				break;
 			case 1:
 				APList_rid.ap[i][j/3]|=
-					hexVal(data->wbuffer[j+i*6*3]);
+					hex_to_bin(data->wbuffer[j+i*6*3]);
 				break;
 			}
 		}
@@ -5340,10 +5333,10 @@ static void proc_wepkey_on_close( struct
 	for( i = 0; i < 16*3 && data->wbuffer[i+j]; i++ ) {
 		switch(i%3) {
 		case 0:
-			key[i/3] = hexVal(data->wbuffer[i+j])<<4;
+			key[i/3] = hex_to_bin(data->wbuffer[i+j])<<4;
 			break;
 		case 1:
-			key[i/3] |= hexVal(data->wbuffer[i+j]);
+			key[i/3] |= hex_to_bin(data->wbuffer[i+j]);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from ext-andriy.shevchenko@nokia.com are

linux-next.patch
lib-introduce-common-method-to-convert-hex-digits.patch
drivers-isdn-use-new-hex_to_bin-method.patch
usb-atm-speedtch-use-new-hex_to_bin-method.patch
sysctl-dont-use-own-implementation-of-hex_to_bin.patch
staging-rt2860-use-new-hex_to_bin-method.patch
fs-ldm-dont-use-own-implementation-of-hex_to_bin.patch
drivers-wireless-use-new-hex_to_bin-method.patch
drivers-acpi-dont-use-own-implementation-of-hex_to_bin.patch

