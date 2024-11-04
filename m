Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0766185B72
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696327; cv=none; b=ra8nrmqVpEOrW2mKw3B6dAoSaBwQAJ8VwNWmRAg2tsHI6MLdSonIwWN228FNWKVTw+5vsQZv7KuD8UerxUQ6ddvaj44YD3HywGY1LSstaGXim1Me0am5NXLFt2OYiyl3cOI2RKdavHJriFXIWV09qGqwPYaYQM+YosX3OKEw5B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696327; c=relaxed/simple;
	bh=G7PA2bCqnjo3Rvta4QGTxnZnAeptrm5A23coMeWpcYI=;
	h=Date:To:From:Subject:Message-Id; b=amHw3Kl1HU20zwSVs0oWKnXaAp4SLL/re+PC1jsTV8JGKoKX3RieZ27m1ulyADQHF58phUDQ13T2JX5YSTS+46MJfI4JpO6u2M6P27txj8ACd6euF3LJg48aYiqh9BjkPPO+DR5b+w84r51U/KRc46Q5jq/Brjwh9Fq3tNE3XNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0/sFLJhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0/sFLJhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95145C4CECE;
	Mon,  4 Nov 2024 04:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696327;
	bh=G7PA2bCqnjo3Rvta4QGTxnZnAeptrm5A23coMeWpcYI=;
	h=Date:To:From:Subject:From;
	b=0/sFLJhhtPBMRAMUIAGr7yvpcyP7FF/OGUalouR9YnzX/X5HpcjJ0gj7GJwVMF5Oe
	 pLzVcxJa/isVUTWdQMbWGIOCvBucIu5oi9/BfAgFabkKA7UTCJwliPS3AzwdJkp5sx
	 0S6RVo0kYh7U4KuNQ2zk8WfCe4h6F5p3MbrYOCSU=
Date: Sun, 03 Nov 2024 20:58:47 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch removed from -mm tree
Message-Id: <20241104045847.95145C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
has been removed from the -mm tree.  Its filename was
     memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch

This patch was dropped because it was folded into memcg-v1-no-need-for-memcg-locking-for-mglru.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-v1-no-need-for-memcg-locking-for-mglru-fix
Date: Fri Oct 25 06:28:06 PM PDT 2024

remove now-unused local:

mm/vmscan.c: In function 'walk_mm':
mm/vmscan.c:3652:28: error: unused variable 'memcg' [-Werror=unused-variable]
 3652 |         struct mem_cgroup *memcg = lruvec_memcg(lruvec);
      |                            ^~~~~
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmscan.c~memcg-v1-no-need-for-memcg-locking-for-mglru-fix
+++ a/mm/vmscan.c
@@ -3649,10 +3649,8 @@ static void walk_mm(struct mm_struct *mm
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-
 	int err;
 	struct lruvec *lruvec = walk->lruvec;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	walk->next_addr = FIRST_USER_ADDRESS;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

