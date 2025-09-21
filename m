Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE4F2C21DC
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490029; cv=none; b=DoY8a82uVqrfM/a/rJ6pjJv4/LfQyj5TmxEWAAMe6x+NF0949GrZYeXC4n+tjtJQk73belZuvDKReuq2Hn509BA5o/cxwMYNBeApkLTImuD/NNhmXw/aplmEsqUXjW3gkEdBBRju+aOyzZqVvDwPseEfZHPa7Lmh72Nbq6zh+6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490029; c=relaxed/simple;
	bh=0mrOT9SJVzsyfuSTfVvcXviMnW05mKAM6pNmduthsE0=;
	h=Date:To:From:Subject:Message-Id; b=hqcVdshyJeSlvf7xfcGJsFkYEUdMfSYacJsUvyPcBXFBXWLhGZpjdlRNhWBv21jntLZp0LcIAr94ejZBKO1PJlA1xxSqPc/O92YqTP/sOLN/EmCMBW4zCERcGwgEZwFF+/72ZeyX1K9/lD97LXK7Nf4qGAvHr1i8FHJOJSm0N8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fs+8/0zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fs+8/0zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA830C4CEE7;
	Sun, 21 Sep 2025 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490029;
	bh=0mrOT9SJVzsyfuSTfVvcXviMnW05mKAM6pNmduthsE0=;
	h=Date:To:From:Subject:From;
	b=fs+8/0zpUndW0BaMuvAHmWhch9p8/kZ/gJmDJoucJheXey3m6d9JAjYmaJcKQUEty
	 /PcbXEsPLqJPkeBAekUJO62CrIzAU63orLvloRNkuEB8sIlIXFR97Sq2sPN3TPTY1T
	 1dGa6+e0YzmprtJ40UlfiJxWhR6M5QNPnVSvdAIk=
Date: Sun, 21 Sep 2025 14:27:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-expose-the-current-tuned-aggregation-interval.patch removed from -mm tree
Message-Id: <20250921212708.EA830C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: expose the current tuned aggregation interval
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-expose-the-current-tuned-aggregation-interval.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: expose the current tuned aggregation interval
Date: Tue, 16 Sep 2025 11:31:26 -0700

Patch series "mm/damon/stat: expose auto-tuned intervals and non-idle
ages".

DAMON_STAT is intentionally providing limited information for easy
consumption of the information.  From production fleet level usages, below
limitations are found, though.

The aggregation interval of DAMON_STAT represents the granularity of the
memory_idle_ms_percentiles.  But the interval is auto-tuned and not
exposed to users, so users cannot know the granularity.

All memory regions of non-zero (positive) nr_accesses are treated as
having zero idle time.  A significant portion of production systems have
such zero idle time.  Hence breakdown of warm and hot data is nearly
impossible.

Make following changes to overcome the limitations.  Expose the auto-tuned
aggregation interval with a new parameter named aggr_interval_us.  Expose
the age of non-zero nr_accesses (how long >0 access frequency the region
retained) regions as a negative idle time.


This patch (of 2):

DAMON_STAT calculates the idle time for a region as the region's age
multiplied by the aggregation interval.  That is, the aggregation interval
is the granularity of the idle time.  Since the aggregation interval is
auto-tuned and not exposed to users, however, users cannot easily know in
what granularity the stat is made.  Expose the tuned aggregation interval
in microseconds via a new parameter, aggr_interval_us.

Link: https://lkml.kernel.org/r/20250916183127.65708-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250916183127.65708-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/stat.c~mm-damon-stat-expose-the-current-tuned-aggregation-interval
+++ a/mm/damon/stat.c
@@ -39,6 +39,11 @@ module_param_array(memory_idle_ms_percen
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
 
+static unsigned long aggr_interval_us;
+module_param(aggr_interval_us, ulong, 0400);
+MODULE_PARM_DESC(aggr_interval_us,
+		"Current tuned aggregation interval in microseconds");
+
 static struct damon_ctx *damon_stat_context;
 
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
@@ -133,6 +138,7 @@ static int damon_stat_damon_call_fn(void
 		return 0;
 	last_refresh_jiffies = jiffies;
 
+	aggr_interval_us = c->attrs.aggr_interval;
 	damon_stat_set_estimated_memory_bandwidth(c);
 	damon_stat_set_idletime_percentiles(c);
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

