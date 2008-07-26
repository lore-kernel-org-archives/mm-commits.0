From: akpm@linux-foundation.org
Subject: - drm-make-drm_minors_cleanup-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:04 -0700
Message-ID: <200807262118.m6QLI4s9020057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758026AbYGZVSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drm: make drm_minors_cleanup() static
has been removed from the -mm tree.  Its filename was
     drm-make-drm_minors_cleanup-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: make drm_minors_cleanup() static
From: Adrian Bunk <bunk@kernel.org>

Male the needlessly global drm_minors_cleanup() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_drv.c~drm-make-drm_minors_cleanup-static drivers/gpu/drm/drm_drv.c
--- a/drivers/gpu/drm/drm_drv.c~drm-make-drm_minors_cleanup-static
+++ a/drivers/gpu/drm/drm_drv.c
@@ -318,7 +318,7 @@ static void drm_cleanup(struct drm_devic
 		DRM_ERROR("Cannot unload module\n");
 }
 
-int drm_minors_cleanup(int id, void *ptr, void *data)
+static int drm_minors_cleanup(int id, void *ptr, void *data)
 {
 	struct drm_minor *minor = ptr;
 	struct drm_device *dev;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

