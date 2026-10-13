Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFCF4825D4
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866027; cv=none; b=UlwGDjbyMUJlnvIB8CJccONGJE0i3KM/HSZNWxnUlahvn60SLaCDte99T6qd0W/Gp5O4hFSR3VH1uuvOC3xZgqjkF0gnRuyGNDdn3ARYqZ7cdhjy0TfrwcCIX7TMRWnJBXmvcTSZb5C4u+tphwUjNanMMZ3mMX3YYAbjVtJe2tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866027; c=relaxed/simple;
	bh=Tfl/y6GzZAhofqHZbQ9x+Pb1X1X8gd6fwibPHTocxaE=;
	h=Date:To:From:Subject:Message-Id; b=hocNuRwdiM0QCjzqbq0M3myUytvOdqyjIlFEH6IILEPesgvrWWtbxJtX6l1e9qJMR0YAyaGrp9jCi5tCLZ2iZQXtaxyxhLwDR+GCXupSXzLK2ailoa82PbVig0cpk5AwDrb5GruHnE6Tqp7SE/Xlff0OKIh7FSL40keJ1CJHVCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFMmTK2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFMmTK2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC711F00899;
	Tue, 13 Oct 2026 04:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866020;
	bh=o9E/NqWcQt83jKZFI/ttAnpVHCd4PwfSxgocp25bT1Y=;
	h=Date:To:From:Subject;
	b=lFMmTK2Wgbhugpi/CMr1AvqgfR0DYx/M9fgvLnR4iY+87eB4nOi6QapyIaQJNdMdi
	 DkklZl5S/l24xCwad6jhWslm19XZUYfXQAhbYvqTMquu/XgydTldbKbwA4t9xshUCv
	 KHCzz/4IEMf+8mpDG4SyrlSF3neDmllixSe+Pcu0=
Date: Mon, 12 Oct 2026 21:33:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-make-the-swap-cases-swapout-reliable.patch removed from -mm tree
Message-Id: <20261013043340.ACC711F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: make the swap cases' swapout reliable
has been removed from the -mm tree.  Its filename was
     selftests-mm-make-the-swap-cases-swapout-reliable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: make the swap cases' swapout reliable
Date: Sat, 19 Sep 2026 01:24:35 +0100

collapse_swapin_single_pte() and collapse_max_ptes_swap() swap a range out
and then require smaps to report exactly the count they asked for.  Two
things keep that count from arriving.

MADV_PAGEOUT is best effort, so the count often turns up a moment late.

And wait_for_scan() leaves the range eligible for collapsing, so
khugepaged is still working on it.  Collapsing reads the swapped-out pages
back in, so the daemon empties the swap as fast as the case fills it.  On
arm64 with 64K pages max_ptes_swap is 1024 pages, which is 64M a step, and
the case loses the race:

    # Swapout 1024 of 8192 pages... Fail
    not ok 10 collapse_max_ptes_swap

Retry for up to two seconds, holding the range out of khugepaged's reach
meanwhile.  The collapse each case runs next restores MADV_HUGEPAGE, so
only the setup is affected.

If the pages still won't swap out, skip: no swap, swap too small or full,
a memcg cap or busy writeback.  None of that is a kernel bug.

Link: https://lore.kernel.org/20260919002451.496763-6-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
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

 tools/testing/selftests/mm/khugepaged.c |   41 +++++++++++++++-------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-make-the-swap-cases-swapout-reliable
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -221,6 +221,29 @@ err_out:
 	return swap;
 }
 
+static bool swapout_range(void *p, unsigned long size)
+{
+	int i;
+
+	/* keep khugepaged from collapsing the range and swapping it back in */
+	if (madvise(p, size, MADV_NOHUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
+
+	/*
+	 * Retry several times because MADV_PAGEOUT is best effort.  Sleep
+	 * between the retries to give outstanding writeback a chance to
+	 * finish.
+	 */
+	for (i = 0; i < 40; i++) {
+		if (madvise(p, size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
+		if (check_swap(p, size))
+			return true;
+		usleep(50 * 1000);
+	}
+	return false;
+}
+
 static void *alloc_mapping(int nr)
 {
 	void *p;
@@ -828,12 +851,10 @@ static void collapse_swapin_single_pte(s
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout one page...");
-	if (madvise(p, page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, page_size)) {
+	if (swapout_range(p, page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -854,12 +875,10 @@ static void collapse_max_ptes_swap(struc
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
+	if (swapout_range(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -871,12 +890,10 @@ static void collapse_max_ptes_swap(struc
 		ops->fault(p, 0, hpage_pmd_size);
 		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
 		       hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
-			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-		if (check_swap(p, max_ptes_swap * page_size)) {
+		if (swapout_range(p, max_ptes_swap * page_size)) {
 			success("OK");
 		} else {
-			fail("Fail");
+			skip("Could not swap out");
 			goto out;
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

