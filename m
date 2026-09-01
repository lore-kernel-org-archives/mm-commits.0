Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B9344162A
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 03:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788234009; cv=none; b=e1NCWYTxqvWNbeQZ4ibsTVCkcPnTMAPipRkn9WjyXCUrxBtAfdomPAp7L0lrqpy7nAxQPg19gDQtLk1NU4Ohf2hiicD3u+ojr1XZbH3U4SVYJ4MPE5pxoTTyMckaZUZ3Vl/MO+oPRYMMxG+0LbOd6QYb1+fOh3FSZ3ulHz0Amvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788234009; c=relaxed/simple;
	bh=ucrrkM4TotSG1t89+GUvaaTeA0r1qlaD4fjJ3sGD9FI=;
	h=Date:To:From:Subject:Message-Id; b=uaIpj8Nk03tv8qCe7lSrAIKJh0Q6f2lbNX7gi6xNV2Nlw53VpB9vL4c6p84veGx9M1AWLR/sV5sWAk2on+OySlXEuSpuuKtgFheDWbY2KmZFXRd87RUK7RiGsM5AB4ZYTj/udC29EGKdIZRliF2DVMr50VJMFu01jCoDmY+HYtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s9nq6Xcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s9nq6Xcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F46E1F000E9;
	Tue,  1 Sep 2026 03:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788234007;
	bh=bvV8O3sJ1SGHrwRD/5jm3uS7q3CBG8fZXFhZmCdP+xA=;
	h=Date:To:From:Subject;
	b=s9nq6XcwFPuNZzb8N0YbTImFifLYap7Rxv3LslZj8R6263sMG1HE6nAHZLlFW+cXb
	 Gq6nm4NL2jYoIprMXqfeppZDyYK82VP1AWB9cS3K6gsn/lp+27Nt34C9SNLL9VpIex
	 xTWpCT4v42MIjKDv1uJnU19desBgae9LI5XJ5cVA=
Date: Mon, 31 Aug 2026 20:40:07 -0700
To: mm-commits@vger.kernel.org,zhaonanzhe@xiaomi.com,youngjun.park@lge.com,xueyuan.chen21@gmail.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch added to mm-new branch
Message-Id: <20260901034007.7F46E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: avoid pointless large folio splits without swap
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/vmscan: avoid pointless large folio splits without swap
Date: Sun, 30 Aug 2026 12:29:19 +0800

When swap is disabled, exhausted, or unavailable due to memcg swap limits,
splitting a large anonymous folio cannot make swapout progress.  The
fallback only destroys the large folio and inflates split statistics.

Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
the folio might allow swapout of smaller pieces.  For other allocation
failures, keep the existing activation path and avoid the split.

This preserves the split fallback for fragmented or partially available
swap, while avoiding it when there is no backing space for any part of the
folio.

Link: https://lore.kernel.org/20260830042920.2280454-4-xueyuan.chen21@gmail.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-pointless-large-folio-splits-without-swap
+++ a/mm/vmscan.c
@@ -1262,6 +1262,8 @@ retry:
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1280,11 +1282,14 @@ retry:
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
 				if (!folio_test_large(folio))
 					goto activate_locked_split;
+				if (ret != -E2BIG)
+					goto activate_locked;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-make-retry-logic-explicit-in-isolate_folios.patch
mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch

