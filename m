Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480991EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119327; cv=none; b=JiaxjShv1v8m4sHynnGqaktwQ7Q4S+lAmjw6v22sReKiLTdBjyWTPmZjG42mYb8oJX81MbLqEqX2JVX9wOC5eALLdntP+ytXdRqeTBDlAgpamlHZo+zpX3HYGXd75CF+deEjJiGawkFGJklx+jGNA7aToTAmgeEemSexUgZgnKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119327; c=relaxed/simple;
	bh=hsfClosWUaNbpmr1nFCHFvjfZZuhy76bsZmWQLsjYGg=;
	h=Date:To:From:Subject:Message-Id; b=aNU6pgOvG/mSK2KsfNEeD1Oi4yDk/bJzG2ymEHz6m3cqkEyRrRUc2+7fieCOSwiM7HXYwIpzDhoO70LZ3FSOoGhOF5HvmCEH1RrnZk4sjQDIsI78zDA8kUlziPPJgFFs0tdTI661AkMvH3hKxbpEZppNZesYckdqAv/jH1ThWfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AC9JYZAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AC9JYZAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8A4C4CEE4;
	Tue, 13 May 2025 06:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119327;
	bh=hsfClosWUaNbpmr1nFCHFvjfZZuhy76bsZmWQLsjYGg=;
	h=Date:To:From:Subject:From;
	b=AC9JYZAWENI972yuy2V5IhMBu8wwoAm5GsAGO+CcFyGnWLBL2YKa528MMRfG71dUf
	 Fj3F+mbItmZWMhuKL88+8+y7/MEgXySvmlpV2el/loxbnC2asn26a95ECJG739CvGr
	 3dDd1lLv2MlK+u3uWYnaRpqqqBIzBi1lXL5yvI/w=
Date: Mon, 12 May 2025 23:55:26 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch removed from -mm tree
Message-Id: <20250513065527.1F8A4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move folio_index to mm/swap.h and remove no longer needed helper
has been removed from the -mm tree.  Its filename was
     mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm: move folio_index to mm/swap.h and remove no longer needed helper
Date: Thu, 1 May 2025 02:10:51 +0800

There are no remaining users of folio_index() outside the mm subsystem. 
Move it to mm/swap.h to co-locate it with swap_cache_index(), eliminating
a forward declaration, and a function call overhead.

Also remove the helper that was used to fix circular header dependency
issue.

Link: https://lkml.kernel.org/r/20250430181052.55698-6-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   20 --------------------
 mm/gup.c                |    1 +
 mm/memfd.c              |    1 +
 mm/migrate.c            |    1 +
 mm/page-writeback.c     |    1 +
 mm/swap.h               |   18 ++++++++++++++++++
 mm/swapfile.c           |    6 ------
 7 files changed, 22 insertions(+), 26 deletions(-)

--- a/include/linux/pagemap.h~mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper
+++ a/include/linux/pagemap.h
@@ -884,26 +884,6 @@ static inline struct page *grab_cache_pa
 			mapping_gfp_mask(mapping));
 }
 
-extern pgoff_t __folio_swap_cache_index(struct folio *folio);
-
-/**
- * folio_index - File index of a folio.
- * @folio: The folio.
- *
- * For a folio which is either in the page cache or the swap cache,
- * return its index within the address_space it belongs to.  If you know
- * the page is definitely in the page cache, you can look at the folio's
- * index directly.
- *
- * Return: The index (offset in units of pages) of a folio in its file.
- */
-static inline pgoff_t folio_index(struct folio *folio)
-{
-	if (unlikely(folio_test_swapcache(folio)))
-		return __folio_swap_cache_index(folio);
-	return folio->index;
-}
-
 /**
  * folio_next_index - Get the index of the next folio.
  * @folio: The current folio.
--- a/mm/gup.c~mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper
+++ a/mm/gup.c
@@ -26,6 +26,7 @@
 #include <asm/tlbflush.h>
 
 #include "internal.h"
+#include "swap.h"
 
 struct follow_page_context {
 	struct dev_pagemap *pgmap;
--- a/mm/memfd.c~mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper
+++ a/mm/memfd.c
@@ -20,6 +20,7 @@
 #include <linux/memfd.h>
 #include <linux/pid_namespace.h>
 #include <uapi/linux/memfd.h>
+#include "swap.h"
 
 /*
  * We need a tag: a new tag would expand every xa_node by 8 bytes,
--- a/mm/migrate.c~mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper
+++ a/mm/migrate.c
@@ -50,6 +50,7 @@
 #include <trace/events/migrate.h>
 
 #include "internal.h"
+#include "swap.h"
 
 bool isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
--- a/mm/page-writeback.c~mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper
+++ a/mm/page-writeback.c
@@ -41,6 +41,7 @@
 #include <trace/events/writeback.h>
 
 #include "internal.h"
+#include "swap.h"
 
 /*
  * Sleep at most 200ms at a time in balance_dirty_pages().
--- a/mm/swapfile.c~mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper
+++ a/mm/swapfile.c
@@ -3671,12 +3671,6 @@ struct address_space *swapcache_mapping(
 }
 EXPORT_SYMBOL_GPL(swapcache_mapping);
 
-pgoff_t __folio_swap_cache_index(struct folio *folio)
-{
-	return swap_cache_index(folio->swap);
-}
-EXPORT_SYMBOL_GPL(__folio_swap_cache_index);
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
--- a/mm/swap.h~mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper
+++ a/mm/swap.h
@@ -201,4 +201,22 @@ static inline int swap_zeromap_batch(swp
 
 #endif /* CONFIG_SWAP */
 
+/**
+ * folio_index - File index of a folio.
+ * @folio: The folio.
+ *
+ * For a folio which is either in the page cache or the swap cache,
+ * return its index within the address_space it belongs to.  If you know
+ * the folio is definitely in the page cache, you can look at the folio's
+ * index directly.
+ *
+ * Return: The index (offset in units of pages) of a folio in its file.
+ */
+static inline pgoff_t folio_index(struct folio *folio)
+{
+	if (unlikely(folio_test_swapcache(folio)))
+		return swap_cache_index(folio->swap);
+	return folio->index;
+}
+
 #endif /* _MM_SWAP_H */
_

Patches currently in -mm which might be from kasong@tencent.com are


