From: akpm@linux-foundation.org
Subject: + vsprintf-add-%pmr-for-bluetooth-mac-address.patch added to -mm tree
Date: Fri, 08 Jun 2012 16:29:52 -0700
Message-ID: <20120608232952.94388A02DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60123 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760334Ab2FHX3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 19:29:54 -0400
Received: by were53 with SMTP id e53so132258wer.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 16:29:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrei.emeltchenko@intel.com, joe@perches.com, marcel@holtmann.org


The patch titled
     Subject: vsprintf: add %pMR for Bluetooth MAC address
has been added to the -mm tree.  Its filename is
     vsprintf-add-%pmr-for-bluetooth-mac-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 lib/vsprintf.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

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
Subject: Subject: vsprintf: add %pMR for Bluetooth MAC address

Patches currently in -mm which might be from andrei.emeltchenko@intel.com are

linux-next.patch
vsprintf-add-%pmr-for-bluetooth-mac-address.patch

