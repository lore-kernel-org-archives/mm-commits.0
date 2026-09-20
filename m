Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD13D88F2
	for <mm-commits@vger.kernel.org>; Sun, 20 Sep 2026 23:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789948493; cv=none; b=iair2B3CnQycCc2lFZv7bXAk3rzJFW7YzZH1qgf2u5y3cYjkI62BJgEhTFdccS9twnrthZ/kUg+B6VNcLYl0uLjvgE57oepBj7OP575rhmkbOrn/j1nTzcit4UXvR/kfAFqyZuhJJrWig9VeaO3iUsjcwrYBD6GVqW/GokEjaYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789948493; c=relaxed/simple;
	bh=f4VNvF8CVjZRjP3sdg/wSNv1/0PO4FNZr94tGB1cq/Q=;
	h=Date:To:From:Subject:Message-Id; b=bIO5rrIYjATClfkwOWSggyoChnbJVGomDB+rWleaykxHQpzwZBtyy2BuDQd53js5Ot2qTdcD4/6BF66eZO8ecENKb2lI1AIKaK4KAmFFYTuHcvTYztkMDxQkqwnUJ4/vuOxSctRmog5Y36wYLYC2D3L4OpShnbBwIfjUqHjpWJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bPYODMie; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bPYODMie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5211F000FF;
	Sun, 20 Sep 2026 23:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789948491;
	bh=1q0AzHzP4bubjrfLNdoasoceljaKHmgc+Z34r2iSl2A=;
	h=Date:To:From:Subject;
	b=bPYODMieULPw5ewsOYtfoQXo5dOe7X16c7jFmCRtw9+4wdQW5drK/Chlx6bOKv7gi
	 PTZQbgCmfSdUfBDZdNqbZpF2h8g4qufK14DpuiI24317OXRpDm7aDyFLzsJj1NYTQl
	 1THqpF19kJSS1DdL2mJn2wM4gLr8lUk4b2UFvPnE=
Date: Sun, 20 Sep 2026 16:54:51 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch added to mm-new branch
Message-Id: <20260920235451.AC5211F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: scale khugepaged's collapse wait with the PMD size
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: scale khugepaged's collapse wait with the PMD size
Date: Sat, 19 Sep 2026 01:24:33 +0100

wait_for_scan() gives every case the same three seconds, whatever the huge
page costs to build.  collapse_full() asks for four of them: 8M at a 2M
PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.  Three seconds is
thin at that size, and the case has reported a failure for a collapse that
was still going.

The timeout is a ceiling on a poll loop, not a sleep: the loop stops as
soon as ops->check_huge() sees the collapse, or as soon as full_scans has
advanced by two.  Raising it costs a passing case nothing.  Across 80 runs
of collapse_full() on arm64 with 64K pages the wait was half a second in
73 of them, with a tail to two seconds.

Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
PMD is unchanged, so x86-64 is too; a 512M PMD gets 19 seconds.

On arm64 with 64K pages a passing ./khugepaged all:anon takes 49 seconds
under TCG before and after this change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260919002451.496763-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -561,8 +561,11 @@ static bool wait_for_scan(const char *ms
 		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
 	unsigned long hpage_size = page_size << collap_order;
-	int full_scans;
-	int timeout = 6; /* 3 seconds */
+	unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
+	int timeout, full_scans;
+
+	/* Half-second ticks: three seconds floor, plus a second per 128M */
+	timeout = 6 + 2 * (bytes / (128UL << 20));
 
 	/* Sanity check */
 	if (!ops->check_huge(p, len, 0, hpage_size))
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

