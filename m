From: akpm@linux-foundation.org
Subject: [merged] drm-use-memchr_inv.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:21:38 -0800
Message-ID: <20121126222139.1D83520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58276 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2KZWVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:21:41 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so814391wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:21:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: use memchr_inv()
has been removed from the -mm tree.  Its filename was
     drm-use-memchr_inv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drm: use memchr_inv()

Use memchr_inv() to check the specified memory region is filled with zero.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_edid.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/drm/drm_edid.c~drm-use-memchr_inv drivers/gpu/drm/drm_edid.c
--- a/drivers/gpu/drm/drm_edid.c~drm-use-memchr_inv
+++ a/drivers/gpu/drm/drm_edid.c
@@ -307,12 +307,9 @@ drm_do_probe_ddc_edid(struct i2c_adapter
 
 static bool drm_edid_is_zero(u8 *in_edid, int length)
 {
-	int i;
-	u32 *raw_edid = (u32 *)in_edid;
+	if (memchr_inv(in_edid, 0, length))
+		return false;
 
-	for (i = 0; i < length / 4; i++)
-		if (*(raw_edid + i) != 0)
-			return false;
 	return true;
 }
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch

