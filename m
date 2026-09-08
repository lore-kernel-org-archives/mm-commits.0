Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F83544890
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897018; cv=none; b=oXuHvwYKdW45UZGPTveLpJljryXujU8Lic/4r/gTmWsUxlTJ6r4dAsJLqcpYO2MyIiypmh24/Lvi4yMTfNWzTzgcwdEkL/C1Hnosq7rKuHGtjtZwHSyFZAzQ6X6zYOEEJ+wpNNbncwI2ewVGaSZ8kP0qfKkjeO3iigfuejsUeJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897018; c=relaxed/simple;
	bh=/Wb4I0jG4r7JdvFyFkstKCyVqN4WJOlbhppRNQAoC5o=;
	h=Date:To:From:Subject:Message-Id; b=ZJxRASeUu4J0JnlrQHaLyi83HfuN9kXfUFJnXjmqTzuoUG13WC76lODGsI/gu+vMLH6Un8veaCYfZ+m4csoK+SY5rmXJZh064J9pjV1S/vqYPdLUw7hf0Q02TYZAhBWBS1YYed55P8hOabghep745dcXq2VkjKT1YnGpTErn8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=El8oBsJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="El8oBsJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AD61F00A3A;
	Tue,  8 Sep 2026 19:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897016;
	bh=KASGI/IgtlkU25Jj8iBcg/uHyQugHhWNQQGYkdJMcbw=;
	h=Date:To:From:Subject;
	b=El8oBsJGJBznw3acnv+QXfEmyTAfw3qS5UMHqjxnq+7l6m2SD1Ba9ZodX7dj0x6wG
	 CCgnHKpP8nAq7cxlGqnyvlOvKSLvepc2MKkQtiZU3zxJCTHyWxsbMId+hvYpdIvXLD
	 a8wPyPq6h1lH2yZOgCTHos5y8bOszyMvBulzLiAk=
Date: Tue, 08 Sep 2026 12:50:15 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-move-is_backed_by_folio-into-vm_util.patch added to mm-new branch
Message-Id: <20260908195016.22AD61F00A3A@smtp.kernel.org>
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
Date: Tue, 8 Sep 2026 13:50:53 +0100

Checking that an address range is backed by a folio of a given order is
useful to any test that builds or collapses large folios.  mTHP collapse
coverage in the khugepaged selftest needs exactly that.

split_huge_page_test.c already has the building block:
is_backed_by_folio() reads the compound head and tail flags from
/proc/kpageflags to classify the folio behind a page.

Move it into vm_util so other tests can use it.  No functional change.

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-8-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   61 -----------
 tools/testing/selftests/mm/vm_util.c              |   62 ++++++++++++
 tools/testing/selftests/mm/vm_util.h              |    2 
 3 files changed, 64 insertions(+), 61 deletions(-)

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
@@ -490,6 +490,68 @@ int pageflags_get(unsigned long pfn, int
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
+	return false;
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

