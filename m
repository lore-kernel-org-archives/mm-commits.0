Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD926D1A7;
	Sun, 31 Aug 2025 19:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669380; cv=none; b=CfESQY7UeUbRwgUOwLlhGa+0nY5KNWhWcOdAvFsrTOxGrR6GCWIa8fpg5p9y0i61rxe/E1US08hlELJJlog1CBkGigxEMjtSGeHm18jAJXHuBwrGkYV/xOjonTKFEEDwwRB8GzW+UgC+hol7PzwzXmdAe03l27nBzminFkvHJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669380; c=relaxed/simple;
	bh=1j3C+v8sr9p4ph0rSuNFCHSRL1mdKN5oYs6fNa9pwFk=;
	h=Date:To:From:Subject:Message-Id; b=u/1gAa+prG2WNiR6cOfg74DHAdWl/tg3caS3ElmejxAKXCnEh2C6DKq/Tk/oTPXUxTDos761sbZG/06bkVbWTb2SaqhRkI+V27gDjR2yJ+xhCen4JKunBiMGgkKVbrtvcMLpI4QSloGyxRx79zbDdRtsLV9eDbGvuJu7BP3EwyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVkykXHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVkykXHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081C3C4CEED;
	Sun, 31 Aug 2025 19:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756669380;
	bh=1j3C+v8sr9p4ph0rSuNFCHSRL1mdKN5oYs6fNa9pwFk=;
	h=Date:To:From:Subject:From;
	b=rVkykXHRoEoPmz0aUBx2V1vYjMDpLGOA6XXbloJb9rHpfdZJH8vhUgUH6axB5M2eY
	 ItGfgLDdN0q2SAq+JDamWD/99g62cMEOKump9Cn7yHO3y6DEFj77WUqSpFsuA0viJO
	 kcBHoo6po5ZYTRQoj6MmFzqLsZWkxd9nGJFzZt7g=
Date: Sun, 31 Aug 2025 12:42:59 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-folio_expected_ref_count-when-pg_private_2.patch added to mm-new branch
Message-Id: <20250831194300.081C3C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix folio_expected_ref_count() when PG_private_2
has been added to the -mm mm-new branch.  Its filename is
     mm-fix-folio_expected_ref_count-when-pg_private_2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-folio_expected_ref_count-when-pg_private_2.patch

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
Subject: mm: fix folio_expected_ref_count() when PG_private_2
Date: Sun, 31 Aug 2025 02:01:16 -0700 (PDT)

6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
which (like PG_private, but not in addition to PG_private) counts for 1
more reference: it needs to be using folio_has_private() in place of
folio_test_private().

But this went wrong earlier: folio_expected_ref_count() was based on (and
replaced) mm/migrate.c's folio_expected_refs(), which has been using
folio_test_private() since 6.0 converted to folios(): before that,
expected_page_refs() was correctly using page_has_private().

Just a few filesystems are still using PG_private_2 a.k.a.  PG_fscache. 
Potentially, this fix re-enables page migration on their folios; but it
would not be surprising to learn that in practice those folios are not
migratable for other reasons.

Link: https://lkml.kernel.org/r/f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com
Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count calculation")
Fixes: 108ca8358139 ("mm/migrate: Convert expected_page_refs() to folio_expected_refs()")
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-fix-folio_expected_ref_count-when-pg_private_2
+++ a/include/linux/mm.h
@@ -2234,8 +2234,8 @@ static inline int folio_expected_ref_cou
 	} else {
 		/* One reference per page from the pagecache. */
 		ref_count += !!folio->mapping << order;
-		/* One reference from PG_private. */
-		ref_count += folio_test_private(folio);
+		/* One reference from PG_private or PG_private_2. */
+		ref_count += folio_has_private(folio);
 	}
 
 	/* One reference per page table mapping. */
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-folio_expected_ref_count-when-pg_private_2.patch
mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

