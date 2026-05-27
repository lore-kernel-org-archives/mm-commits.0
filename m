Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FEE2139C9
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 04:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779857643; cv=none; b=Or8kFCbXmfGzbxcPpnyTBqdvvItOqktWcNWfUX9LihwUV4QvXCqEIbC2fPVtC0lpXgawic1Z2O/lzz9LTFJaBugw1l0+C5Wj3we100wTx8n63HD9qnaQlP1u8Eo+Tjv6q6WpmY/kIlC+l5iGSfZV2uTabypz3jUef3WKRbtKRBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779857643; c=relaxed/simple;
	bh=i5WDktvt4W4zJP1s2wlOOzjK4lo7T8JB5g27bnHzWEo=;
	h=Date:To:From:Subject:Message-Id; b=ufCWufTAw2lhjukqdW9AemmrSjX2LZ8y04Qo/j4Ob1qZW2iO+8NCRCkELHTSW3soUnc59MpX2g4InT4c4hHlpwI0jslUDfSeIrqEHK+KV5Qifg5Pk6E+mk7fGh3FU97/LO5O2/TEggZwJnqOjuFPFpp6CuMvWqGq+thMI/1ednQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0iLQyVWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0iLQyVWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606C31F000E9;
	Wed, 27 May 2026 04:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779857641;
	bh=rAiK6rGljxW/xNNOcvHbXAaLniut0VWgLFtrJG03DgU=;
	h=Date:To:From:Subject;
	b=0iLQyVWfa6PkS4LDk/tbG5BkwuhC1mTfBTTogx9Y8MZd4YITLAhmFQwX2dHDMKoAx
	 /6WveA+K4OFFMqmklHh1d7oB5wkgST3QqwUneLoHmy/dyOfV7pILjd8CqGMxq9QJgJ
	 vZoVclpj4NFAe0ZjNLGV6cnNOcWkKfMpOq7EE+jg=
Date: Tue, 26 May 2026 21:54:00 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch removed from -mm tree
Message-Id: <20260527045401.606C31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch

This patch was dropped because it was folded into mm-memcg-swap-store-cgroup-id-in-cluster-table-directly.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
Date: Tue May 19 03:23:38 PM PDT 2026

"fix" CONFIG_SWAP=n build

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

 mm/swap.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/swap.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
+++ a/mm/swap.h
@@ -482,5 +482,11 @@ static inline int swap_zeromap_batch(swp
 {
 	return 0;
 }
+
+static inline unsigned int swp_cluster_offset(swp_entry_t entry)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

