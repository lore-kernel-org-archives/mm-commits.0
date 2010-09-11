From: akpm@linux-foundation.org
Subject: + firmware-ihex2fwc-add-support-for-cs-ip-eip-records.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:29:59 -0700
Message-ID: <201009110029.o8B0Txqk011765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab0IKAak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dwmw2@infradead.org


The patch titled
     firmware/ihex2fw.c: add support for CS:IP/EIP records
has been added to the -mm tree.  Its filename is
     firmware-ihex2fwc-add-support-for-cs-ip-eip-records.patch

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
Subject: firmware/ihex2fw.c: add support for CS:IP/EIP records
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

ihex firmwares can include a jump address for starting execution.  Add a
-j option which will cause this to be written into the generated file as a
record with address zero and data consisting of the address to jump to,
allowing drivers to make use of this information.

This format is chosen because it most closely follows the original ihex
format, though it may make more sense to write a record with length zero
and the address stored as the address.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/ihex2fw.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN firmware/ihex2fw.c~firmware-ihex2fwc-add-support-for-cs-ip-eip-records firmware/ihex2fw.c
--- a/firmware/ihex2fw.c~firmware-ihex2fwc-add-support-for-cs-ip-eip-records
+++ a/firmware/ihex2fw.c
@@ -55,6 +55,7 @@ static int output_records(int outfd);
 
 static int sort_records = 0;
 static int wide_records = 0;
+static int include_jump = 0;
 
 static int usage(void)
 {
@@ -63,6 +64,7 @@ static int usage(void)
 	fprintf(stderr, "usage: ihex2fw [<options>] <src.HEX> <dst.fw>\n");
 	fprintf(stderr, "       -w: wide records (16-bit length)\n");
 	fprintf(stderr, "       -s: sort records by address\n");
+	fprintf(stderr, "       -j: include records for CS:IP/EIP address\n");
 	return 1;
 }
 
@@ -73,7 +75,7 @@ int main(int argc, char **argv)
 	uint8_t *data;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "ws")) != -1) {
+	while ((opt = getopt(argc, argv, "wsj")) != -1) {
 		switch (opt) {
 		case 'w':
 			wide_records = 1;
@@ -81,7 +83,9 @@ int main(int argc, char **argv)
 		case 's':
 			sort_records = 1;
 			break;
-		default:
+		case 'j':
+			include_jump = 1;
+			break;
 			return usage();
 		}
 	}
@@ -128,6 +132,7 @@ static int process_ihex(uint8_t *data, s
 {
 	struct ihex_binrec *record;
 	uint32_t offset = 0;
+	uint32_t *data32;
 	uint8_t type, crc = 0, crcbyte = 0;
 	int i, j;
 	int line = 1;
@@ -223,8 +228,13 @@ next_record:
 			return -EINVAL;
 		}
 
+		data32 = &record->data[0];
+		*data32 = htonl(*data32);
+
 		/* These records contain the CS/IP or EIP where execution
-		 * starts. Don't really know what to do with them. */
+		 * starts. If requested output this as a record. */
+		if (include_jump)
+			file_record(record);
 		goto next_record;
 
 	default:
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
firmware-ihex2fwc-add-support-for-cs-ip-eip-records.patch
mmc-move-regulator-handling-closer-to-core-v3.patch
mmc-move-regulator-handling-closer-to-core-v4.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
mfd-max8998-add-interrupts-support.patch

