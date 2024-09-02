Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115924C62E
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247739; cv=none; b=OM9SdCq58ODGSfftQKBgsW8uMTcRX7+QJd5WxfoiO/2iP5y25S8EO8sIqIjeILKyJFg+aQAvowU3fhml0k6Gr/1Y97z91VBk4+9Ip3ZUHkggpBy2D6jtnuYuUO6g+O7xkVbkg7XqIhm5OO2LxrLXUyLXOM+LzoCB509Kcz5QuZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247739; c=relaxed/simple;
	bh=HWnLU+qCVtKZxrwlO6NqxcxebuosQ49QmzeccTN0b/0=;
	h=Date:To:From:Subject:Message-Id; b=jJCOBAuFnLeBtucBK15caNXMCD2cShWrNOBFlYTkzr/b2g+WOaZNCsCkj/aZjgXo1M5YH0oCriI0oajQngjcm9erGe/N1RBqdk/GRO1NmOAN4jO2bUnsjNwITYWr4v7KchVnAiv4Qufkjt2BUgI1OVH5F+EY0NGFyXbEk+P3yik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciUvufN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciUvufN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C366C4CEC2;
	Mon,  2 Sep 2024 03:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247737;
	bh=HWnLU+qCVtKZxrwlO6NqxcxebuosQ49QmzeccTN0b/0=;
	h=Date:To:From:Subject:From;
	b=ciUvufN+rFiJW+ttY4t9Fb/olwKWe4lH4nbvPOGDRghO/Ia1a2UccM2Q8NooAGCYr
	 /5o9vjV1uQk3+llGuj3DONv+Nf3lvEVylC0TSJ2G/YYd3DbUJ/7Er2ddOjUV95v8f/
	 PBviGSpGpiFY9jQbl/syOei8FtMmu/W3KH41Lz5Y=
Date: Sun, 01 Sep 2024 20:28:57 -0700
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,kaiyang2@cs.cmu.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch removed from -mm tree
Message-Id: <20240902032857.9C366C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: create promo_wmark_pages and clean up open-coded sites
has been removed from the -mm tree.  Its filename was
     mm-create-promo_wmark_pages-and-clean-up-open-coded-sites.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -669,6 +669,7 @@ enum zone_watermarks {
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

mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations.patch
mmmemcg-provide-per-cgroup-counters-for-numa-balancing-operations-v4.patch

