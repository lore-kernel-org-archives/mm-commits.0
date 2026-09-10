Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E5B4718D6
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789076894; cv=none; b=QmxHvh/EfzigtrvRRlwEfChJIZCIQVd+ztI5/lmYMrdaH8WjgIl61PLBCIeqIz/0Vcj4rTSd0lYR4rrCRRGLHdqW/RTy/plr64oTy5FAVcFXAXJsZgzZ4BdqKIGlzfpnM+0/zjyFNjP/pXlltEpRJg+DS8V1j94pa0Fb5tMS/1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789076894; c=relaxed/simple;
	bh=8smJMBn1Sx6VZD42HaLId7VB1IOZTLM+g1JSA9z9Lro=;
	h=Date:To:From:Subject:Message-Id; b=fOjUEIwgGDCM4bw8UN2lfo85+SC5ZtDidZmChfgJ77esKHERv/JH6yWwSFB9vDZXwaKHToRVekhHNp3runJaKkimK1SIo8sLtpr8pXc6GviJ09whxk/5BSXsfxP5G4YCpfMRXe9i7R+o/jUifdshwSBKrGG3qidySSMYUDFgwDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SuuOfmNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SuuOfmNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5401F000FF;
	Thu, 10 Sep 2026 21:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789076892;
	bh=o49rIzh5pA7R90NgviP8gsRL+TEUYbl1nyZgNQiPAXw=;
	h=Date:To:From:Subject;
	b=SuuOfmNCky4GALmy1XuVrUF3y5/elTYQFuxQg5dfk5XdAOGls7QLF3nFGPxEcFqVa
	 4wOiRId7037WJxp5JM2i7z26u/k1Rcu6kYQNiPAJsjBZkfAQQ+AN/KK71C7r/jBYFw
	 +mczLJ28f8Th7X9XTe/+nYicWVnznf3e6Di3RmCk=
Date: Thu, 10 Sep 2026 14:48:12 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,yosryahmed@google.com,nphamcs@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch added to mm-new branch
Message-Id: <20260910214812.6A5401F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: skip xarray walk in zswap_invalidate() when zswap is unused
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch

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
Subject: mm: zswap: skip xarray walk in zswap_invalidate() when zswap is unused
Date: Thu, 10 Sep 2026 20:35:43 +0800

zswap_invalidate() still walks the per-area xarray even when zswap has
never been enabled.  Add a zswap_never_enabled() to skip it.

Link: https://lore.kernel.org/20260910123544.818146-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zswap.c~mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused
+++ a/mm/zswap.c
@@ -1670,6 +1670,9 @@ void zswap_invalidate(int type, pgoff_t
 	struct xarray *tree;
 	unsigned long i;
 
+	if (zswap_never_enabled())
+		return;
+
 	for (i = 0; i < nr_entries; i++) {
 		tree = zswap_tree(type, offset + i);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

xfs-remove-dead-kswapd-flag-inheritance-from-btree-split-worker.patch
iomap-simplify-writepages-reclaim-guard.patch
mm-replace-pf_kswapd-flag-with-kthread_func-check.patch
mm-replace-pf_kcompactd-flag-with-kthread_func-check.patch
mm-zswap-convert-zswap_invalidate-to-take-a-range.patch
mm-zswap-skip-xarray-walk-in-zswap_invalidate-when-zswap-is-unused.patch
mm-zswap-reuse-zswap_invalidate-in-zswap_store.patch

