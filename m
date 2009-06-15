From: akpm@linux-foundation.org
Subject: [merged] drm-simplify-kcalloc-call-to-kzalloc.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:29 -0700
Message-ID: <200906151901.n5FJ1T64022857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758712AbZFOTBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, airlied@linux.ie, eric@anholt.net, mm-commits@vger.kernel.org


The patch titled
     drm: simplify kcalloc() call to kzalloc().
has been removed from the -mm tree.  Its filename was
     drm-simplify-kcalloc-call-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: simplify kcalloc() call to kzalloc().
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Calls to kcalloc() for a single element can be simplified to calls to
kzalloc().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_gem.c~drm-simplify-kcalloc-call-to-kzalloc drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-simplify-kcalloc-call-to-kzalloc
+++ a/drivers/gpu/drm/drm_gem.c
@@ -133,7 +133,7 @@ drm_gem_object_alloc(struct drm_device *
 
 	BUG_ON((size & (PAGE_SIZE - 1)) != 0);
 
-	obj = kcalloc(1, sizeof(*obj), GFP_KERNEL);
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
 
 	obj->dev = dev;
 	obj->filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

