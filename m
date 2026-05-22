Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177632D5436
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 01:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779414730; cv=none; b=XSzfeYwIBaiqSsqvbkTLLoWlF5GNKB1VTqjj2hBtyTisE3nzNktFqMggPjlEh/7JWSy453aLzs7KQ0CO3+blZgzo7q3Ou8dMpiw49a93VHMwLSKKzAU0/NO2E8nCx61pSMzt2qE2H8eHSbO+/drT/qRlC98chFR6wj/B4IO0j/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779414730; c=relaxed/simple;
	bh=8++9AckM6LMbUv8LnKi8SUYlU02xYO+XHJ9bzYNUcWw=;
	h=Date:To:From:Subject:Message-Id; b=cLXv6jc/SHR2t0mY2+czV4eyXKMNm2ez+ij2mRuFJ5WQNMW1jTqukLyZp4AGcPwSZd6Rwrrq+0zDbmegM0pNFZgjgbdTx0EeLQFE1Dop8B8tTwu0pkv2UaantjhCyC6uL+hdNIvMYkq+Jmz0wHphNBO0ewAAh1CRI6FP4MCsYGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AdE6yvYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AdE6yvYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA151F000E9;
	Fri, 22 May 2026 01:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779414728;
	bh=jEoW1PCha59V2Iq7nbaqanwPoUvtRPMhNiHAXColaJ0=;
	h=Date:To:From:Subject;
	b=AdE6yvYOCAlx8r5xlCaXR9XPJcTLhiIx8+gL0ASn6wN8Xp0TeYMc/QK7V6FeEQgBM
	 4h6GanHt78LjHzZhsu3f96bsFstHlg3IO/h17R9y7KRehen6l4NhNzwScelB9XaPvp
	 S2NNvdTI7BlsND3lcT+HbsqOlXY9QF7zHNzYjttU=
Date: Thu, 21 May 2026 18:52:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-merge-zeromap-into-swap-table-fix-2.patch added to mm-unstable branch
Message-Id: <20260522015208.AFA151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-merge-zeromap-into-swap-table-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-merge-zeromap-into-swap-table-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-merge-zeromap-into-swap-table-fix-2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch

