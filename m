Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD9C3E9F8C
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314202; cv=none; b=usBBErlMMG+n6TKvusBpkr9ta4zuatIrTJOJHqmaoqCj6adXh4xJ8nIADCrajFzs/YVYEwLxTcwVPe8CVdy9T1CNH8hKhwCFyysmNMGdNwQWOR7+H0mrYBSAkpd5xrFryRKESjP+5M6NyeA8+WlAw8NL6OaRVOmNKRv5V0w8Ji0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314202; c=relaxed/simple;
	bh=hekgrKYFI3I7wo96elAhjmlCxjuca+1xJbxo/n9M+lY=;
	h=Date:To:From:Subject:Message-Id; b=hpA9RN9AapjnjKYgKMQCjmt/Xwo4LN/2NXTXgI2lddakDdpdaUcJdpF5D2IjQFqQ6/lIfyKhkBr/mEr5jE+zFOGLhovYzU/jxEslEgqQJdNpzeI3piiX7Bth2H+yJa5074Arfp7KDVAxeDr2vuZ9o3pLtpO3q/YnC349f7hGXXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SuUa787j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SuUa787j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86830C19425;
	Mon, 27 Apr 2026 18:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777314202;
	bh=hekgrKYFI3I7wo96elAhjmlCxjuca+1xJbxo/n9M+lY=;
	h=Date:To:From:Subject:From;
	b=SuUa787j4wEt8uU+UDMh26bV8oQ9pSeh74ba1n8Zvbqo4PqMzy6vKuM4pd7hU0+dd
	 n6z7Gp3ZnuKNU9Ak51XYSY2Q9B7D/Enp6ka+4XGj/o4OobVhSyTpVUVh/GyIA8BGa6
	 1bj8z2FTVyde2+nFDy05qa4WXXWyWSgpncJqAXGs=
Date: Mon, 27 Apr 2026 11:23:22 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-use-a-smaller-batch-for-reclaim.patch added to mm-new branch
Message-Id: <20260427182322.86830C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: use a smaller batch for reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-use-a-smaller-batch-for-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-use-a-smaller-batch-for-reclaim.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: use a smaller batch for reclaim
Date: Tue, 28 Apr 2026 02:06:58 +0800

With a fixed number to reclaim calculated at the beginning, making each
following step smaller should reduce the lock contention and avoid
over-aggressive reclaim of folios, as it will abort earlier when the
number of folios to be reclaimed is reached.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-7-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-use-a-smaller-batch-for-reclaim
+++ a/mm/vmscan.c
@@ -5007,7 +5007,7 @@ static bool try_to_shrink_lruvec(struct
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

