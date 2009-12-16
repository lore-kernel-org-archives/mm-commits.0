From: akpm@linux-foundation.org
Subject: [merged] drivers-video-move-dereference-after-null-test.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:42 -0800
Message-ID: <200912162035.nBGKZg4K013115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935400AbZLPUf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, daniel@caiaq.de, eric.y.miao@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     drivers/video: Move dereference after NULL test
has been removed from the -mm tree.  Its filename was
     drivers-video-move-dereference-after-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

If the NULL test on fbi is needed, then the dereference should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/pxafb.c~drivers-video-move-dereference-after-null-test drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~drivers-video-move-dereference-after-null-test
+++ a/drivers/video/pxafb.c
@@ -1221,13 +1221,14 @@ static void setup_smart_timing(struct px
 static int pxafb_smart_thread(void *arg)
 {
 	struct pxafb_info *fbi = arg;
-	struct pxafb_mach_info *inf = fbi->dev->platform_data;
+	struct pxafb_mach_info *inf;
 
-	if (!fbi || !inf->smart_update) {
+	if (!fbi || !fbi->dev->platform_data->smart_update) {
 		pr_err("%s: not properly initialized, thread terminated\n",
 				__func__);
 		return -EINVAL;
 	}
+	inf = fbi->dev->platform_data;
 
 	pr_debug("%s(): task starting\n", __func__);
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-edac-introduce-missing-kfree.patch

