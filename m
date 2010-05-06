From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch removed from -mm tree
Date: Thu, 06 May 2010 12:08:42 -0400
Message-ID: <201005061910.o46JACgU008499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123Ab0EFTKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, airlied@linux.ie, thellstrom@vmware.com, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/via/via_video.c: fix off by one issue
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/via/via_video.c: fix off by one issue
From: Dan Carpenter <error27@gmail.com>

"fx->lock" is used as the index in "dev_priv->decoder_queue[fx->lock]"
which is an array of "VIA_NR_XVMC_LOCKS" elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/via/via_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/via/via_video.c~drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue drivers/gpu/drm/via/via_video.c
--- a/drivers/gpu/drm/via/via_video.c~drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue
+++ a/drivers/gpu/drm/via/via_video.c
@@ -75,7 +75,7 @@ int via_decoder_futex(struct drm_device 
 
 	DRM_DEBUG("\n");
 
-	if (fx->lock > VIA_NR_XVMC_LOCKS)
+	if (fx->lock >= VIA_NR_XVMC_LOCKS)
 		return -EFAULT;
 
 	lock = (volatile int *)XVMCLOCKPTR(sAPriv, fx->lock);
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
mm-document-follow_page.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

