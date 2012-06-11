From: akpm@linux-foundation.org
Subject: + video-uvc-use-memweight.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:45 -0700
Message-ID: <20120611231745.D0E67A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:49848 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2FKXRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:17:47 -0400
Received: by ggeh3 with SMTP id h3so426505gge.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, laurent.pinchart@ideasonboard.com, mchehab@infradead.org


The patch titled
     Subject: video/uvc: use memweight()
has been added to the -mm tree.  Its filename is
     video-uvc-use-memweight.patch

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
Subject: video/uvc: use memweight()

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
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
Subject: Subject: video/uvc: use memweight()

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch
string-introduce-memweight.patch
string-introduce-memweight-fix.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch

