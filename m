Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221492;
	b=l/+Ovp8Jn5w5utYDNyHzLxwLbRLs98HX5tGG2hz+J6i7FpA6SXTE5V1l7akmoH/zT4aw
	 UOkUI6RPZg1sw3DQ5Xa93m8Ny5bbjP7Y57ScekNTLRpX0f5WHHddKru04K6bozwGw5aiv
	 Q0g/0Fc1Q7l6rNUouagDiKBKSkh6hbmHpIZV4IFz7q05vAEq6I8RjfSHIy/PLvsPKA0SG
	 OsSbtksiUw7Fy+OLmKp2QKKsz7cpuKQG926yUqk18BfIWEkpyqCn/OL9F1cRdEoR7itDG
	 UAOnKrfz8fZt+kAOdYtc8ASpxmgpCLRww2zEEKdatjgpCGTmeANms5G735wz7du5jNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221492;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=kAK2hwB3kZfT4APVbgkFz2aEQRFFOV9gQ3CF0uYl2CY=;
	b=RayL05fIgPbMOuDrgFUyNewINlcGmQsJ9nlnIb35bvAJk5JrHNFZRg+Oag2yQvpIRBu4
	 AAvAt3mzJI1ltt5IuUzN5eG14RWvzd1wfm4DK0YsE4flQiRxeUQCegDUj67jQwLzgxKly
	 MHKCPuCYnCl3pbziZ2ONQCean77tKannkcQpyrWJJZwaZoW9POUoJj7RrllAYFOI4yEHY
	 8PJHVMFvP+3CfYVNNdbKPk0x9KKYkWxY4xpTK3riM++7Gnux7uYeu9RRnfTTqYzjIlfPM
	 mmol9upEY+wJLRkA1/Ja6CTL+Sc+vuSNt0cwl3iIXUR8IY2UjhPu5SYFPoF+GY0hQ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Up9pyNEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13591606A31C
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 21:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Up9pyNEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C071F01828;
	Wed, 28 Oct 2026 21:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793221491;
	bh=kAK2hwB3kZfT4APVbgkFz2aEQRFFOV9gQ3CF0uYl2CY=;
	h=Date:To:From:Subject;
	b=Up9pyNEzXCdBWxhxSVQpy7WxdITuAGK4S8mY5cjoBVhnepy3BEBI+rXrGGmyHjfU7
	 SPcRuocuiMHawvlpI/GwIfTw3RgLjXO4eC3/E2DX/s5noHQ9GuS2HfX1j9PUmuM7qv
	 JU5YORn3DtS4JAL3OEHHIXB9pr5eJVWe0ztONqj4=
Date: Wed, 28 Oct 2026 14:04:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,
	nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,zenghui.yu@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure.patch added to mm-new branch
Message-Id: <20261028210451.98C071F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: skip collapse_compound_extreme() on THP allocation failure
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure.patch

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: skip collapse_compound_extreme() on THP allocation failure
Date: Wed, 28 Oct 2026 18:01:19 +0800

collapse_compound_extreme() needs hpage_pmd_nr PMD-order allocations in a
row, and it kills the whole test binary via ksft_exit_fail_msg() as soon
as one of them fails.

Gating the case by PMD size (commit b36bec6a01b1) -- the current
workaround for arm64 with 64K base pages, where a 512M PMD makes every
construction step an order-13 allocation -- is not enough: the case still
dies below the cutoff, e.g.  on an arm64 VM with 16K base pages and 8G of
RAM, where the construction would need ~64G worth of PMD-order
allocations.

Remove the PMD-size gating and treat a failure to allocate a huge page
during the construction as a skip: whether the allocator can hand out that
many PMD-order folios in a row depends on the memory available on the
machine, not on the kernel.

Link: https://lore.kernel.org/20261028100119.11340-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Link: https://lore.kernel.org/all/atiQmWnz8zx2AKI7@thinkstation
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/khugepaged.c |   26 +++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -953,23 +953,25 @@ static void collapse_compound_extreme(st
 	void *p;
 	int i;
 
-	/*
-	 * This needs hpage_pmd_nr PMD-order allocations in a row, which the
-	 * allocator will not supply if the PMD is very large.
-	 */
-	if (hpage_pmd_size > (32UL << 20)) {
-		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
-				      __func__);
-		return;
-	}
-
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
 		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
-		if (!ops->check_huge(BASE_ADDR, hpage_pmd_size, 1, hpage_pmd_size))
-			ksft_exit_fail_msg("Failed to allocate huge page\n");
+		if (!ops->check_huge(BASE_ADDR, hpage_pmd_size, 1, hpage_pmd_size)) {
+			/*
+			 * Constructing the PTE table requires hpage_pmd_nr
+			 * PMD-order allocations in a row.  Whether the
+			 * allocator can supply them depends on the memory
+			 * available on the machine, not on the kernel: skip
+			 * instead of failing the test run.
+			 */
+			ops->cleanup_area(BASE_ADDR - i * page_size,
+					  i * page_size + hpage_pmd_size);
+			ksft_test_result_skip("%s: Failed to allocate huge page\n",
+					      __func__);
+			return;
+		}
 		madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
 
 		p = mremap(BASE_ADDR - i * page_size,
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch
selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch
selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure.patch

