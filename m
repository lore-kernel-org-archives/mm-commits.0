Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF028F49
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 00:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722386373; cv=none; b=MZVwrD1+uhfeNUAPOw68pV6+WAFBYWXo8hQMByT3SjRzb6T5+QFcWxvtsDblmcFeAFA8c5PItK8Vuev1HHyVdK7UA+gi9sCKED+qP4ae30T/BYvFFqt98NeHFZrVnW76umzMd7zsxS7Pqw3MHvEAxBXwsYPAv3lxScxgIv23640=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722386373; c=relaxed/simple;
	bh=dvKd624DD7Ub3SZRgLH30fseM9is3PFKFu8IEtDTmwc=;
	h=Date:To:From:Subject:Message-Id; b=BpPt6ZftYsqatYIQcNDuL2p68zAMVPLUgSkjGVlAR2rpVZoZEniii8DRD8cwaympDSu4i75ChksInEPTTQtFYvnXIRszwNk5nKerZZNy1S7Vm4SdoxIkZtF4K77NZfSCBDClnrahXbJi4/GVCvrTjooijIrtjddKJke3kc1PerU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O4qiyhSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O4qiyhSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB036C32782;
	Wed, 31 Jul 2024 00:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722386372;
	bh=dvKd624DD7Ub3SZRgLH30fseM9is3PFKFu8IEtDTmwc=;
	h=Date:To:From:Subject:From;
	b=O4qiyhSmwJfofen3tqFkuRWmv6hqpcrLj2J3qtr3VLJXS7aKsho4w3TnN4t5lloIg
	 4Orxs+0WkuXNngQIxn/Yng6vY7nCmkY2RS7GcUjuhq6FKOrK4beWNr52wSTpcYKCwJ
	 DHpDFGuHxfgKzpfgz9zE/Iyinm+WT75XR4AnYKUM=
Date: Tue, 30 Jul 2024 17:39:32 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,urezki@gmail.com,torvalds@linux-foundation.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mst@redhat.com,mhocko@suse.com,maxime.coquelin@redhat.com,lstoakes@gmail.com,kees@kernel.org,jasowang@redhat.com,iamjoonsoo.kim@lge.com,hch@infradead.org,hailong.liu@oppo.com,eperezma@redhat.com,cl@linux.com,42.hyeyoo@gmail.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch added to mm-unstable branch
Message-Id: <20240731003932.CB036C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vpda: try to fix the potential crash due to misusing __GFP_NOFAIL
has been added to the -mm mm-unstable branch.  Its filename is
     vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: vpda: try to fix the potential crash due to misusing __GFP_NOFAIL
Date: Wed, 31 Jul 2024 12:01:52 +1200

Patch series "mm: clarify nofail memory allocation", v2.

__GFP_NOFAIL carries the semantics of never failing, so its callers
do not check the return value:
  %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
  cannot handle allocation failures. The allocation could block
  indefinitely but will never return with failure. Testing for
  failure is pointless.

However, __GFP_NOFAIL can sometimes fail if it exceeds size limits or is
used with GFP_ATOMIC/GFP_NOWAIT in a non-sleepable context.  This can
expose security vulnerabilities due to potential NULL dereferences.

Since __GFP_NOFAIL does not support non-blocking allocation, we introduce
GFP_NOFAIL with inclusive blocking semantics and encourage using
GFP_NOFAIL as a replacement for __GFP_NOFAIL in non-mm.

If we must still fail a nofail allocation, we should trigger a BUG rather
than exposing NULL dereferences to callers who do not check the return
value.

* The discussion started from this topic:
 [PATCH RFC] mm: warn potential return NULL for kmalloc_array and
             kvmalloc_array with __GFP_NOFAIL

 https://lore.kernel.org/linux-mm/20240717230025.77361-1-21cnbao@gmail.com/


This patch (of 4):

mm doesn't support non-blockable __GFP_NOFAIL allocation.  Because
__GFP_NOFAIL without direct reclamation may just result in a busy loop
within non-sleepable contexts.

static inline struct page *
__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
                                                struct alloc_context *ac)
{
        ...
        /*
         * Make sure that __GFP_NOFAIL request doesn't leak out and make sure
         * we always retry
         */
        if (gfp_mask & __GFP_NOFAIL) {
                /*
                 * All existing users of the __GFP_NOFAIL are blockable, so warn
                 * of any new users that actually require GFP_NOWAIT
                 */
                if (WARN_ON_ONCE_GFP(!can_direct_reclaim, gfp_mask))
                        goto fail;
                ...
        }
        ...
fail:
        warn_alloc(gfp_mask, ac->nodemask,
                        "page allocation failure: order:%u", order);
got_pg:
        return page;
}

Let's move the memory allocation out of the atomic context and use the
normal sleepable context to get pages.

Link: https://lkml.kernel.org/r/20240731000155.109583-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240731000155.109583-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vdpa/vdpa_user/iova_domain.c |   31 ++++++++++++++++++++-----
 drivers/vdpa/vdpa_user/iova_domain.h |    5 +++-
 drivers/vdpa/vdpa_user/vduse_dev.c   |    4 ++-
 3 files changed, 33 insertions(+), 7 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c~vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail
+++ a/drivers/vdpa/vdpa_user/iova_domain.c
@@ -283,7 +283,23 @@ out:
 	return ret;
 }
 
-void vduse_domain_remove_user_bounce_pages(struct vduse_iova_domain *domain)
+struct page **vduse_domain_alloc_pages_to_remove_bounce(struct vduse_iova_domain *domain)
+{
+	struct page **pages;
+	unsigned long count, i;
+
+	if (!domain->user_bounce_pages)
+		return NULL;
+
+	count = domain->bounce_size >> PAGE_SHIFT;
+	pages = kmalloc_array(count, sizeof(*pages), GFP_KERNEL | __GFP_NOFAIL);
+	for (i = 0; i < count; i++)
+		pages[i] = alloc_page(GFP_KERNEL | __GFP_NOFAIL);
+
+	return pages;
+}
+
+void vduse_domain_remove_user_bounce_pages(struct vduse_iova_domain *domain, struct page **pages)
 {
 	struct vduse_bounce_map *map;
 	unsigned long i, count;
@@ -294,15 +310,16 @@ void vduse_domain_remove_user_bounce_pag
 
 	count = domain->bounce_size >> PAGE_SHIFT;
 	for (i = 0; i < count; i++) {
-		struct page *page = NULL;
+		struct page *page = pages[i];
 
 		map = &domain->bounce_maps[i];
-		if (WARN_ON(!map->bounce_page))
+		if (WARN_ON(!map->bounce_page)) {
+			put_page(page);
 			continue;
+		}
 
 		/* Copy user page to kernel page if it's in use */
 		if (map->orig_phys != INVALID_PHYS_ADDR) {
-			page = alloc_page(GFP_ATOMIC | __GFP_NOFAIL);
 			memcpy_from_page(page_address(page),
 					 map->bounce_page, 0, PAGE_SIZE);
 		}
@@ -310,6 +327,7 @@ void vduse_domain_remove_user_bounce_pag
 		map->bounce_page = page;
 	}
 	domain->user_bounce_pages = false;
+	kfree(pages);
 out:
 	write_unlock(&domain->bounce_lock);
 }
@@ -543,10 +561,13 @@ static int vduse_domain_mmap(struct file
 static int vduse_domain_release(struct inode *inode, struct file *file)
 {
 	struct vduse_iova_domain *domain = file->private_data;
+	struct page **pages;
+
+	pages = vduse_domain_alloc_pages_to_remove_bounce(domain);
 
 	spin_lock(&domain->iotlb_lock);
 	vduse_iotlb_del_range(domain, 0, ULLONG_MAX);
-	vduse_domain_remove_user_bounce_pages(domain);
+	vduse_domain_remove_user_bounce_pages(domain, pages);
 	vduse_domain_free_kernel_bounce_pages(domain);
 	spin_unlock(&domain->iotlb_lock);
 	put_iova_domain(&domain->stream_iovad);
--- a/drivers/vdpa/vdpa_user/iova_domain.h~vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail
+++ a/drivers/vdpa/vdpa_user/iova_domain.h
@@ -74,7 +74,10 @@ void vduse_domain_reset_bounce_map(struc
 int vduse_domain_add_user_bounce_pages(struct vduse_iova_domain *domain,
 				       struct page **pages, int count);
 
-void vduse_domain_remove_user_bounce_pages(struct vduse_iova_domain *domain);
+void vduse_domain_remove_user_bounce_pages(struct vduse_iova_domain *domain,
+					   struct page **pages);
+
+struct page **vduse_domain_alloc_pages_to_remove_bounce(struct vduse_iova_domain *domain);
 
 void vduse_domain_destroy(struct vduse_iova_domain *domain);
 
--- a/drivers/vdpa/vdpa_user/vduse_dev.c~vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail
+++ a/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1030,6 +1030,7 @@ unlock:
 static int vduse_dev_dereg_umem(struct vduse_dev *dev,
 				u64 iova, u64 size)
 {
+	struct page **pages;
 	int ret;
 
 	mutex_lock(&dev->mem_lock);
@@ -1044,7 +1045,8 @@ static int vduse_dev_dereg_umem(struct v
 	if (dev->umem->iova != iova || size != dev->domain->bounce_size)
 		goto unlock;
 
-	vduse_domain_remove_user_bounce_pages(dev->domain);
+	pages = vduse_domain_alloc_pages_to_remove_bounce(dev->domain);
+	vduse_domain_remove_user_bounce_pages(dev->domain, pages);
 	unpin_user_pages_dirty_lock(dev->umem->pages,
 				    dev->umem->npages, true);
 	atomic64_sub(dev->umem->npages, &dev->umem->mm->pinned_vm);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch

