From: akpm@linux-foundation.org
Subject: [merged] ldm-use-generic-uuid-library.patch removed from -mm tree
Date: Mon, 23 May 2016 12:49:04 -0700
Message-ID: <57435eb0.L5Unt4ThF/UyPjhS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbcEWTtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:49:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, axboe@kernel.dk, ldm@flatcap.org, mm-commits@vger.kernel.org


The patch titled
     Subject: block/partitions/ldm.c: use generic UUID library
has been removed from the -mm tree.  Its filename was
     ldm-use-generic-uuid-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: block/partitions/ldm.c: use generic UUID library

Instead of opencoding let's use generic UUID library functions here.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Richard Russon (FlatCap)" <ldm@flatcap.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/ldm.c |   60 ++-------------------------------------
 1 file changed, 4 insertions(+), 56 deletions(-)

diff -puN block/partitions/ldm.c~ldm-use-generic-uuid-library block/partitions/ldm.c
--- a/block/partitions/ldm.c~ldm-use-generic-uuid-library
+++ a/block/partitions/ldm.c
@@ -27,6 +27,8 @@
 #include <linux/pagemap.h>
 #include <linux/stringify.h>
 #include <linux/kernel.h>
+#include <linux/uuid.h>
+
 #include "ldm.h"
 #include "check.h"
 #include "msdos.h"
@@ -66,60 +68,6 @@ void _ldm_printk(const char *level, cons
 }
 
 /**
- * ldm_parse_hexbyte - Convert a ASCII hex number to a byte
- * @src:  Pointer to at least 2 characters to convert.
- *
- * Convert a two character ASCII hex string to a number.
- *
- * Return:  0-255  Success, the byte was parsed correctly
- *          -1     Error, an invalid character was supplied
- */
-static int ldm_parse_hexbyte (const u8 *src)
-{
-	unsigned int x;		/* For correct wrapping */
-	int h;
-
-	/* high part */
-	x = h = hex_to_bin(src[0]);
-	if (h < 0)
-		return -1;
-
-	/* low part */
-	h = hex_to_bin(src[1]);
-	if (h < 0)
-		return -1;
-
-	return (x << 4) + h;
-}
-
-/**
- * ldm_parse_guid - Convert GUID from ASCII to binary
- * @src:   36 char string of the form fa50ff2b-f2e8-45de-83fa-65417f2f49ba
- * @dest:  Memory block to hold binary GUID (16 bytes)
- *
- * N.B. The GUID need not be NULL terminated.
- *
- * Return:  'true'   @dest contains binary GUID
- *          'false'  @dest contents are undefined
- */
-static bool ldm_parse_guid (const u8 *src, u8 *dest)
-{
-	static const int size[] = { 4, 2, 2, 2, 6 };
-	int i, j, v;
-
-	if (src[8]  != '-' || src[13] != '-' ||
-	    src[18] != '-' || src[23] != '-')
-		return false;
-
-	for (j = 0; j < 5; j++, src++)
-		for (i = 0; i < size[j]; i++, src+=2, *dest++ = v)
-			if ((v = ldm_parse_hexbyte (src)) < 0)
-				return false;
-
-	return true;
-}
-
-/**
  * ldm_parse_privhead - Read the LDM Database PRIVHEAD structure
  * @data:  Raw database PRIVHEAD structure loaded from the device
  * @ph:    In-memory privhead structure in which to return parsed information
@@ -167,7 +115,7 @@ static bool ldm_parse_privhead(const u8
 		ldm_error("PRIVHEAD disk size doesn't match real disk size");
 		return false;
 	}
-	if (!ldm_parse_guid(data + 0x0030, ph->disk_id)) {
+	if (uuid_be_to_bin(data + 0x0030, (uuid_be *)ph->disk_id)) {
 		ldm_error("PRIVHEAD contains an invalid GUID.");
 		return false;
 	}
@@ -944,7 +892,7 @@ static bool ldm_parse_dsk3 (const u8 *bu
 	disk = &vb->vblk.disk;
 	ldm_get_vstr (buffer + 0x18 + r_diskid, disk->alt_name,
 		sizeof (disk->alt_name));
-	if (!ldm_parse_guid (buffer + 0x19 + r_name, disk->disk_id))
+	if (uuid_be_to_bin(buffer + 0x19 + r_name, (uuid_be *)disk->disk_id))
 		return false;
 
 	return true;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

wmi-use-generic-uuid-library.patch

