From: akpm@linux-foundation.org
Subject: + drivers-isdn-use-new-hex_to_bin-method.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:12 -0700
Message-ID: <201004301902.o3UJ2CG6005906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933416Ab0D3TCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, tilman@imap.cc


The patch titled
     drivers: isdn: use new hex_to_bin() method
has been added to the -mm tree.  Its filename is
     drivers-isdn-use-new-hex_to_bin-method.patch

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
Subject: drivers: isdn: use new hex_to_bin() method
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Remove own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Acked-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/capi.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/isdn/gigaset/capi.c~drivers-isdn-use-new-hex_to_bin-method drivers/isdn/gigaset/capi.c
--- a/drivers/isdn/gigaset/capi.c~drivers-isdn-use-new-hex_to_bin-method
+++ a/drivers/isdn/gigaset/capi.c
@@ -170,17 +170,6 @@ static inline void ignore_cstruct_param(
 }
 
 /*
- * convert hex to binary
- */
-static inline u8 hex2bin(char c)
-{
-	int result = c & 0x0f;
-	if (c & 0x40)
-		result += 9;
-	return result;
-}
-
-/*
  * convert an IE from Gigaset hex string to ETSI binary representation
  * including length byte
  * return value: result length, -1 on error
@@ -191,7 +180,7 @@ static int encode_ie(char *in, u8 *out, 
 	while (*in) {
 		if (!isxdigit(in[0]) || !isxdigit(in[1]) || l >= maxlen)
 			return -1;
-		out[++l] = (hex2bin(in[0]) << 4) + hex2bin(in[1]);
+		out[++l] = (hex_to_bin(in[0]) << 4) + hex_to_bin(in[1]);
 		in += 2;
 	}
 	out[0] = l;
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

