Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DBD4A1DE9
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897015; cv=none; b=eV/c7dCbiz8UmQL2Kfxk64tddE5AaghFtAQNgMcMi/X6RHsg1IUkjKqocs+0t4FjkpQmURj3nnuYsDGcmiDPUJ6juXazH70/ny8VLRF/vf7Pi8mtkl1OsgtO9PAYjrkBM3cXwI710vyMD7HCnt9YeECSusE/1QY7mGwjqk74HXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897015; c=relaxed/simple;
	bh=MWxYFX9HlOC9BUmS2WaDPQ6SME1wtinDlhYr0xD1x5A=;
	h=Date:To:From:Subject:Message-Id; b=X8tLVFAIQm4fQeiEV/Sf7CaXqr6iUJLa5lKz1m6zLRrCt+2B8FbZHhNNqgfDh6UBBJ3QEN3JURLtD5ciE4oDBgoyTXj2yGYAUZeZQwr+c0wMuKE79fgB4kyHfDcLsNW0UuuRyngQ+HME4/OCD3anFv+RtTIr9zNUFxwTdzC4Omg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6taVjI2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6taVjI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D5D1F00A3A;
	Tue,  8 Sep 2026 19:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897014;
	bh=iAQ/QJD4PY8lHmaGc4l78+DnwDwBFw9tROvZLrk7qWg=;
	h=Date:To:From:Subject;
	b=d6taVjI2kc05eXwz7cZvtzxwImSmXrkZf6UeGz+kswSK4l4J6YEJAO6RWTX3p63Wq
	 mDABU5czzeH+ft54/GR2R2fXuxoVKw5Mdtip8IwOwd/wS/BFVZtUhPcQVlHjFGkYzO
	 o3q5GXp6edWj6plRjqZa2hpTqEPhwjjLK6yK2V2M=
Date: Tue, 08 Sep 2026 12:50:13 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch added to mm-new branch
Message-Id: <20260908195013.E7D5D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch

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
Subject: selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
Date: Tue, 8 Sep 2026 13:50:52 +0100

__madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
khugepaged out of the range and to prove MADV_COLLAPSE ignores the
setting.  It clears the global controls only, which is no longer enough. 
A per-order control overrides them, and -s, which makes the cases fault in
folios of one order, leaves that order's control at "always".  khugepaged
then collapses the very range the case is working on, and the case fails
on a collapse that was interfered with rather than refused.

Clear the per-order controls too, setting them to "inherit" rather than
"never": khugepaged honours the global never and stays out, while
MADV_COLLAPSE on shmem still finds an order to build.

Link: https://lore.kernel.org/20260908125105.1510704-7-kirill@shutemov.name
Fixes: 9f0704eae8a4 ("selftests/mm/khugepaged: enlighten for multi-size THP")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: LLM
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
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-stop-khugepaged-during-the-madv_collapse-cases
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -538,8 +538,8 @@ static bool is_anon(struct mem_ops *ops)
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 			       struct mem_ops *ops, bool expect)
 {
-	int ret;
 	struct thp_settings settings = *thp_current_settings();
+	int ret, i;
 
 	ksft_print_msg("%s...", msg);
 
@@ -552,9 +552,16 @@ static void __madvise_collapse(const cha
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
 	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
+	 *
+	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
+	 * finds an order to build.
 	 */
 	settings.thp_enabled = THP_NEVER;
 	settings.shmem_enabled = SHMEM_NEVER;
+	for (i = 0; i < NR_ORDERS; i++) {
+		settings.hugepages[i].enabled = THP_INHERIT;
+		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
+	}
 	thp_push_settings(&settings);
 
 	/* Clear VM_NOHUGEPAGE */
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

