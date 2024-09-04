Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04756F2E3
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423463; cv=none; b=GyAXyMihP5y6az93hARZQbBIEWp67v59heTocHBkrR/ZHGN/oHsJ2tg/uAF7RgVGwcGVt2D97U4wG4Atfq82cd6QmfpCmOvq5MSPQLO75S6aahy+jZmzk5jRT0Aovi3kcPHWN+6cWq1OqTNIq7y025neBZqWY9Q/oZ4X8Zi0eJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423463; c=relaxed/simple;
	bh=HwhZIJGMzI+Pr0yWDv45OFxo5vZvQ456OfA9AS/51Mg=;
	h=Date:To:From:Subject:Message-Id; b=Eclu/k0/9F8dRt1UrVE67mVt+s+V5rnFKWllJZS6wLi9RpEyALnwTQd5+84vUIl/gmbXhQS/xLS/DnciZxIjujbt8gfmzd/3koDPRnar6k/zRFbhMktOKC5UjmOMejmFYtxA9hZ+blk2IOLjjjm9PgQ/2y2y6YgMVI9Q2i1pqJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R9FQWfxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R9FQWfxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BF2C4CEC2;
	Wed,  4 Sep 2024 04:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423463;
	bh=HwhZIJGMzI+Pr0yWDv45OFxo5vZvQ456OfA9AS/51Mg=;
	h=Date:To:From:Subject:From;
	b=R9FQWfxhxDXjXmvbZiFefODFSYCbB8pEJIKAEqYhXlPk6O2NdSu+KNmg320wkcQiR
	 An9r5P6wEKMqolZlaK0YGIlXt5FJA/o/XieNPmnF89lEkvYik25gt+mt46z1kqIams
	 CwKPL/FBJpleoygZpkrltPZmvH+HomgO2PAFvsX8=
Date: Tue, 03 Sep 2024 21:17:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch removed from -mm tree
Message-Id: <20240904041743.94BF2C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: extend shmem_partial_swap_usage() to support large folio swap
has been removed from the -mm tree.  Its filename was
     mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: extend shmem_partial_swap_usage() to support large folio swap
Date: Mon, 12 Aug 2024 15:42:03 +0800

To support shmem large folio swapout in the following patches, using
xa_get_order() to get the order of the swap entry to calculate the swap
usage of shmem.

Link: https://lkml.kernel.org/r/60b130b9fc3e422bb91293a172c2113c85e9233a.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap
+++ a/mm/shmem.c
@@ -890,7 +890,7 @@ unsigned long shmem_partial_swap_usage(s
 		if (xas_retry(&xas, page))
 			continue;
 		if (xa_is_value(page))
-			swapped++;
+			swapped += 1 << xa_get_order(xas.xa, xas.xa_index);
 		if (xas.xa_index == max)
 			break;
 		if (need_resched()) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


