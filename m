Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794080397;
	b=WshpPYGGCO6w+lcbZgK2NjTQsHM6lB+qVbPjqnU+owpR2PrABFrFJuMg3Kt/K3o3rGZk
	 Aj+FBDoLODgDoIbLAamn4zw0pbY2TN+dblwgtPlqCus3bNDOp3V87NfR/M8SYhK7ATPcC
	 n8VvvEjfFUAJ2ClG/r5Ac76KZ4OYdVNfSn4ccP4pvDrW4+S4RPaoBMY+vjCRTQy7nqwbY
	 I7KK6ET4u6LW2FPKdJ2RDPlPfFkXSc3WTLtJTgFToLtxIccm2NyQAKO8rWfgGgKD+cGWZ
	 eKMtKBS+QvR22eetxmP4x1q6LHegQFzTIkL5qAb9nHulgb6mdBGTP7A2cwkxIiVgzOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794080397;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=tW04A6ZT+mlwmfgrCBwYs9YUkFFT90YwsNxtJj64G3o=;
	b=DUbVEFC0w89Pxmv0HzrWv+Gl5rrP3EEIbcIlNZWJcLKeqQyZejp8/hcg1xrInTolXMWH
	 0yusCMr8DV4u6Ieu5hcLkhP0R9/zwwHSejfI8RXonawj6/YVcpaSfDkzq5yCczfEcWKnj
	 98ioC3sADMI6F7cH6fY4DRz91GfmroczqoX058GAH4Rg4e6FsQ1ZZgZrlZ2yy6MbljeRQ
	 NkR7hzXqrDI+ASEW8ehDx9aG9OWK8ZLrPnkDOmPDnamST3jel5KH7YuqzU2mLIR82eFnq
	 hsJXohDxkI2mp8anZjQ8WxYKPaZhmud8MGl0RyCg5BNoSUZH2atjDFbmSbqk28zn6pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XXoAxkgc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5E8606A326
	for <mm-commits@vger.kernel.org>; Sat,  7 Nov 2026 19:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XXoAxkgc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C154C1F0089F;
	Sat,  7 Nov 2026 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794080396;
	bh=tW04A6ZT+mlwmfgrCBwYs9YUkFFT90YwsNxtJj64G3o=;
	h=Date:To:Cc:From:Subject;
	b=XXoAxkgcfTnSZ2kzmgjKvoHDEiXh7kpD/XHH4RNVXgpzG6ZZwKsCWoLFVmihHsYq+
	 w2OIYpY8nrJMUxTe8h/MZpsFokh5EV27y0SCagkvgSgNfZlmRYHu+gxd+mb21kjzcF
	 FIbG+clIrX1MIHV6TMKcJuZgi9+7U6nGAEK+fSws=
Date: Sat, 07 Nov 2026 11:39:56 -0800
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse.patch removed from -mm tree
Message-Id: <20261107193956.C154C1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
Date: Thu, 05 Nov 2026 19:16:44 +0100

madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
uptodate.  For example, shmem fallocate() can put such folios into the
page cache.

collapse_file() already refuses to proceed with folios that are not
uptodate.  Let's just do the same in try_collapse_pte_mapped_thp() and
skip such folios, leaving handling to the page faults.

Note that collapse_file() effectively clears shmem folios through
shmem_get_folio(); let's keep this fix simple and simply let the page
fault path deal with that.

Link: https://lore.kernel.org/20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/khugepaged.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-dont-map-folios-that-are-not-uptodate-in-madv_collapse
+++ a/mm/khugepaged.c
@@ -1888,6 +1888,12 @@ static enum scan_result try_collapse_pte
 		goto drop_folio;
 	}
 
+	/* Leave any uninitialized folios to the page fault path. */
+	if (!folio_test_uptodate(folio)) {
+		result = SCAN_FAIL;
+		goto drop_folio;
+	}
+
 	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
 	switch (result) {
 	case SCAN_SUCCEED:
_

Patches currently in -mm which might be from david@kernel.org are

mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

