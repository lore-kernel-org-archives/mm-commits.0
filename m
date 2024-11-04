Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCCD4C6C
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695028; cv=none; b=YTCk4maki8DOv8dfvqdS4irISDuwnp2siZD8CyNlMmea0kLcgWnU4xPdhsxU4j6FwLYwJc8wCNYBA1YeQ3WT2QDA7Q4OkgItG6xLIKxAKTj3fddf7z9VNQgTbOyFq0iz+bMobhXImyAtMB1QCIhsUozponQkPCGe3HF3ACNKJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695028; c=relaxed/simple;
	bh=pcCs1DbIymiCQjaHLIgHxKjOuSAXMPoIRDSu9hbieFw=;
	h=Date:To:From:Subject:Message-Id; b=b2bA3dv2hleVzOvbZe/prTs58jU6agrRZSONIDoukJjqbxTRM8Qhbb5G03BvHMqxSIYFfkPiz4oDSAC/zHjKKoLlN3/YEfXREneADUneXPRBLteikp660Ldzh75xZbvTxfvIgNcV93Z3yNJLmQYkUnUafMMGb32eqXHix6C9tzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PlLzaRaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlLzaRaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5466CC4CECE;
	Mon,  4 Nov 2024 04:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695028;
	bh=pcCs1DbIymiCQjaHLIgHxKjOuSAXMPoIRDSu9hbieFw=;
	h=Date:To:From:Subject:From;
	b=PlLzaRaDAfhFmnstYJsenNiB2veFC3pay6obTQHZRTriQJUI9xhS12HQnuMXpbNd/
	 Z2DwcTn6+39adHbGaAIUeMyMyCaAtxadV5FYQqZrZR3uw5KQjiqPBxfWx1me2BjIWD
	 8ofROObVtQ9YrC5ak73c/uY8IQvH4eDwmoRfuTH4=
Date: Sun, 03 Nov 2024 20:37:07 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,zhengqi.arch@bytedance.com,willy@infradead.org,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,longman@redhat.com,kasong@tencent.com,hannes@cmpxchg.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch removed from -mm tree
Message-Id: <20241104043708.5466CC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
has been removed from the -mm tree.  Its filename was
     mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch

This patch was dropped because it was folded into mm-list_lru-split-the-lock-to-per-cgroup-scope.patch

------------------------------------------------------
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
Date: Mon, 28 Oct 2024 01:26:30 +0800

Thanks for the report. I converted list_lru_walk callback to keep the
list unlocked when LRU_RETRY and LRU_REMOVED_RETRY is returned, but
didn't notice shrink_memcg_cg in zswap.c could return LRU_STOP after
it unlocked the list.

Link: https://lkml.kernel.org/r/CAMgjq7D_OA=vYf5SnNnKXjppPFhDqsbYF--6=cOayKiadxuwrQ@mail.gmail.com
Signed-off-by: Kairui Song <ryncsn@gmail.com>
Reported-by: Usama Arif <usamaarif642@gmail.com>
Closes: https://lkml.kernel.org/r/7334b158-8567-4c66-8176-57b879ff8882@gmail.com
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/list_lru.c~mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
+++ a/mm/list_lru.c
@@ -298,9 +298,9 @@ restart:
 		ret = isolate(item, l, &l->lock, cb_arg);
 		switch (ret) {
 		/*
-		 * LRU_RETRY and LRU_REMOVED_RETRY will drop the lru lock,
-		 * the list traversal will be invalid and have to restart from
-		 * scratch.
+		 * LRU_RETRY, LRU_REMOVED_RETRY and LRU_STOP will drop the lru
+		 * lock, the list traversal will be invalid and have to restart
+		 * from scratch.
 		 */
 		case LRU_RETRY:
 			goto restart;
@@ -318,14 +318,13 @@ restart:
 		case LRU_SKIP:
 			break;
 		case LRU_STOP:
-			assert_spin_locked(&l->lock);
 			goto out;
 		default:
 			BUG();
 		}
 	}
-out:
 	unlock_list_lru(l, irq_off);
+out:
 	return isolated;
 }
 
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-list_lru-split-the-lock-to-per-cgroup-scope.patch

