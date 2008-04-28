From: akpm@linux-foundation.org
Subject: - drivers-video-imsttfbc-add-missing-curly-brackets.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:26 -0700
Message-ID: <200804282158.m3SLwQeD018492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965368AbYD1V6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, benh@kernel.crashing.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     drivers/video/imsttfb.c: add missing curly brackets
has been removed from the -mm tree.  Its filename was
     drivers-video-imsttfbc-add-missing-curly-brackets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/imsttfb.c: add missing curly brackets
From: Roel Kluin <12o3l@tiscali.nl>

in #if 0 inactivated function msttfb_load_cursor_image() the call eieio()
occurs after rather than in the loop due to missing curly brackets.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imsttfb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/imsttfb.c~drivers-video-imsttfbc-add-missing-curly-brackets drivers/video/imsttfb.c
--- a/drivers/video/imsttfb.c~drivers-video-imsttfbc-add-missing-curly-brackets
+++ a/drivers/video/imsttfb.c
@@ -1151,8 +1151,10 @@ imsttfb_load_cursor_image(struct imstt_p
 				par->cmap_regs[TVPCRDAT] = 0xff;		eieio();
 			}
 		par->cmap_regs[TVPCADRW] = 0x00;	eieio();
-		for (x = 0; x < 12; x++)
-			par->cmap_regs[TVPCDATA] = fgc;	eieio();
+		for (x = 0; x < 12; x++) {
+			par->cmap_regs[TVPCDATA] = fgc;
+			eieio();
+		}
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
git-kbuild.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

