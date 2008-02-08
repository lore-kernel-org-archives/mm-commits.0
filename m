From: akpm@linux-foundation.org
Subject: - drivers-edac-i3000-replace-macros-with-functions.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:05:48 -0800
Message-ID: <200802080805.m1885Tpd014357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761551AbYBHIUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juhlenko@akamai.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers-edac: i3000 replace macros with functions
has been removed from the -mm tree.  Its filename was
     drivers-edac-i3000-replace-macros-with-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-edac: i3000 replace macros with functions
From: Jason Uhlenkott <juhlenko@akamai.com>

Replace function-like macros with functions.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i3000_edac.c |   50 +++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff -puN drivers/edac/i3000_edac.c~drivers-edac-i3000-replace-macros-with-functions drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~drivers-edac-i3000-replace-macros-with-functions
+++ a/drivers/edac/i3000_edac.c
@@ -42,11 +42,23 @@
 				 * 0     Error channel 0/1
 				 */
 #define I3000_DEAP_GRAIN 		(1 << 7)
-#define I3000_DEAP_PFN(edeap, deap)	((((edeap) & 1) << (32 - PAGE_SHIFT)) \
-					| ((deap) >> PAGE_SHIFT))
-#define I3000_DEAP_OFFSET(deap)		((deap) & ~(I3000_DEAP_GRAIN-1) & \
-					~PAGE_MASK)
-#define I3000_DEAP_CHANNEL(deap)	((deap) & 1)
+
+static inline unsigned long deap_pfn(u8 edeap, u32 deap)
+{
+	deap >>= PAGE_SHIFT;
+	deap |= (edeap & 1) << (32 - PAGE_SHIFT);
+	return deap;
+}
+
+static inline unsigned long deap_offset(u32 deap)
+{
+	return deap & ~(I3000_DEAP_GRAIN - 1) & ~PAGE_MASK;
+}
+
+static inline int deap_channel(u32 deap)
+{
+	return deap & 1;
+}
 
 #define I3000_DERRSYN	0x5c	/* DRAM Error Syndrome (8b)
 				 *
@@ -116,8 +128,16 @@
 				 *     Others: reserved
 				 */
 #define I3000_C1DRA	0x188	/* Channel 1 DRAM Rank Attribute (8b x 2) */
-#define ODD_RANK_ATTRIB(dra)	(((dra) & 0x70) >> 4)
-#define EVEN_RANK_ATTRIB(dra)	((dra) & 0x07)
+
+static inline unsigned char odd_rank_attrib(unsigned char dra)
+{
+	return (dra & 0x70) >> 4;
+}
+
+static inline unsigned char even_rank_attrib(unsigned char dra)
+{
+	return dra & 0x07;
+}
 
 #define I3000_C0DRC0	0x120	/* DRAM Controller Mode 0 (32b)
 				 *
@@ -206,8 +226,8 @@ static int i3000_process_error_info(stru
 				struct i3000_error_info *info,
 				int handle_errors)
 {
-	int row, multi_chan;
-	int pfn, offset, channel;
+	int row, multi_chan, channel;
+	unsigned long pfn, offset;
 
 	multi_chan = mci->csrows[0].nr_channels - 1;
 
@@ -222,9 +242,9 @@ static int i3000_process_error_info(stru
 		info->errsts = info->errsts2;
 	}
 
-	pfn = I3000_DEAP_PFN(info->edeap, info->deap);
-	offset = I3000_DEAP_OFFSET(info->deap);
-	channel = I3000_DEAP_CHANNEL(info->deap);
+	pfn = deap_pfn(info->edeap, info->deap);
+	offset = deap_offset(info->deap);
+	channel = deap_channel(info->deap);
 
 	row = edac_mc_find_csrow_by_page(mci, pfn);
 
@@ -258,9 +278,9 @@ static int i3000_is_interleaved(const un
 	 * we're not interleaved.
 	 */
 	for (i = 0; i < I3000_RANKS_PER_CHANNEL / 2; i++)
-		if (ODD_RANK_ATTRIB(c0dra[i]) != ODD_RANK_ATTRIB(c1dra[i]) ||
-			EVEN_RANK_ATTRIB(c0dra[i]) !=
-						EVEN_RANK_ATTRIB(c1dra[i]))
+		if (odd_rank_attrib(c0dra[i]) != odd_rank_attrib(c1dra[i]) ||
+			even_rank_attrib(c0dra[i]) !=
+						even_rank_attrib(c1dra[i]))
 			return 0;
 
 	/*
_

Patches currently in -mm which might be from juhlenko@akamai.com are

origin.patch
