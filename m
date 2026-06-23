Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D5830C608;
	Tue, 23 Jun 2026 18:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241137; cv=none; b=PMju3iwNc5dfeAdhCqFzl/kalVXY/hKYD829ZH2cbWOX47xj+AV7xZ7M48327F+rr4uHlhRbGW66wDndAl+zNwL05w/Y1Z5Ho0hUNrIL7l7W5stN+n6npAGJPk0r9ZqkxVljbwjZnlW5rz44bNOgUmAa+tX3v4zxvOSSz0OdcMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241137; c=relaxed/simple;
	bh=tUwz1MLn/BZOz7PcqjWrLUp2F4k3oKpKxq+R89aZ8TA=;
	h=Date:To:From:Subject:Message-Id; b=ggP+0ENRaWF7QFrVuJIn1aXDzJynBhcvdK9lD8eXPZ++X3Cngh1Yg/LRIqcjSPKAbcayNxL2vVPABPIBPXT7SJdVOQKtl8rUiiO5R2wxRua1SkEvQFjOgK/fAA9Zmw/OYYVSswmIJISEelOKWlNizkGKhDkt+byh8qsNYR0Qq84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPhN/BFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPhN/BFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE1C1F000E9;
	Tue, 23 Jun 2026 18:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782241136;
	bh=kYRVF6hH9+7QEdbIYa2tN7tCPDTEIeHfLXPxCs+JSl4=;
	h=Date:To:From:Subject;
	b=sPhN/BFaUNAkUHGFs8vrUlB6NTngh/MX165iq6h5VYKGjW/Rn7wj+RFupTd4u2JNF
	 sdsUiwuvjolnYaQnWlcl2bLM0kRXSQOnZw0oJcMLLHlE81mYy08mXo+s1qIhpdPzeD
	 sFsOLiKRZP5g4CT5aLJFlAmMWLo0VKhcYt99lGtg=
Date: Tue, 23 Jun 2026 11:58:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch added to mm-hotfixes-unstable branch
Message-Id: <20260623185855.EBE1C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: handle extreme intervals in damon_hot_score()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/ops-common: handle extreme intervals in damon_hot_score()
Date: Tue, 23 Jun 2026 06:58:31 -0700

Fix three issues in damon_hot_score() that comes from wrong handling of
extreme (zero or too high) monitoring intervals user setup.

When the user sets sampling interval zero, damon_max_nr_accesses(), which
is called from damon_hot_score(), causes a divide-by-zero.  Needless to
say, it is a problem.

When the user sets the aggregation interval zero, the function returns
zero.  It is wrong, since the real maximum nr_acceses in the setup should
be one.  Worse yet, it can cause another divide-by-zero from its caller,
damon_hot_score(), since it uses damon_max_nr_accesses() return value as a
denominator.

When the user sets the aggregation interval very high, damon_hot_score()
could return a value out of [0, DAMOS_MAX_SCORE] range.  Since the return
value is used as an index to the regions_score_histogram array, which is
DAMOS_MAX_SCORE+1 size, it causes out of bounds array access.

The issues can be relatively easily reproduced like below.  The sysfs
write permission is required, though.

    # ./damo start --damos_action lru_prio --damos_quota_space 100M \
            --damos_quota_interval 1s
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/monitoring_attrs/intervals/sample_us
    # echo 0 > contexts/0/monitoring_attrs/intervals/aggr_us
    # echo commit > state
    # dmesg
    [...]
    [  131.329762] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [  131.336089] RIP: 0010:damon_hot_score+0x27/0xd0
    [...]

Fix the divide-by-zero intervals problems by explicitly handling the zero
intervals in damon_max_nr_accesses().  Fix the out-of-bound array access
by applying [0, DAMOS_MAX_SCORE] bounds before returning from
damon_hot_score().

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260623135834.67189-1-sj@kernel.org
Link: https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org [1]
Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    8 ++++++--
 mm/damon/ops-common.c |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score
+++ a/include/linux/damon.h
@@ -979,9 +979,13 @@ static inline bool damon_target_has_pid(
 
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
-	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
+	unsigned long sample_interval;
+	unsigned long max_nr_accesses;
+
+	sample_interval = attrs->sample_interval ? : 1;
+	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
+	return max_nr_accesses ? : 1;
 }
 
 
--- a/mm/damon/ops-common.c~mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score
+++ a/mm/damon/ops-common.c
@@ -140,6 +140,7 @@ int damon_hot_score(struct damon_ctx *c,
 	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
 	 */
 	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
+	hotness = max(min(hotness, DAMOS_MAX_SCORE), 0);
 
 	return hotness;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch

