Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E94134BF
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKva8G4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBC6C433C8;
	Fri, 29 Dec 2023 19:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879999;
	bh=v2Ac8FGLBuGMRwhPZSJ1zFk6qzhev0BvZrRlsezXpls=;
	h=Date:To:From:Subject:From;
	b=eKva8G4+5ge/FH3f+ywzk1CaO/JPjRkVYu+a11yN7yjiFbSgoI2AJjEm0I5H9CCNW
	 Wo1UHFYCVPUalwF81z+Cicn73QlqR1Ifm0rvvP1mF4ivLvOKS0JfUU6gbKfEs8XJ5z
	 j0iYCdddVUySQhZsBKi0Cjh81Nn9NoC8DXVMNMG8=
Date: Fri, 29 Dec 2023 11:59:58 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,21cnbao@gmail.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-cleanup-zswap_writeback_entry.patch removed from -mm tree
Message-Id: <20231229195959.6FBC6C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: cleanup zswap_writeback_entry()
has been removed from the -mm tree.  Its filename was
     mm-zswap-cleanup-zswap_writeback_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: cleanup zswap_writeback_entry()
Date: Thu, 28 Dec 2023 09:45:45 +0000

Also after the common decompress part goes to __zswap_load(), we can
cleanup the zswap_writeback_entry() a little.

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v5-4-9382162bbf05@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org> (Google)
Cc: Barry Song <21cnbao@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/mm/zswap.c~mm-zswap-cleanup-zswap_writeback_entry
+++ a/mm/zswap.c
@@ -1434,7 +1434,6 @@ static int zswap_writeback_entry(struct
 	struct page *page;
 	struct mempolicy *mpol;
 	bool page_was_allocated;
-	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
@@ -1443,16 +1442,17 @@ static int zswap_writeback_entry(struct
 	mpol = get_task_policy(current);
 	page = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
 				NO_INTERLEAVE_INDEX, &page_was_allocated, true);
-	if (!page) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	if (!page)
+		return -ENOMEM;
 
-	/* Found an existing page, we raced with load/swapin */
+	/*
+	 * Found an existing page, we raced with load/swapin. We generally
+	 * writeback cold pages from zswap, and swapin means the page just
+	 * became hot. Skip this page and let the caller find another one.
+	 */
 	if (!page_was_allocated) {
 		put_page(page);
-		ret = -EEXIST;
-		goto fail;
+		return -EEXIST;
 	}
 
 	/*
@@ -1466,8 +1466,7 @@ static int zswap_writeback_entry(struct
 	if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
 		spin_unlock(&tree->lock);
 		delete_from_swap_cache(page_folio(page));
-		ret = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 	spin_unlock(&tree->lock);
 
@@ -1483,15 +1482,7 @@ static int zswap_writeback_entry(struct
 	__swap_writepage(page, &wbc);
 	put_page(page);
 
-	return ret;
-
-fail:
-	/*
-	 * If we get here because the page is already in swapcache, a
-	 * load may be happening concurrently. It is safe and okay to
-	 * not free the entry. It is also okay to return !0.
-	 */
-	return ret;
+	return 0;
 }
 
 static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are


