From: akpm@linux-foundation.org
Subject: - powerpc-offb-add-support-for-foreign-endianness.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:17 -0700
Message-ID: <200804282157.m3SLvHvS018386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965939AbYD1WDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:03:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, adaplas@pol.net, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: offb: add support for foreign endianness
has been removed from the -mm tree.  Its filename was
     powerpc-offb-add-support-for-foreign-endianness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: offb: add support for foreign endianness
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/offb.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/video/offb.c~powerpc-offb-add-support-for-foreign-endianness drivers/video/offb.c
--- a/drivers/video/offb.c~powerpc-offb-add-support-for-foreign-endianness
+++ a/drivers/video/offb.c
@@ -248,7 +248,7 @@ static void __iomem *offb_map_reg(struct
 static void __init offb_init_fb(const char *name, const char *full_name,
 				int width, int height, int depth,
 				int pitch, unsigned long address,
-				struct device_node *dp)
+				int foreign_endian, struct device_node *dp)
 {
 	unsigned long res_size = pitch * height * (depth + 7) / 8;
 	struct offb_par *par = &default_par;
@@ -397,7 +397,7 @@ static void __init offb_init_fb(const ch
 	info->screen_base = ioremap(address, fix->smem_len);
 	info->par = par;
 	info->pseudo_palette = (void *) (info + 1);
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | foreign_endian;
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
@@ -424,6 +424,15 @@ static void __init offb_init_nodriver(st
 	u64 rstart, address = OF_BAD_ADDR;
 	const u32 *pp, *addrp, *up;
 	u64 asize;
+	int foreign_endian = 0;
+
+#ifdef __BIG_ENDIAN
+	if (of_get_property(dp, "little-endian", NULL))
+		foreign_endian = FBINFO_FOREIGN_ENDIAN;
+#else
+	if (of_get_property(dp, "big-endian", NULL))
+		foreign_endian = FBINFO_FOREIGN_ENDIAN;
+#endif
 
 	pp = of_get_property(dp, "linux,bootx-depth", &len);
 	if (pp == NULL)
@@ -509,7 +518,7 @@ static void __init offb_init_nodriver(st
 		offb_init_fb(no_real_node ? "bootx" : dp->name,
 			     no_real_node ? "display" : dp->full_name,
 			     width, height, depth, pitch, address,
-			     no_real_node ? NULL : dp);
+			     foreign_endian, no_real_node ? NULL : dp);
 	}
 }
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch

