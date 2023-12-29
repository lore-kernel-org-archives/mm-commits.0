Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C7D134BF
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bgDFgcZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB9BC433C8;
	Fri, 29 Dec 2023 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879997;
	bh=xE6hdAo37F/nVywwamWGJpAakKgDBocWEnaU0sy3LsQ=;
	h=Date:To:From:Subject:From;
	b=bgDFgcZBH19ol6JYxK8vSqC71oEje1TZTmsLYAkOIiHG5teSKZPhkgRvo8JHGszt6
	 PzGfj1ZKrfLOZ8WzgTbvPvRXTYri6Omxi/tWfk1F8pHRwKYZoXvlHl6YVEeFAXfuof
	 k/QoKLEs4d6+oLz0tcudX9yAVovetIjvjMqKEkhU=
Date: Fri, 29 Dec 2023 11:59:57 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,21cnbao@gmail.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-cleanup-zswap_load.patch removed from -mm tree
Message-Id: <20231229195957.CFB9BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: cleanup zswap_load()
has been removed from the -mm tree.  Its filename was
     mm-zswap-cleanup-zswap_load.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: cleanup zswap_load()
Date: Thu, 28 Dec 2023 09:45:44 +0000

After the common decompress part goes to __zswap_load(), we can cleanup
the zswap_load() a little.

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v5-3-9382162bbf05@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chis Li <chrisl@kernel.org> (Google)
Cc: Barry Song <21cnbao@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/zswap.c~mm-zswap-cleanup-zswap_load
+++ a/mm/zswap.c
@@ -1746,7 +1746,6 @@ bool zswap_load(struct folio *folio)
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
 	u8 *dst;
-	bool ret;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
@@ -1759,23 +1758,20 @@ bool zswap_load(struct folio *folio)
 	}
 	spin_unlock(&tree->lock);
 
-	if (!entry->length) {
+	if (entry->length)
+		__zswap_load(entry, page);
+	else {
 		dst = kmap_local_page(page);
 		zswap_fill_page(dst, entry->value);
 		kunmap_local(dst);
-		ret = true;
-		goto stats;
 	}
 
-	__zswap_load(entry, page);
-	ret = true;
-stats:
 	count_vm_event(ZSWPIN);
 	if (entry->objcg)
 		count_objcg_event(entry->objcg, ZSWPIN);
 
 	spin_lock(&tree->lock);
-	if (ret && zswap_exclusive_loads_enabled) {
+	if (zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
 		folio_mark_dirty(folio);
 	} else if (entry->length) {
@@ -1785,7 +1781,7 @@ stats:
 	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-	return ret;
+	return true;
 }
 
 void zswap_invalidate(int type, pgoff_t offset)
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are


