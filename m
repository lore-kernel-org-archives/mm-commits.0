Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE312C21F3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490030; cv=none; b=QHrXsNkctBWhW8vQqJPraK7nBYxPEPHKdCWEAWxKtB/ga8fyFusQTkIUvNREVzK5HGF3xGLHQ4GroGqX7YksIPAl2Z7HFXCvGASSYEqNtHZ0rH/q03QjP06zDWc725o5iBDaqOn7McaBIDrKcZgxqJbSFrwWGP6DKothRF3yENE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490030; c=relaxed/simple;
	bh=9Hl0nV7ZR27AharsJXH85BDsmSjyzdnnBOi3YJ48bsI=;
	h=Date:To:From:Subject:Message-Id; b=oMGHrhdRcfJiCl9+4B8GoRM1iMB1nljcD+s9ELgRFBxK5bvXFNowHTTM6VpxF/ccCKirgBl0pf1uEdTgB5OQXB29mRR2Gq9u9I+6Y2+iOGFBDGuMtnwrk9/8v1OqdpA424WrdQG/iuCIWeRxpY1IFcb1P8pYOsomKry3FZAO2Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JEVegdc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JEVegdc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFA6C4CEE7;
	Sun, 21 Sep 2025 21:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490030;
	bh=9Hl0nV7ZR27AharsJXH85BDsmSjyzdnnBOi3YJ48bsI=;
	h=Date:To:From:Subject:From;
	b=JEVegdc3JpI03lLoUNcxYSWM7/wWEO3WtiTRTPGHkgwXpQ1dsMunjDRNMe+0O+1FP
	 4lyqyPTrYkGdr87+ELX6MGZteM11uB/kSaUVGnFC/0aE2ur0zGwjD8q/kd413yWczl
	 vFbFdk+ss0cAzAMGVbcM8ceC3cx4z7+KCVa2Lc+0=
Date: Sun, 21 Sep 2025 14:27:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-expose-negative-idle-time.patch removed from -mm tree
Message-Id: <20250921212710.0AFA6C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: expose negative idle time
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-expose-negative-idle-time.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: expose negative idle time
Date: Tue, 16 Sep 2025 11:31:27 -0700

DAMON_STAT calculates the idle time of a region using the region's age if
the region's nr_accesses is zero.  If the nr_accesses value is non-zero
(positive), the idle time of the region becomes zero.

This means the users cannot know how warm and hot data is distributed,
using DAMON_STAT's memory_idle_ms_percentiles output.  The other stat,
namely estimated_memory_bandwidth, can help understanding how the overall
access temperature of the system is, but it is still very rough
information.  On production systems, actually, a significant portion of
the system memory is observed with zero idle time, and we cannot break it
down based on its internal hotness distribution.

Define the idle time of the region using its age, similar to those having
zero nr_accesses, but multiples '-1' to distinguish it.  And expose that
using the same parameter interface, memory_idle_ms_percentiles.

Link: https://lkml.kernel.org/r/20250916183127.65708-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-expose-negative-idle-time
+++ a/mm/damon/stat.c
@@ -34,8 +34,8 @@ module_param(estimated_memory_bandwidth,
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
-static unsigned long memory_idle_ms_percentiles[101] __read_mostly = {0,};
-module_param_array(memory_idle_ms_percentiles, ulong, NULL, 0400);
+static long memory_idle_ms_percentiles[101] __read_mostly = {0,};
+module_param_array(memory_idle_ms_percentiles, long, NULL, 0400);
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
 
@@ -61,10 +61,10 @@ static void damon_stat_set_estimated_mem
 		MSEC_PER_SEC / c->attrs.aggr_interval;
 }
 
-static unsigned int damon_stat_idletime(const struct damon_region *r)
+static int damon_stat_idletime(const struct damon_region *r)
 {
 	if (r->nr_accesses)
-		return 0;
+		return -1 * (r->age + 1);
 	return r->age + 1;
 }
 
@@ -122,7 +122,7 @@ static void damon_stat_set_idletime_perc
 		while (next_percentile <= accounted_bytes * 100 / total_sz)
 			memory_idle_ms_percentiles[next_percentile++] =
 				damon_stat_idletime(region) *
-				c->attrs.aggr_interval / USEC_PER_MSEC;
+				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
 	}
 	kfree(sorted_regions);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

