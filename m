Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78F85A0F5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423077; cv=none; b=e1m9MH5adBbFcTNFzm5puq8qZ34cPRlgHbhr+qG5ayXemmIqF0YHMVhT1ZK0zIKjO/gDdrKRpYJ17rYBftz07UDZe0vLBoqdaYwFaObykq/vikQPnfMAS0ECxulPXoTwesyKhTLJGhrOuZ8z1kstGTElHLmBVvecP0UgQOaq5iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423077; c=relaxed/simple;
	bh=13Dt+xhOOtUpDt7x/cT4ZN9mZ4B2xHEsYoTZ83tC8OU=;
	h=Date:To:From:Subject:Message-Id; b=ePhlxpSXmCorKrjnFGLhqQbR8ZczD+aSTHcrUhhZfA8nh3u1dfwviUp5Vesuw/OvtZRk1jF+L5yQjjhvPsdFaldxap0KM2jZXkxlBtVSRkNrScBCKHh+8rhp+enJED0OXZPrNy/ThCR+EpiEcNMxZIraniqDlVoQrF/eL/uvDHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aRB9/qjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aRB9/qjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28125C4CEC2;
	Wed,  4 Sep 2024 04:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423077;
	bh=13Dt+xhOOtUpDt7x/cT4ZN9mZ4B2xHEsYoTZ83tC8OU=;
	h=Date:To:From:Subject:From;
	b=aRB9/qjoo1GD6pXsLuWxykvK6Ah7/VhaRUFHimdbWNyI6hJUjip6c4rFGE32Jj7Xv
	 UImbSQvuXbBQzM9kSqHFKClwRA9e3dSnfPBxpJG/7mAztutQu07j5aDcu0sgCstmaX
	 lzTiM0cmFhH2dKeqoySipzI8pBrf8m+ZpFVEZkAo=
Date: Tue, 03 Sep 2024 21:11:16 -0700
To: mm-commits@vger.kernel.org,linmiaohe@huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-add-unmap_poisoned_folio-fix.patch removed from -mm tree
Message-Id: <20240904041117.28125C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-add-unmap_poisoned_folio-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-unmap_poisoned_folio-fix.patch

This patch was dropped because it was folded into mm-memory-failure-add-unmap_poisoned_folio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-add-unmap_poisoned_folio-fix
Date: Sun Sep  1 04:48:53 PM PDT 2024

whitespace tweak, per Miaohe Lin

Link: https://lkml.kernel.org/r/1f80c7e3-c30d-1ac1-6a36-d1a5f5907f7c@huawei.com
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-memory-failure-add-unmap_poisoned_folio-fix
+++ a/mm/memory-failure.c
@@ -1558,6 +1558,7 @@ void unmap_poisoned_folio(struct folio *
 {
 	if (folio_test_hugetlb(folio) && !folio_test_anon(folio)) {
 		struct address_space *mapping;
+
 		/*
 		 * For hugetlb folios in shared mappings, try_to_unmap
 		 * could potentially call huge_pmd_unshare.  Because of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-add-unmap_poisoned_folio.patch
mm-count-the-number-of-anonymous-thps-per-size-fix.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch

