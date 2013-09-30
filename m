From: akpm@linux-foundation.org
Subject: [merged] drm-i915-fix-up-usage-of-shrink_stop.patch removed from
 -mm tree
Date: Mon, 30 Sep 2013 11:57:26 -0700
Message-ID: <5249c996.DVp9u2XZG1vbCoPt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3I3S51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 14:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@openvz.org, glommer@gmail.com, dchinner@redhat.com, Knut_Petersen@t-online.de, daniel.vetter@ffwll.ch

Subject: [merged] drm-i915-fix-up-usage-of-shrink_stop.patch removed from -mm tree
To: daniel.vetter@ffwll.ch,Knut_Petersen@t-online.de,dchinner@redhat.com,glommer@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 11:57:26 -0700


The patch titled
     Subject: drm/i915: Fix up usage of SHRINK_STOP
has been removed from the -mm tree.  Its filename was
     drm-i915-fix-up-usage-of-shrink_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: drm/i915: Fix up usage of SHRINK_STOP

In

commit 81e49f811404f428a9d9a63295a0c267e802fa12
Author: Glauber Costa <glommer@openvz.org>
Date:   Wed Aug 28 10:18:13 2013 +1000

    i915: bail out earlier when shrinker cannot acquire mutex

SHRINK_STOP was added to tell the core shrinker code to bail out and go to
the next shrinker since the i915 shrinker couldn't acquire required locks.
 But the SHRINK_STOP return code was added to the ->count_objects callback
and not the ->scan_objects callback as it should have been, resulting in
tons of dmesg noise like

shrink_slab: i915_gem_inactive_scan+0x0/0x9c negative objects to delete nr=-xxxxxxxxx

Fix discusssed with Dave Chinner.

References: http://www.spinics.net/lists/intel-gfx/msg33597.html
Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>
Acked-by: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~drm-i915-fix-up-usage-of-shrink_stop drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~drm-i915-fix-up-usage-of-shrink_stop
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -4800,10 +4800,10 @@ i915_gem_inactive_count(struct shrinker
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
-			return SHRINK_STOP;
+			return 0;
 
 		if (dev_priv->mm.shrinker_no_lock_stealing)
-			return SHRINK_STOP;
+			return 0;
 
 		unlock = false;
 	}
@@ -4901,10 +4901,10 @@ i915_gem_inactive_scan(struct shrinker *
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
-			return 0;
+			return SHRINK_STOP;
 
 		if (dev_priv->mm.shrinker_no_lock_stealing)
-			return 0;
+			return SHRINK_STOP;
 
 		unlock = false;
 	}
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are

linux-next.patch
drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch

