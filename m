Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FA2130495
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924787; cv=none; b=uVePnICryHVLIuS4AAG2HfFaXughyHJXFQjuziDxrL0aMrDzzbzgCBPHjKUokxViCuJjpO8pL6lUAcA1gvyD27QlUbanA5AeFticoUb+NuHHNNDVNRq1LuQRPk5DiO/zHU45/XF8ZObBndaQtoFKu+q/5/e73FOLrRERqsfKBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924787; c=relaxed/simple;
	bh=9gbI0BVekaCddbKMwXSSIUjA9e4mm/7Bl5JnuuYEmqc=;
	h=Date:To:From:Subject:Message-Id; b=GlhygjIS8537oBYDJ0pra5KM9Cewsyfno6XIDv7D5OeLuJRub6JPbv1DpFNYxkKO1I/W1gc/BMJKpQd/u4FUwOLIOqt8vk2cEbP1RZrEP+4eJiBfypIsw7C1wpNrlCuFuxO5vTL+U55/bkM5Aa9sbv6uhC6FJaIRvExLGGht6q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+Q/+LYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+Q/+LYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E42DC4CEC5;
	Mon,  9 Sep 2024 23:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924787;
	bh=9gbI0BVekaCddbKMwXSSIUjA9e4mm/7Bl5JnuuYEmqc=;
	h=Date:To:From:Subject:From;
	b=C+Q/+LYJFJ/YIIWbp9k1XY0vdQymx3zDf8vRXvmypa7EO1ZVtmfuzwNFwt8QTj4gH
	 urhdWlp3vxZz+jGq8+3GlGUJ6ZYQoNvDa7zV5yV5ie6vs1CNIlckHwrJtHsPmd3gde
	 /wvgjNsLF+X1QXK8u6Cdt40a16Nk6WlNhbDrp8us=
Date: Mon, 09 Sep 2024 16:33:06 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch removed from -mm tree
Message-Id: <20240909233307.4E42DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch

This patch was dropped because it was folded into mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix
Date: Tue Aug 27 07:16:26 PM PDT 2024

comment tweak, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix
+++ a/mm/shmem.c
@@ -685,7 +685,7 @@ next:
 		if (!folio || xa_is_value(folio))
 			goto drop;
 
-		/* No large page at the end of the file: nothing to split */
+		/* No large folio at the end of the file: nothing to split */
 		if (!folio_test_large(folio)) {
 			folio_put(folio);
 			goto drop;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch
mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch
mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

