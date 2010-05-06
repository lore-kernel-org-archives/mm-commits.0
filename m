From: akpm@linux-foundation.org
Subject: [merged] drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch removed from -mm tree
Date: Thu, 06 May 2010 12:08:51 -0400
Message-ID: <201005061910.o46JALce008522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab0EFTKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 15:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, airlied@linux.ie, eric@anholt.net, mm-commits@vger.kernel.org


The patch titled
     drivers/gpu/drm/drm_memory.c: fix check for end of loop
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpu/drm/drm_memory.c: fix check for end of loop
From: Dan Carpenter <error27@gmail.com>

"agpmem" is never NULL here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_memory.c~drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop drivers/gpu/drm/drm_memory.c
--- a/drivers/gpu/drm/drm_memory.c~drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop
+++ a/drivers/gpu/drm/drm_memory.c
@@ -77,7 +77,7 @@ static void *agp_remap(unsigned long off
 		    && (agpmem->bound + (agpmem->pages << PAGE_SHIFT)) >=
 		    (offset + size))
 			break;
-	if (!agpmem)
+	if (&agpmem->head == &dev->agp->memory)
 		return NULL;
 
 	/*
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

