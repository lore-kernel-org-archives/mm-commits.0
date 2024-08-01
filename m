Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0577913E04C
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 23:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722556195; cv=none; b=nI3S1jD1yMH9Hnp6JCdV+0TOWNvxfN4KWfjHDSwVzbzrN8t/QELbFkSJo+tc1JbNm7/uSr0vBj0/u/gcRx7TxkQvXFia71fJIcl3bVfZ2ONZnOma49ppeGFaCqAC9PYSlt+3n65HQQ3i4L/2oiX4Gcaw4MN+J25x6XUCgMd1cEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722556195; c=relaxed/simple;
	bh=M4JG9Lf2YO0jO5P47vupF4Png+hQ10g6hlcMHzGA5Uc=;
	h=Date:To:From:Subject:Message-Id; b=jEl+ZW8YZYblH44zItFwDzNGRJpve6B8B67GqBrUS/GMl3liboiWy9W3sbVGF6uWXrrLpPLcPh6HPg0e4SYwx/y5tkJhyZgjRjM6qebo8Sy32bmFamqK5VVweA3NUZBWAw0tAjIYGZCBMHXYlqcVc1NrS7raWGk0cGazOf783Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ys3rMW7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ys3rMW7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B135C32786;
	Thu,  1 Aug 2024 23:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722556194;
	bh=M4JG9Lf2YO0jO5P47vupF4Png+hQ10g6hlcMHzGA5Uc=;
	h=Date:To:From:Subject:From;
	b=Ys3rMW7uOY0dH41h6Hcyj1gI/LK7Hf3zkCQ1bC6I56LYGFpbGz4rykvQ2zAKPFvVB
	 p+wF8jcwJRtt+6zj7sHsXs4gSwsfn5z5xaGEcrksa5p9OxMJ0SJoI2diFR4LOwYqr9
	 U5CbHgFDiaSd0HDz98x86k86R1naW3/96lbf8gQw=
Date: Thu, 01 Aug 2024 16:49:53 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch added to mm-unstable branch
Message-Id: <20240801234954.7B135C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: create promo_wmark_pages and clean up open-coded sites
has been added to the -mm mm-unstable branch.  Its filename is
     mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch

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
From: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Subject: mm: create promo_wmark_pages and clean up open-coded sites
Date: Thu, 1 Aug 2024 23:25:47 +0000

Patch series "mm: print the promo watermark in zoneinfo", v2.


This patch (of 2):

Define promo_wmark_pages and convert current call sites of wmark_pages
with fixed WMARK_PROMO to using it instead.

Link: https://lkml.kernel.org/r/20240801232548.36604-1-kaiyang2@cs.cmu.edu
Link: https://lkml.kernel.org/r/20240801232548.36604-2-kaiyang2@cs.cmu.edu
Signed-off-by: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 kernel/sched/fair.c    |    2 +-
 mm/vmscan.c            |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-create-promo_wmark_pages-and-clean-up-open-coded-sites
+++ a/include/linux/mmzone.h
@@ -671,6 +671,7 @@ enum zone_watermarks {
 #define min_wmark_pages(z) (z->_watermark[WMARK_MIN] + z->watermark_boost)
 #define low_wmark_pages(z) (z->_watermark[WMARK_LOW] + z->watermark_boost)
 #define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
+#define promo_wmark_pages(z) (z->_watermark[WMARK_PROMO] + z->watermark_boost)
 #define wmark_pages(z, i) (z->_watermark[i] + z->watermark_boost)
 
 /*
--- a/kernel/sched/fair.c~mm-create-promo_wmark_pages-and-clean-up-open-coded-sites
+++ a/kernel/sched/fair.c
@@ -1742,7 +1742,7 @@ static bool pgdat_free_space_enough(stru
 			continue;
 
 		if (zone_watermark_ok(zone, 0,
-				      wmark_pages(zone, WMARK_PROMO) + enough_wmark,
+				      promo_wmark_pages(zone) + enough_wmark,
 				      ZONE_MOVABLE, 0))
 			return true;
 	}
--- a/mm/vmscan.c~mm-create-promo_wmark_pages-and-clean-up-open-coded-sites
+++ a/mm/vmscan.c
@@ -6669,7 +6669,7 @@ static bool pgdat_balanced(pg_data_t *pg
 			continue;
 
 		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-			mark = wmark_pages(zone, WMARK_PROMO);
+			mark = promo_wmark_pages(zone);
 		else
 			mark = high_wmark_pages(zone);
 		if (zone_watermark_ok_safe(zone, order, mark, highest_zoneidx))
_

Patches currently in -mm which might be from kaiyang2@cs.cmu.edu are

mm-consider-cma-pages-in-watermark-check-for-numa-balancing-target-node.patch
mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch
mm-print-the-promo-watermark-in-zoneinfo.patch

