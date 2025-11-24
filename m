Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCACC343D91
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023638; cv=none; b=SMUJWzcDysaGclwb43mzVEiizER0U/56MZ9FMOv3142NkYbvaT1ysbw8tzKiY4S+S22IsqZHJMKg6UUhbrJyn+M9sQaabFoircHAyMP+Ox+70FRb7IOiY0yChuvXJ/0xWmY26La4fyrR8Mz4nyCtUKdHPXdz3t4tUK7hcv86+bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023638; c=relaxed/simple;
	bh=7hCvAkSNSnVXw2ng7k4Vp9ieYfS2G+atQFiyuEwMRs0=;
	h=Date:To:From:Subject:Message-Id; b=H757BLnl1ykcB+YACRwUTlZ+NLpBvZjgNPjhJaHlF1q7RpwrheDRcS4e1kgZ/COndVUQg/U049z+GhM+GzrYeyBGjYIUipiV5t010/gnAlTnmObrAnrjAqqJs/BdZncuKPPqTMNtUXd/bz5oZVQhPHTeWWED4SCJ7DXRn9044lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HEltMee4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HEltMee4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A373FC4CEF1;
	Mon, 24 Nov 2025 22:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023636;
	bh=7hCvAkSNSnVXw2ng7k4Vp9ieYfS2G+atQFiyuEwMRs0=;
	h=Date:To:From:Subject:From;
	b=HEltMee4j2mZe4tptHmXASrkqhCNoeYzculabUCU4KudUvcmFEhBzjg9rqj9bStog
	 ckcuqppJNXLThAEO0hRI9RHj+Lv7ikkfoyuTNwCkZJPzL5p2iAFOBkSbODoa92nyBE
	 kzvSlJJNAavlDySDc3P5A14BYT94MWXid0u2zbm0=
Date: Mon, 24 Nov 2025 14:33:56 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch removed from -mm tree
Message-Id: <20251124223356.A373FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2.patch

This patch was dropped because it was folded into mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2
Date: Wed, 5 Nov 2025 11:01:09 -0500

add newline to fix an error and a warning from docutils

Documentation/core-api/mm-api:134: mm/huge_memory.c:3593: ERROR: Unexpected indentation. [docutils]
Documentation/core-api/mm-api:134: mm/huge_memory.c:3595: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]

Link: https://lkml.kernel.org/r/040B38C0-23C6-4AEA-B069-69AE6DAA828B@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/huge_memory.c~mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related-fix-2
+++ a/mm/huge_memory.c
@@ -3516,6 +3516,7 @@ static void __split_folio_to_order(struc
  *    uniform_split is false.
  *
  * The high level flow for these two methods are:
+ *
  * 1. uniform split: @xas is split with no expectation of failure and a single
  *    __split_folio_to_order() is called to split the @folio into @new_order
  *    along with stats update.
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch
mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

