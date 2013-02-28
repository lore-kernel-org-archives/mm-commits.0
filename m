From: akpm@linux-foundation.org
Subject: [folded-dropped] drm-convert-to-idr_alloc-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:43:42 -0800
Message-ID: <20130228004342.E1AC45A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:59672 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3B1Ann (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:43:43 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so138849ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:43:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.savkov@gmail.com, airlied@linux.ie, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drm: missing idr_preload_end in drm_gem_flink_ioctl
has been removed from the -mm tree.  Its filename was
     drm-convert-to-idr_alloc-fix.patch

This patch was dropped because it was folded into drm-convert-to-idr_alloc.patch

------------------------------------------------------
From: Artem Savkov <artem.savkov@gmail.com>
Subject: drm: missing idr_preload_end in drm_gem_flink_ioctl

Added missing idr_preload_end calls in drm_gem_flink_ioctl().  Without
those preemption stays disabled resulting in lots of "scheduling while
atomic" BUGs.

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc-fix drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc-fix
+++ a/drivers/gpu/drm/drm_gem.c
@@ -456,6 +456,7 @@ drm_gem_flink_ioctl(struct drm_device *d
 		obj->name = ret;
 		args->name = (uint64_t) obj->name;
 		spin_unlock(&dev->object_name_lock);
+		idr_preload_end();
 
 		if (ret < 0)
 			goto err;
@@ -465,6 +466,7 @@ drm_gem_flink_ioctl(struct drm_device *d
 	} else {
 		args->name = (uint64_t) obj->name;
 		spin_unlock(&dev->object_name_lock);
+		idr_preload_end();
 		ret = 0;
 	}
 
_

Patches currently in -mm which might be from artem.savkov@gmail.com are

drm-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc-fix-fix.patch

