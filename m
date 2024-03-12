Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE814264F
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274067; cv=none; b=EL28q+WvjhRdDzHJXgWCwyuSHF7jn7ONtHHAk88SMr1BMhe2/cZmu/mTeuGxJOkcdnBPNm3ZtkyZ5T3gtR2RbYRjRWrOF2eV2dnIFY/8Rhr7iV1O9f+R0+t7a/yAdU+r7tBRyx9llWZCFt23PcAq6W0EVQM0GZZIFN2dLGJ7pZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274067; c=relaxed/simple;
	bh=2ofzmCYxmV1nKQylNXBlvKosfVXxlvKs36EFr0gGNsw=;
	h=Date:To:From:Subject:Message-Id; b=lSYxiVXxApQMVM3T0/nPIgfaih6BkWbJIjNHOvb0bpnaKx2IYTtvijwHle0VejAukwwp9bQ9XIZU0JEoOrXkuLxdeNaLY1qQ7A9R/q2SGS3rwTtFbgWyEH8u8ZHJQyKPfl1fDnGbF/34OhBPuTBHhRadKoxomKqnhEm5/Zv3axY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=su2hrbHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="su2hrbHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC4AC43394;
	Tue, 12 Mar 2024 20:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274067;
	bh=2ofzmCYxmV1nKQylNXBlvKosfVXxlvKs36EFr0gGNsw=;
	h=Date:To:From:Subject:From;
	b=su2hrbHJg2NCOStCh5Gt04CQR4p9GNfdgSBOYm7JmUj3km8mlU38rVJxYHog59pyp
	 8q4EtBumG88+10yT/hVhXTrT3Jf/UuxttlYbvHnSCfU94e+fgeyB/V3n+VRoHL0NsS
	 dbDWNHOCfTFPaBYEYkuLvLy2cNlcZ4nOyy+0G1s0=
Date: Tue, 12 Mar 2024 13:07:46 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,peterx@redhat.com,axelrasmussen@google.com,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-an-explicit-smp_wmb-to-uffdio_continue.patch removed from -mm tree
Message-Id: <20240312200746.EDC4AC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add an explicit smp_wmb() to UFFDIO_CONTINUE
has been removed from the -mm tree.  Its filename was
     mm-add-an-explicit-smp_wmb-to-uffdio_continue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: James Houghton <jthoughton@google.com>
Subject: mm: add an explicit smp_wmb() to UFFDIO_CONTINUE
Date: Thu, 7 Mar 2024 01:02:50 +0000

Users of UFFDIO_CONTINUE may reasonably assume that a write memory barrier
is included as part of UFFDIO_CONTINUE.  That is, a user may believe that
all writes it has done to a page that it is now UFFDIO_CONTINUE'ing are
guaranteed to be visible to anyone subsequently reading the page through
the newly mapped virtual memory region.

Today, such a user happens to be correct.  mmget_not_zero(), for example,
is called as part of UFFDIO_CONTINUE (and comes before any PTE updates),
and it implicitly gives us a write barrier.

To be resilient against future changes, include an explicit smp_wmb(). 
While we're at it, optimize the smp_wmb() that is already incidentally
present for the HugeTLB case.

Merely making a syscall does not generally imply the memory ordering
constraints that we need (including on x86).

Link: https://lkml.kernel.org/r/20240307010250.3847179-1-jthoughton@google.com
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c     |   17 +++++++++++++----
 mm/userfaultfd.c |    9 +++++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-add-an-explicit-smp_wmb-to-uffdio_continue
+++ a/mm/hugetlb.c
@@ -6780,11 +6780,20 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	}
 
 	/*
-	 * The memory barrier inside __folio_mark_uptodate makes sure that
-	 * preceding stores to the page contents become visible before
-	 * the set_pte_at() write.
+	 * If we just allocated a new page, we need a memory barrier to ensure
+	 * that preceding stores to the page become visible before the
+	 * set_pte_at() write. The memory barrier inside __folio_mark_uptodate
+	 * is what we need.
+	 *
+	 * In the case where we have not allocated a new page (is_continue),
+	 * the page must already be uptodate. UFFDIO_CONTINUE already includes
+	 * an earlier smp_wmb() to ensure that prior stores will be visible
+	 * before the set_pte_at() write.
 	 */
-	__folio_mark_uptodate(folio);
+	if (!is_continue)
+		__folio_mark_uptodate(folio);
+	else
+		WARN_ON_ONCE(!folio_test_uptodate(folio));
 
 	/* Add shared, newly allocated pages to the page cache. */
 	if (vm_shared && !is_continue) {
--- a/mm/userfaultfd.c~mm-add-an-explicit-smp_wmb-to-uffdio_continue
+++ a/mm/userfaultfd.c
@@ -845,6 +845,15 @@ ssize_t mfill_atomic_zeropage(struct use
 ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
 			      unsigned long len, uffd_flags_t flags)
 {
+
+	/*
+	 * A caller might reasonably assume that UFFDIO_CONTINUE contains an
+	 * smp_wmb() to ensure that any writes to the about-to-be-mapped page by
+	 * the thread doing the UFFDIO_CONTINUE are guaranteed to be visible to
+	 * subsequent loads from the page through the newly mapped address range.
+	 */
+	smp_wmb();
+
 	return mfill_atomic(ctx, start, 0, len,
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_CONTINUE));
 }
_

Patches currently in -mm which might be from jthoughton@google.com are


