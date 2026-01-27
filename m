Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AC41ADC97
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486591; cv=none; b=TJ6AIW4C2gmwWgXaP5yuu+S+bIYoomHmBWX1D5MK58CcyTX0J5PsZXnr+9s5rf/gtuLWszSa95tLWEqWcmtTvFv21ty4pY+dxrETmiwejizaDkqekwxpt3Ja7pnnFXiPJuEpG+iwq7EB04Vyh9tgePA+ICylllWWGtBDu6TRbfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486591; c=relaxed/simple;
	bh=2VpRkPmypLBPn3Tfe20z/UZn1D7sbZs5KjYvOspt1E8=;
	h=Date:To:From:Subject:Message-Id; b=aZT9dUnunKcCU+0yQW3ebagFX9gPlKtkbzYg3sMau2awbODRg7tVYNerN8Qv+U6gc6ub6M6EsVek6YF83FabnXbQxNRlLNDiuGPUmkwiB3MC+qYSE5jm5rv/V7M7P4DovxthuMoG4QEtqigz2vm+XfKo5xWnBpvEKw2+IOJHeiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vudv6MrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vudv6MrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B649C116D0;
	Tue, 27 Jan 2026 04:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486590;
	bh=2VpRkPmypLBPn3Tfe20z/UZn1D7sbZs5KjYvOspt1E8=;
	h=Date:To:From:Subject:From;
	b=vudv6MrY7J/cPryilx+wpugm0y4e/H2LBwcUj4W3zOX1/5OeI81fYg3Stv2iQKvim
	 mMmAs4atS8jTuLucz0OCsF8BPctJAwS3RWguHx/H64ufVPBaWN6ZZkv+P7eOphzK+z
	 G++DqlRtvLztm+cF69F8ER5MXQsN19kWp2GjubBw=
Date: Mon, 26 Jan 2026 20:03:10 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,Branden.Moore@amd.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch removed from -mm tree
Message-Id: <20260127040310.9B649C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: map dirty/writeback pages failures to EAGAIN
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: map dirty/writeback pages failures to EAGAIN
Date: Sun, 18 Jan 2026 19:09:40 +0000

Patch series "mm/khugepaged: fix dirty page handling for MADV_COLLAPSE",
v5.

MADV_COLLAPSE on file-backed mappings fails with -EINVAL when TEXT pages
are dirty. This affects scenarios like package/container updates or
executing binaries immediately after writing them, etc.

The issue is that collapse_file() triggers async writeback and returns
SCAN_FAIL (maps to -EINVAL), expecting khugepaged to revisit later. But
MADV_COLLAPSE is synchronous and userspace expects immediate success or
a clear retry signal.

Reproduction:
 - Compile or copy 2MB-aligned executable to XFS/ext4 FS
 - Call MADV_COLLAPSE on .text section
 - First call fails with -EINVAL (text pages dirty from copy)
 - Second call succeeds (async writeback completed)

Issue Report:
https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com


This patch (of 2):

When collapse_file encounters dirty or writeback pages in file-backed
mappings, it currently returns SCAN_FAIL which maps to -EINVAL.  This is
misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
pages represent transient conditions that may resolve on retry.

Introduce SCAN_PAGE_DIRTY_OR_WRITEBACK to cover both dirty and writeback
states, mapping it to -EAGAIN.  For MADV_COLLAPSE, this provides userspace
with a clear signal that retry may succeed after writeback completes.  For
khugepaged, this is harmless as it will naturally revisit the range during
periodic scans after async writeback completes.

Link: https://lkml.kernel.org/r/20260118190939.8986-2-shivankg@amd.com
Link: https://lkml.kernel.org/r/20260118190939.8986-4-shivankg@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 ++-
 mm/khugepaged.c                    |    8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain
+++ a/include/trace/events/huge_memory.h
@@ -37,7 +37,8 @@
 	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
-	EMe(SCAN_PAGE_FILLED,		"page_filled")
+	EM( SCAN_PAGE_FILLED,		"page_filled")			\
+	EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
 
 #undef EM
 #undef EMe
--- a/mm/khugepaged.c~mm-khugepaged-map-dirty-writeback-pages-failures-to-eagain
+++ a/mm/khugepaged.c
@@ -58,6 +58,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1967,11 +1968,11 @@ static int collapse_file(struct mm_struc
 				 */
 				xas_unlock_irq(&xas);
 				filemap_flush(mapping);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
 				xas_unlock_irq(&xas);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
@@ -2018,7 +2019,7 @@ static int collapse_file(struct mm_struc
 			 * folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
-			result = SCAN_FAIL;
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 			goto out_unlock;
 		}
 
@@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum s
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

