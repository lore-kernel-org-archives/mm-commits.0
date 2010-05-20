From: akpm@linux-foundation.org
Subject: + i915-fix-lock-imbalance-on-error-path.patch added to -mm tree
Date: Thu, 20 May 2010 11:15:45 -0700
Message-ID: <201005201815.o4KIFjEw029431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855Ab0ETSQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 14:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.blueman@gmail.com, airlied@linux.ie, bgamari.foss@gmail.com, jbarnes@virtuousgeek.org, oga@openbsd.org, stable@kernel.org


The patch titled
     i915: fix lock imbalance on error path
has been added to the -mm tree.  Its filename is
     i915-fix-lock-imbalance-on-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i915: fix lock imbalance on error path
From: Daniel J Blueman <daniel.blueman@gmail.com>

While investigating Intel i5 Arrandale GPU lockups with -rc4, I noticed a
lock imbalance.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Owain G. Ainsworth <oga@openbsd.org>
Cc: Ben Gamari <bgamari.foss@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_drv.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpu/drm/i915/i915_drv.c~i915-fix-lock-imbalance-on-error-path drivers/gpu/drm/i915/i915_drv.c
--- a/drivers/gpu/drm/i915/i915_drv.c~i915-fix-lock-imbalance-on-error-path
+++ a/drivers/gpu/drm/i915/i915_drv.c
@@ -370,6 +370,7 @@ int i965_reset(struct drm_device *dev, u
 		}
 	} else {
 		DRM_ERROR("Error occurred. Don't know how to reset this chip.\n");
+		mutex_unlock(&dev->struct_mutex);
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from daniel.blueman@gmail.com are

i915-fix-lock-imbalance-on-error-path.patch

