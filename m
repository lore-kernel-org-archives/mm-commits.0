Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983A62EE29F;
	Mon,  8 Sep 2025 22:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757370988; cv=none; b=h6cITDu8G/OZ3rz8yIXvUALHDSSYdJvQqoy7oCcT52FuhM245xch15JbVopMWf7RpNJZB2NkfBK63CZEwKBkQ4INMGNjDX+Ufs0R+W1AasHRknWwu6UnIlaE+ixma7zl7pW/JKSe6B1zF3SmG+dST4pN1KIFA7pex1WqNp9Uhik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757370988; c=relaxed/simple;
	bh=TCWprkcTGFARHI5F5pe75Amvfue9eR2WSZGg2/y4l8s=;
	h=Date:To:From:Subject:Message-Id; b=VuZoPN95wdEYy8RHoX1Zy5CMnR6Y9OjZddfw5dWQhuhRreeLSvUbc4acc4juEPWBo4HLIHw5EQjtxPMspiOgTrPO5xA79ugGjJk8JpxNLaqzUd/hCWNTrEpLSROergKR0nwbvUY1rbkrdN2yc/CPMbkPl6NkABXtDBLbPQxvJM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B1Nllx4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B1Nllx4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A8BC4CEF1;
	Mon,  8 Sep 2025 22:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757370988;
	bh=TCWprkcTGFARHI5F5pe75Amvfue9eR2WSZGg2/y4l8s=;
	h=Date:To:From:Subject:From;
	b=B1Nllx4CXi/O3jN5o5WmoqUS9F3eYI8+vIPqH8/Og++u3Iawf2KU7g+vYT9El/MZd
	 KHn2ryocFZMBzA1zt6xmRk19B9M+2u/JckeRHIDVKJwzlnduDDMSCawYmKicRdu1rV
	 EClwLv4R1MAwcuOTCz9DOtSjoOu3+GOKg/wuODN4=
Date: Mon, 08 Sep 2025 15:36:27 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch added to mm-hotfixes-unstable branch
Message-Id: <20250908223628.23A8BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: revert "mm: vmscan.c: fix OOM on swap stress test"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch

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
Subject: mm: revert "mm: vmscan.c: fix OOM on swap stress test"
Date: Mon, 8 Sep 2025 15:21:12 -0700 (PDT)

This reverts commit 0885ef470560: that was a fix to the reverted
33dfe9204f29b415bbc0abb1a50642d1ba94f5e9.

Link: https://lkml.kernel.org/r/aa0e9d67-fbcd-9d79-88a1-641dfbe1d9d1@google.com
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

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test
+++ a/mm/vmscan.c
@@ -4507,7 +4507,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from hughd@google.com are

mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_lru_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

