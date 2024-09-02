Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ABAB663
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238888; cv=none; b=eZlF87gquWKlWEGzX0v5ICF8D/ijuvyEp6s9MuFShxuehqpCTVs/wM2aF8e5yGiq7hJ5T8+RNe5UbDJoMbl68SMBod56utXmhePnUZSperHmdCoxiTd8WPPDbl2324VNFEAr0r8dBdECwnnqRB37gAfeXgkkQ4GrOthnruqupRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238888; c=relaxed/simple;
	bh=KCJ7p7WUK9CphauU6HjMoJ6WSy3w3Qf0x/x1F6Kl4RU=;
	h=Date:To:From:Subject:Message-Id; b=Mllatz6OySXeZw1U/OCyi5N8dcq2pC+y6iViTcLtA2oGBYYsEnqEkw0Bb41bPQUraGggb8vUWrDH4HVESaRTJrBfHEqWpPxuzMV74rU31l5D2Kjb+9a1WOqj1pxk3QyXx6BN9t4YOAm1xXdX6YtSmV/RXzCxJ3X7BQOtdF54BGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qpeVzq7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qpeVzq7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6CAC4CEC3;
	Mon,  2 Sep 2024 01:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238888;
	bh=KCJ7p7WUK9CphauU6HjMoJ6WSy3w3Qf0x/x1F6Kl4RU=;
	h=Date:To:From:Subject:From;
	b=qpeVzq7E/Y2R1SfH46BEm+BF7whW9pLfMrMLmofHVIkNSnlgR+Kb7528a5z6IGA3t
	 asPrsdbCNXvUYxs9wt5AA9ODmEuMJWRDXm49fFqws/eEahOwOmEth2/DUUCH4b/23I
	 eY9sjzA6rM0nqssRQnS1Ojqe1sm9WAII+PuSegVU=
Date: Sun, 01 Sep 2024 18:01:27 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-implement-vrealloc-fix-3.patch removed from -mm tree
Message-Id: <20240902010128.3E6CAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vrealloc: consider spare memory for __GFP_ZERO
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-implement-vrealloc-fix-3.patch

This patch was dropped because it was folded into mm-vmalloc-implement-vrealloc.patch

------------------------------------------------------
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: vrealloc: consider spare memory for __GFP_ZERO
Date: Tue, 30 Jul 2024 20:49:42 +0200

Zero spare memory when shrinking a buffer with __GFP_ZERO.

Link: https://lkml.kernel.org/r/20240730185049.6244-3-dakr@kernel.org
Fixes: 1f39ee9615a8 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-implement-vrealloc-fix-3
+++ a/mm/vmalloc.c
@@ -4073,12 +4073,15 @@ void *vrealloc_noprof(const void *p, siz
 		old_size = get_vm_area_size(vm);
 	}
 
+	/*
+	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
+	 * would be a good heuristic for when to shrink the vm_area?
+	 */
 	if (size <= old_size) {
-		/*
-		 * TODO: Shrink the vm_area, i.e. unmap and free unused pages.
-		 * What would be a good heuristic for when to shrink the
-		 * vm_area?
-		 */
+		/* Zero out spare memory. */
+		if (want_init_on_alloc(flags))
+			memset((void *)p + size, 0, old_size - size);
+
 		return (void *)p;
 	}
 
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix-4.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

