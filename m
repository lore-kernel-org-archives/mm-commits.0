Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792621914;
	b=PJNq2A2M5SaRKVAQ7aEVhtkjTjoTsXtoYguJtA1R+pSTr/32M5QMTJnT+yUOQ6hdNSLh
	 Uc4Tz1H85JN3tytnXqgNDcZQbfr/J8abzkXxWuHCNRMYNOve6WKG4hFctGJLXapJOhS+/
	 jES17lg2LQq8UxlaU0OsUBYQ2g32iZwY6yQl8ChFCP/mMWiZDYL1Ipmo9seDGHF8Esx17
	 Iva/a0Xdte4maUbjMBU6vqnXp0vcLPjjckO0mgyooapoJFvQcR5O7aJVUl/ySCDxIN5uS
	 LH4azLcRZb3eunV56NyZoufo9uWzq/RHE8O4FpFGREJLZv6Qfz2QZF/Av8gbMyC+SOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792621914;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TWDAlm4aqzEjA3mDm8PjrMywwRtuZCz2pBJu4PwvRqE=;
	b=Xpmx754iSzsNllwj9394nj3TswNePnH9G0BBqbWFJB9e70ah76COnhVapREV3q5pMSnw
	 hhUeEL3n4DCr4ttA5eMUGqUjGFSt7So3Wq3/wWe0N57M3WM7ENg9IyZczSHHlP62RDpFJ
	 D/G8O5aBGECqP3vdLqgDRKWOVEaofJZNxZqBbLSuiD3IybRr0G6XJankdUvcj74BM0pQp
	 Vvl8VT7aJZXM1mYJU+NqxJl5OzOjk+pF78uWlRdsCUcseGHbIunWrPpJDYRKYSxWSXzji
	 ytRzZ5S4Fuwy/IJJQuV5/gGYcJS2+0SHp8yeU2s3U2UiImcwI2DlDyQ1/pz5u0JLZcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YKt2oOYS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5CF606A319;
	Wed, 21 Oct 2026 22:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YKt2oOYS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2233D1F000C1;
	Wed, 21 Oct 2026 22:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792621913;
	bh=TWDAlm4aqzEjA3mDm8PjrMywwRtuZCz2pBJu4PwvRqE=;
	h=Date:To:From:Subject;
	b=YKt2oOYSIOY9KWHIbSZ8V0kF79jJ0qTt7HtOAuA4wsHtD8cczhAv2Kog2Gd3cs9FA
	 +4b+YGxwktaYXrzrQfYWAxvKzefkVt1P3CiAYvbOPRgx7Wdv/Ad6sF4x0sNn2ZrtLH
	 Gk9X7yE7yQO37c7Hdzijgw1VnDA1B3B7FAZeeMgY=
Date: Wed, 21 Oct 2026 15:31:52 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,shr@devkernel.io,jack@suse.cz,gourry@gourry.net,dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch added to mm-unstable branch
Message-Id: <20261021223153.2233D1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch
compat-avoid-double-rounding-in-times.patch

