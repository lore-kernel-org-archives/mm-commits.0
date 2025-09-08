Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6E42F4A01;
	Mon,  8 Sep 2025 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757370985; cv=none; b=TPiGK7+9/VJhab+o/PKLNmxXsrNzB7s/Ut7bGQ5rbf1W9bfcsAPZEUeDIqq4vFn+AsAVvdl0lGgEvOxTHcTAFcW0ad6WAwx06VfnlrAGN6AZqH85KWKRPu+knKLcESwVGTIP1fxJdYWHxO6ngqcsc3qILHDkd7tq8bjw0N4pHEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757370985; c=relaxed/simple;
	bh=BlkltI1RExD7fEzFuDq65s1R8CgS0X2wUzlbbGc9OjQ=;
	h=Date:To:From:Subject:Message-Id; b=FODAHzL9S2XDnqVO7eqWXkhgzoCvSMZQs+nbtlUdku7g7iLQnN1Goy1LAIQED6HwQfzbgHhsNrYRUTQrmjfbSSV7QaQcq7K1vRThfMcW9oZOGcTHpwsvwE0bt8YFFgTnpnNcABmrzd6IxwJVY5ctfMLl6X/wHvxHP1GUj30aeFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k5jk1miV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k5jk1miV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76E5C4CEF1;
	Mon,  8 Sep 2025 22:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757370984;
	bh=BlkltI1RExD7fEzFuDq65s1R8CgS0X2wUzlbbGc9OjQ=;
	h=Date:To:From:Subject:From;
	b=k5jk1miVQMqjcHmKc45z94c0yCw5kYb52EJBB8egsOU196rtCOTjQzASfB/dr96Bf
	 84tUEUdD1h60JtTZICI/8o6TyKFTRvMgOdV9FlDsIU6rQJi885Fc7h4DK2OmKXIkeD
	 BurfFAOYoiDpmHPtPwd21uxQt9FPL2dgXV8+l6KE=
Date: Mon, 08 Sep 2025 15:36:23 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch added to mm-hotfixes-unstable branch
Message-Id: <20250908223624.C76E5C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch

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
Subject: mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
Date: Mon, 8 Sep 2025 15:16:53 -0700 (PDT)

In many cases, if collect_longterm_unpinnable_folios() does need to drain
the LRU cache to release a reference, the cache in question is on this
same CPU, and much more efficiently drained by a preliminary local
lru_add_drain(), than the later cross-CPU lru_add_drain_all().

Marked for stable, to counter the increase in lru_add_drain_all()s from
"mm/gup: check ref_count instead of lru before migration".  Note for clean
backports: can take 6.16 commit a03db236aebf ("gup: optimize longterm
pin_user_pages() for large folio") first.

Link: https://lkml.kernel.org/r/66f2751f-283e-816d-9530-765db7edc465@google.com
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
Cc: Rik van Riel <riel@surriel.com>
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

 mm/gup.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all
+++ a/mm/gup.c
@@ -2287,8 +2287,8 @@ static unsigned long collect_longterm_un
 		struct pages_or_folios *pofs)
 {
 	unsigned long collected = 0;
-	bool drain_allow = true;
 	struct folio *folio;
+	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2307,10 +2307,17 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
-		if (drain_allow && folio_ref_count(folio) !=
-				   folio_expected_ref_count(folio) + 1) {
+		if (drained == 0 &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
+			lru_add_drain();
+			drained = 1;
+		}
+		if (drained == 1 &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
-			drain_allow = false;
+			drained = 2;
 		}
 
 		if (!folio_isolate_lru(folio))
_

Patches currently in -mm which might be from hughd@google.com are

mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_lru_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

