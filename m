Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AEB2609FD
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 22:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779229612; cv=none; b=J39QCz2Km7JlkjPIXq5Eh8yAvwWvgiqTXfewlNn+Mi0I+r8E6crAk4GRPHBsttuypfbvja3i8cDZ4YmNYFkLvuZ/5eq/3wxOTbMKMqUgkklzC9Zc8ygDM1DuJvfkVAhuV364BBqQ7iMxJ56VK5ykdQmUilCDSJukX8QBm9APuxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779229612; c=relaxed/simple;
	bh=vNE4oAcrAvvOgxilIV46AO1vkkA0pOrE8s+XSdkDgZg=;
	h=Date:To:From:Subject:Message-Id; b=MZ6ASFHLAu9FhT5fs+nxQHvryKpUsEgE2wnEnRyWYJy4/vCIrKxSgcEp8dRQGDZpYVNMZRDx4fTwfrgtddBnWNGSZ1eyt3IBgc7RqBWXSOa1omxqr0lMUwK+nVjagOh3aNTX5hjpYa6EnTGQpv9LiUQ1H5viLhwUlXtv+PJIGdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wJz7AzR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wJz7AzR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46B11F00893;
	Tue, 19 May 2026 22:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779229610;
	bh=pUIPC2Jf4/6NTDxaZ2gJ+mw+52O7pvoFLrbVLP18dwI=;
	h=Date:To:From:Subject;
	b=wJz7AzR1fZE0By9pJunZdcleWhxLBDXnccLrR/OM8wtyq84C3R4TLJb8CLJ6X8oYU
	 SoXZQDB7mpHqP3pBLhL568K757Rgx5eSDv5O/2LZe2wqD79kl3Tt5Dzl1mWbOeVwKG
	 txMx5E+yoIHixV8pDzNmdoER9Kjm5LyS4Ms/c/RA=
Date: Tue, 19 May 2026 15:26:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,ljs@kernel.org,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch added to mm-new branch
Message-Id: <20260519222650.A46B11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch

