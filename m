From: akpm@osdl.org
Subject: - romsignature-checksum-cleanup.patch removed from -mm tree
Date: Mon, 08 Jan 2007 14:51:17 -0800
Message-ID: <200701082251.l08MpHf6021532@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50742 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbXAHWvX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 17:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@gmail.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     romsignature/checksum cleanup
has been removed from the -mm tree.  Its filename was
     romsignature-checksum-cleanup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: romsignature/checksum cleanup
From: Rene Herman <rene.herman@gmail.com>

Use adding __init to romsignature() (it's only called from probe_roms()
which is itself __init) as an excuse to submit a pedantic cleanup.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/e820.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/e820.c~romsignature-checksum-cleanup arch/i386/kernel/e820.c
--- a/arch/i386/kernel/e820.c~romsignature-checksum-cleanup
+++ a/arch/i386/kernel/e820.c
@@ -157,21 +157,22 @@ static struct resource standard_io_resou
 	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
 } };
 
-static int romsignature(const unsigned char *x)
+#define ROMSIGNATURE 0xaa55
+
+static int __init romsignature(const unsigned char *rom)
 {
 	unsigned short sig;
-	int ret = 0;
-	if (probe_kernel_address((const unsigned short *)x, sig) == 0)
-		ret = (sig == 0xaa55);
-	return ret;
+
+	return probe_kernel_address((const unsigned short *)rom, sig) == 0 &&
+	       sig == ROMSIGNATURE;
 }
 
 static int __init romchecksum(unsigned char *rom, unsigned long length)
 {
-	unsigned char *p, sum = 0;
+	unsigned char sum;
 
-	for (p = rom; p < rom + length; p++)
-		sum += *p;
+	for (sum = 0; length; length--)
+		sum += *rom++;
 	return sum == 0;
 }
 
_

Patches currently in -mm which might be from rene.herman@gmail.com are

romsignature-checksum-cleanup.patch
