From: akpm@linux-foundation.org
Subject: + fs-ldm-dont-use-own-implementation-of-hex_to_bin.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:02:20 -0700
Message-ID: <201004301902.o3UJ2Kqr005920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759416Ab0D3TEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:04:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-andriy.shevchenko@nokia.com, ldm@flatcap.org


The patch titled
     fs: ldm: don't use own implementation of hex_to_bin()
has been added to the -mm tree.  Its filename is
     fs-ldm-dont-use-own-implementation-of-hex_to_bin.patch

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
Subject: fs: ldm: don't use own implementation of hex_to_bin()
From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Remove own implementation of hex_to_bin().

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: "Richard Russon (FlatCap)" <ldm@flatcap.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/ldm.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/partitions/ldm.c~fs-ldm-dont-use-own-implementation-of-hex_to_bin fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~fs-ldm-dont-use-own-implementation-of-hex_to_bin
+++ a/fs/partitions/ldm.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/stringify.h>
+#include <linux/kernel.h>
 #include "ldm.h"
 #include "check.h"
 #include "msdos.h"
@@ -77,17 +78,16 @@ static int ldm_parse_hexbyte (const u8 *
 	int h;
 
 	/* high part */
-	if      ((x = src[0] - '0') <= '9'-'0') h = x;
-	else if ((x = src[0] - 'a') <= 'f'-'a') h = x+10;
-	else if ((x = src[0] - 'A') <= 'F'-'A') h = x+10;
-	else return -1;
-	h <<= 4;
+	x = h = hex_to_bin(src[0]);
+	if (h < 0)
+		return -1;
 
 	/* low part */
-	if ((x = src[1] - '0') <= '9'-'0') return h | x;
-	if ((x = src[1] - 'a') <= 'f'-'a') return h | (x+10);
-	if ((x = src[1] - 'A') <= 'F'-'A') return h | (x+10);
-	return -1;
+	h = hex_to_bin(src[1]);
+	if (h < 0)
+		return -1;
+
+	return (x << 4) + h;
 }
 
 /**
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

