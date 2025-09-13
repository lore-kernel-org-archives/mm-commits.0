Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556C52580D7;
	Sat, 13 Sep 2025 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794163; cv=none; b=cFbNwuWjluEIx93v03hNmTihyeGmN7BBPFh6yhg2HJ6YBtjdmohZTnS3MtNVW0Lp79/eyu/mZavRVNcdZ95Fj5c0P2zhe4edkbbyCUzr0xedW8rA8DSjYjXS40Hi1bLPoicThNP+NBeeZqBQboSpsdRCjOiRSeFTz7wvbT/LPZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794163; c=relaxed/simple;
	bh=bhzs0fj816wE6CxlMtgobKMFxbygHSzrXTAMmlZm3Rk=;
	h=Date:To:From:Subject:Message-Id; b=q6LgQd2sHB6vomwTJGg+X6KJ9qk62QkbxQyckrrgtNJf3ZfV9QXAIy3U8DvpsmEu6Li88VBuFThCKw1L8XRaJh+U9pXrP9v2+7EzTkRd8YkGKkBrOvF6H3ycozfVzzkIZwTZm4oB0xRVz4S57q+XDaU0MTPNc9QDD7aWDjZbQkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vtJgnw8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vtJgnw8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DE3C4CEF5;
	Sat, 13 Sep 2025 20:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794162;
	bh=bhzs0fj816wE6CxlMtgobKMFxbygHSzrXTAMmlZm3Rk=;
	h=Date:To:From:Subject:From;
	b=vtJgnw8Hkvm4ouzWf5KmlX8pJoZgp/aLifQPF4S3mfdQt/HXA5t2G5zipu8SJ0Dcj
	 8JUxXHnjOCsOmCiedyAjzSCj9Q6H1qtMJegO5c9U3M/KuG2pGfM+CUzGJa+dEfUoJT
	 RfPM6Mn9Az/s+tf12eeqL+HhzKYFW0yrKrCPaseY=
Date: Sat, 13 Sep 2025 13:09:22 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch removed from -mm tree
Message-Id: <20250913200922.D4DE3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
has been removed from the -mm tree.  Its filename was
     mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

