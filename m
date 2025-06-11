Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B60619A
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607064; cv=none; b=ZXZQ9FTR1Ki6fKvk0+xM1KD3Y1vzXHQENKWkYjGFPOGjFU5NsolBvspGq5OU3vWsGjiDa7H4caf5jsXLESCdaVON41kMSj/lAAU+iKo7aDN5+qmRii22YTQdRn0lmNKWVUG1V6AK/DbiVTghvhFQXVaEfg71EM3J7dbyY+VWXzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607064; c=relaxed/simple;
	bh=qn0J5DqZTFHcrSbL+F+wJOlzNGhu++mz9CE1jfYhvXw=;
	h=Date:To:From:Subject:Message-Id; b=R7XiOV2HWeOtojO5588dzwAwk3agkLjXXro2eRmnSTB5MHU3f+y0bKjoKL3hAZzF+iX4xy+jVXQO2tSNv0odbUH9H/tJCII/ZJzsMKtEF+6fWimlsnZiFd3cjp4B63rQ1omQpD1dGh0fTA3IH4D6mUq5NaPTVXUomzepcyVAj/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W9ladZ/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W9ladZ/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A16FC4CEED;
	Wed, 11 Jun 2025 01:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607062;
	bh=qn0J5DqZTFHcrSbL+F+wJOlzNGhu++mz9CE1jfYhvXw=;
	h=Date:To:From:Subject:From;
	b=W9ladZ/HlMPFucsNPqZ2/k7v16Q1fueXH0c6sBRv9/kQbPsX30yzMHGbECaD13xes
	 FfUuIBch7X7YtzebNV3KVQ0t2npgf+1Zpwa/qsccZFhuJpIa/nIQs5QdjrTXQWkRq3
	 vOoMmngcBf6J2tLt2dDrWv2Y59YGrU5NO7Q2T0aM=
Date: Tue, 10 Jun 2025 18:57:41 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,igor.b@beldev.am,hannes@cmpxchg.org,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-zblock-allocator-fix-2-fix.patch removed from -mm tree
Message-Id: <20250611015742.8A16FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-zblock-allocator-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-add-zblock-allocator-fix-2-fix.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-zblock-allocator-fix-2-fix
Date: Mon May 19 07:37:22 PM PDT 2025

try_alloc_pages() was renamed

Cc: David Hildenbrand <david@redhat.com>
Cc: Igor Belousov <igor.b@beldev.am>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-add-zblock-allocator-fix-2-fix
+++ a/mm/page_alloc.c
@@ -7403,4 +7403,4 @@ struct page *alloc_pages_nolock_noprof(i
 	kmsan_alloc_page(page, order, alloc_gfp);
 	return page;
 }
-EXPORT_SYMBOL_GPL(try_alloc_pages_noprof);
+EXPORT_SYMBOL_GPL(alloc_pages_nolock_noprof);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch
mm-add-zblock-allocator.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

