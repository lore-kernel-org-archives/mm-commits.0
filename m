From: akpm@linux-foundation.org
Subject: - drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:13 -0700
Message-ID: <200804282158.m3SLwDxd018474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965344AbYD1V6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/aty/aty128fb.c: fix incorrect usage of strncat in aty128_init()
has been removed from the -mm tree.  Its filename was
     drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/aty/aty128fb.c: fix incorrect usage of strncat in aty128_init()
From: Roel Kluin <12o3l@tiscali.nl>

Fix incorrect length for strncat by replacing it with strlcat

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/aty128fb.c~drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init
+++ a/drivers/video/aty/aty128fb.c
@@ -1885,7 +1885,7 @@ static int __devinit aty128_init(struct 
 
 	/* range check to make sure */
 	if (ent->driver_data < ARRAY_SIZE(r128_family))
-	    strncat(video_card, r128_family[ent->driver_data], sizeof(video_card));
+	    strlcat(video_card, r128_family[ent->driver_data], sizeof(video_card));
 
 	printk(KERN_INFO "aty128fb: %s [chip rev 0x%x] ", video_card, chip_rev);
 
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-kbuild.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

