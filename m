Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B0A187FE4
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 04:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273356; cv=none; b=bceiMbadLdEIVEoDnqsVsPvlFmIIT6gb/Xhd9aP740jLm2TLR0ETewXyhV1QP6vhXcntZ3mWXMZtMTPwUL/qny/b11kvTFvOyVum6GmPxIwEtUotbU48pGis8eZFO0dwKVCOdbAqIom73HGYlO5lDGzKFRsASMILKIynbJWrkuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273356; c=relaxed/simple;
	bh=HTIV1l/gOPPQvdAxrvXYeyQIJaDq56jmxns01fE+IKg=;
	h=Date:To:From:Subject:Message-Id; b=OBOvGwpRQPGuEMYOHvxeop0vtJHAxSF/YaICcKH90DstmCAHCTuNBYtGpt05to7W35v8XnDUNn8KknEVblYzKcsLc3nzK3baIw1h1ciArw+BoN0MyRy/8QCUi7LB3L3q9poRHeWG/fnadiwD8vFExkga0oV07o4TjKWOFdtmsPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=svE1vHZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="svE1vHZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6377BC4CEDD;
	Tue, 18 Mar 2025 04:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742273355;
	bh=HTIV1l/gOPPQvdAxrvXYeyQIJaDq56jmxns01fE+IKg=;
	h=Date:To:From:Subject:From;
	b=svE1vHZr9Lf9rOnsBJ9okkyKc1kLwFRn5eU3K7X5LGJKK5ODG5pMu/F45ir2P1sRe
	 DP86MPg6ZyGBwqYhnf19Q1JDNHAjPzJKFU2cjziODREGZLte86Ex3ca+IufA9Kptkb
	 /dWkT+nYB0GlmscZTlsw52nQM7e+aN1TzGm9cObs=
Date: Mon, 17 Mar 2025 21:49:14 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch removed from -mm tree
Message-Id: <20250318044915.6377BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: use NULL instead of 0 for folio->private assignment
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch

This patch was dropped because it was folded into mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: use NULL instead of 0 for folio->private assignment
Date: Thu, 13 Mar 2025 10:04:20 -0400

It makes sparse happy.

Link: https://lkml.kernel.org/r/1E11B9DD-3A87-4C9C-8FB4-E1324FB6A21A@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503131109.s7iuWfGq-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2
+++ a/mm/huge_memory.c
@@ -3584,7 +3584,7 @@ static void __split_folio_to_order(struc
 		 */
 		if (unlikely(new_folio->private)) {
 			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = 0;
+			new_folio->private = NULL;
 		}
 
 		if (folio_test_swapcache(folio))
_

Patches currently in -mm which might be from ziy@nvidia.com are

xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

