From: akpm@linux-foundation.org
Subject: + drm-radeon-use-hweight32.patch added to -mm tree
Date: Tue, 20 Nov 2012 15:35:31 -0800
Message-ID: <20121120233532.87BF6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:36755 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2KTXfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 18:35:34 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so292695bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 15:35:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, airlied@linux.ie


The patch titled
     Subject: drm/radeon: use hweight32()
has been added to the -mm tree.  Its filename is
     drm-radeon-use-hweight32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drm-radeon-use-hweight32.patch
drm-use-memchr_inv.patch
drm-ttm-remove-unneeded-preempt_disable-enable.patch
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

