Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277C01804A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246646; cv=none; b=Kqxul9cff8RZh49hJqb8UeAxPU8n1DCHe1ssnwqUwO38xDFa1jirV6DCy4MNT3sy1bH284KARCMOt9Us11uf7ql1n4quxaOcn2YlicODirF7dyNOzCkHVMi9on4MOMh3p0BAR/o203KKj2qosIMjxobtcyM0sW+paNeIAS4ImDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246646; c=relaxed/simple;
	bh=kq9QW8cSF4S/b19mwkxXikIwIYAV6CQwGMtqsNmE5MQ=;
	h=Date:To:From:Subject:Message-Id; b=Ri2GSL1bM991CK32A8JvxIy8fNMgBLgDFkj4GHdKKG+PlRpXeFdXEnay25kvkeNQajnJvrkTX4gyl0ygLwigYfea0GuST73jyOU9Kg8pjG099NcmMXAF8/dkcJY5Jfme73kWDZArzFbqG889/ZuIaHxGWbphNoiWHyhYJ74o5AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=szHxdRG9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="szHxdRG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E193C4CEC3;
	Mon,  2 Sep 2024 03:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246645;
	bh=kq9QW8cSF4S/b19mwkxXikIwIYAV6CQwGMtqsNmE5MQ=;
	h=Date:To:From:Subject:From;
	b=szHxdRG9BkrsbqSNrJhPxUfIuqxzmeL2OKSYW5tQlIJcYYtvhYZ9InVtb0H/4JlyN
	 RCwcWSQaC106rnA3q20IyFokBpBtPwsg4YZVCj4cBS82D8sPgiesBbfEifRsWFGe9O
	 yU+7vYzbOQkZC7W2qm5H8DCk8FjHq1FRpb0b7eAM=
Date: Sun, 01 Sep 2024 20:10:44 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch removed from -mm tree
Message-Id: <20240902031045.8E193C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: clarify swap_count_continued and improve readability for  __swap_duplicate
has been removed from the -mm tree.  Its filename was
     mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch

This patch was dropped because it was folded into mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: clarify swap_count_continued and improve readability for  __swap_duplicate
Date: Fri, 2 Aug 2024 17:52:43 +1200

When usage=1 and swapcount is very large, the situation can become quite
complex.  The first entry might succeed with swap_count_continued(), but
the second entry may require extending to an additional continued page. 
Rolling back these changes can be extremely challenging.  Therefore,
anyone using usage==1 for batched __swap_duplicate() operations should
proceed with caution.

Additionally, we have moved swap_count_continued() to the second iteration
to enhance readability, as this function may modify data.

Link: https://lkml.kernel.org/r/20240802071817.47081-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/mm/swapfile.c~mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix
+++ a/mm/swapfile.c
@@ -3386,6 +3386,7 @@ static int __swap_duplicate(swp_entry_t
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
+	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = lock_cluster_or_swap_info(p, offset);
 
 	err = 0;
@@ -3404,27 +3405,14 @@ static int __swap_duplicate(swp_entry_t
 		has_cache = count & SWAP_HAS_CACHE;
 		count &= ~SWAP_HAS_CACHE;
 
-		if (usage == SWAP_HAS_CACHE) {
-			/* set SWAP_HAS_CACHE if there is no cache and entry is used */
-			if (!has_cache && count)
-				continue;
-			else if (has_cache)		/* someone else added cache */
+		if (!count && !has_cache) {
+			err = -ENOENT;
+		} else if (usage == SWAP_HAS_CACHE) {
+			if (has_cache)
 				err = -EEXIST;
-			else				/* no users remaining */
-				err = -ENOENT;
-
-		} else if (count || has_cache) {
-
-			if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
-				continue;
-			else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX)
-				err = -EINVAL;
-			else if (swap_count_continued(p, offset + i, count))
-				continue;
-			else
-				err = -ENOMEM;
-		} else
-			err = -ENOENT;			/* unused swap entry */
+		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
+			err = -EINVAL;
+		}
 
 		if (err)
 			goto unlock_out;
@@ -3439,8 +3427,16 @@ static int __swap_duplicate(swp_entry_t
 			has_cache = SWAP_HAS_CACHE;
 		else if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
 			count += usage;
-		else
+		else if (swap_count_continued(p, offset + i, count))
 			count = COUNT_CONTINUED;
+		else {
+			/*
+			 * Don't need to rollback changes, because if
+			 * usage == 1, there must be nr == 1.
+			 */
+			err = -ENOMEM;
+			goto unlock_out;
+		}
 
 		WRITE_ONCE(p->swap_map[offset + i], count | has_cache);
 	}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch

