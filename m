Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9392288D5
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 22:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758233005; cv=none; b=Uufju8hv2OqZB8+aFUYFxSLlYiLzbaBUaOd9ZTRxrvlunoMa4KAMx6nqFPN0RiKNQSVcRnIt11N2nXhZXCRYgO9d0eJ6jqfd5/SCn/mYIatyPi2mCgKECXeD34R8yqFGGBMNFLbbYAlKWotk52trDXPzMtpUp8/gjC5HunzITKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758233005; c=relaxed/simple;
	bh=NqZJ+mqvRgwQWWHWm47RnfVE2EoEwhVJZ3HHl3vV1C0=;
	h=Date:To:From:Subject:Message-Id; b=FuefCkOZVOnoX9gXDv6fWQRBJJPnz+YAYLgodvstxF3p6dYVaJrp6AYRSwqmIE8RvWkgFdwTgW+ETH8ONw20sv55uVaG8Zy9m257J/CzRV7V6rJJGm1U4DKiJivyjOtD7F6npW/xTaD9KMUuI2k8qgJURWRzlel+wL/2wogG75s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHZKq0TT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHZKq0TT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD276C4CEF0;
	Thu, 18 Sep 2025 22:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758233005;
	bh=NqZJ+mqvRgwQWWHWm47RnfVE2EoEwhVJZ3HHl3vV1C0=;
	h=Date:To:From:Subject:From;
	b=AHZKq0TTDekN1Zdq0Eknsl7mv8x5Y2pPgOJpv93d/Jq4M3c0UAT6nzWnhxXsnyJkX
	 +3o3Y59+uHl7+U8i5FxMfrM1iPfSrSooUEThe1Yc9o8K0rYV//IF4vJ2An0OshCNvl
	 mtKotbH19HSpL/zuuaWulcyt4QRkArpVPymuCZRA=
Date: Thu, 18 Sep 2025 15:03:24 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch added to mm-new branch
Message-Id: <20250918220324.DD276C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: simplify the folio refcount check in pageout()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: simplify the folio refcount check in pageout()
Date: Thu, 18 Sep 2025 11:46:54 +0800

Since we no longer attempt to write back filesystem folios in pageout()
(they will be filtered out by the following check in pageout()), and only
tmpfs/shmem folios and anonymous swapcache folios can be written back, we
can remove the redundant folio_test_private() when checking the folio's
refcount, as tmpfs/shmem and swapcache folios do not use the PG_private
flag.

While we're at it, we can open-code the folio refcount check instead of
adding a simple helper that has only one user.

Link: https://lkml.kernel.org/r/4cbbec5bb92397aa4597105f1f499aabf7a1901c.1758166683.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-simplify-the-folio-refcount-check-in-pageout
+++ a/mm/vmscan.c
@@ -477,17 +477,6 @@ static int reclaimer_offset(struct scan_
 	return PGSTEAL_DIRECT - PGSTEAL_KSWAPD;
 }
 
-static inline int is_page_cache_freeable(struct folio *folio)
-{
-	/*
-	 * A freeable page cache folio is referenced only by the caller
-	 * that isolated the folio, the page cache and optional filesystem
-	 * private data at folio->private.
-	 */
-	return folio_ref_count(folio) - folio_test_private(folio) ==
-		1 + folio_nr_pages(folio);
-}
-
 /*
  * We detected a synchronous write error writing a folio out.  Probably
  * -ENOSPC.  We need to propagate that into the address_space for a subsequent
@@ -696,8 +685,11 @@ static pageout_t pageout(struct folio *f
 	 * block, for some throttling. This happens by accident, because
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
+	 *
+	 * A freeable shmem or swapcache folio is referenced only by the
+	 * caller that isolated the folio and the page cache.
 	 */
-	if (!is_page_cache_freeable(folio))
+	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio))
 		return PAGE_KEEP;
 	if (!mapping) {
 		/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-the-strategy-for-the-tmpfs-huge=-options.patch
mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch

