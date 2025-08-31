Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A12F6D1A7;
	Sun, 31 Aug 2025 19:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669383; cv=none; b=dBr3FJtJYWg19KdiMNiIPgEHjJIWi/M5vU3wEN8NBFPwRu2mKzxUsm77V7LyXd9pMAZA4o2YjIWntNOfrxKfjl8INPnWhAerSTX62yQf+tppRnonBxXohAPxrBgtgfaRBe8M7PFxP+8ZZJeKd30IyorMK0fmmjbnROCyqBhSbCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669383; c=relaxed/simple;
	bh=lA58dIfpXtAV3IwvBcMweWZ3IMrSt+FUYUOGTj9jSpA=;
	h=Date:To:From:Subject:Message-Id; b=I7tgNp1c5EUWVqVlrlSt3Ydz3vXU+1xc9tsQOc8eWrWf25HnXN2AOtcn2n+vGUNxz9E4/4emFOwq8nsUaYO7rhZ/cVCMJacdIeDJhFK28iXiLgOEEH8nIR/CXHSepkj/hVecG/3k5dgFrYnt+xSCtq2qA6vDEgaKe0qgU7fN8uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aoo4Atw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aoo4Atw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA6C4CEED;
	Sun, 31 Aug 2025 19:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756669382;
	bh=lA58dIfpXtAV3IwvBcMweWZ3IMrSt+FUYUOGTj9jSpA=;
	h=Date:To:From:Subject:From;
	b=aoo4Atw15R9l19y7XcHtuglLr4rAW534koVg8xuzq6tuZjmOTXHFh8QagnNHfkfA1
	 y14Ze5PXxnv3vib8uxZQfBweGcvCU1B60STNVyIR/IjCMi7wEfKX3qXzuG3uaGCepD
	 p1PsSBkmZmHLT4IDeXYxOaNDdEyNaJySo5ygfbXU=
Date: Sun, 31 Aug 2025 12:43:01 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-check-ref_count-instead-of-lru-before-migration.patch added to mm-new branch
Message-Id: <20250831194302.A5BA6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: check ref_count instead of lru before migration
has been added to the -mm mm-new branch.  Its filename is
     mm-gup-check-ref_count-instead-of-lru-before-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-check-ref_count-instead-of-lru-before-migration.patch

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
Subject: mm/gup: check ref_count instead of lru before migration
Date: Sun, 31 Aug 2025 02:05:56 -0700 (PDT)

Will Deacon reports:-

When taking a longterm GUP pin via pin_user_pages(),
__gup_longterm_locked() tries to migrate target folios that should not be
longterm pinned, for example because they reside in a CMA region or
movable zone.  This is done by first pinning all of the target folios
anyway, collecting all of the longterm-unpinnable target folios into a
list, dropping the pins that were just taken and finally handing the list
off to migrate_pages() for the actual migration.

It is critically important that no unexpected references are held on the
folios being migrated, otherwise the migration will fail and
pin_user_pages() will return -ENOMEM to its caller.  Unfortunately, it is
relatively easy to observe migration failures when running pKVM (which
uses pin_user_pages() on crosvm's virtual address space to resolve stage-2
page faults from the guest) on a 6.15-based Pixel 6 device and this
results in the VM terminating prematurely.

In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
mapping of guest memory prior to the pinning.  Subsequently, when
pin_user_pages() walks the page-table, the relevant 'pte' is not present
and so the faulting logic allocates a new folio, mlocks it with
mlock_folio() and maps it in the page-table.

Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch
by pagevec"), mlock/munlock operations on a folio (formerly page), are
deferred.  For example, mlock_folio() takes an additional reference on the
target folio before placing it into a per-cpu 'folio_batch' for later
processing by mlock_folio_batch(), which drops the refcount once the
operation is complete.  Processing of the batches is coupled with the LRU
batch logic and can be forcefully drained with lru_add_drain_all() but as
long as a folio remains unprocessed on the batch, its refcount will be
elevated.

This deferred batching therefore interacts poorly with the pKVM pinning
scenario as we can find ourselves in a situation where the migration code
fails to migrate a folio due to the elevated refcount from the pending
mlock operation.

Hugh Dickins adds:-

!folio_test_lru() has never been a very reliable way to tell if an
lru_add_drain_all() is worth calling, to remove LRU cache references to
make the folio migratable: the LRU flag may be set even while the folio is
held with an extra reference in a per-CPU LRU cache.

5.18 commit 2fbb0c10d1e8 may have made it more unreliable.  Then 6.11
commit 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding
to LRU batch") tried to make it reliable, by moving LRU flag clearing; but
missed the mlock/munlock batches, so still unreliable as reported.

And it turns out to be difficult to extend 33dfe9204f29's LRU flag
clearing to the mlock/munlock batches: if they do benefit from batching,
mlock/munlock cannot be so effective when easily suppressed while !LRU.

Instead, switch to an expected ref_count check, which was more reliable
all along: some more false positives (unhelpful drains) than before, and
never a guarantee that the folio will prove migratable, but better.

Note for stable backports: requires 6.16 commit 86ebd50224c0 ("mm: add
folio_expected_ref_count() for reference count calculation") and 6.17
commit ("mm: fix folio_expected_ref_count() when PG_private_2").

Link: https://lkml.kernel.org/r/47c51c9a-140f-1ea1-b692-c4bae5d1fa58@google.com
Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/linux-mm/20250815101858.24352-1-will@kernel.org/
Cc: <stable@vger.kernel.org>
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
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-check-ref_count-instead-of-lru-before-migration
+++ a/mm/gup.c
@@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
-		if (!folio_test_lru(folio) && drain_allow) {
+		if (drain_allow && folio_ref_count(folio) !=
+				   folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-folio_expected_ref_count-when-pg_private_2.patch
mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

