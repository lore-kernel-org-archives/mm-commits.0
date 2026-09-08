Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0531048E0CD
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897050; cv=none; b=WobXxoRrTEe1hj40dl4Uqd+Cs8VKeMU8husLexD/BSiGJmKiGKGct2RVvPbHIP7iQoKuLEt8CzOMHU3NSOHvitod5kQpyzIRAPArXgFSvoxOsHCoyh200O1NEX79AEGySFiTEu3F3Jdzl6gLfAhnrOj7BRqstiWc1H5AdZUHr5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897050; c=relaxed/simple;
	bh=Dv08+IC8YvYkSc7q2qsrLUBrA94pgP0bu5W+1TkQQ+E=;
	h=Date:To:From:Subject:Message-Id; b=VCddFk0uEHlvbflzYB3gazMBD2+DEU+/FT9MP4XH0F5B19iJSlw/Yuys5LNQkf3f4LmHMcZIOeiCkeyEGzNv+Akt1kF26sTS8eHXKTbLSYj5E/Rbt8ULMNiUYWAYzJbFBx61j+Heo9EbZ4BnYOgBo0HYgjLsN70sC0WnIJ+SqQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0yfFw36H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0yfFw36H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A078C1F00A3A;
	Tue,  8 Sep 2026 19:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897048;
	bh=1BzeustnoGwuusVMiw8JKvalWPKs7Hx5impC68tNSyE=;
	h=Date:To:From:Subject;
	b=0yfFw36Hgr1J69h0uTpa0hq0gRkHxS6qwYEvmhZWsmcvXSAawN5/JBfvVv302sZjR
	 Yn3zsWpTgCsxppTQDFQLJ8SoESWa3DOqiBiK8tobL6mMrnwcHeaLF+98//gK5LUTXO
	 GuN4XsZ//Pzfq4/ff2cKwBZPQJKs0JS+2lFsDPs0=
Date: Tue, 08 Sep 2026 12:50:48 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-race-the-collapse-of-windows-with-holes.patch added to mm-new branch
Message-Id: <20260908195048.A078C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: race the collapse of windows with holes
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-race-the-collapse-of-windows-with-holes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-race-the-collapse-of-windows-with-holes.patch

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
Subject: selftests/mm: race the collapse of windows with holes
Date: Tue, 8 Sep 2026 13:51:03 +0100

The harness pins max_ptes_none to 0, so khugepaged only collapses a window
once every PTE in it is present.  A window with holes takes a different
route, and never gets raced.  A hole is zero-filled in the new folio
rather than copied.  Which slots count as holes keeps moving under the
racing MADV_DONTNEED, right up to the moment the PMD is detached.

Run both ends of the occupancy scale for every driver mode, one after the
other.  mTHP collapse supports only those two, 0 and HPAGE_PMD_NR - 1, and
coerces anything between them to 0.  Each result says which end it ran:

  ok 1 stepped/strict: 5s, 231 steps, no corruption
  ok 2 stepped/holes: 5s, 194 steps, no corruption

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-18-kirill@shutemov.name
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

 tools/testing/selftests/mm/khugepaged_race.c |   32 ++++++++++-------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged_race.c~selftests-mm-race-the-collapse-of-windows-with-holes
+++ a/tools/testing/selftests/mm/khugepaged_race.c
@@ -231,6 +231,8 @@ int main(int argc, char **argv)
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	static const bool occupancies[] = { false, true };	/* strict, holes */
+	const int nr_occupancies = ARRAY_SIZE(occupancies);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -298,7 +300,7 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes);
+	ksft_set_plan(nr_modes * nr_occupancies);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -306,8 +308,9 @@ int main(int argc, char **argv)
 	/* Base of the settings stack; the bottom entry is never popped */
 	thp_push_settings(&settings);
 
-	for (int m = 0; m < nr_modes; m++) {
-		const char *mode = modes[m];
+	for (int run = 0; run < nr_modes * nr_occupancies; run++) {
+		const char *mode = modes[run / nr_occupancies];
+		bool holes = occupancies[run % nr_occupancies];
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -317,12 +320,14 @@ int main(int argc, char **argv)
 		settings.khugepaged.scan_sleep_millisecs =
 			strcmp(mode, "free") ? 1000 : 0;
 		settings.khugepaged.alloc_sleep_millisecs = 10;
+
 		/*
-		 * mTHP collapse honours only 0 or HPAGE_PMD_NR - 1 here, and 0
-		 * keeps a step from being spent on PMD allocations that racing
-		 * MADV_DONTNEED will not let succeed.
+		 * mTHP collapse honours only 0 or HPAGE_PMD_NR - 1 here.  The two
+		 * ends race different paths: a strict window has every PTE
+		 * present, a hole-heavy one is mostly zero-filled.
 		 */
-		settings.khugepaged.max_ptes_none = 0;
+		settings.khugepaged.max_ptes_none = holes ?
+			(hpage_pmd_size / page_size) - 1 : 0;
 		/* One wake, one pass: the playground plus the forked children's copies */
 		settings.khugepaged.pages_to_scan =
 			nr_areas * (hpage_pmd_size / page_size) * 8;
@@ -388,8 +393,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s: %ds, %d steps, no corruption\n",
-				 mode, duration_s, steps);
+				 "%s/%s: %ds, %d steps, no corruption\n",
+				 mode, holes ? "holes" : "strict",
+				 duration_s, steps);
 
 		/* The next mode maps the same fixed address with its own settings */
 		munmap(region, nr_areas * hpage_pmd_size);
@@ -399,9 +405,11 @@ int main(int argc, char **argv)
 
 		if (corrupted) {
 			/* Memory is suspect; the rest would prove nothing */
-			while (++m < nr_modes)
-				ksft_test_result_skip("%s: skipped after corruption\n",
-						      modes[m]);
+			while (++run < nr_modes * nr_occupancies)
+				ksft_test_result_skip("%s/%s: skipped after corruption\n",
+						      modes[run / nr_occupancies],
+						      occupancies[run % nr_occupancies] ?
+						      "holes" : "strict");
 			break;
 		}
 	}
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

