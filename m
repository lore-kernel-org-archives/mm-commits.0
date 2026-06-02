Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F9C3C3792
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439184; cv=none; b=Lbf7enBXBHFqnoxclHDv54k5exFD3Zcfjps+PfTLyecdwPX3p8HBHG0siIDgj1nbQomVC+wRP8I1XPi7zliwIKCyYPqLZ/JoUSnagozy3R3HOjGiCSyQ5Qba2AGet6mZr8hA1SwHNqeiCWkKggnJvGLIo7K7cZhMFAD2FQgwqUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439184; c=relaxed/simple;
	bh=YHCwexpL/sHmdcyPG4aou+TJNeL1Uv3iqR3q0tYj8bo=;
	h=Date:To:From:Subject:Message-Id; b=tDy9P3vlxPZylM9G3Y4XHF4XD3kIB9kyBNITph3QFGjKSXcbLKcqZkWZKNM/rYs6ePtsfTO/90odcW9OzZ4OSpr95tRswwLkZ7rDjBpJTm9VlyaCc35aSrc5RWzGaNg/NDtK7pV7aweovl8k+fZ7CrEIqW3yb5cEG5AzraRpCjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vWhSyQnu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vWhSyQnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620AE1F00893;
	Tue,  2 Jun 2026 22:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439183;
	bh=C02DbQm+aBzTIzQKpQKpnSWfMdT7OPDDG/Hb6m/EmI4=;
	h=Date:To:From:Subject;
	b=vWhSyQnuM1oRgJgPU/S66kI/dbyTM/A5Bnr18b/KtaMAcsFyEFhDbYCOsZwTISJMS
	 Fq5QD0p3cJkMsJI40bUBXkllQGQS3oWqOVUXvVRNJ3yY+UQjUJv5GcPUngMNR7VZRn
	 Qe+xzzRufk+1ILhjjgV5D3pr7Ri3PColn+6NbxYc=
Date: Tue, 02 Jun 2026 15:26:22 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-use-a-smaller-batch-for-reclaim.patch removed from -mm tree
Message-Id: <20260602222623.620AE1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: use a smaller batch for reclaim
has been removed from the -mm tree.  Its filename was
     mm-mglru-use-a-smaller-batch-for-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5011,7 +5011,7 @@ static bool try_to_shrink_lruvec(struct
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
_

Patches currently in -mm which might be from kasong@tencent.com are


