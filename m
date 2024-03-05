Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B8101C5
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600543; cv=none; b=RInb0lLhyR0vTFOYLLpB6ua7PSP/URHfbKQEP9AGOzoSC7L/I5DWkCIGVLptEoRWFqY4+Q23mN3cFS94q9aY/URDuWAb5YbXaxz4s52NiqJEtZWWD8XMuTp8j+d2vpBv4WMya9V1hO5wWp2ATjQBTmVnLSEG00UvBjguQr2ih3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600543; c=relaxed/simple;
	bh=ATiWByTZ38BGstNBA8Li541diPQR3YNw8H6kTvca+58=;
	h=Date:To:From:Subject:Message-Id; b=AwEXk5Kwo992ZKUi1MV0t5Pt9g8hh/M4R/p1IW1dIsn9TLIZGii4vzbEKEbtxK4qaZ7bFCg1o+C1wz1TpNRatDJo6F7HJaYpEfn6xQN421IC3LM/FosQS8+j3ovNEPac0sB0nxS7U4a5YupL/ElmfoEdSp5RO2HV2f4hCrvQB8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qbP+23Hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qbP+23Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85696C433C7;
	Tue,  5 Mar 2024 01:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600542;
	bh=ATiWByTZ38BGstNBA8Li541diPQR3YNw8H6kTvca+58=;
	h=Date:To:From:Subject:From;
	b=qbP+23HxYJFxlnml0vwbh5P68qE0CYYCU+6kMoclUSij7T7Sdego3LGSlmXNr68wY
	 MRkjCJQyABcaecTe6uVJQ9CHgVYUFr3w8OpdWzQo2JLteulENyJvPwAKq2VspIf+Ew
	 7vH+OjaNIzBJDlYo2+wOfbPPqEV+FY1fDxrpUbFw=
Date: Mon, 04 Mar 2024 17:02:22 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-only-split-pmd-mapping-when-necessary-in-unmap_folio.patch removed from -mm tree
Message-Id: <20240305010222.85696C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: only split PMD mapping when necessary in unmap_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-only-split-pmd-mapping-when-necessary-in-unmap_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: only split PMD mapping when necessary in unmap_folio()
Date: Mon, 26 Feb 2024 15:55:27 -0500

Patch series "Split a folio to any lower order folios", v5.

File folio supports any order and multi-size THP is upstreamed[1], so both
file and anonymous folios can be >0 order.  Currently, split_huge_page()
only splits a huge page to order-0 pages, but splitting to orders higher
than 0 might better utilize large folios, if done properly.  In addition,
Large Block Sizes in XFS support would benefit from it during truncate[2].
This patchset adds support for splitting a large folio to any lower order
folios.

In addition to this implementation of split_huge_page_to_list_to_order(),
a possible optimization could be splitting a large folio to arbitrary
smaller folios instead of a single order.  As both Hugh and Ryan pointed
out [3,5] that split to a single order might not be optimal, an order-9
folio might be better split into 1 order-8, 1 order-7, ..., 1 order-1, and
2 order-0 folios, depending on subsequent folio operations.  Leave this as
future work.

[1] https://lore.kernel.org/all/20231207161211.2374093-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/linux-mm/20240226094936.2677493-1-kernel@pankajraghav.com/
[3] https://lore.kernel.org/linux-mm/9dd96da-efa2-5123-20d4-4992136ef3ad@google.com/
[4] https://lore.kernel.org/linux-mm/cbb1d6a0-66dd-47d0-8733-f836fe050374@arm.com/
[5] https://lore.kernel.org/linux-mm/20240213215520.1048625-1-zi.yan@sent.com/


This patch (of 8):

As multi-size THP support is added, not all THPs are PMD-mapped, thus
during a huge page split, there is no need to always split PMD mapping in
unmap_folio().  Make it conditional.

Link: https://lkml.kernel.org/r/20240226205534.1603748-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20240226205534.1603748-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-only-split-pmd-mapping-when-necessary-in-unmap_folio
+++ a/mm/huge_memory.c
@@ -2727,11 +2727,14 @@ void vma_adjust_trans_huge(struct vm_are
 
 static void unmap_folio(struct folio *folio)
 {
-	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
-		TTU_SYNC | TTU_BATCH_FLUSH;
+	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
+		TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	if (folio_test_pmd_mappable(folio))
+		ttu_flags |= TTU_SPLIT_HUGE_PMD;
+
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
_

Patches currently in -mm which might be from ziy@nvidia.com are


