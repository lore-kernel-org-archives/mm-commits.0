From: akpm@linux-foundation.org
Subject: [merged] video-uvc-use-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:06 -0700
Message-ID: <20120731185107.0E21C200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:61555 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2GaSvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:09 -0400
Received: by wgbdt11 with SMTP id dt11so291159wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, laurent.pinchart@ideasonboard.com, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: video/uvc: use memweight()
has been removed from the -mm tree.  Its filename was
     video-uvc-use-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: video/uvc: use memweight()

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/uvc/uvc_ctrl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/uvc/uvc_ctrl.c~video-uvc-use-memweight drivers/media/video/uvc/uvc_ctrl.c
--- a/drivers/media/video/uvc/uvc_ctrl.c~video-uvc-use-memweight
+++ a/drivers/media/video/uvc/uvc_ctrl.c
@@ -2083,7 +2083,7 @@ int uvc_ctrl_init_device(struct uvc_devi
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
 		struct uvc_control *ctrl;
-		unsigned int bControlSize = 0, ncontrols = 0;
+		unsigned int bControlSize = 0, ncontrols;
 		__u8 *bmControls = NULL;
 
 		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
@@ -2101,8 +2101,7 @@ int uvc_ctrl_init_device(struct uvc_devi
 		uvc_ctrl_prune_entity(dev, entity);
 
 		/* Count supported controls and allocate the controls array */
-		for (i = 0; i < bControlSize; ++i)
-			ncontrols += hweight8(bmControls[i]);
+		ncontrols = memweight(bmControls, bControlSize);
 		if (ncontrols == 0)
 			continue;
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

