Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D160F44C7C
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 21:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725054343; cv=none; b=p2V85mawlW0+hb34D8z15tICcCZjfyYqWtThIiOFVOaOF7Q2t/YuwNv5RfmVfUOMrS7+2p+ZSQE5nb9i/X64u4Qub24AsZzjpS8lfhLspE/n06aTEQOI96ZfStezSOJmRCabOg23SouYlXLWh+tevQ8/WejbVnAWTBSC5SKEqcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725054343; c=relaxed/simple;
	bh=3cw8WjRcIiHMjPvSIniw+pvUKdRAv0jBRJW45Dm7y/s=;
	h=Date:To:From:Subject:Message-Id; b=IKlx4m2zNhqyOLBAycED72nQ4w9Bp0W9HWQFTWNjY57l1Eg74zCyg8slq6umphxqWKSySoJ9nMsz5STvqCmppDAaDpVq9kJkC74iUurROfqxXaOjdX8PPSLbmVaEGBA/w+rArivsLduJMdYwXxKjrcvESJq3JZqLT4DR02yrj5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uCxsSvtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uCxsSvtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B8DC4CEC2;
	Fri, 30 Aug 2024 21:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725054342;
	bh=3cw8WjRcIiHMjPvSIniw+pvUKdRAv0jBRJW45Dm7y/s=;
	h=Date:To:From:Subject:From;
	b=uCxsSvtgUdPEITCVI5QyAL4AKCfrc7b0qduK9k5KafD6/Bd6Gkt/2pZCCD1UUR7r6
	 g3MKAj1fQ/791FzSNoP/mMYAdHe4QjsYWXF91OcmnkGGq3VXjkhRADhyuO/FjQVlQD
	 RLwPcdOXZfamDWfV7feJLiD7Io/1GbOGTexpA//4=
Date: Fri, 30 Aug 2024 14:45:41 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,xieyongji@bytedance.com,v-songbaohua@oppo.com,vbabka@suse.cz,urezki@gmail.com,torvalds@linux-foundation.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mst@redhat.com,mhocko@suse.com,maxime.coquelin@redhat.com,lorenzo.stoakes@oracle.com,laoar.shao@gmail.com,kees@kernel.org,iamjoonsoo.kim@lge.com,hch@lst.de,hch@infradead.org,hailong.liu@oppo.com,eperezma@redhat.com,david@redhat.com,dave@stgolabs.net,cl@linux.com,42.hyeyoo@gmail.com,jasowang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vduse-avoid-using-__gfp_nofail.patch added to mm-unstable branch
Message-Id: <20240830214542.55B8DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vduse: avoid using __GFP_NOFAIL
has been added to the -mm mm-unstable branch.  Its filename is
     vduse-avoid-using-__gfp_nofail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vduse-avoid-using-__gfp_nofail.patch

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
From: Jason Wang <jasowang@redhat.com>
Subject: vduse: avoid using __GFP_NOFAIL
Date: Sat, 31 Aug 2024 08:28:21 +1200

Patch series "mm/vdpa: correct misuse of non-direct-reclaim __GFP_NOFAIL
and improve related doc and warn", v4.

__GFP_NOFAIL carries the semantics of never failing, so its callers do not
check the return value:

  %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
  cannot handle allocation failures. The allocation could block
  indefinitely but will never return with failure. Testing for
  failure is pointless.

However, __GFP_NOFAIL can sometimes fail if it exceeds size limits or is
used with GFP_ATOMIC/GFP_NOWAIT in a non-sleepable context.  This patchset
handles illegal using __GFP_NOFAIL together with GFP_ATOMIC lacking
__GFP_DIRECT_RECLAIM(without this, we can't do anything to reclaim memory
to satisfy the nofail requirement) and improve related document and
warnings.

The proper size limits for __GFP_NOFAIL will be handled separately after
more discussions.


This patch (of 3):

mm doesn't support non-blockable __GFP_NOFAIL allocation.  Because
persisting in providing __GFP_NOFAIL services for non-block users who
cannot perform direct memory reclaim may only result in an endless busy
loop.

Therefore, in such cases, the current mm-core may directly return a NULL
pointer:

static inline struct page *
__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
                                                struct alloc_context *ac)
{
        ...
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

Unfortuantely, vpda does that nofail allocation under non-sleepable lock. 
A possible way to fix that is to move the pages allocation out of the lock
into the caller, but having to allocate a huge number of pages and
auxiliary page array seems to be problematic as well per Tetsuon: " You
should implement proper error handling instead of using __GFP_NOFAIL if
count can become large."

So I chose another way, which does not release kernel bounce pages when
user tries to register userspace bounce pages.  Then we can avoid
allocating in paths where failure is not expected.(e.g in the release). 
We pay this for more memory usage as we don't release kernel bounce pages
but further optimizations could be done on top.

[v-songbaohua@oppo.com: Refine the changelog]
Link: https://lkml.kernel.org/r/20240830202823.21478-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240830202823.21478-2-21cnbao@gmail.com
Fixes: 6c77ed22880d ("vduse: Support using userspace pages as bounce buffer")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Tested-by: Xie Yongji <xieyongji@bytedance.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hailong.Liu <hailong.liu@oppo.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vdpa/vdpa_user/iova_domain.c |   19 +++++++++++--------
 drivers/vdpa/vdpa_user/iova_domain.h |    1 +
 2 files changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/vdpa/vdpa_user/iova_domain.c~vduse-avoid-using-__gfp_nofail
+++ a/drivers/vdpa/vdpa_user/iova_domain.c
@@ -162,6 +162,7 @@ static void vduse_domain_bounce(struct v
 				enum dma_data_direction dir)
 {
 	struct vduse_bounce_map *map;
+	struct page *page;
 	unsigned int offset;
 	void *addr;
 	size_t sz;
@@ -178,7 +179,10 @@ static void vduse_domain_bounce(struct v
 			    map->orig_phys == INVALID_PHYS_ADDR))
 			return;
 
-		addr = kmap_local_page(map->bounce_page);
+		page = domain->user_bounce_pages ?
+		       map->user_bounce_page : map->bounce_page;
+
+		addr = kmap_local_page(page);
 		do_bounce(map->orig_phys + offset, addr + offset, sz, dir);
 		kunmap_local(addr);
 		size -= sz;
@@ -270,9 +274,8 @@ int vduse_domain_add_user_bounce_pages(s
 				memcpy_to_page(pages[i], 0,
 					       page_address(map->bounce_page),
 					       PAGE_SIZE);
-			__free_page(map->bounce_page);
 		}
-		map->bounce_page = pages[i];
+		map->user_bounce_page = pages[i];
 		get_page(pages[i]);
 	}
 	domain->user_bounce_pages = true;
@@ -297,17 +300,17 @@ void vduse_domain_remove_user_bounce_pag
 		struct page *page = NULL;
 
 		map = &domain->bounce_maps[i];
-		if (WARN_ON(!map->bounce_page))
+		if (WARN_ON(!map->user_bounce_page))
 			continue;
 
 		/* Copy user page to kernel page if it's in use */
 		if (map->orig_phys != INVALID_PHYS_ADDR) {
-			page = alloc_page(GFP_ATOMIC | __GFP_NOFAIL);
+			page = map->bounce_page;
 			memcpy_from_page(page_address(page),
-					 map->bounce_page, 0, PAGE_SIZE);
+					 map->user_bounce_page, 0, PAGE_SIZE);
 		}
-		put_page(map->bounce_page);
-		map->bounce_page = page;
+		put_page(map->user_bounce_page);
+		map->user_bounce_page = NULL;
 	}
 	domain->user_bounce_pages = false;
 out:
--- a/drivers/vdpa/vdpa_user/iova_domain.h~vduse-avoid-using-__gfp_nofail
+++ a/drivers/vdpa/vdpa_user/iova_domain.h
@@ -21,6 +21,7 @@
 
 struct vduse_bounce_map {
 	struct page *bounce_page;
+	struct page *user_bounce_page;
 	u64 orig_phys;
 };
 
_

Patches currently in -mm which might be from jasowang@redhat.com are

vduse-avoid-using-__gfp_nofail.patch

