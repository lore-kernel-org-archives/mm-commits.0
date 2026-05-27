Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9821E32D6
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 04:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779857689; cv=none; b=jcMM/WWebJ8q3CnGxOG/j6i3K1BidOFm6IY8dGicFlf2UFxcLKiFOyMN8nc1lRsMNEhh7ZX38BD/nt/QchLVHeNsmMQ2xQolj9VdbFvBOVCCgKN09bpiaFHPdwjHh6tURjm3dk27Gd0erD/aYKj1Mr+kgUVO/ukfLGynHma0W3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779857689; c=relaxed/simple;
	bh=3WOdvVHs1dO8glHEu9GeVUhDpMkyNldKSrmuuH74s9Y=;
	h=Date:To:From:Subject:Message-Id; b=kM0D8sGjGKGxcRUKkivGO6ADrJg72Y6/+BcoQcNVjdJqgsYspFY61rJnru/ofpsBrcqjQTEShYgXnwM/mCd2/qVRIDCdtIPlcAL8mT1d+PY9DYAWBHr+/hG07sS32d5B5Tz9X8Nw0ETyfiQQjZJZx73PVTuN98jB6RUfZ5JYSA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SBEZ8bx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SBEZ8bx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD701F000E9;
	Wed, 27 May 2026 04:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779857686;
	bh=WdYpN0wO3QPjElvDtzQFOjMe6nPEFFX+FhSb6lvNeiI=;
	h=Date:To:From:Subject;
	b=SBEZ8bx2uCZGUz1/5UNsnAdLgjFtvX8MriGeADDIrNOX3wEIwg+tXZMSUJDYEzFuN
	 e+eB8DTvj+/nGVsQsSL7SeEmc+bnm8uQMO63+C2fXVW02q3KD6wgphPsfSsClRcs6G
	 PTAw95UjUYOj3nAwOhg/s0Sm39VWNuIDJRLnvpzY=
Date: Tue, 26 May 2026 21:54:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-merge-zeromap-into-swap-table-fix.patch removed from -mm tree
Message-Id: <20260527045446.BBD701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-merge-zeromap-into-swap-table-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-merge-zeromap-into-swap-table-fix.patch

This patch was dropped because it was folded into mm-swap-merge-zeromap-into-swap-table.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-merge-zeromap-into-swap-table-fix
Date: Mon May 18 06:15:39 PM PDT 2026

swap_cluster_alloc_table(): remove unused local `ret'

Cc: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-merge-zeromap-into-swap-table-fix
+++ a/mm/swapfile.c
@@ -450,7 +450,6 @@ static int swap_cluster_alloc_table(stru
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
-	int ret = 0;
 
 	/* The cluster must be empty and not on any list during allocation. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
mm-swap-merge-zeromap-into-swap-table.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

