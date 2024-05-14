Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C620D181BB3
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 22:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715724119; cv=none; b=Pj9jyHso45rQJVxwITHMcWFhfkgpECzLqw2mTcj79AJ8BSibhNFi6ae3mo1nLuPrmcathLlYGU+fYW8JpWlOsM/bxaa8vUB8zWMh09U8ugLEi4VvAUxRbQkNfz5IWQEC1BKl3MZgUgpBpplVFvv4zR+frYx9wMqYXeTKRbWjWuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715724119; c=relaxed/simple;
	bh=cbEErQDy15mh620/bUbi5vhRYjtNrgq8NmStnEEqpfI=;
	h=Date:To:From:Subject:Message-Id; b=Ce3FWJvhB6HHAQg2HbMl/Ynm2sTxBZuLZcFh/tukYb9nsr5Y9N/Xl6JgocC5u4bgYiqM6zDjmjFTXe5TUAjtJKU9ImjQyZXhg3ODSwwsFyT7Cvh70qPEmszfiVDVlTq6Xggclf72hcm4FWdUYunJJ+NZPhXPyfpK3NcpD8konXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zZE6HWdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zZE6HWdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72362C32782;
	Tue, 14 May 2024 22:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715724119;
	bh=cbEErQDy15mh620/bUbi5vhRYjtNrgq8NmStnEEqpfI=;
	h=Date:To:From:Subject:From;
	b=zZE6HWdbKyQGlI+3VHKLmJvdTw0BHlz3JpzKiWXQyF4YkrjYfslbQbUIAK1OU21JP
	 RG1ifpkqS/Gf1FqRHFsWewbomKNVKGaX4UgGcvhJsAEoD8bdwcauOOqoIN/nVwH2UG
	 bX0wEHqA9mpgprMDntcraHob0U5AoEQEbos7o0BU=
Date: Tue, 14 May 2024 15:01:58 -0700
To: mm-commits@vger.kernel.org,xuyu@linux.alibaba.com,willy@infradead.org,shy828301@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-huge_memory-mark-huge_zero_page-reserved-fix.patch removed from -mm tree
Message-Id: <20240514220159.72362C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-mark-huge_zero_page-reserved-fix.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix
Date: Tue May 14 01:53:37 PM PDT 2024

Update it for 5691753d73a2 ("mm: convert huge_zero_page to huge_zero_folio")

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-mark-huge_zero_page-reserved-fix
+++ a/mm/huge_memory.c
@@ -212,7 +212,7 @@ retry:
 		folio_put(zero_folio);
 		goto retry;
 	}
-	__SetPageReserved(zero_page);
+	__folio_clear_reserved(zero_folio);
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
 	/* We take additional reference here. It will be put back by shrinker */
@@ -265,7 +265,7 @@ static unsigned long shrink_huge_zero_pa
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
 		BUG_ON(zero_folio == NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
-		__ClearPageReserved(zero_page);
+		__folio_clear_reserved(zero_folio);
 		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memory-mark-huge_zero_page-reserved-fix-fix.patch
lib-add-version-into-proc-allocinfo-output-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

