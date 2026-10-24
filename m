Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792830336;
	b=Xr2+Vbmiq8g1kxsZK3ksnS40uSAnLg879YIc1pDclP4LVLycOrBcNtq3cTvugzLT3YOS
	 QyeOpZnKb0DjYk6WLL7Rjybv6NQUpGU/qoPG8L2t+O8zfwPQq5ESJAdoOr+xlkRJY7VN6
	 cEUot1rX4e+wkol3rQvJrWGwEYbjCu3Qt3CKMgBTqGxSeqN+hesKTmnUqcwtpDvYDi2wA
	 b5DvyzA85TOs9QDoS2apcAd+hctsx9OdKPOBnYsMv9DdD7i7V95p0S/qmgJgn0vNEJs18
	 fc9UyNHYiK+zDgdq1OMfLIwb6ImRsWH5R4dpoycEAO7Qt8cl5YqgXZQcj6ELo8g7Lcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792830336;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=r9HeNAhstyT/VfTIfMD1l5PLoI+ZzRHjbFEaQc/3zus=;
	b=5SzTjtUNYTvj8hl06OJ9gqlCMunaRWKAgIKwdhHcfG9osmpjamh0r11cL9xWp7kiFx3w
	 GPmPHLLmloqH9mw7gTHIMyiCV+KYQfE4QA0Pk5q4FkLpdoRBqtT8FoFhu+nXj6vbkuINv
	 ZXjkeHnUnKGWlAlXVmJddPKgGj9uDJNYMG4dwxxfkCjLFIcHwg4oAjyHb5H01V5190uLO
	 Ap3vAVnozMmb/qdC+8ei33jIyC5DAhi0ehqzP/tiNW0q6Hk0nQTckxg7jxsCgTgqaYzGs
	 HBj+Fn8pAO9FyBipZGyeIHbv83UvIajuQSkGVAd7VAt7Ucx8CU9atL8fQAeDgA1idww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BIxZbOfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA058606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BIxZbOfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACFB1F01825;
	Sat, 24 Oct 2026 08:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792830335;
	bh=r9HeNAhstyT/VfTIfMD1l5PLoI+ZzRHjbFEaQc/3zus=;
	h=Date:To:From:Subject;
	b=BIxZbOfNrCkw6byNmBLjX8CTCUZ2LzkcWK6KRiRY1ZifXgYcuKnNG4HsYrsMm8Xaa
	 3KtBgWFinrIwbMZSOK9PB+wSsyUpDilDMVc7/qr8EO0MrVM16twcqiyymSzO6uqrJD
	 VB8DAd7jsrSTPueJPi8OW4jVKJD+BdeKqnuOq0B0=
Date: Sat, 24 Oct 2026 01:25:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sshegde@linux.ibm.com,rppt@kernel.org,ritesh.list@gmail.com,qi.zheng@linux.dev,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,david@kernel.org,chleroy@kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch removed from -mm tree
Message-Id: <20261024082535.1ACFB1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fixup! mm/mm_init: add zone mismatch warning during page init
has been removed from the -mm tree.  Its filename was
     mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch

This patch was dropped because it was folded into mm-mm_init-add-zone-mismatch-warning-during-page-init.patch

------------------------------------------------------
From: Muchun Song <muchun.song@linux.dev>
Subject: fixup! mm/mm_init: add zone mismatch warning during page init
Date: Sat, 10 Oct 2026 19:55:23 +0800

Document the ordering of shared and retained struct page initialization.

Link: https://lore.kernel.org/20261010115523.4005071-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>
---

 mm/mm_init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-add-zone-mismatch-warning-during-page-init-fix
+++ a/mm/mm_init.c
@@ -618,6 +618,10 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	/*
+	 * Shared tail struct pages are initialized during vmemmap population,
+	 * before retained struct pages reach here.
+	 */
 	vmemmap_optimization_verify_zone(page);
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-warn-on-unaligned-compound-zone-device-ranges.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

