From: akpm@linux-foundation.org
Subject: + drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking.patch added to -mm tree
Date: Tue, 03 Feb 2009 14:33:47 -0800
Message-ID: <200902032233.n13MXlw6014377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbZBCWgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 17:36:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: airlied@linux.ie, airlied@redhat.com, daniel@ffwll.ch, jbarnes@virtuousgeek.org, rjw@sisk.pl


The patch titled
     drivers/gpu/drm/i915/intel_lvds.c: remove unneeded locking
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking.patch

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
Subject: drivers/gpu/drm/i915/intel_lvds.c: remove unneeded locking
From: Dave Airlie <airlied@linux.ie>

This code is always called under the lock from the higher layers,
so need to go locking it here.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_lvds.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking drivers/gpu/drm/i915/intel_lvds.c
--- a/drivers/gpu/drm/i915/intel_lvds.c~drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking
+++ a/drivers/gpu/drm/i915/intel_lvds.c
@@ -311,10 +311,8 @@ static int intel_lvds_get_modes(struct d
 	if (dev_priv->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode;
 
-		mutex_lock(&dev->mode_config.mutex);
 		mode = drm_mode_duplicate(dev, dev_priv->panel_fixed_mode);
 		drm_mode_probed_add(connector, mode);
-		mutex_unlock(&dev->mode_config.mutex);
 
 		return 1;
 	}
_

Patches currently in -mm which might be from airlied@linux.ie are

origin.patch
linux-next.patch
intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch
intelfb-support-i854.patch
drivers-gpu-drm-i915-intel_lvdsc-remove-unneeded-locking.patch

