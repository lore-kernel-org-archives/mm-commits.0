From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 06 Jan 2017 15:25:16 -0800
Message-ID: <5870275c.5RZUiWQiWiOokw+e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969661AbdAFXYB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2017 18:24:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem.c      |    4 ----
 drivers/gpu/drm/i915/intel_overlay.c |   11 -----------
 2 files changed, 15 deletions(-)

diff -puN drivers/gpu/drm/i915/i915_gem.c~linux-next-git-rejects drivers/gpu/drm/i915/i915_gem.c
--- a/drivers/gpu/drm/i915/i915_gem.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/i915_gem.c
@@ -2776,11 +2776,7 @@ static void i915_gem_reset_engine(struct
 	if (i915_gem_context_is_default(hung_ctx))
 		return;
 
-<<<<<<< HEAD
-	timeline = i915_gem_context_lookup_timeline(incomplete_ctx, engine);
-=======
 	timeline = i915_gem_context_lookup_timeline(hung_ctx, engine);
->>>>>>> linux-next/akpm-base
 
 	spin_lock_irqsave(&engine->timeline->lock, flags);
 	spin_lock(&timeline->lock);
diff -puN drivers/gpu/drm/i915/intel_overlay.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_overlay.c
--- a/drivers/gpu/drm/i915/intel_overlay.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_overlay.c
@@ -895,17 +895,6 @@ static int intel_overlay_do_put_image(st
 	if (ret)
 		goto out_unpin;
 
-<<<<<<< HEAD
-	i915_gem_track_fb(overlay->vma ? overlay->vma->obj : NULL,
-			  vma->obj, INTEL_FRONTBUFFER_OVERLAY(pipe));
-
-	overlay->old_vma = overlay->vma;
-	overlay->vma = vma;
-
-	intel_frontbuffer_flip(dev_priv, INTEL_FRONTBUFFER_OVERLAY(pipe));
