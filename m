Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9669F1EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450055; cv=none; b=o4sruvNaJPj8DQ78LZKBn0aG4EkpBNlNsyWK+SydoqYz4V85aOLVtf0doB5gfBGNo+RL7BjM/RABhFbMCgqwooddB4pfCrUlR5gO46TKlYmJ8wWq6nwyyRK+k8+QBx7l9bi5cn+k2NVf8nGI+mAWabPK0GvdcLx2tGavHRLhGgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450055; c=relaxed/simple;
	bh=yZGMxq9LE6AS61vp5swdhjFBaTgudEFjlxPtB8rrD/A=;
	h=Date:To:From:Subject:Message-Id; b=PiIWXdI0EmufAiLICcalYJ0hOTN0LVWhzluQ1N/z5sQFjKxrFqa5dSJxMIyBbnZTR7DwnNjSrpqwH7bAiXjcB5O35iX83z2ZanxgdkBQ7WDqzu4pwpy3wffkDYWQBRLupsF1jMeNcd2BWTT/AJQvaUcGIRfV8LhCZoO8jG2ANy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TRkSbHUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TRkSbHUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679C8C4CEE3;
	Sun, 13 Jul 2025 23:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450055;
	bh=yZGMxq9LE6AS61vp5swdhjFBaTgudEFjlxPtB8rrD/A=;
	h=Date:To:From:Subject:From;
	b=TRkSbHUl8LvVvEIcE2s9nY7WdeDORlU+aT8lSDfBac7KTb+rAImKYjmbg4D4tNg53
	 ByTuIf5mmrB1kgCG3/yVMOQX2MpToX9FZh/qU3V+odHrQ3820WZCh5pZWX15RNmKVl
	 SonZhnNksgkdyexcgvsDdsk+lvNBLBTxyvnY7TpQ=
Date: Sun, 13 Jul 2025 16:40:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,xuanzhuo@linux.alibaba.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nao.horiguchi@gmail.com,mst@redhat.com,mpe@ellerman.id.au,minchan@kernel.org,mhocko@suse.com,matthew.brost@intel.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,jack@suse.cz,jackmanb@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,arnd@arndb.de,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch removed from -mm tree
Message-Id: <20250713234055.679C8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: convert balloon_page_delete() to balloon_page_finalize()
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/balloon_compaction: convert balloon_page_delete() to balloon_page_finalize()
Date: Fri, 4 Jul 2025 12:24:56 +0200

Let's move the removal of the page from the balloon list into the single
caller, to remove the dependency on the PG_isolated flag and clarify
locking requirements.

Note that for now, balloon_page_delete() was used on two paths:

(1) Removing a page from the balloon for deflation through
    balloon_page_list_dequeue()
(2) Removing an isolated page from the balloon for migration in the
    per-driver migration handlers. Isolated pages were already removed from
    the balloon list during isolation.

So instead of relying on the flag, we can just distinguish both cases
directly and handle it accordingly in the caller.

We'll shuffle the operations a bit such that they logically make more
sense (e.g., remove from the list before clearing flags).

In balloon migration functions we can now move the balloon_page_finalize()
out of the balloon lock and perform the finalization just before dropping
the balloon reference.

Document that the page lock is currently required when modifying the
movability aspects of a page; hopefully we can soon decouple this from the
page lock.

Link: https://lkml.kernel.org/r/20250704102524.326966-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pé rez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/cmm.c |    2 -
 drivers/misc/vmw_balloon.c           |    3 -
 drivers/virtio/virtio_balloon.c      |    4 --
 include/linux/balloon_compaction.h   |   43 +++++++++----------------
 mm/balloon_compaction.c              |    3 +
 5 files changed, 21 insertions(+), 34 deletions(-)

--- a/arch/powerpc/platforms/pseries/cmm.c~mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -532,7 +532,6 @@ static int cmm_migratepage(struct balloo
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, newpage);
-	balloon_page_delete(page);
 	b_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 
@@ -542,6 +541,7 @@ static int cmm_migratepage(struct balloo
 	 */
 	plpar_page_set_active(page);
 
+	balloon_page_finalize(page);
 	/* balloon page list reference */
 	put_page(page);
 
--- a/drivers/misc/vmw_balloon.c~mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize
+++ a/drivers/misc/vmw_balloon.c
@@ -1778,8 +1778,7 @@ static int vmballoon_migratepage(struct
 	 * @pages_lock . We keep holding @comm_lock since we will need it in a
 	 * second.
 	 */
-	balloon_page_delete(page);
-
+	balloon_page_finalize(page);
 	put_page(page);
 
 	/* Inflate */
--- a/drivers/virtio/virtio_balloon.c~mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize
+++ a/drivers/virtio/virtio_balloon.c
@@ -866,15 +866,13 @@ static int virtballoon_migratepage(struc
 	tell_host(vb, vb->inflate_vq);
 
 	/* balloon's page migration 2nd step -- deflate "page" */
-	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
-	balloon_page_delete(page);
-	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
 	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
 	set_page_pfns(vb, vb->pfns, page);
 	tell_host(vb, vb->deflate_vq);
 
 	mutex_unlock(&vb->balloon_lock);
 
+	balloon_page_finalize(page);
 	put_page(page); /* balloon reference */
 
 	return MIGRATEPAGE_SUCCESS;
--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize
+++ a/include/linux/balloon_compaction.h
@@ -98,27 +98,6 @@ static inline void balloon_page_insert(s
 }
 
 /*
- * balloon_page_delete - delete a page from balloon's page list and clear
- *			 the page->private assignement accordingly.
- * @page    : page to be released from balloon's page list
- *
- * Caller must ensure the page is locked and the spin_lock protecting balloon
- * pages list is held before deleting a page from the balloon device.
- */
-static inline void balloon_page_delete(struct page *page)
-{
-	__ClearPageOffline(page);
-	__ClearPageMovable(page);
-	set_page_private(page, 0);
-	/*
-	 * No touch page.lru field once @page has been isolated
-	 * because VM is using the field.
-	 */
-	if (!PageIsolated(page))
-		list_del(&page->lru);
-}
-
-/*
  * balloon_page_device - get the b_dev_info descriptor for the balloon device
  *			 that enqueues the given page.
  */
@@ -141,12 +120,6 @@ static inline void balloon_page_insert(s
 	list_add(&page->lru, &balloon->pages);
 }
 
-static inline void balloon_page_delete(struct page *page)
-{
-	__ClearPageOffline(page);
-	list_del(&page->lru);
-}
-
 static inline gfp_t balloon_mapping_gfp_mask(void)
 {
 	return GFP_HIGHUSER;
@@ -155,6 +128,22 @@ static inline gfp_t balloon_mapping_gfp_
 #endif /* CONFIG_BALLOON_COMPACTION */
 
 /*
+ * balloon_page_finalize - prepare a balloon page that was removed from the
+ *			   balloon list for release to the page allocator
+ * @page: page to be released to the page allocator
+ *
+ * Caller must ensure that the page is locked.
+ */
+static inline void balloon_page_finalize(struct page *page)
+{
+	if (IS_ENABLED(CONFIG_BALLOON_COMPACTION)) {
+		__ClearPageMovable(page);
+		set_page_private(page, 0);
+	}
+	__ClearPageOffline(page);
+}
+
+/*
  * balloon_page_push - insert a page into a page list.
  * @head : pointer to list
  * @page : page to be added
--- a/mm/balloon_compaction.c~mm-balloon_compaction-convert-balloon_page_delete-to-balloon_page_finalize
+++ a/mm/balloon_compaction.c
@@ -94,7 +94,8 @@ size_t balloon_page_list_dequeue(struct
 		if (!trylock_page(page))
 			continue;
 
-		balloon_page_delete(page);
+		list_del(&page->lru);
+		balloon_page_finalize(page);
 		__count_vm_event(BALLOON_DEFLATE);
 		list_add(&page->lru, pages);
 		unlock_page(page);
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

