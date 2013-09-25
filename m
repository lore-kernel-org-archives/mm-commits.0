From: akpm@linux-foundation.org
Subject: + drm-i915-fix-up-usage-of-shrink_stop.patch added to -mm tree
Date: Wed, 25 Sep 2013 12:54:43 -0700
Message-ID: <52433f83.5LqzrbTJnzTxuRVn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3IYTyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@openvz.org, glommer@gmail.com, david@fromorbit.com, Knut_Petersen@t-online.de, daniel.vetter@ffwll.ch

Subject: + drm-i915-fix-up-usage-of-shrink_stop.patch added to -mm tree
To: daniel.vetter@ffwll.ch,Knut_Petersen@t-online.de,david@fromorbit.com,glommer@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:54:43 -0700


The patch titled
     Subject: drm/i915: Fix up usage of SHRINK_STOP
has been added to the -mm tree.  Its filename is
     drm-i915-fix-up-usage-of-shrink_stop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-i915-fix-up-usage-of-shrink_stop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-i915-fix-up-usage-of-shrink_stop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Dave Chinner <david@fromorbit.com>
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

drm-i915-fix-up-usage-of-shrink_stop.patch
drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch
linux-next.patch

