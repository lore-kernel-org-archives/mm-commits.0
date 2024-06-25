Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C81448EF
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291678; cv=none; b=RXOHNEHpmNwkFaH15wbLHHWSJ2MyU5eYRuGbearPKmVSYcTAOP41K4v0AW7N8hRbL4niSOXOwTbTWaEY3jJ2wF/xJQ2boqKde7Xlof7VZWCxd7RwoHIdYGJNp1MBBujRIjMqPL+iJJ4NlG4bAhA6cy03k1jD9VPYbg2Rdz3Up7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291678; c=relaxed/simple;
	bh=Pp9yYXiEvNiGSsl3CPkNNmUbcnlLXOxGT/ZRGpGddmM=;
	h=Date:To:From:Subject:Message-Id; b=XwY4I/TUjgAjtYW8Y/4TubsHxr3cO7bnpKJT+7F8G2TEKJDtUCOCdVTaf/INd+Ml2jp9OL3+3UVciArXI4VHlmPfQXlMlwlyqa+l3IuTji+CsUEO3vrvMjGeOCrcUHFm+O/ieYNHLMaRz92XVKl97vrW/hMSK2inJ1C543xs5Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ykemEuiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ykemEuiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38833C32782;
	Tue, 25 Jun 2024 05:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291678;
	bh=Pp9yYXiEvNiGSsl3CPkNNmUbcnlLXOxGT/ZRGpGddmM=;
	h=Date:To:From:Subject:From;
	b=ykemEuiUjZlW73nroa8YU4CvdCok6JBmcqU3s8FX7YD/SiXywEg8Miwj91LmwnB5c
	 uyymhiiglaWmQHNzRrf4VyjJJahc+Hpxx96ubqZPwqhANY0V5M/lr61U75JfKgdCqk
	 bPmYpKk2cMPvsVspWJRXiIuPajyHTwCS/7mJ42Yc=
Date: Mon, 24 Jun 2024 22:01:17 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,willy@infradead.org,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch removed from -mm tree
Message-Id: <20240625050118.38833C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: do not start/end writeback for pages stored in zswap
has been removed from the -mm tree.  Its filename was
     mm-do-not-start-end-writeback-for-pages-stored-in-zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap-v6.patch
mm-remove-code-to-handle-same-filled-pages.patch

