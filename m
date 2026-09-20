Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF13D75A0
	for <mm-commits@vger.kernel.org>; Sun, 20 Sep 2026 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789948507; cv=none; b=c3qtSfej/QIuKW6+tfjEQ216oaOek+NSmovPa7noSdnyGwuh9nyMvjiF3v7foyO+lszySTxEdgWl52kOqFxk8mpMSsle4QWY7MoqHbtDF9N8uTtRpIdsBlmWARuTySYPIvxIvyxKT9s/BH3SzeZ4sB3vEoyp1iW6IxUDpkpWcoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789948507; c=relaxed/simple;
	bh=sl0epoZVRigpDO4JWYtHfK3v5we5TP8mVuR8YRyDK1I=;
	h=Date:To:From:Subject:Message-Id; b=U19GqAtFV01cyTqpEUa/ntK0GvHQ4Hg7KZyzSKN8OTPUKRqliRws2uWPaayIEzqRolKqfKRmeK9nszc7sqFenyZmOGmbZpLAQN8vtJ9kTQ9v0vLhJENFMFROQInpeDggCw+iDsEYL2582q0XpEqwljbWSVIE9obfuwSeG07M16s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KnNZwhiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KnNZwhiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830B51F00893;
	Sun, 20 Sep 2026 23:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789948505;
	bh=/fgKFNLyusDTPuFW9hRE7T0Ew1XY85Pj0SuPGx0Cxm0=;
	h=Date:To:From:Subject;
	b=KnNZwhiNAWocjQJjaKG+yi5zQhq97MsDSNfeTOrvXIZZoBJ5hysiN7dXh2+cjrIOW
	 rDKfsJg6fMfc2tNRRaFKYnbxYHh8AYMQD6M+NYmmt659eOOs7eSnDPaSv7DFu5Sn2K
	 O4REjWMi8zkIKPVZXcelFJQbRBAPM7Le9wGQ8mYI=
Date: Sun, 20 Sep 2026 16:55:05 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-is_backed_by_folio-into-vm_util.patch added to mm-new branch
Message-Id: <20260920235505.830B51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: move is_backed_by_folio() into vm_util
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-move-is_backed_by_folio-into-vm_util.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-move-is_backed_by_folio-into-vm_util.patch

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
Subject: selftests/mm: move is_backed_by_folio() into vm_util
Date: Sat, 19 Sep 2026 01:24:37 +0100

Checking that an address range is backed by a folio of a given order is
useful to any test that builds or collapses large folios.  mTHP collapse
coverage in the khugepaged selftest needs exactly that.

split_huge_page_test.c already has the building block:
is_backed_by_folio() reads the compound head and tail flags from
/proc/kpageflags to classify the folio behind a page.

Move it into vm_util so other tests can use it.  No functional change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260919002451.496763-8-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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

 tools/testing/selftests/mm/split_huge_page_test.c |   61 ------------
 tools/testing/selftests/mm/vm_util.c              |   61 ++++++++++++
 tools/testing/selftests/mm/vm_util.h              |    2 
 3 files changed, 63 insertions(+), 61 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-move-is_backed_by_folio-into-vm_util
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -41,67 +41,6 @@ const char *kpageflags_proc = "/proc/kpa
 int pagemap_fd;
 int kpageflags_fd;
 
-static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
-		int kpageflags_fd)
-{
-	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
-	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
-	const unsigned long nr_pages = 1UL << order;
-	unsigned long pfn_head;
-	uint64_t pfn_flags;
-	unsigned long pfn;
-	unsigned long i;
-
-	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-
-	/* non present page */
-	if (pfn == -1UL)
-		return false;
-
-	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* check for order-0 pages */
-	if (!order) {
-		if (pfn_flags & (folio_head_flags | folio_tail_flags))
-			return false;
-		return true;
-	}
-
-	/* non THP folio */
-	if (!(pfn_flags & KPF_THP))
-		return false;
-
-	pfn_head = pfn & ~(nr_pages - 1);
-
-	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* head PFN has no compound_head flag set */
-	if ((pfn_flags & folio_head_flags) != folio_head_flags)
-		return false;
-
-	/* check all tail PFN flags */
-	for (i = 1; i < nr_pages; i++) {
-		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
-			goto fail;
-		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
-			return false;
-	}
-
-	/*
-	 * check the PFN after this folio, but if its flags cannot be obtained,
-	 * assume this folio has the expected order
-	 */
-	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
-		return true;
-
-	/* If we find another tail page, then the folio is larger. */
-	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
-fail:
-	ksft_exit_fail_msg("Failed to get folio info\n");
-}
-
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
 {
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-move-is_backed_by_folio-into-vm_util
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -490,6 +490,67 @@ int pageflags_get(unsigned long pfn, int
 	return 0;
 }
 
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd)
+{
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
+	const unsigned long nr_pages = 1UL << order;
+	unsigned long pfn_head;
+	uint64_t pfn_flags;
+	unsigned long pfn;
+	unsigned long i;
+
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+
+	/* non present page */
+	if (pfn == -1UL)
+		return false;
+
+	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* check for order-0 pages */
+	if (!order) {
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
+			return false;
+		return true;
+	}
+
+	/* non THP folio */
+	if (!(pfn_flags & KPF_THP))
+		return false;
+
+	pfn_head = pfn & ~(nr_pages - 1);
+
+	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* head PFN has no compound_head flag set */
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
+		return false;
+
+	/* check all tail PFN flags */
+	for (i = 1; i < nr_pages; i++) {
+		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
+			goto fail;
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
+			return false;
+	}
+
+	/*
+	 * check the PFN after this folio, but if its flags cannot be obtained,
+	 * assume this folio has the expected order
+	 */
+	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
+		return true;
+
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
+fail:
+	ksft_exit_fail_msg("Failed to get folio info\n");
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-move-is_backed_by_folio-into-vm_util
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -99,6 +99,8 @@ int64_t allocate_transhuge(void *ptr, in
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
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

