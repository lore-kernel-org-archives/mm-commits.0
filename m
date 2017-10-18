From: akpm@linux-foundation.org
Subject: + mm-remove-cold-parameter-for-release_pages.patch added to -mm
 tree
Date: Wed, 18 Oct 2017 15:16:53 -0700
Message-ID: <59e7d2d5.f57TxsJl/iWTsdVN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdJRWQy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2017 18:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove cold parameter for release_pages
has been added to the -mm tree.  Its filename is
     mm-remove-cold-parameter-for-release_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-cold-parameter-for-release_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-cold-parameter-for-release_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: remove cold parameter for release_pages

All callers of release_pages claim the pages being released are cache hot.
As no one cares about the hotness of pages being released to the
allocator, just ditch the parameter.

No performance impact is expected as the overhead is marginal.  The
parameter is removed simply because it is a bit stupid to have a useless
parameter copied everywhere.

Link: http://lkml.kernel.org/r/20171018075952.10627-7-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c  |    6 ++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c   |    6 +++---
 drivers/gpu/drm/i915/i915_gem_userptr.c |    4 ++--
 drivers/gpu/drm/radeon/radeon_ttm.c     |    2 +-
 fs/fuse/dev.c                           |    2 +-
 include/linux/pagemap.h                 |    2 +-
 include/linux/swap.h                    |    2 +-
 mm/swap.c                               |    8 ++++----
 mm/swap_state.c                         |    2 +-
 11 files changed, 18 insertions(+), 20 deletions(-)

diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c~mm-remove-cold-parameter-for-release_pages drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c~mm-remove-cold-parameter-for-release_pages
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -553,8 +553,7 @@ static int amdgpu_cs_parser_bos(struct a
 				 * invalidated it. Free it and try again
 				 */
 				release_pages(e->user_pages,
-					      e->robj->tbo.ttm->num_pages,
-					      false);
+					      e->robj->tbo.ttm->num_pages);
 				kvfree(e->user_pages);
 				e->user_pages = NULL;
 			}
@@ -691,8 +690,7 @@ error_free_pages:
 				continue;
 
 			release_pages(e->user_pages,
-				      e->robj->tbo.ttm->num_pages,
-				      false);
+				      e->robj->tbo.ttm->num_pages);
 			kvfree(e->user_pages);
 		}
 	}
diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c~mm-remove-cold-parameter-for-release_pages drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c~mm-remove-cold-parameter-for-release_pages
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -347,7 +347,7 @@ int amdgpu_gem_userptr_ioctl(struct drm_
 	return 0;
 
 free_pages:
-	release_pages(bo->tbo.ttm->pages, bo->tbo.ttm->num_pages, false);
+	release_pages(bo->tbo.ttm->pages, bo->tbo.ttm->num_pages);
 
 unlock_mmap_sem:
 	up_read(&current->mm->mmap_sem);
diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~mm-remove-cold-parameter-for-release_pages drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~mm-remove-cold-parameter-for-release_pages
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -659,7 +659,7 @@ int amdgpu_ttm_tt_get_user_pages(struct
 	return 0;
 
 release_pages:
-	release_pages(pages, pinned, 0);
+	release_pages(pages, pinned);
 	return r;
 }
 
diff -puN drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-remove-cold-parameter-for-release_pages drivers/gpu/drm/etnaviv/etnaviv_gem.c
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~mm-remove-cold-parameter-for-release_pages
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -779,7 +779,7 @@ static struct page **etnaviv_gem_userptr
 	up_read(&mm->mmap_sem);
 
 	if (ret < 0) {
-		release_pages(pvec, pinned, 0);
+		release_pages(pvec, pinned);
 		kvfree(pvec);
 		return ERR_PTR(ret);
 	}
@@ -852,7 +852,7 @@ static int etnaviv_gem_userptr_get_pages
 		}
 	}
 
-	release_pages(pvec, pinned, 0);
+	release_pages(pvec, pinned);
 	kvfree(pvec);
 
 	work = kmalloc(sizeof(*work), GFP_KERNEL);
@@ -886,7 +886,7 @@ static void etnaviv_gem_userptr_release(
 	if (etnaviv_obj->pages) {
 		int npages = etnaviv_obj->base.size >> PAGE_SHIFT;
 
-		release_pages(etnaviv_obj->pages, npages, 0);
+		release_pages(etnaviv_obj->pages, npages);
 		kvfree(etnaviv_obj->pages);
 	}
 	put_task_struct(etnaviv_obj->userptr.task);
diff -puN drivers/gpu/drm/i915/i915_gem_userptr.c~mm-remove-cold-parameter-for-release_pages drivers/gpu/drm/i915/i915_gem_userptr.c
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c~mm-remove-cold-parameter-for-release_pages
+++ a/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -554,7 +554,7 @@ __i915_gem_userptr_get_pages_worker(stru
 	}
 	mutex_unlock(&obj->mm.lock);
 
-	release_pages(pvec, pinned, 0);
+	release_pages(pvec, pinned);
 	kvfree(pvec);
 
 	i915_gem_object_put(obj);
@@ -668,7 +668,7 @@ i915_gem_userptr_get_pages(struct drm_i9
 		__i915_gem_userptr_set_active(obj, true);
 
 	if (IS_ERR(pages))
-		release_pages(pvec, pinned, 0);
+		release_pages(pvec, pinned);
 	kvfree(pvec);
 
 	return pages;
diff -puN drivers/gpu/drm/radeon/radeon_ttm.c~mm-remove-cold-parameter-for-release_pages drivers/gpu/drm/radeon/radeon_ttm.c
--- a/drivers/gpu/drm/radeon/radeon_ttm.c~mm-remove-cold-parameter-for-release_pages
+++ a/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -597,7 +597,7 @@ release_sg:
 	kfree(ttm->sg);
 
 release_pages:
-	release_pages(ttm->pages, pinned, 0);
+	release_pages(ttm->pages, pinned);
 	return r;
 }
 
diff -puN fs/fuse/dev.c~mm-remove-cold-parameter-for-release_pages fs/fuse/dev.c
--- a/fs/fuse/dev.c~mm-remove-cold-parameter-for-release_pages
+++ a/fs/fuse/dev.c
@@ -1636,7 +1636,7 @@ out_finish:
 
 static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	release_pages(req->pages, req->num_pages, false);
+	release_pages(req->pages, req->num_pages);
 }
 
 static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
diff -puN include/linux/pagemap.h~mm-remove-cold-parameter-for-release_pages include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-remove-cold-parameter-for-release_pages
+++ a/include/linux/pagemap.h
@@ -117,7 +117,7 @@ static inline void mapping_set_gfp_mask(
 	m->gfp_mask = mask;
 }
 
-void release_pages(struct page **pages, int nr, bool cold);
+void release_pages(struct page **pages, int nr);
 
 /*
  * speculatively take a reference to a page.
diff -puN include/linux/swap.h~mm-remove-cold-parameter-for-release_pages include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-cold-parameter-for-release_pages
+++ a/include/linux/swap.h
@@ -509,7 +509,7 @@ static inline struct swap_info_struct *s
 #define free_page_and_swap_cache(page) \
 	put_page(page)
 #define free_pages_and_swap_cache(pages, nr) \
-	release_pages((pages), (nr), false);
+	release_pages((pages), (nr));
 
 static inline void show_swap_cache_info(void)
 {
diff -puN mm/swap.c~mm-remove-cold-parameter-for-release_pages mm/swap.c
--- a/mm/swap.c~mm-remove-cold-parameter-for-release_pages
+++ a/mm/swap.c
@@ -210,7 +210,7 @@ static void pagevec_lru_move_fn(struct p
 	}
 	if (pgdat)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-	release_pages(pvec->pages, pvec->nr, 0);
+	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
 
@@ -740,7 +740,7 @@ void lru_add_drain_all(void)
  * Decrement the reference count on all the pages in @pages.  If it
  * fell to zero, remove the page from the LRU and free it.
  */
-void release_pages(struct page **pages, int nr, bool cold)
+void release_pages(struct page **pages, int nr)
 {
 	int i;
 	LIST_HEAD(pages_to_free);
@@ -817,7 +817,7 @@ void release_pages(struct page **pages,
 		spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
 
 	mem_cgroup_uncharge_list(&pages_to_free);
-	free_hot_cold_page_list(&pages_to_free, cold);
+	free_hot_cold_page_list(&pages_to_free, 0);
 }
 EXPORT_SYMBOL(release_pages);
 
@@ -837,7 +837,7 @@ void __pagevec_release(struct pagevec *p
 		lru_add_drain();
 		pvec->drained = true;
 	}
-	release_pages(pvec->pages, pagevec_count(pvec), 0);
+	release_pages(pvec->pages, pagevec_count(pvec));
 	pagevec_reinit(pvec);
 }
 EXPORT_SYMBOL(__pagevec_release);
diff -puN mm/swap_state.c~mm-remove-cold-parameter-for-release_pages mm/swap_state.c
--- a/mm/swap_state.c~mm-remove-cold-parameter-for-release_pages
+++ a/mm/swap_state.c
@@ -318,7 +318,7 @@ void free_pages_and_swap_cache(struct pa
 	lru_add_drain();
 	for (i = 0; i < nr; i++)
 		free_swap_cache(pagep[i]);
-	release_pages(pagep, nr, false);
+	release_pages(pagep, nr);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages.patch
mm-page_alloc-enable-disable-irqs-once-when-freeing-a-list-of-pages-fix.patch
mm-truncate-do-not-check-mapping-for-every-page-being-truncated.patch
mm-truncate-remove-all-exceptional-entries-from-pagevec-under-one-lock.patch
mm-only-drain-per-cpu-pagevecs-once-per-pagevec-usage.patch
mm-pagevec-remove-cold-parameter-for-pagevecs.patch
mm-remove-cold-parameter-for-release_pages.patch
mm-remove-cold-parameter-from-free_hot_cold_page.patch
mm-remove-__gfp_cold.patch

