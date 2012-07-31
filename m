From: akpm@linux-foundation.org
Subject: [merged] vsprintf-add-%pmr-for-bluetooth-mac-address.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:50 -0700
Message-ID: <20120731184951.1AD265C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57525 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2GaStx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:53 -0400
Received: by eaao12 with SMTP id o12so241388eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrei.emeltchenko@intel.com, joe@perches.com, marcel@holtmann.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf: add %pMR for Bluetooth MAC address
has been removed from the -mm tree.  Its filename was
     vsprintf-add-%pmr-for-bluetooth-mac-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Subject: vsprintf: add %pMR for Bluetooth MAC address

Bluetooth uses mostly LE byte order which is reversed for visual
interpretation.  Currently in Bluetooth in use unsafe batostr function.

This is a slightly modified version of Joe's patch (sent Sat, Dec 4,
2010).

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    5 +++++
 lib/vsprintf.c                   |   23 +++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff -puN Documentation/printk-formats.txt~vsprintf-add-%pmr-for-bluetooth-mac-address Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~vsprintf-add-%pmr-for-bluetooth-mac-address
+++ a/Documentation/printk-formats.txt
@@ -56,6 +56,7 @@ Struct Resources:
 MAC/FDDI addresses:
 
 	%pM	00:01:02:03:04:05
+	%pMR	05:04:03:02:01:00
 	%pMF	00-01-02-03-04-05
 	%pm	000102030405
 
@@ -67,6 +68,10 @@ MAC/FDDI addresses:
 	the 'M' specifier to use dash ('-') separators instead of the default
 	separator.
 
+	For Bluetooth addresses the 'R' specifier shall be used after the 'M'
+	specifier to use reversed byte order suitable for visual interpretation
+	of Bluetooth addresses which are in the little endian order.
+
 IPv4 addresses:
 
 	%pI4	1.2.3.4
diff -puN lib/vsprintf.c~vsprintf-add-%pmr-for-bluetooth-mac-address lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-add-%pmr-for-bluetooth-mac-address
+++ a/lib/vsprintf.c
@@ -662,15 +662,28 @@ char *mac_address_string(char *buf, char
 	char *p = mac_addr;
 	int i;
 	char separator;
+	bool reversed = false;
 
-	if (fmt[1] == 'F') {		/* FDDI canonical format */
+	switch (fmt[1]) {
+	case 'F':
 		separator = '-';
-	} else {
+		break;
+
+	case 'R':
+		reversed = true;
+		/* fall through */
+
+	default:
 		separator = ':';
+		break;
 	}
 
 	for (i = 0; i < 6; i++) {
-		p = hex_byte_pack(p, addr[i]);
+		if (reversed)
+			p = hex_byte_pack(p, addr[5 - i]);
+		else
+			p = hex_byte_pack(p, addr[i]);
+
 		if (fmt[0] == 'M' && i != 5)
 			*p++ = separator;
 	}
@@ -933,6 +946,7 @@ int kptr_restrict __read_mostly;
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
+ * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -995,7 +1009,8 @@ char *pointer(const char *fmt, char *buf
 		return resource_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
-					/* [mM]F (FDDI, bit reversed) */
+					/* [mM]F (FDDI) */
+					/* [mM]R (Reverse order; Bluetooth) */
 		return mac_address_string(buf, end, ptr, spec, fmt);
 	case 'I':			/* Formatted IP supported
 					 * 4:	1.2.3.4
_

Patches currently in -mm which might be from andrei.emeltchenko@intel.com are

origin.patch
linux-next.patch

