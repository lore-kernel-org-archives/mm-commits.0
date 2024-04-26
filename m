Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FB17602D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101712; cv=none; b=B9NNQG3MJ+ctKKMEBbILfKUuCoqVkxZP01I9p1G58xyafPbGA6mxTPJCV3YrBNiIuDyIf4IuT/8Hj/CrrQsQYgXR/DsCGGNoDzKqk7YtYO6nmATQNQ26Z7rIafawOC2tGB6tUdv2yG1k3on0jTx+sVxd3Pqpv1JVUOHEF5hqFY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101712; c=relaxed/simple;
	bh=wktHeP/MdCB6nH0T2mFMOTEOUQnwzCtCBVGJ75tLU+s=;
	h=Date:To:From:Subject:Message-Id; b=JgPh0nNDgVLs4j070pnhPxLDOib6PvU2AVvdmsVoedrZX3iWopnstCAsO6NVrJBevPWLLuW5k3XTUx9Z6N7WOa48vLkY+7s2WzhQOMXNNd4NRiqntr/u9pdepw+YzoJRU9MZQ++W4940sCthpUx27g2Gm2Fr0kH/Ql4qWrPo+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cV9rPy32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cV9rPy32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BA8C113CD;
	Fri, 26 Apr 2024 03:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101711;
	bh=wktHeP/MdCB6nH0T2mFMOTEOUQnwzCtCBVGJ75tLU+s=;
	h=Date:To:From:Subject:From;
	b=cV9rPy32rCuTi4aUThC+FFQZeOG2hJWdSQCdQGJbg28JjoBWArf4VtUZYHzxHgK+t
	 mirQ9QVwaldxTFDQV9FFmP7+RfzJhdU4RINU3dWlFLeYEE377jyDqRiew3JGR/sSv1
	 6jNVt8vE5aZXBHlryNAVRcgHziquBJc5T0+Xk+NA=
Date: Thu, 25 Apr 2024 20:21:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,v-songbaohua@oppo.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch removed from -mm tree
Message-Id: <20240426032151.D1BA8C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix
has been removed from the -mm tree.  Its filename was
     mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch

This patch was dropped because it was folded into mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix
Date: Tue Mar 26 11:30:46 AM PDT 2024

rewrap comment, per Matthew

Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix
+++ a/mm/vmscan.c
@@ -1258,14 +1258,16 @@ retry:
 			if (folio_test_pmd_mappable(folio))
 				flags |= TTU_SPLIT_HUGE_PMD;
 			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to hold PTL
-			 * from the first present PTE within a large folio. Some initial
-			 * PTEs might be skipped due to races with parallel PTE writes
-			 * in which PTEs can be cleared temporarily before being written
-			 * new present values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially unmapped after
-			 * try_to_unmap; TTU_SYNC helps try_to_unmap acquire PTL from the
-			 * first PTE, eliminating the influence of temporary PTE values.
+			 * Without TTU_SYNC, try_to_unmap will only begin to
+			 * hold PTL from the first present PTE within a large
+			 * folio. Some initial PTEs might be skipped due to
+			 * races with parallel PTE writes in which PTEs can be
+			 * cleared temporarily before being written new present
+			 * values. This will lead to a large folio is still
+			 * mapped while some subpages have been partially
+			 * unmapped after try_to_unmap; TTU_SYNC helps
+			 * try_to_unmap acquire PTL from the first PTE,
+			 * eliminating the influence of temporary PTE values.
 			 */
 			if (folio_test_large(folio) && list_empty(&folio->_deferred_list))
 				flags |= TTU_SYNC;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

