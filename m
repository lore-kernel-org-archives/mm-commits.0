Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672122;
	b=E6eGp6Wd+RCECQDI2vshcR6CIMJWvNkiLcW08CjFTU9RePkWppJEpCNjG4KScjUUK/zO
	 5Ic2lPieZaEMyLnZaLzUv1Ij6NfnpwSwru38KDFyaomJPEUbRB8pWBuZBbKHnB2LOq7Lr
	 ea2GjH4Uxb5GsyTeyLGxJDfdvW4qYzPl0qU5V5rj7K+HPbghAKYipCZcM2+gh9CrUILi9
	 8i0u9oRLPV1xrQo2uM0BSGFfyy13cWjVg73IjGuwhQWsQ0jFONOmNM0od+rrGN85c2sLZ
	 fKgEGYXixfDyNAdVd75MPcvhqCFyKiS8iR5kFpeKfE2boKQD6XelDvDnlvK3PfEVR0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672122;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uUpV1F8P8CBFp2CWGXMjSMa8gjPpB32uX2M0K1SN6Js=;
	b=L5OD4U+YfneEt8jTgJJGsCRz3m39dvLRLl7aswEJ5IT4BU1es450ykME20iyYU5xIivn
	 LiJwl5X1TtIC0vCGc1Prwi1Ejg5ivyTfYd2t8NE3m5oXs6lVI5Ouo+BmetAoblBKk7X5j
	 Knv+wx9v3nE27BQhMP471LlPrGAPcN5nPc76+Ny8RWMXWHM1ARoLVVLdhTn7oJfsYt3SZ
	 SlQzAJqBJsbxTfdon/9fKgFwEG3ct+KfM7OYZut+uOV0mcapTpd+SAaYwoLGHS9HQ7FlS
	 o5ioKQfAuTyc4PMBbRXVbbL+rcdVKdoILthJuR90N/ks6CpiR7azsWbQC4Q3KgAX3Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PZK4RVdq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB0D606A335;
	Tue,  3 Nov 2026 02:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PZK4RVdq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB211F00A15;
	Tue,  3 Nov 2026 02:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672122;
	bh=uUpV1F8P8CBFp2CWGXMjSMa8gjPpB32uX2M0K1SN6Js=;
	h=Date:To:From:Subject;
	b=PZK4RVdqvXos/uaK1YNz5xe3WHX4LpeHfnvJ+d9bHjaq0CqWsY6yvuD3ZSEg7ke9W
	 WRj2NdKj/ht9RuItuNLZ77mUFJJDKdT/JSJVXr49bGt2IkEx35iy9WP2V1HVcYa4FJ
	 XdlhyNBwyD4EdlCeRbcq0NVxNR8PfMbw35twiAM4=
Date: Mon, 02 Nov 2026 18:15:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,
	shr@devkernel.io,jack@suse.cz,gourry@gourry.net,dennylin0707@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch removed from -mm tree
Message-Id: <20261103021521.EDB211F00A15@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
Date: Wed, 21 Oct 2026 06:06:54 +0000

The ratios used by __wb_calc_thresh() are scaled to parts per million, but
the threshold and ratio operands are unsigned long.  On 32-bit kernels,
their multiplication can wrap before the result is assigned to u64.

For example, with a threshold of 25600 pages and the default maximum ratio
of 1000000, wb_max_thresh becomes 4125 pages instead of 25600.  The shared
threshold and minimum share calculations can overflow in the same way,
producing incorrect per-writeback dirty limits.

Use a u64 threshold for the three ratio multiplications and div_u64() to
retain the existing division order and rounding.

Link: https://lore.kernel.org/20261021060654.27855-1-dennylin0707@gmail.com
Fixes: ae82291e9ca4 ("mm: use part per 1000000 for bdi ratios")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: <stable@vger.kernel.org>
---

 mm/page-writeback.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/page-writeback.c~mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares
+++ a/mm/page-writeback.c
@@ -883,6 +883,7 @@ static unsigned long __wb_calc_thresh(st
 {
 	struct wb_domain *dom = dtc_dom(dtc);
 	struct bdi_writeback *wb = dtc->wb;
+	u64 threshold = thresh;
 	u64 wb_thresh;
 	u64 wb_max_thresh;
 	unsigned long numerator, denominator;
@@ -894,13 +895,14 @@ static unsigned long __wb_calc_thresh(st
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
-	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
+	wb_thresh = div_u64(threshold * (100 * BDI_RATIO_SCALE - bdi_min_ratio),
+			    100 * BDI_RATIO_SCALE);
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
 
-	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
+	wb_thresh += div_u64(threshold * wb_min_ratio, 100 * BDI_RATIO_SCALE);
 
 	/*
 	 * It's very possible that wb_thresh is close to 0 not because the
@@ -916,7 +918,7 @@ static unsigned long __wb_calc_thresh(st
 			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 8);
 	}
 
-	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	wb_max_thresh = div_u64(threshold * wb_max_ratio, 100 * BDI_RATIO_SCALE);
 	if (wb_thresh > wb_max_thresh)
 		wb_thresh = wb_max_thresh;
 
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch

