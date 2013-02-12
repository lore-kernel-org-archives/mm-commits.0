From: akpm@linux-foundation.org
Subject: + drm-convert-to-idr_alloc-fix.patch added to -mm tree
Date: Tue, 12 Feb 2013 13:14:55 -0800
Message-ID: <20130212211455.BA5D831C1BD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51652 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3BLVO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 16:14:57 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so58444vea.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 13:14:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.savkov@gmail.com, airlied@linux.ie, tj@kernel.org


The patch titled
     Subject: drm: missing idr_preload_end in drm_gem_flink_ioctl
has been added to the -mm tree.  Its filename is
     drm-convert-to-idr_alloc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drm-convert-to-idr_alloc-fix.patch

