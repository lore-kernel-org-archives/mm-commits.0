From: akpm@linux-foundation.org
Subject: - i386-probe_roms-cleanup.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:39 -0800
Message-ID: <200702180215.l1I2Fdcf008416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993122AbXBRCPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@gmail.com, ak@suse.de, jeremy@goop.org, murrayma@citi.umich.edu, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386: probe_roms() cleanup
has been removed from the -mm tree.  Its filename was
     i386-probe_roms-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: probe_roms() cleanup
From: Rene Herman <rene.herman@gmail.com>

Remove the assumption that if the first page of a legacy ROM is mapped,
it'll all be mapped. This'll also stop people reading this code from
wondering if they're looking at a bug...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Martin Murray <murrayma@citi.umich.edu>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/e820.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/e820.c~i386-probe_roms-cleanup arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~i386-probe_roms-cleanup
+++ a/arch/i386/kernel/e820.c
@@ -161,26 +161,27 @@ static struct resource standard_io_resou
 
 static int __init romsignature(const unsigned char *rom)
 {
+	const unsigned short * const ptr = (const unsigned short *)rom;
 	unsigned short sig;
 
-	return probe_kernel_address((const unsigned short *)rom, sig) == 0 &&
-	       sig == ROMSIGNATURE;
+	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
 }
 
-static int __init romchecksum(unsigned char *rom, unsigned long length)
+static int __init romchecksum(const unsigned char *rom, unsigned long length)
 {
-	unsigned char sum;
+	unsigned char sum, c;
 
-	for (sum = 0; length; length--)
-		sum += *rom++;
-	return sum == 0;
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
@@ -191,8 +192,11 @@ static void __init probe_roms(void)
 
 		video_rom_resource.start = start;
 
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* if checksum okay, trust length byte */
 		if (length && romchecksum(rom, length))
@@ -226,8 +230,11 @@ static void __init probe_roms(void)
 		if (!romsignature(rom))
 			continue;
 
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
 		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
+		length = c * 512;
 
 		/* but accept any length that fits if checksum okay */
 		if (!length || start + length > upper || !romchecksum(rom, length))
_

Patches currently in -mm which might be from rene.herman@gmail.com are

origin.patch
git-alsa.patch
