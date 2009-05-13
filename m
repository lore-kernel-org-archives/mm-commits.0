From: akpm@linux-foundation.org
Subject: [merged] viafb-make-it-work-on-x86_64.patch removed from -mm tree
Date: Wed, 13 May 2009 11:31:53 -0700
Message-ID: <200905131831.n4DIVrZZ018634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760525AbZEMSfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     viafb: make it work on x86_64
has been removed from the -mm tree.  Its filename was
     viafb-make-it-work-on-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: make it work on x86_64
From: Harald Welte <HaraldWelte@viatech.com>

Fix a bug in viafb on x86_64 builds (e.g. for VIA Nano CPU).

You cannot make the assumption that sizeof(unsigned int) ==
sizeof(unsigned long), so the parsing of the default mode (640x480) fails,
leading to a division by zero during insmod of the driver.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Cc: <JosephChan@via.com.tw>
Cc: <ScottFang@viatech.com.cn>
Cc: Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-make-it-work-on-x86_64 drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-make-it-work-on-x86_64
+++ a/drivers/video/via/viafbdev.c
@@ -2103,7 +2103,7 @@ static void viafb_remove_proc(struct pro
 
 static int __devinit via_pci_probe(void)
 {
-	unsigned int default_xres, default_yres;
+	unsigned long default_xres, default_yres;
 	char *tmpc, *tmpm;
 	char *tmpc_sec, *tmpm_sec;
 	int vmode_index;
@@ -2196,8 +2196,8 @@ static int __devinit via_pci_probe(void)
 	viafb_FB_MM = viaparinfo->fbmem_virt;
 	tmpm = viafb_mode;
 	tmpc = strsep(&tmpm, "x");
-	strict_strtoul(tmpc, 0, (unsigned long *)&default_xres);
-	strict_strtoul(tmpm, 0, (unsigned long *)&default_yres);
+	strict_strtoul(tmpc, 0, &default_xres);
+	strict_strtoul(tmpm, 0, &default_yres);
 
 	vmode_index = viafb_get_mode_index(default_xres, default_yres, 0);
 	DEBUG_MSG(KERN_INFO "0->index=%d\n", vmode_index);
_

Patches currently in -mm which might be from HaraldWelte@viatech.com are

origin.patch

