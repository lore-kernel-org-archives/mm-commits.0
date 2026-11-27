Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795819254;
	b=kgk/X3TLpG2AogVHNRT2lhSMK5mCzHarNKsr+qgLILX1Q1OhEjHHWCaPiTS7b4Rj0Jxn
	 O2KvZU7AE9o0nTarlWl1OlLs3pXcRAae2yDto/knZ781FYSw5Lcnr9YncTTK58hObkBzg
	 FomdJSl2udvn0Neisbr/x6Epin2KsBvOpJ22oYoQSBvX1QEhsfpoi4mWAuO7GRCikwpLG
	 6X/U3mxMtftldBWwyZ9sZkn3avAY+yAnh9Xd+u66z24nTywQZEpzHyasTtFsIkFClKF6p
	 O8Rp13u9GlkI4qZNWamZyLwTs+6QaOYbSfl0hvrbrwjs7fl9JtxczD4vn7SuZ3BIsqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795819254;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=VGRJ/PN0m8XDLNwUmE0KO2G39AD2uf0xlZILzTN4dng=;
	b=5jjjDIiFYbJ/uGWmRztmfe+oSfCEeLHOFGFXqmTa3erIzTNXRGHR0hbbUvS12S8t6ZkN
	 CMorVOaXXOPwhGa+O0DTMtybLZC4H4i+Q7ZiD1qPKMnQvmwv4Zqwfe+Gl8TFbM4CRh9lm
	 qSee4JpZvFfRUmFEJ4jUHmk0i8/EmDoi/NL0BT49SqNgfvOfbnZfomouI9gsvGWTX92VY
	 duhEA6fNaV2vBCHavmKaG0P7OFItMRaH9rPFQ4fHqdSxbSnVFt2LCzO1ASzRHJhJ/gvsN
	 BkbqK/9aCDayYJ4dpSOaFSiw4bJBvvp8dN3939lSFe825LnKku1lmF2J7VaeZQW58Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bPw7tA8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD67F606A31C
	for <mm-commits@vger.kernel.org>; Fri, 27 Nov 2026 22:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bPw7tA8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8201F00893;
	Fri, 27 Nov 2026 22:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795819254;
	bh=VGRJ/PN0m8XDLNwUmE0KO2G39AD2uf0xlZILzTN4dng=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=bPw7tA8QskaikwvwWHYtd0GNOVu8PsxKJTTaHWSqcocEZjpXSkn6UCYB1FdH99YAR
	 jkMpl+oMp90lHVrJ71Br0utEpqnoNPWp6WpJ/gQduurBkqeN99CLHevzutVw58ArZe
	 J3/671m7GMgP0pbaj2BpWWZ6Cx7WxjGKg4+3brRQ=
Date: Fri, 27 Nov 2026 14:40:53 -0800
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-15-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-15-4dd9e94ea9ac@kernel.org>
Subject: + mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix-2.patch added to mm-unstable branch
Message-Id: <20261127224054.6E8201F00893@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/huge_memory: pass false to __tlb_remove_page_size()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix-2.patch

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
Subject: mm/huge_memory: pass false to __tlb_remove_page_size()
Date: Fri, 27 Nov 2026 14:38:54 -0800

"mm/hugetlb: delay anon folio rmap removal until after the TLB flush" adds
a delay_rmap argument to __tlb_remove_page_size(), but misses the call in
zap_huge_pmd_folio().  This breaks the build.

Pass false.  zap_huge_pmd_folio() removes the PMD rmap itself, either
before queueing the page or after its explicit TLB flush when handling a
dirty file-backed PMD.  Passing true would also queue the rmap for removal
by tlb_flush_rmaps(), removing it twice.

Link: https://lore.kernel.org/r/20261116-fixes_hugetlb-v2-15-4dd9e94ea9ac@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix-2
+++ a/mm/huge_memory.c
@@ -2543,7 +2543,7 @@ static void zap_huge_pmd_folio(struct mm
 	/* Device private folios are pinned and don't need a TLB flush. */
 	if (is_device_private)
 		folio_put(folio);
-	else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE))
+	else if (__tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE, false))
 		*force_flush = true;
 
 	if (delay_rmap) {
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
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush-fix-2.patch
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

