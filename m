From: akpm@linux-foundation.org
Subject: [folded-merged]
 treewide-remove-gfp_temporary-allocation-flag-fix-2.patch removed from -mm
 tree
Date: Wed, 13 Sep 2017 16:24:57 -0700
Message-ID: <59b9be49.CMq6ZuHQnIXtLtx2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMXY6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, airlied@linux.ie, chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, jason@jlekstrand.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/i915: fix up for mm: treewide: remove GFP_TEMPORARY allocation flag
has been removed from the -mm tree.  Its filename was
     treewide-remove-gfp_temporary-allocation-flag-fix-2.patch

This patch was dropped because it was folded into treewide-remove-gfp_temporary-allocation-flag.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: drm/i915: fix up for mm: treewide: remove GFP_TEMPORARY allocation flag

Link: http://lkml.kernel.org/r/20170816144703.378d4f4d@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/i915/i915_gem_execbuffer.c~treewide-remove-gfp_temporary-allocation-flag-fix-2 drivers/gpu/drm/i915/i915_gem_execbuffer.c
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c~treewide-remove-gfp_temporary-allocation-flag-fix-2
+++ a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -2077,7 +2077,7 @@ get_fence_array(struct drm_i915_gem_exec
 		return ERR_PTR(-EFAULT);
 
 	fences = kvmalloc_array(args->num_cliprects, sizeof(*fences),
-				__GFP_NOWARN | GFP_TEMPORARY);
+				__GFP_NOWARN | GFP_KERNEL);
 	if (!fences)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

treewide-remove-gfp_temporary-allocation-flag.patch

