Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795816978;
	b=MBQ6uW/FsRLnZcP27arxirBvT4EDRrRfx+H9ws7H2iYqj6RopsW2pH9GIK0icIjLg3xa
	 XmNacwmBdR3oJuR7+FL0/czVhKWiokDLbsWIkewwYryBcqHUHXmPz1ijNi7n7d5WACkBx
	 VGhRKNW6jqQevuxYLxsU/7h+Tft6a/aCHybVl14UP21GpJmCbPxKv51sm/o5dOzWd1b48
	 QGW/pVqJRZhgpD0cqizAHLYJGfX+YbUbllSTuBxkra9lnZ+OFdxJO8ec64MTJ3VJkNatF
	 Lemv9NpR6wpTkiwPoecZ8KXcSaYXG//71l7azLnIcmJBJ+6A2H2HWk+O/7gwznAtcEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795816978;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=8XKHycyHwtfhmNXx8dXpxgAlRmudDksO+XAk5jEhYuA=;
	b=OVuQAo6xQe85ASECAr/tefI9gGmZ56RBPAuyFxszC2MAByCtFHF1KsYFq108cZxAQr8V
	 cs9ZgBSWA+7g6Giw413PCK3gPIy5NX5yuWV6n8OYQvbXnYGvJXGJ9PZUiL9Xh8xYp1xqq
	 7UCNlpNplRlyuNCrniMurTNl4WwXFz1iLdPukd0aNe+IkJPdVC3sE9PLNdCLtuXevSxJR
	 PRFSKEfQghxhCCaBzFqbPQKokzdfLNgEUIsfd1l3JwpAEjXGzSjkojood24S/OIU8IqSS
	 eMm86cS5LpnoiitVMluJuWw8cyEhXXHG/laeMuZankoYoi9Xah6SKkSNt3dvkcinfHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pmX6W7OL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ED3606A31C
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 22:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pmX6W7OL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B0C1F000C1;
	Fri, 27 Nov 2026 22:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795816977;
	bh=8XKHycyHwtfhmNXx8dXpxgAlRmudDksO+XAk5jEhYuA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=pmX6W7OLwtezc1wrCKaGr9RyU7B9oPc1QBW2jclcPLHeFAwCUqhIyuvAtn34czuit
	 adSPdfR/HjxqO/a4ZYgS0hzBvcTNLfWxTvDovYU/xAzMDVYw4ALQyqZNNdFEwOE/fs
	 qWBh+RLp+dFNqKcTZpaSsTnInx72NIxHqVX14whk=
Date: Fri, 27 Nov 2026 14:02:57 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-15-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-15-4dd9e94ea9ac@kernel.org>
Subject: + mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix.patch added to mm-unstable branch
Message-Id: <20261127220257.94B0C1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: use tlb_can_delay_rmap() when unmapping
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb: use tlb_can_delay_rmap() when unmapping
Date: Fri, 27 Nov 2026 13:46:55 -0800

The combination of "mm/hugetlb: delay anon folio rmap removal until after
the TLB flush" and "mm/huge_memory: flush dirty file PMDs before removing
rmap" fails to build: the latter removed tlb_delay_rmap().

The old helper checked whether rmap removal could be delayed and set
tlb->delayed_rmap.  Its replacement, tlb_can_delay_rmap(), only checks
whether delaying is supported.  The state change now occurs when
__tlb_remove_folio_pages_size() queues a page with delay_rmap set.

Use the new predicate here.  This hugetlb path already passes delay_rmap
to __tlb_remove_page_size(), which calls that queueing helper.  It
therefore still sets tlb->delayed_rmap before the TLB flush and delayed
rmap removal; no separate assignment is needed.

Link: https://lore.kernel.org/r/20261116-fixes_hugetlb-v2-15-4dd9e94ea9ac@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix
+++ a/mm/hugetlb.c
@@ -5541,7 +5541,7 @@ static void hugetlb_unmap_range(struct m
 		 * entries are gone, unless the mm has no users left.
 		 */
 		if (folio_test_anon(folio) && !tlb->fullmm) {
-			delay_rmap = tlb_delay_rmap(tlb);
+			delay_rmap = tlb_can_delay_rmap();
 			/*
 			 * Without delay-rmap support, just flush before
 			 * dropping the PTL. Except with MMU_GATHER_NO_GATHER
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
scripts-bloat-o-meter-describe-output-fields-in-help-text-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

