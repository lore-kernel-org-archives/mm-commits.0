From: akpm@linux-foundation.org
Subject: [merged] cx88-improve-error-handling.patch removed from -mm tree
Date: Tue, 04 May 2010 11:28:26 -0400
Message-ID: <201005041829.o44ITvbM011414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932968Ab0EDSae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 14:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     cx88: improve error handling
has been removed from the -mm tree.  Its filename was
     cx88-improve-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cx88: improve error handling
From: Dan Carpenter <error27@gmail.com>

Return -EINVAL if we don't find the right query control id.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-video.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/cx88/cx88-video.c~cx88-improve-error-handling drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~cx88-improve-error-handling
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -1537,9 +1537,12 @@ static int radio_queryctrl (struct file 
 		c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
 	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		for (i = 0; i < CX8800_CTLS; i++)
+		for (i = 0; i < CX8800_CTLS; i++) {
 			if (cx8800_ctls[i].v.id == c->id)
 				break;
+		}
+		if (i == CX8800_CTLS)
+			return -EINVAL;
 		*c = cx8800_ctls[i].v;
 	} else
 		*c = no_ctl;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

