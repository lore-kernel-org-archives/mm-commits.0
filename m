Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA936D1A7;
	Sun, 31 Aug 2025 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756669389; cv=none; b=EXGIXdc8mqpXHy1vQVBofGwpTrn+b+harUCT6yi4TYxBt39FN+vH4KxQXNWsvaBlWly6w2qixp/RUQWS1z11ixM9sGDc2m/H9gySKpTFaQp0k5ORGcGsphljSXozojbIM0aL+q0ouR2n/Gqc37bU99GvBqAbNcyOiZ/+A3Culn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756669389; c=relaxed/simple;
	bh=0+geXnx95akkonkZ6FED+Li8jqBfmJr0gZE/q508luk=;
	h=Date:To:From:Subject:Message-Id; b=KiD49mo8fH0V7xNA4SoZ+dKwS+7yn/pjApYNjZRjgORRamzriL6SIOr7s6CsQueUvJpfw9rkPdLiEjZG/K32756nx+dx4JedH1YnCyCw03felGdcse/XUdiymwf9cm1FNC6tQYe9/HgOLnNnASHTUEqwZ4aJBXcOOJKD5QRnzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uqA4vUmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uqA4vUmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D1DC4CEED;
	Sun, 31 Aug 2025 19:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756669389;
	bh=0+geXnx95akkonkZ6FED+Li8jqBfmJr0gZE/q508luk=;
	h=Date:To:From:Subject:From;
	b=uqA4vUmCkEG2ZA4IZirOryWBxR4LtcG9OTQOc8FPtxCiYuJ1c5sz3GJ13aPc0t4Vv
	 tw9pNUSJaHfPPFrNeif7U2hy+mzIRoDVxb/G3SCh11PITSFfVX1cYm/7QmqGuhP6DL
	 hFqRzxRCEPILZDulNgLQuG+M8DG1DTQywIovT/4w=
Date: Sun, 31 Aug 2025 12:43:08 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,stable@vger.kernel.org,shivankg@amd.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch added to mm-new branch
Message-Id: <20250831194309.62D1DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Revert "mm: vmscan.c: fix OOM on swap stress test"
has been added to the -mm mm-new branch.  Its filename is
     mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch

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
Subject: mm: Revert "mm: vmscan.c: fix OOM on swap stress test"
Date: Sun, 31 Aug 2025 02:13:55 -0700 (PDT)

This reverts commit 0885ef4705607936fc36a38fd74356e1c465b023: that
was a fix to the reverted 33dfe9204f29b415bbc0abb1a50642d1ba94f5e9.

Link: https://lkml.kernel.org/r/bd440614-3d2c-31d6-1b8f-9635c69cef7c@google.com
Fixes: 0885ef470560 ("mm: vmscan.c: fix OOM on swap stress test")
Signed-off-by: Hugh Dickins <hughd@google.com>
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
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test
+++ a/mm/vmscan.c
@@ -4500,7 +4500,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-folio_expected_ref_count-when-pg_private_2.patch
mm-gup-check-ref_count-instead-of-lru-before-migration.patch
mm-gup-local-lru_add_drain-to-avoid-lru_add_drain_all.patch
mm-revert-mm-gup-clear-the-lru-flag-of-a-page-before-adding-to-lru-batch.patch
mm-revert-mm-vmscanc-fix-oom-on-swap-stress-test.patch
mm-folio_may_be_cached-unless-folio_test_large.patch
mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

