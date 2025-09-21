Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB722AE99
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489918; cv=none; b=h4sp6nHFMyB9fVmB50oyxPNHmKiMg54XSpOwDsUD1NHJKh/yAFN12B9gquMETGEfPMeGplEs5eZ4C7ITxqfyTmHXCKsfdJ3gbOKwH6mZdcg1nVEvWsPiCbdwCYHptCK7l1tGpwIdyLtNR3t/m32kGJdEIzuoQsiF3aZsEjJeO6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489918; c=relaxed/simple;
	bh=FQTHg2gAzSKtgaoQxU2Qen6zk8p66Cjx5STXKot8u68=;
	h=Date:To:From:Subject:Message-Id; b=sEdE0GYYPOEas8JS5Fu/Vt0FVH5F0Rkn5LBfAXozKuJRtpHtFzYbbNzFA4yupfisreqPxDOWHVu8Q41UM4nxmBEuxazRa3tjh0NYtIKmWcKFKrvE8cV1AVbIFRhy+/TcrvQiS52S8P59b3suFTUhTRCX2dYXAv1iQ410V8Y+bs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0tKe7v39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0tKe7v39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3904C4CEE7;
	Sun, 21 Sep 2025 21:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489918;
	bh=FQTHg2gAzSKtgaoQxU2Qen6zk8p66Cjx5STXKot8u68=;
	h=Date:To:From:Subject:From;
	b=0tKe7v395nmZg4JtLGBDByyFyo6XGku7UkCT7jNHRJ8nu4iEdshh96lMoc+GlkD8r
	 B/JNdlhtFpE/tu7cAr/Kp3sinIa5ejBpl8A3dTxJC3zvsYO6jb1KFRqwoWmJEQ9i8w
	 +0IBBZxlGYZTvSy0OF4qrzL+4D1KNWQYO2fJeyXA=
Date: Sun, 21 Sep 2025 14:25:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch removed from -mm tree
Message-Id: <20250921212517.F3904C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio() wrong results
has been removed from the -mm tree.  Its filename was
     selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: split_huge_page_test: fix occasional is_backed_by_folio() wrong results
Date: Wed, 3 Sep 2025 09:02:52 +0200

Patch series "selftests/mm: split_huge_page_test: split_pte_mapped_thp
improvements", v2.

One fix for occasional failures I found while testing and a bunch of
cleanups that should make that test easier to digest.


This patch (of 2):

When checking for actual tail or head pages of a folio, we must make sure
that the KPF_COMPOUND_HEAD/KPF_COMPOUND_TAIL flag is paired with KPF_THP.

For example, if we have another large folio after our large folio in
physical memory, our "pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)" would
trigger even though it's actually a head page of the next folio.

If is_backed_by_folio() returns a wrong result, split_pte_mapped_thp() can
fail with "Some THPs are missing during mremap".

Fix it by checking for head/tail pages of folios properly.  Add
folio_tail_flags/folio_head_flags to improve readability and use these
masks also when just testing for any compound page.

Link: https://lkml.kernel.org/r/20250903070253.34556-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250903070253.34556-2-david@redhat.com
Fixes: 169b456b0162 ("selftests/mm: reimplement is_backed_by_thp() with more precise check")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |   15 +++++-------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-split_huge_page_test-fix-occasional-is_backed_by_folio-wrong-results
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -44,6 +44,8 @@ int kpageflags_fd;
 static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
 		int kpageflags_fd)
 {
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
 	const unsigned long nr_pages = 1UL << order;
 	unsigned long pfn_head;
 	uint64_t pfn_flags;
@@ -61,7 +63,7 @@ static bool is_backed_by_folio(char *vad
 
 	/* check for order-0 pages */
 	if (!order) {
-		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
 			return false;
 		return true;
 	}
@@ -76,14 +78,14 @@ static bool is_backed_by_folio(char *vad
 		goto fail;
 
 	/* head PFN has no compound_head flag set */
-	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
 		return false;
 
 	/* check all tail PFN flags */
 	for (i = 1; i < nr_pages; i++) {
 		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
 			goto fail;
-		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
 			return false;
 	}
 
@@ -94,11 +96,8 @@ static bool is_backed_by_folio(char *vad
 	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
 		return true;
 
-	/* this folio is bigger than the given order */
-	if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL))
-		return false;
-
-	return true;
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
 fail:
 	ksft_exit_fail_msg("Failed to get folio info\n");
 	return false;
_

Patches currently in -mm which might be from david@redhat.com are


