From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 006/131] drm/i915: convert get_user_pages() -->
 pin_user_pages()
Date: Wed, 03 Jun 2020 15:56:37 -0700
Message-ID: <20200603225637.pX0j1WfEq%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFCW4j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:56:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, akpm@linux-foundation.org, chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@linux.intel.com, jhubbard@nvidia.com, joonas.lahtinen@linux.intel.com, jrdr.linux@gmail.com, linux-mm@kvack.org, matthew.auld@intel.com, mm-commits@vger.kernel.org, rodrigo.vivi@intel.com, torvalds@linux-foundation.org, tvrtko.ursulin@intel.com, willy@infradead.org

From: John Hubbard <jhubbard@nvidia.com>
Subject: drm/i915: convert get_user_pages() --> pin_user_pages()

This code was using get_user_pages*(), in a "Case 2" scenario (DMA/RDMA),
using the categorization from [1].  That means that it's time to convert
the get_user_pages*() + put_page() calls to pin_user_pages*() +
unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small part
of fixing a long-standing disconnect between pinning pages, and file
systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Link: http://lkml.kernel.org/r/20200519002124.2025955-5-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: "Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |   22 ++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c~drm-i915-convert-get_user_pages-pin_user_pages
+++ a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -471,7 +471,7 @@ __i915_gem_userptr_get_pages_worker(stru
 					down_read(&mm->mmap_sem);
 					locked = 1;
 				}
-				ret = get_user_pages_remote
+				ret = pin_user_pages_remote
 					(work->task, mm,
 					 obj->userptr.ptr + pinned * PAGE_SIZE,
 					 npages - pinned,
@@ -507,7 +507,7 @@ __i915_gem_userptr_get_pages_worker(stru
 	}
 	mutex_unlock(&obj->mm.lock);
 
-	release_pages(pvec, pinned);
+	unpin_user_pages(pvec, pinned);
 	kvfree(pvec);
 
 	i915_gem_object_put(obj);
@@ -564,6 +564,7 @@ static int i915_gem_userptr_get_pages(st
 	struct sg_table *pages;
 	bool active;
 	int pinned;
+	unsigned int gup_flags = 0;
 
 	/* If userspace should engineer that these pages are replaced in
 	 * the vma between us binding this page into the GTT and completion
@@ -606,11 +607,14 @@ static int i915_gem_userptr_get_pages(st
 		 *
 		 * We may or may not care.
 		 */
-		if (pvec) /* defer to worker if malloc fails */
-			pinned = __get_user_pages_fast(obj->userptr.ptr,
-						       num_pages,
-						       !i915_gem_object_is_readonly(obj),
-						       pvec);
+		if (pvec) {
+			/* defer to worker if malloc fails */
+			if (!i915_gem_object_is_readonly(obj))
+				gup_flags |= FOLL_WRITE;
+			pinned = pin_user_pages_fast_only(obj->userptr.ptr,
+							  num_pages, gup_flags,
+							  pvec);
+		}
 	}
 
 	active = false;
@@ -628,7 +632,7 @@ static int i915_gem_userptr_get_pages(st
 		__i915_gem_userptr_set_active(obj, true);
 
 	if (IS_ERR(pages))
-		release_pages(pvec, pinned);
+		unpin_user_pages(pvec, pinned);
 	kvfree(pvec);
 
 	return PTR_ERR_OR_ZERO(pages);
@@ -683,7 +687,7 @@ i915_gem_userptr_put_pages(struct drm_i9
 		}
 
 		mark_page_accessed(page);
-		put_page(page);
+		unpin_user_page(page);
 	}
 	obj->mm.dirty = false;
 
_
