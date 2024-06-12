Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB662904
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 18:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718217049; cv=none; b=s8hhpDWkaqMndJoQPOTUqlO7jjfCKkO41YpwnVbae9xfCxHlJ5TCNzSzOmRqc0ZcpvzcfDSvtXnS5kulk6r2A/6fIEh44gWnlyrkC1qxoMHcf3LQKMLVviFR5QT9/Ju94UCZjummbNDqig8kV3d92WOKuuxqv3F4Yy6vnDMS4uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718217049; c=relaxed/simple;
	bh=SOt9eRSY4fV354EGoQo3+y95Hm1fphBhHK/9yHDbpN4=;
	h=Date:To:From:Subject:Message-Id; b=L+yVDqcK7Tu9B9h0bO2T52bXwG9ZGkrmEewO4YeBxJ8AtoTFJKTCe3CuwM6g5jPrXVHi7/+JTk9yFsQr0QDUyFPHRdY5cq0fuQD2C9sxeMTytJkgEUF5ZT+IlcOO17vVZitRYRgjv9Eq3oH35QGMeJnV0i6jh+hNn+OyC7W6BJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lcYAFZ1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lcYAFZ1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EF0C32786;
	Wed, 12 Jun 2024 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718217049;
	bh=SOt9eRSY4fV354EGoQo3+y95Hm1fphBhHK/9yHDbpN4=;
	h=Date:To:From:Subject:From;
	b=lcYAFZ1xhKgGuOPQiu1sr3TE+xv3wDeXQZaZRXwUtAuXAIe6oPyAFSYskLce06nrn
	 p4uPAcArY30skrlGU1ZCiygGr4Ar0ymm0U9Gu3xK2oCsR0jFoDbuR6k15KmBgEdT83
	 Q25JQ3PCGQLzz5O/Y3dHaV9ynlA6qi5778L343jQ=
Date: Wed, 12 Jun 2024 11:30:48 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch added to mm-unstable branch
Message-Id: <20240612183049.60EF0C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: do not start/end writeback for pages stored in zswap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch

This patch will later appear in the mm-unstable branch at
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
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: do not start/end writeback for pages stored in zswap
Date: Mon, 10 Jun 2024 15:30:37 +0100

Most of the work done in folio_start_writeback is reversed in
folio_end_writeback.  For e.g.  NR_WRITEBACK and NR_ZONE_WRITE_PENDING are
incremented in start_writeback and decremented in end_writeback.  Calling
end_writeback immediately after start_writeback (separated by
folio_unlock) cancels the affect of most of the work done in start hence
can be removed.

There is some extra work done in folio_end_writeback, however it is
incorrect/not applicable to zswap:
- folio_end_writeback incorrectly increments NR_WRITTEN counter,
  eventhough the pages aren't written to disk, hence this change
  corrects this behaviour.
- folio_end_writeback calls folio_rotate_reclaimable, but that only
  makes sense for async writeback pages, while for zswap pages are
  synchronously reclaimed.

Link: https://lkml.kernel.org/r/20240612100109.1616626-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20240610143037.812955-1-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_io.c~mm-do-not-start-end-writeback-for-pages-stored-in-zswap
+++ a/mm/page_io.c
@@ -196,9 +196,7 @@ int swap_writepage(struct page *page, st
 		return ret;
 	}
 	if (zswap_store(folio)) {
-		folio_start_writeback(folio);
 		folio_unlock(folio);
-		folio_end_writeback(folio);
 		return 0;
 	}
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch

