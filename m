Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794964436;
	b=fK8tOc/3r0L9IbmD9/hafWFezfuu1LtmO2wNBq8PLNk18M4qKpT7Is51ckyiCriugQ1X
	 cspKl8DKi6EeCi7mm/yMZBV6fNULCaats+H38ACVJz4rk7wWdctbkv7/rU6fncs+kvOEf
	 86uo0aLic3+0HX58h36NH8D1I/QNvWs56DM6nxBbcHDUF+3uq3MlFci2jEnBSMuS6pgpm
	 gMdBZvQnQsR8c7khPAwg1w8QqlYDvD+0gfav4dIeANibonJI4K7u0jaUq6X0VDPDyG6sL
	 bqqGG3e2BMgfKHC89tT9CBxCtwrm1/QUEEjRXjrv6UteaKQO4ABrabyGx/bmMyGnfRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794964436;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9lI06JsKLWjoBxzl/hKszWfynAp1gbYZil/Azp9kmSw=;
	b=fnDLbiBgg8prwjnFXBEYU2oos/M1+JwsTFoFhXWRSc9lsjvqhyKvCUnp7d/yLOGZGeQh
	 5roR4+sn4i32wp4uCTggsEEudttcSYTNzUc3AueNQERY+ocCNJmIzEStPfWJWynkAz27A
	 8Gt5ciNLwzJbv7iFP3FeIQ6XWNr7oEBhoyRlttgJtX7PxgoSYSvW3XmH0kgjSNJuAhyGt
	 5DOJ9VJ8DI1cu+0CyQkoCTxS5C/h9iv1c41yG38gCmi/P0FG2x5pPqLHTfNieOGcjcSPQ
	 DrKtxmiMRxSb9zpUGx5eF5Cwl2qvsleRSjJwhlJjIL5zuHBnuDf2J+WurDgl3uNkerg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bJJnheqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88488606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 01:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bJJnheqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004281F000C4;
	Wed, 18 Nov 2026 01:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794964436;
	bh=9lI06JsKLWjoBxzl/hKszWfynAp1gbYZil/Azp9kmSw=;
	h=Date:To:From:Subject;
	b=bJJnheqZDZXN1MODET8yiQAA5cMcqOtEnqPjTNgLSGXDc1Xs6AlKRtArPzoLwgPck
	 PUc7qE9zIK4ogieYo6rYDkqs98+kUYB8kRDAR5DLWBsM4vQ5qwdVYG4k6HehDNt2oy
	 F3LSyAlZhCfNFWdLne8HQQw5HpEXhJHUzwg6tgsk=
Date: Tue, 17 Nov 2026 17:13:55 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,
	peterx@redhat.com,lokeshgidra@google.com,kasong@tencent.com,david@kernel.org,
	nakixii@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-check-exclusivity-of-the-page-being-moved.patch added to mm-new branch
Message-Id: <20261118011356.004281F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/userfaultfd: check exclusivity of the page being moved
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-check-exclusivity-of-the-page-being-moved.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-check-exclusivity-of-the-page-being-moved.patch

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
From: Eric Li <nakixii@gmail.com>
Subject: mm/userfaultfd: check exclusivity of the page being moved
Date: Wed, 18 Nov 2026 05:24:00 +0800

move_pages_ptes() gets the folio of a present source PTE and then checks
PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive is
per page, so for a PTE-mapped large folio this can give the wrong answer
for the page that is actually being moved.

This happens after fork().  fork() clears the flag on every page of the
folio.  Once the child exits, a write fault in the parent can reuse the
large folio, and do_wp_page() sets the flag again only on the faulting
page.  This case only exists since commit 1da190f4d0a6 ("mm: Copy-on-Write
(COW) reuse support for PTE-mapped THP").  Before that, the same state
could already come from fork() after MADV_DONTFORK on part of the folio,
or from reclaim when try_to_unmap() replaces the earlier pages with swap
entries and then fails on a later one.

Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though the
folio could be split and the page moved.  Callers that fall back to
UFFDIO_COPY on -EBUSY end up copying instead.  It also goes wrong the
other way: if the first page is exclusive and the page being moved is not,
the folio is split for nothing before the retry sees the shared page and
returns -EBUSY.

Check the flag on the page mapped by the source PTE and get the folio from
that page.  Locking, refcounting and the split-and-retry path stay the
same.  The batched path only handles small folios and the PMD path already
checks the page the PMD maps, so they don't need this.

Tested in an x86_64 KVM guest on mm-unstable with only 64K anonymous mTHP
enabled: map a 64K-aligned region backed by one large folio, fork, let the
child exit, write to the sixth page and move it.  Without this patch all
20 moves failed with -EBUSY.  With it all 20 worked and the data was
correct.  Moving the first page right after fork() still fails with
-EBUSY, as it should.  Writing to the first page instead and moving the
sixth fails with -EBUSY either way, but without this patch the folio was
also split all 20 times.  The move tests in uffd-unit-tests pass with and
without the patch (the two swap tests were skipped, there is no swap in
the guest).  I didn't reproduce the MADV_DONTFORK or reclaim cases and
didn't test arm64.

I found this with Claude Code while debugging an out-of-tree swap backend,
and it wrote the first version of the fix.  This version, the changelog
and the reproducer were also done with AI help.  I've reviewed all of it.

Link: https://lore.kernel.org/20261117212400.1890820-1-nakixii@gmail.com
Link: https://lore.kernel.org/all/20261116110122.309748-1-nakixii@gmail.com/
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Eric Li <nakixii@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Kairui Song <kasong@tencent.com>

 mm/userfaultfd.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-check-exclusivity-of-the-page-being-moved
+++ a/mm/userfaultfd.c
@@ -1560,6 +1560,7 @@ retry:
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			struct page *page;
 			bool locked;
 
 			/*
@@ -1573,13 +1574,20 @@ retry:
 				goto out;
 			}
 
-			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
-			if (!folio || !PageAnonExclusive(&folio->page)) {
+			/*
+			 * PG_anon_exclusive is per page. The first page of a
+			 * large folio can be shared while the page mapped here
+			 * is still exclusive, so check the page being moved.
+			 */
+			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
+			if (!page || !PageAnonExclusive(page)) {
 				spin_unlock(src_ptl);
 				ret = -EBUSY;
 				goto out;
 			}
 
+			folio = page_folio(page);
+
 			locked = folio_trylock(folio);
 			/*
 			 * We avoid waiting for folio lock with a raised
_

Patches currently in -mm which might be from nakixii@gmail.com are

mm-userfaultfd-check-exclusivity-of-the-page-being-moved.patch

