Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1422A1D2799
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724788298; cv=none; b=ISLVui3HyM1LESGCUpD6wI8GgUcU3+tSt1pkrZXSWNyLrkGcJzaarBl4lITDF+aMVgu4yJr/br0mCl1qCZuNVCnMgQQGRN5SCjOjhGFiKIOoQL67QFVApt08TOTTBB3Luh9hwcldzI35G8LjTbfs47JbMZVaad/e3vZ0CDl7pO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724788298; c=relaxed/simple;
	bh=o2OzQ/F1NCqfjOrfG6XdAljOB/IwMKHeWdB7KqtNTh4=;
	h=Date:To:From:Subject:Message-Id; b=UJ/pfonsei5lk9RNwFFe89Ll0vMgEPMeE68LIxCFlyez6s5kMdu2b5BJUimpMvb6KTN1RnJ8b4A7quai7IuvT+/T65jSJRO+l4RZ+W8oqXif71Q0O5de1Y72zoDOCPXnokkV1RwdSlr8L/F+GQ+msWlEQYuXQWqWevDNQ2oPapY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nZOyoVvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nZOyoVvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70503C4FF1A;
	Tue, 27 Aug 2024 19:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724788297;
	bh=o2OzQ/F1NCqfjOrfG6XdAljOB/IwMKHeWdB7KqtNTh4=;
	h=Date:To:From:Subject:From;
	b=nZOyoVvjgNB+ysFrJG9hDZzHl6KNobbczjjwp96EOvQykcGjKGI5aPKxkTt4eSYe9
	 Nne9lDH94//iVmJREBySspXACdF0mpwllcxp/MBg/3v9ugQiKw9meogZElfemWZuoP
	 DdC46EKJCEcw++qdrOVibtrLydv/LtLm9JCyULRI=
Date: Tue, 27 Aug 2024 12:51:36 -0700
To: mm-commits@vger.kernel.org,oleksiy.avramchenko@sony.com,mhocko@suse.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-refactor-vm_area_alloc_pages-function.patch added to mm-unstable branch
Message-Id: <20240827195137.70503C4FF1A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: refactor vm_area_alloc_pages() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-refactor-vm_area_alloc_pages-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-refactor-vm_area_alloc_pages-function.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: refactor vm_area_alloc_pages() function
Date: Tue, 27 Aug 2024 21:09:16 +0200

The aim is to simplify and making the vm_area_alloc_pages()
function less confusing as it became more clogged nowadays:

- eliminate a "bulk_gfp" variable and do not overwrite a gfp
  flag for bulk allocator;
- drop __GFP_NOFAIL flag for high-order-page requests on upper
  layer. It becomes less spread between levels when it comes to
  __GFP_NOFAIL allocations;
- add a comment about a fallback path if high-order attempt is
  unsuccessful because for such cases __GFP_NOFAIL is dropped;
- fix a typo in a commit message.

Link: https://lkml.kernel.org/r/20240827190916.34242-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-refactor-vm_area_alloc_pages-function
+++ a/mm/vmalloc.c
@@ -3531,8 +3531,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
-	gfp_t alloc_gfp = gfp;
-	bool nofail = gfp & __GFP_NOFAIL;
 	struct page *page;
 	int i;
 
@@ -3543,9 +3541,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * more permissive.
 	 */
 	if (!order) {
-		/* bulk allocator doesn't support nofail req. officially */
-		gfp_t bulk_gfp = gfp & ~__GFP_NOFAIL;
-
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
 
@@ -3563,12 +3558,11 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * but mempolicy wants to alloc memory by interleaving.
 			 */
 			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
-				nr = alloc_pages_bulk_array_mempolicy_noprof(bulk_gfp,
+				nr = alloc_pages_bulk_array_mempolicy_noprof(gfp,
 							nr_pages_request,
 							pages + nr_allocated);
-
 			else
-				nr = alloc_pages_bulk_array_node_noprof(bulk_gfp, nid,
+				nr = alloc_pages_bulk_array_node_noprof(gfp, nid,
 							nr_pages_request,
 							pages + nr_allocated);
 
@@ -3582,30 +3576,24 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			if (nr != nr_pages_request)
 				break;
 		}
-	} else if (gfp & __GFP_NOFAIL) {
-		/*
-		 * Higher order nofail allocations are really expensive and
-		 * potentially dangerous (pre-mature OOM, disruptive reclaim
-		 * and compaction etc.
-		 */
-		alloc_gfp &= ~__GFP_NOFAIL;
 	}
 
 	/* High-order pages or fallback path if "bulk" fails. */
 	while (nr_allocated < nr_pages) {
-		if (!nofail && fatal_signal_pending(current))
+		if (!(gfp & __GFP_NOFAIL) && fatal_signal_pending(current))
 			break;
 
 		if (nid == NUMA_NO_NODE)
-			page = alloc_pages_noprof(alloc_gfp, order);
+			page = alloc_pages_noprof(gfp, order);
 		else
-			page = alloc_pages_node_noprof(nid, alloc_gfp, order);
+			page = alloc_pages_node_noprof(nid, gfp, order);
+
 		if (unlikely(!page))
 			break;
 
 		/*
 		 * Higher order allocations must be able to be treated as
-		 * indepdenent small pages by callers (as they can with
+		 * independent small pages by callers (as they can with
 		 * small-page vmallocs). Some drivers do their own refcounting
 		 * on vmalloc_to_page() pages, some use page->mapping,
 		 * page->lru, etc.
@@ -3666,7 +3654,16 @@ static void *__vmalloc_area_node(struct
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
 	page_order = vm_area_page_order(area);
 
-	area->nr_pages = vm_area_alloc_pages(gfp_mask | __GFP_NOWARN,
+	/*
+	 * Higher order nofail allocations are really expensive and
+	 * potentially dangerous (pre-mature OOM, disruptive reclaim
+	 * and compaction etc.
+	 *
+	 * Please note, the __vmalloc_node_range_noprof() falls-back
+	 * to order-0 pages if high-order attempt is unsuccessful.
+	 */
+	area->nr_pages = vm_area_alloc_pages((page_order ?
+		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
 		node, page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-refactor-vm_area_alloc_pages-function.patch

