Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB29BE65
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739441; cv=none; b=r5JPAlwrJPqZlYgg5aNqvE6BHHCPRS/aoLqJQRT0L3vBtFoSsd4sUO7yny7nEM3bDKRlQaV7lBIyv9FteioMeS/6Y9F199xwhAYRc5KF2TZ9TQblp6GfV9Yu/BbIFvvNszJ4hcAHaBsdYP9VsTU7xH5Rw5MAOhblsUNAeUd12f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739441; c=relaxed/simple;
	bh=Ycurp41aonSEPaIK8ChsJ8FJHFqe3YynVtafCYOzstM=;
	h=Date:To:From:Subject:Message-Id; b=IYzxjNjUFdXPMhGlyBNABkhbv8WzqMnkkl0cNudue2oPNfyltuUEPOxdKFWwLxSsWMS+JmJGfYS5IhskYyNmbumfU4PSVLbdxkazVeLi6A7oA4yeBJHWQksl//smw1tlcrjf0R/ATDVMqJZ2cCg1RZXNL4Pgx9wRYz6tRV1kDzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q7c/tf+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q7c/tf+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80870C433F1;
	Sat, 24 Feb 2024 01:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739441;
	bh=Ycurp41aonSEPaIK8ChsJ8FJHFqe3YynVtafCYOzstM=;
	h=Date:To:From:Subject:From;
	b=q7c/tf+0TGoMeivF5fHKXJLcfzMjIzljP/ebVaajYhfVHr7xVQwrNYiWNDsZzQ99c
	 psNh5kibwYDUAGWJQ8kjfRisttzj/7Wvh+MqADRcLnzZJ7Z5CjJGpgXMaf6k1F8QmU
	 tZeUrK+tDVKPheVkgK4pXVZwr0YVdBHFtPFSBlj0=
Date: Fri, 23 Feb 2024 17:50:41 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch removed from -mm tree
Message-Id: <20240224015041.80870C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: remove_zspage() don't need fullness parameter
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zsmalloc: remove_zspage() don't need fullness parameter
Date: Tue, 20 Feb 2024 06:53:01 +0000

We must remove_zspage() from its current fullness list, then use
insert_zspage() to update its fullness and insert to new fullness list. 
Obviously, remove_zspage() doesn't need the fullness parameter.

Link: https://lkml.kernel.org/r/20240220-b4-zsmalloc-cleanup-v1-2-5c5ee4ccdd87@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove_zspage-dont-need-fullness-parameter
+++ a/mm/zsmalloc.c
@@ -687,10 +687,10 @@ static void insert_zspage(struct size_cl
  * This function removes the given zspage from the freelist identified
  * by <class, fullness_group>.
  */
-static void remove_zspage(struct size_class *class,
-				struct zspage *zspage,
-				int fullness)
+static void remove_zspage(struct size_class *class, struct zspage *zspage)
 {
+	int fullness = zspage->fullness;
+
 	VM_BUG_ON(list_empty(&class->fullness_list[fullness]));
 
 	list_del_init(&zspage->list);
@@ -716,7 +716,7 @@ static int fix_fullness_group(struct siz
 	if (newfg == currfg)
 		goto out;
 
-	remove_zspage(class, zspage, currfg);
+	remove_zspage(class, zspage);
 	insert_zspage(class, zspage, newfg);
 out:
 	return newfg;
@@ -878,7 +878,7 @@ static void free_zspage(struct zs_pool *
 		return;
 	}
 
-	remove_zspage(class, zspage, ZS_INUSE_RATIO_0);
+	remove_zspage(class, zspage);
 	__free_zspage(pool, class, zspage);
 }
 
@@ -1609,7 +1609,7 @@ static struct zspage *isolate_src_zspage
 		zspage = list_first_entry_or_null(&class->fullness_list[fg],
 						  struct zspage, list);
 		if (zspage) {
-			remove_zspage(class, zspage, fg);
+			remove_zspage(class, zspage);
 			return zspage;
 		}
 	}
@@ -1626,7 +1626,7 @@ static struct zspage *isolate_dst_zspage
 		zspage = list_first_entry_or_null(&class->fullness_list[fg],
 						  struct zspage, list);
 		if (zspage) {
-			remove_zspage(class, zspage, fg);
+			remove_zspage(class, zspage);
 			return zspage;
 		}
 	}
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch

