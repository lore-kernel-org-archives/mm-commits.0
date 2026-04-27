Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26553D75AD
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313493; cv=none; b=hKYOBCIwoqsTXQd/BDh2SffrjRbykM2DAHlk8Iqyni0opb+o53WjYzxcvVYBv887CnapxJHcdTh/E5usdUjTVqfpL/GHusYlu/J3VbT/ptCnosxvsNLMUnayTXvoiQFkrmrTLAx6v9c3coDtJw/FBRvBdLjO1XvcnnwBzsGU2hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313493; c=relaxed/simple;
	bh=P0JrebCXeGid3xSnP+DGrmHgl1hwO9JhYG5SQoMrG4E=;
	h=Date:To:From:Subject:Message-Id; b=F5GCYhrazf5gzGYarSXQkmLsia9X/XO0JfeyZURtD9DqrOUzEgZxX4Y0wibLzs52Jm1HNShTh++5lzw3N5XATnejcLn7FaX7IA/EbnFBcxxfdJ+fB+Y7qdiUMAoBsvUkxl/+n5MlBA/1/MC6fVUN1pxbw/Ri6vtdBs96bGFsI9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ifb5us1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ifb5us1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59407C19425;
	Mon, 27 Apr 2026 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313493;
	bh=P0JrebCXeGid3xSnP+DGrmHgl1hwO9JhYG5SQoMrG4E=;
	h=Date:To:From:Subject:From;
	b=Ifb5us1DxPumw4VnJaqcy1c21t6OPG6rU1i+qAwOkWPyB+MdFMa7U3Je7U00dgmL3
	 pK8ZbC5KCICrN+rUA1pGmas9uUmYf182M+phMq+qoKGrXQaG5pKgRu/7vX3tD+U7rT
	 E2RX5KQrXw7a3R8bZ2NA55AwWYTci2ZLrMuvwZaw=
Date: Mon, 27 Apr 2026 11:11:32 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-use-a-smaller-batch-for-reclaim.patch removed from -mm tree
Message-Id: <20260427181133.59407C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: use a smaller batch for reclaim
has been removed from the -mm tree.  Its filename was
     mm-mglru-use-a-smaller-batch-for-reclaim.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: use a smaller batch for reclaim
Date: Fri, 24 Apr 2026 01:43:17 +0800

With a fixed number to reclaim calculated at the beginning, making each
following step smaller should reduce the lock contention and avoid
over-aggressive reclaim of folios, as it will abort earlier when the
number of folios to be reclaimed is reached.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-6-a57622d770c3@tencent.com
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
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
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
@@ -5006,7 +5006,7 @@ static bool try_to_shrink_lruvec(struct
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

