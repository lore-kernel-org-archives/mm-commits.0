From: akpm@linux-foundation.org
Subject: [merged] drm-radeon-use-hweight32.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:21:34 -0800
Message-ID: <20121126222135.1B523200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:57468 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2KZWVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:21:38 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so490597eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:21:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/radeon: use hweight32()
has been removed from the -mm tree.  Its filename was
     drm-radeon-use-hweight32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drm/radeon: use hweight32()

Use hweight32() instead of counting for each bit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/r600.c    |    8 +-------
 drivers/gpu/drm/radeon/r600_cp.c |    7 +------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/gpu/drm/radeon/r600.c~drm-radeon-use-hweight32 drivers/gpu/drm/radeon/r600.c
--- a/drivers/gpu/drm/radeon/r600.c~drm-radeon-use-hweight32
+++ a/drivers/gpu/drm/radeon/r600.c
@@ -1424,13 +1424,7 @@ u32 r6xx_remap_render_backend(struct rad
 
 int r600_count_pipe_bits(uint32_t val)
 {
-	int i, ret = 0;
-
-	for (i = 0; i < 32; i++) {
-		ret += val & 1;
-		val >>= 1;
-	}
-	return ret;
+	return hweight32(val);
 }
 
 static void r600_gpu_init(struct radeon_device *rdev)
diff -puN drivers/gpu/drm/radeon/r600_cp.c~drm-radeon-use-hweight32 drivers/gpu/drm/radeon/r600_cp.c
--- a/drivers/gpu/drm/radeon/r600_cp.c~drm-radeon-use-hweight32
+++ a/drivers/gpu/drm/radeon/r600_cp.c
@@ -721,12 +721,7 @@ static u32 r600_get_tile_pipe_to_backend
 
 static int r600_count_pipe_bits(uint32_t val)
 {
-	int i, ret = 0;
-	for (i = 0; i < 32; i++) {
-		ret += val & 1;
-		val >>= 1;
-	}
-	return ret;
+	return hweight32(val);
 }
 
 static void r600_gfx_init(struct drm_device *dev,
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

