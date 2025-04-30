Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519732C2ACE
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047094; cv=none; b=E3D5zGopZv1gVNW2y64i014ihGvN78ufOkxBGNDZLuC6AXC75v8JTW5OYhhXpeYC/inMYEGoXYtFsDc9xyV4eBr7olM/fjH+ye1Q8ibb3KA+8MeE6rNZcThLBfv7SPTZSQBoz1cGXdcgwCbX216W82cUeXZU8qDgAg+XCBVqm4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047094; c=relaxed/simple;
	bh=c4lqqXt6Yj8GVuCCh0UHd5m+k3265Ha0PsrrNMTvh+M=;
	h=Date:To:From:Subject:Message-Id; b=quuX6KVD8C5m1Y2CbogU+FTH57aOHg0bF8YrNZz/oJd9NKsBsvyW1NGA99nsbJs60QV1zhGzn2/45YIghQKVV4Q6b9RDYsW2WJHwfiT04OojgrU6I87InuMnZVujShlBv7usxTtbaLEENOmDGcaPBh+r8HCjp/bSECubQ0TN5nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2TWZNPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2TWZNPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D75C4CEEA;
	Wed, 30 Apr 2025 21:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047094;
	bh=c4lqqXt6Yj8GVuCCh0UHd5m+k3265Ha0PsrrNMTvh+M=;
	h=Date:To:From:Subject:From;
	b=Z2TWZNPEhz6xyS9goR/LGQE8sR6UzbCCEE5PnjTxYsf0oD+g59dNCxlZtLyCQAL2b
	 vky9UGW9CN+bW35uA2VynDDfg7Xbu3GVi8/0n46CuubLUH7BiPNCN9+CWrXpOq3qHB
	 QM2ilIbv0s+LaiWphjhjprQx96tpdqHmJQdZNWEk=
Date: Wed, 30 Apr 2025 14:04:53 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch added to mm-new branch
Message-Id: <20250430210453.F3D75C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move folio_index to mm/swap.h and remove no longer needed helper
has been added to the -mm mm-new branch.  Its filename is
     mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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

mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch
mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch
fuse-drop-usage-of-folio_index.patch
btrfs-drop-usage-of-folio_index.patch
f2fs-drop-usage-of-folio_index.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios.patch
mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch
mm-swap-remove-no-longer-used-swap-mapping-helper.patch

