Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD345152E01;
	Tue, 20 Feb 2024 22:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467742; cv=none; b=kOanMouoXPCVtzKMca55dU8sgW00d9vxR3DwT0ue666QGg1PUlvk4vXzmFF/5+P3yg97YRilNHnrk2wl1NiTctUZwLKAKIebykwqMKyasFwb2kyPgIcQqHFPsAqHYggrRmv9PhDlZLSBS+NUbssHlwMftLGzyxstyTkIibyc7p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467742; c=relaxed/simple;
	bh=YlQ46O90GPzBQG+gqL38VNbzeNdDpKY+V8aFKE6fUfo=;
	h=Date:To:From:Subject:Message-Id; b=HHchHWZMOApgfK5zyNcB9WyBDx1q/d5fK/Jkq1iPtduuLIKRGTD05svem8h+90ITsQBxsaV23xAhjBTIm2Bj4t5OPLggsROUFHrvsTrNNwL/ov2KNU6OBPtOwBdfiNGsdxuzkNfp9xYu9VJCVzJb3kMdPb1VmZ+3+5274XTKy2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ifa0USAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ifa0USAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB8DC433C7;
	Tue, 20 Feb 2024 22:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467742;
	bh=YlQ46O90GPzBQG+gqL38VNbzeNdDpKY+V8aFKE6fUfo=;
	h=Date:To:From:Subject:From;
	b=ifa0USAZhHQdLslDDfUclGqjrPNXUqple6NGnaXlN0DzYYYnMbzp9qEm/Exr7hHxy
	 TN0RYcCWreWb1QvzLZic2wrqvGBklsubBJHGw2kbslLXqw06/zm4SL0E6blZEfflIZ
	 j5U+axGk+5uwYKb9UW4QnxQff9Fi6/1bWrYcEY04=
Date: Tue, 20 Feb 2024 14:22:21 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,stable@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,cerasuolodomenico@gmail.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch removed from -mm tree
Message-Id: <20240220222222.1FB8DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: zswap: fix missing folio cleanup in writeback race path
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: zswap: fix missing folio cleanup in writeback race path
Date: Thu, 25 Jan 2024 08:51:27 +0000

In zswap_writeback_entry(), after we get a folio from
__read_swap_cache_async(), we grab the tree lock again to check that the
swap entry was not invalidated and recycled.  If it was, we delete the
folio we just added to the swap cache and exit.

However, __read_swap_cache_async() returns the folio locked when it is
newly allocated, which is always true for this path, and the folio is
ref'd.  Make sure to unlock and put the folio before returning.

This was discovered by code inspection, probably because this path handles
a race condition that should not happen often, and the bug would not crash
the system, it will only strand the folio indefinitely.

Link: https://lkml.kernel.org/r/20240125085127.1327013-1-yosryahmed@google.com
Fixes: 04fc7816089c ("mm: fix zswap writeback race condition")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/zswap.c~mm-zswap-fix-missing-folio-cleanup-in-writeback-race-path
+++ a/mm/zswap.c
@@ -1440,6 +1440,8 @@ static int zswap_writeback_entry(struct
 	if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
 		spin_unlock(&tree->lock);
 		delete_from_swap_cache(folio);
+		folio_unlock(folio);
+		folio_put(folio);
 		return -ENOMEM;
 	}
 	spin_unlock(&tree->lock);
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch
x86-mm-delete-unused-cpu-argument-to-leave_mm.patch
x86-mm-clarify-prev-usage-in-switch_mm_irqs_off.patch

