Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8226306D23
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 22:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757370992; cv=none; b=tyAmiK7gN+P10SwSjJbN0XrmtE5JGFIlVA5FangAtB5eNNIrLO3ughAHA1QqQNLmJcEjvcjK4O1IrO0bCwsP/IRQFXaaFgiKvkgJ2YVCdbzInPS6KG+b1gSAejPL2qdZx4NUKJQCmtOA2P8EsEJSz/YTgt9toZgh/g/rqC8/EAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757370992; c=relaxed/simple;
	bh=oqrj9vv7Dkr4gHhgWxFDoOaF5iHDo4FKTo0LlPLqEYI=;
	h=Date:To:From:Subject:Message-Id; b=S2ZxVDIVazR8ZAkgO2VvjhIrZ/7ZQPV4rCA9icZ1cxRQvGryFzro8NKWbnqBMWxXBEEGiYjHjWP7S70ysc1bDtFmZRndYccXKFtrVQnI7Zgc+NOVWcWc3DntsbwZZ4wi6xguO7l9gbkxBiBsQ+rZYRYQj8p7HVCr3ryQua1S1RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a+9jDO9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a+9jDO9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD4AC4CEF1;
	Mon,  8 Sep 2025 22:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757370992;
	bh=oqrj9vv7Dkr4gHhgWxFDoOaF5iHDo4FKTo0LlPLqEYI=;
	h=Date:To:From:Subject:From;
	b=a+9jDO9KQFQ1fRZwRRNWwtVRhiftXEDP04oVReKUDI0X97cBRuw/UP0oB7SsLpVSt
	 vfb+x67x83I4XWYzlqIi0bXWwr6Hw09gIJhVsTTK2TAERh2q8ns5AXXbZ/kRHgXxDZ
	 08H4z/W27poBpVBMKghpWaC448EHEia7olZp4hNY=
Date: Mon, 08 Sep 2025 15:36:31 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-lru_add_drain_all-do-local-lru_add_drain-first.patch added to mm-hotfixes-unstable branch
Message-Id: <20250908223632.3BD4AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: lru_add_drain_all() do local lru_add_drain() first
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Mon, 8 Sep 2025 15:24:54 -0700 (PDT)

No numbers to back this up, but it seemed obvious to me, that if there are
competing lru_add_drain_all()ers, the work will be minimized if each
flushes its own local queues before locking and doing cross-CPU drains.

Link: https://lkml.kernel.org/r/33389bf8-f79d-d4dd-b7a4-680c4aa21b23@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
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

mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_lru_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

