Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923AC1917C2
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118343; cv=none; b=NiCgMyWq5fA31GzQVBLXjkEMupnRmCdgjcv0PO40dTeX0DgdLyLLFVO6lC4YE6VR34xeQg8m0ORi8p18TX34LGgwihBSq9PLawYN/pGOaAy33DPzBRdaP/TqxcLcvjRHvdwvUZna8WDk4z9sZZ9kunj4oYNAKr+MgKgd5Z34y0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118343; c=relaxed/simple;
	bh=ZvDmvrh/GJO1Ty9Kn/Wh80yzz/+QtfkRzPkt5shOIFg=;
	h=Date:To:From:Subject:Message-Id; b=rwuglPjJGfwIBl+r9GZfn5YF0zHtGiTAOixz3Q8ViFhkYDND5NYGJ44pR92HHzEh05VGADWbkP8ucO9VqzUBKpnnWvi2fUSLgnvfMB09gDRsrkyU7O7WQpyURbRKJ+t24pWdpkB3rbuvz7LFNNPGt2v2aoFd5acTFhr9LI1YmFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NMnSVm+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NMnSVm+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A8CC4CEE4;
	Tue, 13 May 2025 06:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118343;
	bh=ZvDmvrh/GJO1Ty9Kn/Wh80yzz/+QtfkRzPkt5shOIFg=;
	h=Date:To:From:Subject:From;
	b=NMnSVm+BuaZlgS817Nuw0bR/QlsSKtc0XSNlfBJupQc4VuO7jDiR5G660BF8c2qDP
	 XQWkqrAVdgKVzGFSxEBsPgUF5OTXRDocUXq7vVkjwipaGA7klTr8XxMH9skSAu4bHb
	 Ldf82+Ils2Sl3tZ5TIXsPdexawqhvx/CzYaAR/ps=
Date: Mon, 12 May 2025 23:39:02 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hezhongkun.hzk@bytedance.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch removed from -mm tree
Message-Id: <20250513063903.01A8CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix
has been removed from the -mm tree.  Its filename was
     mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix.patch

This patch was dropped because it was folded into mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix
Date: Wed May  7 06:27:25 PM PDT 2025

tweak coding style

Cc: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only-update-fix
+++ a/mm/vmscan.c
@@ -5606,9 +5606,9 @@ static ssize_t lru_gen_seq_write(struct
 			break;
 		}
 
-		if (n == 4)
+		if (n == 4) {
 			swappiness = -1;
-		else if (!strcmp("max", swap_string)) {
+		} else if (!strcmp("max", swap_string)) {
 			/* set by userspace for anonymous memory only */
 			swappiness = SWAPPINESS_ANON_ONLY;
 		} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
jfs-implement-migrate_folio-for-jfs_metapage_aops-fix-2.patch
mm-hugetlbc-__unmap_hugepage_range-comment-cleanup.patch
mm-establish-mm-vma_execc-for-shared-exec-mm-vma-functionality-fix.patch
mm-perform-vma-allocation-freeing-duplication-in-mm-fix.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios-fix.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

