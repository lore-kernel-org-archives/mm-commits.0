Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7E21EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450057; cv=none; b=UeakErJ2VfHht7dnNC/wtuTp+HBSRVbOpf0pY/wDiNLfEvnaCquwCCyjmapHbDmJTG7dXAi7e8ti8uv7vQmhhceKGhk6XVwQJA2UjjrVqvOjsIBtcCko42tUbIOFmVxyLx5EBWADeYKPPfXDox2DmM0s3fB3rMjJe8hx3iU8YVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450057; c=relaxed/simple;
	bh=oXz55KGAbdGAuKrIzeLxO5uVkrvqyHCVammqg+39h+Q=;
	h=Date:To:From:Subject:Message-Id; b=MjZHieUh42c64QqCQHQ55enh5CIMClunTFWIytgn6cBw9jS6XOXV6eU+I7U2NZFHy68NSv2JkYuXR263hZfkQ3gEIZTacclVIerGi6+T3MOhNyhEaWMgPceUg4MTVC19fAJ6ikUQRzVxZGiv/vaSt3VS/cyWy+Z83V9Rpg138iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KECKBs3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KECKBs3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD1CC4CEE3;
	Sun, 13 Jul 2025 23:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450057;
	bh=oXz55KGAbdGAuKrIzeLxO5uVkrvqyHCVammqg+39h+Q=;
	h=Date:To:From:Subject:From;
	b=KECKBs3skkoYaoezbqW0p+Z2icxRnGfZwyHdTXUIo2UnJ75jtiNTIrjfrXfeTrOED
	 riCE8jlKCHjaez6OfhUJahefz3FNGK6vQr5ZK9TzO6XK5qShWmdjvN64afos3hI/BI
	 ee0EpG1awFJLqgKlv504MO0ku4wUdAaVtFmOK9lQ=
Date: Sun, 13 Jul 2025 16:40:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,xuanzhuo@linux.alibaba.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,nao.horiguchi@gmail.com,mst@redhat.com,mpe@ellerman.id.au,minchan@kernel.org,mhocko@suse.com,matthew.brost@intel.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jhubbard@nvidia.com,jgg@ziepe.ca,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,jack@suse.cz,jackmanb@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,arnd@arndb.de,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-drop-pageisolated-related-vm_bug_ons.patch removed from -mm tree
Message-Id: <20250713234057.2DD1CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: drop PageIsolated() related VM_BUG_ONs
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-drop-pageisolated-related-vm_bug_ons.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/zsmalloc: drop PageIsolated() related VM_BUG_ONs
Date: Fri, 4 Jul 2025 12:24:57 +0200

Let's drop these checks; these are conditions the core migration code must
make sure will hold either way, no need to double check.

Link: https://lkml.kernel.org/r/20250704102524.326966-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
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
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |    5 -----
 mm/zsmalloc.c |    5 -----
 2 files changed, 10 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-drop-pageisolated-related-vm_bug_ons
+++ a/mm/zpdesc.h
@@ -168,11 +168,6 @@ static inline void __zpdesc_clear_zsmall
 	__ClearPageZsmalloc(zpdesc_page(zpdesc));
 }
 
-static inline bool zpdesc_is_isolated(struct zpdesc *zpdesc)
-{
-	return PageIsolated(zpdesc_page(zpdesc));
-}
-
 static inline struct zone *zpdesc_zone(struct zpdesc *zpdesc)
 {
 	return page_zone(zpdesc_page(zpdesc));
--- a/mm/zsmalloc.c~mm-zsmalloc-drop-pageisolated-related-vm_bug_ons
+++ a/mm/zsmalloc.c
@@ -1719,8 +1719,6 @@ static bool zs_page_isolate(struct page
 	 * Page is locked so zspage couldn't be destroyed. For detail, look at
 	 * lock_zspage in free_zspage.
 	 */
-	VM_BUG_ON_PAGE(PageIsolated(page), page);
-
 	return true;
 }
 
@@ -1739,8 +1737,6 @@ static int zs_page_migrate(struct page *
 	unsigned long old_obj, new_obj;
 	unsigned int obj_idx;
 
-	VM_BUG_ON_PAGE(!zpdesc_is_isolated(zpdesc), zpdesc_page(zpdesc));
-
 	/* The page is locked, so this pointer must remain valid */
 	zspage = get_zspage(zpdesc);
 	pool = zspage->pool;
@@ -1811,7 +1807,6 @@ static int zs_page_migrate(struct page *
 
 static void zs_page_putback(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 }
 
 static const struct movable_operations zsmalloc_mops = {
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-fpb_ignore_-into-fpb_respect_.patch
mm-smaller-folio_pte_batch-improvements.patch
mm-split-folio_pte_batch-into-folio_pte_batch-and-folio_pte_batch_flags.patch
mm-remove-boolean-output-parameters-from-folio_pte_batch_ext.patch
mm-memory-introduce-is_huge_zero_pfn-and-use-it-in-vm_normal_page_pmd.patch

