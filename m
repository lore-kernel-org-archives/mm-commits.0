From: akpm@osdl.org
Subject: + x86_64-sync-up-probe_roms-with-i386.patch added to -mm tree
Date: Mon, 29 Jan 2007 16:48:30 -0800
Message-ID: <200701300048.l0U0mUdD004554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35565 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965261AbXA3Asg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 19:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@gmail.com, ak@suse.de, jeremy@goop.org, zach@vmware.com


The patch titled
     x86_64: sync up probe_roms() with i386
has been added to the -mm tree.  Its filename is
     x86_64-sync-up-probe_roms-with-i386.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: sync up probe_roms() with i386
From: Rene Herman <rene.herman@gmail.com>

Sync up with i386. Specifically, be careful about touching the
legacy ROMs; in virtualized environments they may not be mapped.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/setup.c |   35 +++++++++++++++++++++++++----------
 1 files changed, 25 insertions(+), 10 deletions(-)

diff -puN arch/x86_64/kernel/setup.c~x86_64-sync-up-probe_roms-with-i386 arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86_64-sync-up-probe_roms-with-i386
+++ a/arch/x86_64/kernel/setup.c
@@ -183,22 +183,31 @@ static struct resource video_ram_resourc
 	.flags = IORESOURCE_RAM,
 };
 
-#define romsignature(x) (*(unsigned short *)(x) == 0xaa55)
+#define ROMSIGNATURE 0xaa55
 
-static int __init romchecksum(unsigned char *rom, unsigned long length)
+static int __init romsignature(const unsigned char *rom)
 {
-	unsigned char *p, sum = 0;
+	const unsigned short * const ptr = (const unsigned short *)rom;
+	unsigned short sig;
 
-	for (p = rom; p < rom + length; p++)
-		sum += *p;
-	return sum == 0;
+	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
+}
+
+static int __init romchecksum(const unsigned char *rom, unsigned long length)
+{
+	unsigned char sum, c;
+
+	for (sum = 0; length && probe_kernel_address(rom++, c) == 0; length--)
+		sum += c;
+	return !length && !sum;
 }
 
 static void __init probe_roms(void)
 {
+	const unsigned char *rom;
 	unsigned long start, length, upper;
-	unsigned char *rom;
-	int	      i;
+	unsigned char c;
+	int i;
 
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
@@ -209,8 +218,11 @@ static void __init probe_roms(void)
 
 		video_rom_resource.start = start;
 
+		if (probe_kernel_address(rom, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* if checksum okay, trust length byte */
 		if (length && romchecksum(rom, length))
@@ -245,8 +257,11 @@ static void __init probe_roms(void)
 		if (!romsignature(rom))
 			continue;
 
+		if (probe_kernel_address(rom, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* but accept any length that fits if checksum okay */
 		if (!length || start + length > upper || !romchecksum(rom, length))
_

Patches currently in -mm which might be from rene.herman@gmail.com are

i386-probe_roms-cleanup.patch
x86_64-sync-up-probe_roms-with-i386.patch
