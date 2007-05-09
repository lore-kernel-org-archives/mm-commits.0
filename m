From: akpm@linux-foundation.org
Subject: - cm4000_cs-use-bitrev.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:58 -0700
Message-ID: <200705092149.l49Lnw6X002746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754713AbXEIVuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, laforge@gnumonks.org, linux@dominikbrodowski.net, mm-commits@vger.kernel.org


The patch titled
     cm4000_cs: use bitrev
has been removed from the -mm tree.  Its filename was
     cm4000_cs-use-bitrev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cm4000_cs: use bitrev
From: Akinobu Mita <akinobu.mita@gmail.com>

Cleanup using bitrev8 in cm4000_cs driver.

Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/Kconfig     |    1 
 drivers/char/pcmcia/cm4000_cs.c |   35 +++++-------------------------
 2 files changed, 7 insertions(+), 29 deletions(-)

diff -puN drivers/char/pcmcia/Kconfig~cm4000_cs-use-bitrev drivers/char/pcmcia/Kconfig
--- a/drivers/char/pcmcia/Kconfig~cm4000_cs-use-bitrev
+++ a/drivers/char/pcmcia/Kconfig
@@ -21,6 +21,7 @@ config SYNCLINK_CS
 config CARDMAN_4000
 	tristate "Omnikey Cardman 4000 support"
 	depends on PCMCIA
+	select BITREVERSE
 	help
 	  Enable support for the Omnikey Cardman 4000 PCMCIA Smartcard
 	  reader.
diff -puN drivers/char/pcmcia/cm4000_cs.c~cm4000_cs-use-bitrev drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~cm4000_cs-use-bitrev
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -31,6 +31,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
+#include <linux/bitrev.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -194,41 +195,17 @@ static inline unsigned char xinb(unsigne
 }
 #endif
 
-#define	b_0000	15
-#define	b_0001	14
-#define	b_0010	13
-#define	b_0011	12
-#define	b_0100	11
-#define	b_0101	10
-#define	b_0110	9
-#define	b_0111	8
-#define	b_1000	7
-#define	b_1001	6
-#define	b_1010	5
-#define	b_1011	4
-#define	b_1100	3
-#define	b_1101	2
-#define	b_1110	1
-#define	b_1111	0
-
-static unsigned char irtab[16] = {
-	b_0000, b_1000, b_0100, b_1100,
-	b_0010, b_1010, b_0110, b_1110,
-	b_0001, b_1001, b_0101, b_1101,
-	b_0011, b_1011, b_0111, b_1111
-};
+static inline unsigned char invert_revert(unsigned char ch)
+{
+	return bitrev8(~ch);
+}
 
 static void str_invert_revert(unsigned char *b, int len)
 {
 	int i;
 
 	for (i = 0; i < len; i++)
-		b[i] = (irtab[b[i] & 0x0f] << 4) | irtab[b[i] >> 4];
-}
-
-static unsigned char invert_revert(unsigned char ch)
-{
-	return (irtab[ch & 0x0f] << 4) | irtab[ch >> 4];
+		b[i] = invert_revert(b[i]);
 }
 
 #define	ATRLENCK(dev,pos) \
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
