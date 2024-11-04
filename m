Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5798290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695913; cv=none; b=QKbZPi+QRprYKGzHTe7qk+OGE531yRnWTeZbTZNTNqBXDZWa2tpIVkKK94uCPOqOvJS6cR6IRvibpPin71bTak+UQfOmm0roTAMJhpDiU/ZAmMi7FFbB2GOeOqWZZ7Mq2OSAIXksqoacQDXDs3Gmj8SDoRiB0y9Esi2f6HJTQBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695913; c=relaxed/simple;
	bh=ser7XDHB0I+X6uN+i4+WbgaNjAPw7wdGq2RlAN21XRo=;
	h=Date:To:From:Subject:Message-Id; b=meiZBkaITLb4MM3RHqJeLyzoZ5l5SfnYBpMpDb/V0LoHDBt1bSV83eYLeBMoH9QTVZmvnXm8pG48fDc9wjuVNic4ELcsbHc6Z+Xk72jfJ9ddSFSXNyHVoFx/0twyiTDYZdm04R75MUilLn5AvfGjiRL4gJAVGhLFxV2miBx76UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EMqR7rjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EMqR7rjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCF7C4CECE;
	Mon,  4 Nov 2024 04:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695913;
	bh=ser7XDHB0I+X6uN+i4+WbgaNjAPw7wdGq2RlAN21XRo=;
	h=Date:To:From:Subject:From;
	b=EMqR7rjw7XTiT+gYUWeNxPhv6EbXtxTn3IRrus5kUjxN8oRmUsdvyMwi6Gx5qtXcV
	 Vw6CjCZJtnubZy+Ayu9QQwB+DQdxOqFOCG1Fb+vVjvyPZNvM8lkw6HlDnnIR1SffN5
	 bKwp+rYIsQ7my6mVflJxmhHfsCMaKlQRY/sZ/en4=
Date: Sun, 03 Nov 2024 20:51:52 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,ryan.roberts@arm.com,linmiaohe@huawei.com,keescook@chromium.org,jhubbard@nvidia.com,glider@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix.patch removed from -mm tree
Message-Id: <20241104045153.9FCF7C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
has been removed from the -mm tree.  Its filename was
     mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix.patch

This patch was dropped because it was folded into mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
Date: Tue, 22 Oct 2024 10:33:40 -0400

comment fixes, per David

Link: https://lkml.kernel.org/r/97DB52E1-C594-49B5-9736-89AC302FAB01@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++++
 mm/memory.c      |    7 +++++++
 2 files changed, 12 insertions(+)

--- a/mm/huge_memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
+++ a/mm/huge_memory.c
@@ -1165,6 +1165,11 @@ static struct folio *vma_alloc_anon_foli
 	}
 	folio_throttle_swaprate(folio, gfp);
 
+       /*
+	* When a folio is not zeroed during allocation (__GFP_ZERO not used),
+	* folio_zero_user() is used to make sure that the page corresponding
+	* to the faulting address will be hot in the cache after zeroing.
+	*/
 	if (!alloc_zeroed())
 		folio_zero_user(folio, addr);
 	/*
--- a/mm/memory.c~mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1-fix
+++ a/mm/memory.c
@@ -4726,6 +4726,13 @@ static struct folio *alloc_anon_folio(st
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
+			/*
+			 * When a folio is not zeroed during allocation
+			 * (__GFP_ZERO not used), folio_zero_user() is used
+			 * to make sure that the page corresponding to the
+			 * faulting address will be hot in the cache after
+			 * zeroing.
+			 */
 			if (!alloc_zeroed())
 				folio_zero_user(folio, vmf->address);
 			return folio;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-avoid-zeroing-user-movable-page-twice-with-init_on_alloc=1.patch

