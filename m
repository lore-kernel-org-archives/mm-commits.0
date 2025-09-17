Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652B7258A
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 00:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758070233; cv=none; b=gmSPmvem2zpkyVZkWmNGI6fEmiEKcDjVReRHyGVVI+Xwl4S8VzyqPS+80gehovZXnExFyYJYYSdLTAORCQaP87tYqvEzsneneqb4m1CwXohIh7HvdAQyXTPT0GBKhiumJb+R1153Y9dC9LkDdf69MCi0pF5sZeZyoGrlk2+7YIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758070233; c=relaxed/simple;
	bh=rrkTg2F/44HPZb6zpzhJcuMpf0/9ZW3jwVzfeqnWyU8=;
	h=Date:To:From:Subject:Message-Id; b=pUrZspgtKSVHeHEFAn0QIUB5CzhYBR2DPhbK5C7wHSwnnXwKbqbLvjNbioaF51q4gg3at8EVzKC7M7t/fSM7Ze5Xho+fSS1mX7CrDCpgCjq5dIXR1yFw+9J2DtHWA9D2nv51LHywQew4KzEw96fXwPSpxkSzVWY6KF75QcpDFOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1nLyjoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1nLyjoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A181C4CEEB;
	Wed, 17 Sep 2025 00:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758070232;
	bh=rrkTg2F/44HPZb6zpzhJcuMpf0/9ZW3jwVzfeqnWyU8=;
	h=Date:To:From:Subject:From;
	b=I1nLyjoOVYwoSFnPDmGQHKaxTX2aUDjDewmL7Ya3biNcCdgOIm3mczvIQYqXWGaD2
	 9DOGAPTRMh90DB3vmh2AWylgWNS0NCmqdy6Xbc56T4HNLylvJGArdH3j+orTM813Sr
	 jF5hG7fjUtu19dBoBzzlcENCeCgm+LvGq73R757o=
Date: Tue, 16 Sep 2025 17:50:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-expose-negative-idle-time.patch added to mm-new branch
Message-Id: <20250917005032.1A181C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: expose negative idle time
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-expose-negative-idle-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-expose-negative-idle-time.patch

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

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch
mm-damon-core-implement-damon_initialized-function.patch
mm-damon-stat-use-damon_initialized.patch
mm-damon-reclaim-use-damon_initialized.patch
mm-damon-lru_sort-use-damon_initialized.patch
samples-damon-wsse-use-damon_initialized.patch
samples-damon-prcl-use-damon_initialized.patch
samples-damon-mtier-use-damon_initialized.patch
mm-damon-stat-expose-the-current-tuned-aggregation-interval.patch
mm-damon-stat-expose-negative-idle-time.patch

