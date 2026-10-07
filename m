Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7D03168EB
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334322; cv=none; b=LmzCWWrltvv5YxGA8xOTqfsc+Dw90TDCNO9eJY4ge0k5JPQs2N+AQJN7dtM0bfPRPVvV/aTJMWdqUjwdqH1NmyGvTrLsWrK82tQkZe66In76zsPIvLoUUeFbYP6yyUOyKckYInM2QD29l0Tdc5Si09CAMJHizJnon4yTcTHqGek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334322; c=relaxed/simple;
	bh=mMQ3G7NOqAGuEpr1uX/1ZvPXUgENVfcIhGQ0vhHSBW8=;
	h=Date:To:From:Subject:Message-Id; b=XSHUOLPmfF1zcTybyWXMo6NVxRxLv6YMwEkGDgevMK9v+wkzChXdwEKTd0U7TT3eMjgDLjKfXgP2IDzFGrgCWOfbSesv5EKnWkTTH3hlcT20Z612Nv2rvFn37SVfqPtk88l6xvfTjqblTgp8L75qBoK/wUGKYUtQhLorkJTSwsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gydJlqf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gydJlqf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DA61F0089E;
	Wed,  7 Oct 2026 00:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334320;
	bh=K5qPuiURI8a1KUruOX2YWW7UkTewbIZupfcfAdutQUo=;
	h=Date:To:From:Subject;
	b=gydJlqf5RlWmvLBHMUCkd3X7+9MI6naNM30nOJ4Nm4KhDvTi0yA0OmbS9prs1s/3F
	 wPkNsBHHVfzbuyADEOow7Ee72vfP6IajznA8ZtmnHZZyHatq0S7D2naNtxIoNCc/gh
	 +/1SbGDkCh0EC49pfjxeY40NF/HS1Zl4Ns1E6fB4=
Date: Tue, 06 Oct 2026 17:52:00 -0700
To: mm-commits@vger.kernel.org,zhaonanzhe@xiaomi.com,youngjun.park@lge.com,xueyuan.chen21@gmail.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch removed from -mm tree
Message-Id: <20261007005200.D2DA61F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: avoid pointless large folio splits without swap
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-pointless-large-folio-splits-without-swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-pointless-large-folio-splits-without-swap
+++ a/mm/vmscan.c
@@ -1259,6 +1259,8 @@ retry:
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1277,11 +1279,14 @@ retry:
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

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

