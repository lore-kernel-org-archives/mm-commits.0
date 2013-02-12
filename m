From: akpm@linux-foundation.org
Subject: + drm-convert-to-idr_alloc-fix-fix.patch added to -mm tree
Date: Tue, 12 Feb 2013 14:13:16 -0800
Message-ID: <20130212221316.97BC05A41F1@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:63305 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3BLWNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 17:13:18 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so65290qen.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 14:13:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, airlied@linux.ie, artem.savkov@gmail.com, tj@kernel.org


The patch titled
     Subject: drm-convert-to-idr_alloc-fix-fix
has been added to the -mm tree.  Its filename is
     drm-convert-to-idr_alloc-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: drm-convert-to-idr_alloc-fix-fix

fix drm_gem_flink_ioctl() return value

Cc: Artem Savkov <artem.savkov@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc-fix-fix drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-convert-to-idr_alloc-fix-fix
+++ a/drivers/gpu/drm/drm_gem.c
@@ -460,6 +460,7 @@ drm_gem_flink_ioctl(struct drm_device *d
 
 		if (ret < 0)
 			goto err;
+		ret = 0;
 
 		/* Allocate a reference for the name table.  */
 		drm_gem_object_reference(obj);
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
drm-convert-to-idr_alloc-fix-fix.patch

