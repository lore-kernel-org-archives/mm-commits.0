Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C24071F3
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525494; cv=none; b=HYE3WGwD63cKB1WVN7ATilTIUWw+271UIcm25hz0nF4GGKT3YbK4Z201gQqsVKM8mNa3hCZCmUR2oTofFWD9Ikigsw50BBwbTm4tjlLNV+m1RqCwGr62Z9aI8M1Gv5YEtIxWhAUuY4+MpYOLjILiUWTFQUU8c4tEbcXk2SPXgCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525494; c=relaxed/simple;
	bh=UtJw9/klAm+LJjKymXvqTZiFNCpz8HqNKKb4YOUtWug=;
	h=Date:To:From:Subject:Message-Id; b=kSF7MvhC7Sfc/OULMaU8xw0o2qj3Y5mkvy50Wvlch0fo1TwcFnU8jizpzCD9iTg7tQq0tW/Dkq/c9avEpVObNiW4GmvFYqVzeRi7Y0EkiwBrmz4vG8Cd8AWtsltWo+4rv9W+VNHUivbFOcKUb2lbK7k1f8vrxWHXATyxL6Jc+O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CIm4UKJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CIm4UKJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2807E1F000FF;
	Fri,  9 Oct 2026 05:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525493;
	bh=sjeIb4tT6DL+mcUU0V2VD/lT+KJo4J3OG/XR6qsldF0=;
	h=Date:To:From:Subject;
	b=CIm4UKJf5bVTRo+PfgH2SiK0t9fyCSvTIECWfd8w24Znk5/HB3UQzvlPzrwV3MsMU
	 UwDZbs+fLk0vMJGKpNB5MinZffByfJKkdX7xV+YAOgGlFXn0DbKR5p5/ScFOQOM0MV
	 ApELzMq0z0Zy6XJeG+5rOR6dC3cAtw0+/LcQfGxY=
Date: Thu, 08 Oct 2026 22:58:12 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch removed from -mm tree
Message-Id: <20261009055813.2807E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: reuse zswap_invalidate() in zswap_store()
has been removed from the -mm tree.  Its filename was
     mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: zswap: reuse zswap_invalidate() in zswap_store()
Date: Thu, 10 Sep 2026 20:35:44 +0800

Reuse zswap_invalidate() in zswap_store() check_old path.  Its
zswap_never_enabled() and xa_empty() guards avoid redundant xarray lookups
and deduplicate the per-slot free logic.

Link: https://lore.kernel.org/20260910123544.818146-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
---

 mm/zswap.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/mm/zswap.c~mm-zswap-reuse-zswap_invalidate-in-zswap_store
+++ a/mm/zswap.c
@@ -1543,19 +1543,8 @@ check_old:
 	 * offsets corresponding to each page of the folio. Otherwise,
 	 * writeback could overwrite the new data in the swapfile.
 	 */
-	if (!ret) {
-		unsigned type = swp_type(swp);
-		pgoff_t offset = swp_offset(swp);
-		struct zswap_entry *entry;
-		struct xarray *tree;
-
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
-			if (entry)
-				zswap_entry_free(entry);
-		}
-	}
+	if (!ret)
+		zswap_invalidate(swp_type(swp), swp_offset(swp), nr_pages);
 
 	return ret;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mincore-use-per-vma-lock-during-page-table-walk.patch

