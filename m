From: akpm@linux-foundation.org
Subject: + drm-use-memchr_inv.patch added to -mm tree
Date: Tue, 20 Nov 2012 15:35:34 -0800
Message-ID: <20121120233534.DFB7A82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:58088 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2KTXfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Nov 2012 18:35:36 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so757386vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Nov 2012 15:35:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, airlied@linux.ie


The patch titled
     Subject: drm: use memchr_inv()
has been added to the -mm tree.  Its filename is
     drm-use-memchr_inv.patch

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

