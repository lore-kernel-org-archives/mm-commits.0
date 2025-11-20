Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD26036D503
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763674106; cv=none; b=JEUhmc82p5XmmtdvstqYg0H2QaGOfFuMVLvC2xxWiFY7JRNvJ+G4i3eiXMB6ewVKJn230lZv6ruJBhc+Xk/pw6AdpOcthcW07S81VjxMRTdlgeo199SMwgcQuDvZ7wjcf9JnZOvTImnUqyf89jvzKVn7a6/xSPbkgooO0ODxYeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763674106; c=relaxed/simple;
	bh=X0uTvWZ2MB4DFUdszKS8UeylLi4rlM48GxGWZ2M9A34=;
	h=Date:To:From:Subject:Message-Id; b=oKXz0PhlS/zCGmnWUbR0RDK4bFwg4cuC1juPoVgBAAWlEBM/DgOoiUUwQTFucmFZPRyzhJ9k4uLfGPcdbwFDs2iHLxSTMZaE1bvnR2Hrsd74DSWrq11LneYlCDZADBRDXZXZut+rrRpf+vkGu5YrxwDs+GrMNzvW6lhFnDCH7NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E5cHTezj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E5cHTezj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A966C4CEF1;
	Thu, 20 Nov 2025 21:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763674106;
	bh=X0uTvWZ2MB4DFUdszKS8UeylLi4rlM48GxGWZ2M9A34=;
	h=Date:To:From:Subject:From;
	b=E5cHTezjgfKFnw/YsRHCupGc91P7jA6GZ0oWIlDIzIN3i8HSnCIQnRPQqyushmPki
	 45y0ApiK9KezKzP4ljs6sBDBrftNFwrNJDWagmbDbqXAJtlfAnf8YHsGAl6tuotPaa
	 urQ6hhvUpVzuVnG9wNkJA3ehEz/rxBz1ZSRPFTvI=
Date: Thu, 20 Nov 2025 13:28:25 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch removed from -mm tree
Message-Id: <20251120212826.0A966C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-remove-folio_test_private-check-in-pageout-fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

This patch was dropped because it was folded into mm-vmscan-remove-folio_test_private-check-in-pageout.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-remove-folio_test_private-check-in-pageout-fix
Date: Thu Sep 18 03:01:31 PM PDT 2025

redo comment, per David

Link: https://lkml.kernel.org/r/17d1b293-e393-4989-a357-7eea74b3c805@redhat.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-folio_test_private-check-in-pageout-fix
+++ a/mm/vmscan.c
@@ -701,8 +701,8 @@ static pageout_t pageout(struct folio *f
 		return PAGE_KEEP;
 	if (!mapping) {
 		/*
-		 * Is it still possible to have a dirty folio with
-		 * a NULL mapping? I think not.
+		 * We should no longer have dirty folios with clean buffers and
+		 * a NULL mapping. However, let's be careful for now.
 		 */
 		VM_WARN_ON_FOLIO(true, folio);
 		return PAGE_KEEP;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-propagate-vm_softdirty-on-merge-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-correctly-handle-uffd-pte-markers-fix.patch
mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch
uaccess-gate-_copy__user-on-inline_copy_from_user-fix.patch

