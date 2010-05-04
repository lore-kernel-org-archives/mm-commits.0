From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch removed from -mm tree
Date: Tue, 04 May 2010 11:28:14 -0400
Message-ID: <201005041829.o44ITjqT011402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932661Ab0EDSa0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 May 2010 14:30:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/au0828/au0828-video.c: off by one bug
has been removed from the -mm tree.  Its filename was
     drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/au0828/au0828-video.c: off by one bug
From: Dan Carpenter <error27@gmail.com>

The "AUVI_INPUT(tmp)" macro uses "tmp" as an index of an array with
AU0828_MAX_INPUT elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/au0828/au0828-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/au0828/au0828-video.c~drivers-media-video-au0828-au0828-videoc-off-by-one-bug drivers/media/video/au0828/au0828-video.c
--- a/drivers/media/video/au0828/au0828-video.c~drivers-media-video-au0828-au0828-videoc-off-by-one-bug
+++ a/drivers/media/video/au0828/au0828-video.c
@@ -1105,7 +1105,7 @@ static int vidioc_enum_input(struct file
 
 	tmp = input->index;
 
-	if (tmp > AU0828_MAX_INPUT)
+	if (tmp >= AU0828_MAX_INPUT)
 		return -EINVAL;
 	if (AUVI_INPUT(tmp).type == 0)
 		return -EINVAL;
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

