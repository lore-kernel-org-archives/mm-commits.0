Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8213C2F3C26
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 04:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779857692; cv=none; b=YdTh9Dn9FnepADP8+0HEgvTPJkiC+GWXZmwBImMK4Mqib013w92N8cYZz6fmpHnckuuVlPBHHMg6/z5IhdqlFZ5GNfRC/VrkoRchuyh7CLqIiHZLoAt1CDd0J668w9RqsV68+JkGoGGfGzelkjh3Q4rL3S76iL3GxGCsf3i3wuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779857692; c=relaxed/simple;
	bh=JVsp6Sivg3cLIoWsP8F6u04BUrx985C37ndyYCNQzfI=;
	h=Date:To:From:Subject:Message-Id; b=pMB7a7GA9kEgT5KP2R2w1QflQUrvdEEKnf+/HzUSk6+6VKJYTYw5BXtZWZhNbyX9KlWR4vU6C+iZDXt+2lvwYrBe9wNOlxSHzFNFglu4niL+ZQ6+gg9viNFXXvSVd2KaReiPwzXLsZAg4h1nGW7W8jH/gxROag5WMVWGCbujdZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Or5c4kn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Or5c4kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5FC1F000E9;
	Wed, 27 May 2026 04:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779857691;
	bh=nwLmls+b1pHLJnwFNyRlxj9Gm3aoS/f++Lk2Qyw04O8=;
	h=Date:To:From:Subject;
	b=0Or5c4knkavuBO580OsFeKMN+cFE5hK3T7MaljdK2UgTPt/Ni/ol+IdKTFhDnmIwA
	 NKRghYZ1gUisZw7Jhl9hCvxPDaFA8Xnhqpj0uAE632ReRf58NddtTXOjO3oohaDXk1
	 F67Tno8TcFGAJbJCdHTO0NrKLCBOnuhwQwWPe2gQ=
Date: Tue, 26 May 2026 21:54:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-merge-zeromap-into-swap-table-fix-2.patch removed from -mm tree
Message-Id: <20260527045451.1D5FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-merge-zeromap-into-swap-table-fix-2
has been removed from the -mm tree.  Its filename was
     mm-swap-merge-zeromap-into-swap-table-fix-2.patch

This patch was dropped because it was folded into mm-swap-merge-zeromap-into-swap-table.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-merge-zeromap-into-swap-table-fix-2
Date: Thu May 21 06:39:20 PM PDT 2026

mm/swapfile.c: In function 'swap_cluster_alloc_table':
mm/swapfile.c:488:1: warning: label 'err_free' defined but not used [-Wunused-label]
  488 | err_free:
      | ^~~~~~~~

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/swapfile.c~mm-swap-merge-zeromap-into-swap-table-fix-2
+++ a/mm/swapfile.c
@@ -472,22 +472,22 @@ static int swap_cluster_alloc_table(stru
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
-		if (!ci->memcg_table)
-			goto err_free;
+		if (!ci->memcg_table) {
+			swap_cluster_free_table(ci);
+			return -ENOMEM;
+		}
 	}
 #endif
 
 #if !SWAP_TABLE_HAS_ZEROFLAG
 	VM_WARN_ON_ONCE(ci->zero_bitmap);
 	ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
-	if (!ci->zero_bitmap)
-		goto err_free;
+	if (!ci->zero_bitmap) {
+		swap_cluster_free_table(ci);
+		return -ENOMEM;
+	}
 #endif
 	return 0;
-
-err_free:
-	swap_cluster_free_table(ci);
-	return -ENOMEM;
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
mm-swap-merge-zeromap-into-swap-table.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

