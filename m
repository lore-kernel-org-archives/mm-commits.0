Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7544718FC
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789076896; cv=none; b=cqHXxU7HdsavmzasNY9GC99XaWtaZvFxXIcleRJr0vIjeZJ3GOCbK5z7FI74+BBi67z13YN4kvSgm6fYtAwrp03KUsOgbDKOS5Fdm5pelU58coe7KGUU0wxC374NDN3kzMXswApXRi0YZPipTyQ27jU5S/VLE+CpZfxmMKAR60g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789076896; c=relaxed/simple;
	bh=Vjpu7IsBm4vWLeriFaV/YUK3t5Z9+xOWyRc0r6AWjMU=;
	h=Date:To:From:Subject:Message-Id; b=ZExPGMIpmmAIxblZrqP99wnWfyyUwokGdOnXni52vEAfhdaPqWDnVJcY9IngAozbgy2yoYYGi2bsTjPCpCeH9sMApF76fotW+MpcSXxKtc7x7f7QQiQ3vIrIfR+EA3mtI1DGZX+X65YuB/Gk/C3lHrgeFLl3H0jcL43P7Hir9S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TafH9afv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TafH9afv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D831F000FF;
	Thu, 10 Sep 2026 21:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789076894;
	bh=Qp8G9q7Ax/Yc5qNrIiPtgpU9CLU4Qzvlc2OxLhY5NgI=;
	h=Date:To:From:Subject;
	b=TafH9afvnyzXR/m/vnOx1Dp3JEc/kYnSOpfcqHLxSTZKrVxzryMhac4tKLHbHOAJ3
	 1pi8qalLpUY2Wp0nLz9dW1kVUgAe76FvcUhdwnz83e4wdc36SRxOtFSOMpynZ2CWwe
	 +krlGg/HhKHZQ31sDUrkd/hBI1hC0GTxTkw/LQLE=
Date: Thu, 10 Sep 2026 14:48:14 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch added to mm-new branch
Message-Id: <20260910214814.70D831F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: reuse zswap_invalidate() in zswap_store()
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: zswap: reuse zswap_invalidate() in zswap_store()
Date: Thu, 10 Sep 2026 20:35:44 +0800

Reuse zswap_invalidate() in zswap_store() check_old path.  Its
zswap_never_enabled() and xa_empty() guards avoid redundant xarray lookups
and deduplicate the per-slot free logic.

Link: https://lore.kernel.org/20260910123544.818146-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/mm/zswap.c~mm-zswap-reuse-zswap_invalidate-in-zswap_store
+++ a/mm/zswap.c
@@ -1546,19 +1546,8 @@ check_old:
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

xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch
iomap-simplify-writepages-reclaim-guard.patch
mm-replace-pf_kswapd-flag-with-kthread_func-check.patch
mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch
mm-zswap-convert-zswap_invalidate-to-take-a-range.patch
mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch
mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch

