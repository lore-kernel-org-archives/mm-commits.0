From: akpm@linux-foundation.org
Subject: [to-be-updated]
 i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch removed from -mm tree
Date: Thu, 06 Jun 2013 12:35:01 -0700
Message-ID: <51b0e465./vEcmlCJqm/XcPZo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3FFTfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:35:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dchinner@redhat.com, glommer@openvz.org

Subject: [to-be-updated] i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch removed from -mm tree
To: glommer@openvz.org,dchinner@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:35:01 -0700


The patch titled
     Subject: i915: bail out earlier when shrinker cannot acquire mutex
has been removed from the -mm tree.  Its filename was
     i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: i915: bail out earlier when shrinker cannot acquire mutex

The main shrinker driver will keep trying for a while to free objects if
the returned value from the shrink scan procedure is 0.  That means "no
objects now", but a retry could very well succeed.

A negative value has a different meaning.  It means it is impossible to
shrink, and we would better bail out soon.  We find this behavior more
appropriate for the case where the lock cannot be taken.  Specially given
the hammer behavior of the i915: if another thread is already shrinking,
we are likely not to be able to shrink anything anyway when we finally
acquire the mutex.

Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -4497,10 +4497,10 @@ i915_gem_inactive_count(struct shrinker
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
-			return 0;
+			return -1;
 
 		if (dev_priv->mm.shrinker_no_lock_stealing)
-			return 0;
+			return -1;
 
 		unlock = false;
 	}
_

Patches currently in -mm which might be from glommer@openvz.org are

shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

