Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E094753B61E
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897055; cv=none; b=tN1+I6BxZvXtOOdUA7gp6SzEUWJHyJ/8u/LSw/qP0/7lF5qk6OWHH24L1isPDv8mGOmUg0TO8wRrM/cuKP1A6KqOV/tTeBMAjv7nZx+tdn5f4ummTJQm4kdIQqBtFxdjyWOWr9AiXk/WaN65/9UOFl+T9MSLYNg479m5lNr41BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897055; c=relaxed/simple;
	bh=EHXJE1qQa8fOVZg0S0S+Kcwz9wLW2YSuGIpAJYSvQNk=;
	h=Date:To:From:Subject:Message-Id; b=BNYpNk1Rfue0i7AvsX9McXqyrRJYXMIUBNttpi/guh9Q/nq/6ooo80r4YyObW0LImiI9u/jxzJtXGitOcsTLIi+bkoUr67o9QZiPm96JbEM7EHkqwhXEyttHiTv9vWHQYTCtmraxlMyfZujdSY5wEaIPkYJSt35WcZgNLynjHUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DlMaFzJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DlMaFzJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0451F00A3A;
	Tue,  8 Sep 2026 19:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897053;
	bh=f1vGvirlRJN8LfpGDsnDF2oPygqhpq53FkWJkvqka/k=;
	h=Date:To:From:Subject;
	b=DlMaFzJXqY9ePNXHoFwTT8moa2kQU7OnGAME7db7WBaFxha7Oo0Hi7sWpZJ9hHWMv
	 NGsCtzTBFakLSyTYLAWwVCvptx/L3vt7IewxxM0IxsMtFsFKAuKjh+rlPsn8Zb/yN7
	 QJOzTtQjn5+gJMxTlWNS+UuRW0LZ+7gJ48A+HUkU=
Date: Tue, 08 Sep 2026 12:50:52 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch added to mm-new branch
Message-Id: <20260908195053.4F0451F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: zap whole PTE tables in the khugepaged race harness
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

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
Subject: selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Tue, 8 Sep 2026 13:51:05 +0100

The harness's MADV_DONTNEED thread zaps 1 to 32 pages at a time, never a
whole PMD-aligned area, and only a zap that covers a full table frees the
table itself (CONFIG_PT_RECLAIM).

Make the thread zap a whole PMD-aligned area about one iteration in 64,
and keep the fine-grained zaps as the common case.  The new case frees
page tables, racing that against a collapse walking the same table.

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-20-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged_race.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged_race.c~selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness
+++ a/tools/testing/selftests/mm/khugepaged_race.c
@@ -118,8 +118,21 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size,
-			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		/*
+		 * Now and then zap a whole PMD-aligned area: only a zap that
+		 * covers the full table frees the table itself (CONFIG_PT_RECLAIM).
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				room_from(page_idx, nr) * page_size,
+				MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
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

