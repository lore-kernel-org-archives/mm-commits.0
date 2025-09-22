Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC633A1CD
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 22:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579225; cv=none; b=ZGH/olqTyNmqAp2p2opX+v668rDW82WW98H+VXYJ608D3+F+f0tet0vczp2yTpdO8rBA/Af88S3921eufsbTadh7VbXGdaIInboTcNYrcdxv0kAPVZWcdRh+xSzCMSWfXBoPad3MyKVLkvpmTfGqJbnd1lJldkTteJ1XEgdS50E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579225; c=relaxed/simple;
	bh=lGy9sqWLUYAyas3pLcgkvTAKF5qJXHd+minA3zCvQRE=;
	h=Date:To:From:Subject:Message-Id; b=ru+VmdAJmIy2wVV3Htf3+ZIE9QDFVTM8oFkQFmEz1Yo432LpSqYenBi2ZnPJsWTGezuuUMFQueIoeyeCQZ43Kg0zxxBQIN93HynXOGGkP/slc5rad/72KyT+XTPxsJ9phE0RaLFhLFF8DVbpTF6/kvbEqlzgtHKHc3EjR/JnMGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RW//m/Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RW//m/Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCEBC4CEF0;
	Mon, 22 Sep 2025 22:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758579224;
	bh=lGy9sqWLUYAyas3pLcgkvTAKF5qJXHd+minA3zCvQRE=;
	h=Date:To:From:Subject:From;
	b=RW//m/VsgkqUIgzTh8/kyT093E3Uz2CFGt9TMYA80SREKVM1bbrsk48/XuzAzjhmZ
	 /hF6SUCOu/xLApV2SUHrcvoz/YidiJlxeP30yDp1NbYGRhU52jaIYNV57kmjHxxe4+
	 zzS2BQZ2fqxVxhJ6wdp6wF2sVmn8NWcRrjmdGZr0=
Date: Mon, 22 Sep 2025 15:13:43 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix.patch added to mm-new branch
Message-Id: <20250922221344.AFCEBC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix.patch

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
Subject: mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix
Date: Mon, 22 Sep 2025 14:02:28 +0800

remove warning and comment, per Hugh

Link: https://lkml.kernel.org/r/392a9ca3-31ac-4447-bd44-3c656d63e4ca@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix
+++ a/mm/vmscan.c
@@ -689,16 +689,8 @@ static pageout_t pageout(struct folio *f
 	 * A freeable shmem or swapcache folio is referenced only by the
 	 * caller that isolated the folio and the page cache.
 	 */
-	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio))
+	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio) || !mapping)
 		return PAGE_KEEP;
-	if (!mapping) {
-		/*
-		 * We should no longer have dirty folios with clean buffers and
-		 * a NULL mapping. However, let's be careful for now.
-		 */
-		VM_WARN_ON_FOLIO(true, folio);
-		return PAGE_KEEP;
-	}
 
 	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
 		return PAGE_ACTIVATE;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix.patch

