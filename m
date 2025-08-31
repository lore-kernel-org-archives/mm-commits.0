Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5677F6D1A7
	for <mm-commits@vger.kernel.org>; Sun, 31 Aug 2025 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669397; cv=none; b=hTpMcdj6kakBjRHbNBdIcGDst8nSlKHGZdiIjsfKjog6kvkbPPRDMmkAyrWx6FL/LAwER62IOJPIAA9tDmeYp10DSiA6SG+TSXMF3ywK1Bc4qjlIp2mLyBnwdcxGPVs5nAG0py/qgW5KtWajWB45oc1bu1h2W6E5tUWRDqEz3J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669397; c=relaxed/simple;
	bh=KfNGjJ979cKRJwizzpQ4+EysVhd7EO4ApLskiNqbGHk=;
	h=Date:To:From:Subject:Message-Id; b=j4RSwPURhG6wQ5ethuPnMfIyg8LQ1pkF5c/fZAQJRmq4K97bG+cpAwoTucUu/HdC+PpVnlw+5HAqSMiVjOPyFfwyc2i9g01xFeI0OMygE/qkOoUEpvUBe8qxCIq2uMrBxoYMcDYSRa9tYPozR8yx671rQUNFHraZNbBrFUISnQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mmYLwe6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mmYLwe6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA771C4CEED;
	Sun, 31 Aug 2025 19:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756669394;
	bh=KfNGjJ979cKRJwizzpQ4+EysVhd7EO4ApLskiNqbGHk=;
	h=Date:To:From:Subject:From;
	b=mmYLwe6a4ncZaXOoVdkkQb2Kbtct4tfNz9rCQ6yWhE2N6v4prCXgNpAW6z4PCEoPQ
	 MLn2eeuW2AuOhYEBQJBRt0RgP+NrxamFm9ZYG1PsnBpkY0GKq6URpYTdfU6eq6MRqf
	 RnYLLEgreJ+Z1i8h2oLXDpMq+GcNaV1XYSw36irI=
Date: Sun, 31 Aug 2025 12:43:14 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,shivankg@amd.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lru_add_drain_all-do-local-lru_add_drain-first.patch added to mm-new branch
Message-Id: <20250831194314.CA771C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: lru_add_drain_all() do local lru_add_drain() first
has been added to the -mm mm-new branch.  Its filename is
     mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: lru_add_drain_all() do local lru_add_drain() first
Date: Sun, 31 Aug 2025 02:18:39 -0700 (PDT)

No numbers to back this up, but it seemed obvious to me, that if there are
competing lru_add_drain_all()ers, the work will be minimized if each
flushes its own local queues before locking and doing cross-CPU drains.

Link: https://lkml.kernel.org/r/c50129a4-a07e-869e-604e-3952f8530316@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swap.c~mm-lru_add_drain_all-do-local-lru_add_drain-first
+++ a/mm/swap.c
@@ -834,6 +834,9 @@ static inline void __lru_add_drain_all(b
 	 */
 	this_gen = smp_load_acquire(&lru_drain_gen);
 
+	/* It helps everyone if we do our own local drain immediately. */
+	lru_add_drain();
+
 	mutex_lock(&lock);
 
 	/*
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-folio_expected_ref_count-when-pg_private_2.patch
mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

