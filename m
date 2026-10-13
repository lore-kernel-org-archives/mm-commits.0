Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68D74848A6
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866039; cv=none; b=IO9eduaeAUGM0IAwzJHv1IiJEHG1l5QOuOeGv26mM8yr67OR/3omz0WRDZkKhg5WGo1o+PHTslsn2g5/67oT32X25BWBPja2/ZugxysK2Z9Pcjdx+y2uaRwi/5BZFdmBk6CWD4Y7mAX29dQY8F+XntJAgKqeS+pJ6RaFCxh7dFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866039; c=relaxed/simple;
	bh=l7Sfh42QildSPHgS5ojUHcS+Z6b2iSAOwCsOH9jifmg=;
	h=Date:To:From:Subject:Message-Id; b=bJywGj+5Xr//XV7qDUTwXlafbU+dgjuTr/5bMgaufNfhximIqMZMKCPlzndvQ1bbBjAGgbryJDmcInfnoIzCqQ5Tfp2+ftLYao7bWLFa3RLToRkJ+OAJrIT7Dl3dhOtwh5Vk8ukg3cOg2PYXOUL/F7e0+1Rtt7TVS7G5NBidBmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ebIof5m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ebIof5m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC31B1F000FF;
	Tue, 13 Oct 2026 04:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866037;
	bh=1nNbVrMoElAC1JdiXjE+9tigTCS0Vnw4zod8SL686iM=;
	h=Date:To:From:Subject;
	b=ebIof5m0u/aOaJn35CWSbpFj05wMi1tGsr9LRDSsu9fdxlFSCQzRWirV+awIJgAXF
	 nHKzrp5UDVE9uuD/pIJvUABqzozFaTp6TYltsyfz69LjBLX6TMj6j9v1gy7PZryP02
	 ObJ/w64MP04S2gHmPpf4yiZBk/LqZtzWk50rIRIU=
Date: Mon, 12 Oct 2026 21:33:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-race-the-collapse-of-windows-with-holes.patch removed from -mm tree
Message-Id: <20261013043357.AC31B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: race the collapse of windows with holes
has been removed from the -mm tree.  Its filename was
     selftests-mm-race-the-collapse-of-windows-with-holes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: race the collapse of windows with holes
Date: Sat, 19 Sep 2026 01:24:47 +0100

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

Link: https://lore.kernel.org/20260919002451.496763-18-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged_race.c |   32 ++++++++++-------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged_race.c~selftests-mm-race-the-collapse-of-windows-with-holes
+++ a/tools/testing/selftests/mm/khugepaged_race.c
@@ -236,6 +236,8 @@ int main(int argc, char **argv)
 	const int nr_threads = ARRAY_SIZE(thread_names);
 	pthread_t threads[ARRAY_SIZE(thread_names)];
 	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	static const bool occupancies[] = { false, true };	/* strict, holes */
+	const int nr_occupancies = ARRAY_SIZE(occupancies);
 	const char *one_mode[1];
 	const char * const *modes = all_modes;
 	int nr_modes = ARRAY_SIZE(all_modes);
@@ -303,7 +305,7 @@ int main(int argc, char **argv)
 		 -1, 0) != (void *)mremap_scratch)
 		ksft_exit_fail_perror("mmap() mremap scratch");
 
-	ksft_set_plan(nr_modes);
+	ksft_set_plan(nr_modes * nr_occupancies);
 
 	thp_save_settings();
 	thp_read_settings(&settings);
@@ -311,8 +313,9 @@ int main(int argc, char **argv)
 	/* Base of the settings stack; the bottom entry is never popped */
 	thp_push_settings(&settings);
 
-	for (int m = 0; m < nr_modes; m++) {
-		const char *mode = modes[m];
+	for (int run = 0; run < nr_modes * nr_occupancies; run++) {
+		const char *mode = modes[run / nr_occupancies];
+		bool holes = occupancies[run % nr_occupancies];
 
 		thp_read_settings(&settings);
 		settings.thp_enabled = THP_MADVISE;
@@ -322,12 +325,14 @@ int main(int argc, char **argv)
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
@@ -393,8 +398,9 @@ int main(int argc, char **argv)
 			check_page(i);
 
 		ksft_test_result(!corrupted,
-				 "%s: %ds, %d steps, no corruption\n",
-				 mode, duration_s, steps);
+				 "%s/%s: %ds, %d steps, no corruption\n",
+				 mode, holes ? "holes" : "strict",
+				 duration_s, steps);
 
 		/* The next mode maps the same fixed address with its own settings */
 		munmap(region, nr_areas * hpage_pmd_size);
@@ -404,9 +410,11 @@ int main(int argc, char **argv)
 
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

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

