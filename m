Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB98E258A
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 00:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758070230; cv=none; b=p18p++NiUKqM2lUesumILPL+kkbNDAv6LkqSCHwBb9g+fdm+SlZR5PBvl0tCeEsBYV+VqFXYdiGrEh9q3nsee37RP4qwpQ/wCW/8FZFBZa1ZYMniers8bnvPh7haYdmQ5ldol1w2QMX0rZq7ry/LoyhhTn+qtQPRgFLt7Fm2lf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758070230; c=relaxed/simple;
	bh=YjQIGHgDPVSOfcY6eTPrBdfIMXiexbTnBLTI7APvkjg=;
	h=Date:To:From:Subject:Message-Id; b=S54/Gglkm3RQFC6xK5Iv6tD9jR9sySwVaNngSslzTH1/71ik6x02JPBkXQCgrugyqYpuZH6KhMmcqfX3+ycoSfxgiBuLX3BdjLxs+7JwPr88pki68SsNiQ19Vvo+rVWzuXCHkRudFpzvjgruvvXtkhImCAIkIHliDMiNIK2eFik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JhVjSgVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JhVjSgVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35337C4CEEB;
	Wed, 17 Sep 2025 00:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758070230;
	bh=YjQIGHgDPVSOfcY6eTPrBdfIMXiexbTnBLTI7APvkjg=;
	h=Date:To:From:Subject:From;
	b=JhVjSgVjd5ISFWZKlsY4Nj+fvIm4fpleR8qT7GLcQ1MVYZ/gitc8YL9g9B6DhxAlc
	 Ib9zRJcuADP/CAf5t1/0sglKmjjxzwuT5R8VQBEipHcrce8GIBnPXPHd2HG8+76xXJ
	 9+aqqQ3IPsDmZipP4Ouoj2hzkdtHpjMwztIqXixc=
Date: Tue, 16 Sep 2025 17:50:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-expose-the-current-tuned-aggregation-interval.patch added to mm-new branch
Message-Id: <20250917005030.35337C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: expose the current tuned aggregation interval
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-expose-the-current-tuned-aggregation-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-expose-the-current-tuned-aggregation-interval.patch

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

