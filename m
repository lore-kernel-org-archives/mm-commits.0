Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A850A274B30;
	Fri, 31 Oct 2025 03:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761881391; cv=none; b=OZzPMrE/Tj72mH47e+WX29Nd0SNKlCuv9JgmoN1ndc/8ctszTXJvkszVRKHRYjkcjUhoCnj8YVwUZjCNr1p25oAP0PtArT3YBJQ8UYm+tjNyuegSn91hHem031jo3McEq5Bju/XIy24tiax5e/cbSqTXId2k6eZQzmsUhTUZCPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761881391; c=relaxed/simple;
	bh=WYhyJg3qpUSKmjFB1UvxzcohYrOki3OK0ui64z+Qf4s=;
	h=Date:To:From:Subject:Message-Id; b=oMH+A4xImpVyjE5kMgDchtL1wq5eO5F4ZmPMWDxwwzVefN1c/b3pWmOUE3hG8BwO1dxGe/QuioCiHTFlCDWacs2Ouz8xAQF9RF1t+yyNZBAzr8BoT86uAMVcD7+PaStzyMLWLNkFuGeJf52IIrQw9FyH9wCpTDnhfiDe09QJuhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Laaw1Pzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Laaw1Pzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3EBC4CEF1;
	Fri, 31 Oct 2025 03:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761881391;
	bh=WYhyJg3qpUSKmjFB1UvxzcohYrOki3OK0ui64z+Qf4s=;
	h=Date:To:From:Subject:From;
	b=Laaw1PzfETMHfH2gSK5qJIeqTmFWsHuAjJihtFEi+yjnWLG2aZPVhGb7pQUApmWR/
	 hPZasYqZF4KR5W7X1F7WswznEqwtEknyuJbaSSgAeiqgTGzH9VXrQQocBpIcH6MI7O
	 9sstxLlxfbPK045s2eyN8MF4UrG4jUTwepG6pDXg=
Date: Thu, 30 Oct 2025 20:29:50 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable.patch added to mm-hotfixes-unstable branch
Message-Id: <20251031032950.EA3EBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: change last_refresh_jiffies to a global variable
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Quanmin Yan <yanquanmin1@huawei.com>
Subject: mm/damon/stat: change last_refresh_jiffies to a global variable
Date: Thu, 30 Oct 2025 10:07:45 +0800

Patch series "mm/damon: fixes for the jiffies-related issues", v2.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier.  However, this may cause the
time_before() series of functions to return unexpected values, resulting
in DAMON not functioning as intended.  Meanwhile, similar issues exist in
some specific user operation scenarios.

This patchset addresses these issues.  The first patch is about the
DAMON_STAT module, and the second patch is about the core layer's sysfs.


This patch (of 2):

In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
avoid unnecessarily frequent stat update.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier.  However, this causes time_before_eq()
in DAMON_STAT to unexpectedly return true during the first 5 minutes after
boot on 32-bit systems (see [1] for more explanation, which fixes another
jiffies-related issue before).  As a result, DAMON_STAT does not update
any monitoring results during that period, which becomes more confusing
when DAMON_STAT_ENABLED_DEFAULT is enabled.

There is also an issue unrelated to the system's word size[2]: if the user
stops DAMON_STAT just after last_refresh_jiffies is updated and restarts
it after 5 seconds or a longer delay, last_refresh_jiffies will retain an
older value, causing time_before_eq() to return false and the update to
happen earlier than expected.

Fix these issues by making last_refresh_jiffies a global variable and
initializing it each time DAMON_STAT is started.

Link: https://lkml.kernel.org/r/20251030020746.967174-2-yanquanmin1@huawei.com
Link: https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com [1]
Link: https://lore.kernel.org/all/20251028143250.50144-1-sj@kernel.org/ [2]
Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable
+++ a/mm/damon/stat.c
@@ -46,6 +46,8 @@ MODULE_PARM_DESC(aggr_interval_us,
 
 static struct damon_ctx *damon_stat_context;
 
+static unsigned long damon_stat_last_refresh_jiffies;
+
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -130,13 +132,12 @@ static void damon_stat_set_idletime_perc
 static int damon_stat_damon_call_fn(void *data)
 {
 	struct damon_ctx *c = data;
-	static unsigned long last_refresh_jiffies;
 
 	/* avoid unnecessarily frequent stat update */
-	if (time_before_eq(jiffies, last_refresh_jiffies +
+	if (time_before_eq(jiffies, damon_stat_last_refresh_jiffies +
 				msecs_to_jiffies(5 * MSEC_PER_SEC)))
 		return 0;
-	last_refresh_jiffies = jiffies;
+	damon_stat_last_refresh_jiffies = jiffies;
 
 	aggr_interval_us = c->attrs.aggr_interval;
 	damon_stat_set_estimated_memory_bandwidth(c);
@@ -210,6 +211,8 @@ static int damon_stat_start(void)
 	err = damon_start(&damon_stat_context, 1, true);
 	if (err)
 		return err;
+
+	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
 	return damon_call(damon_stat_context, &call_control);
 }
_

Patches currently in -mm which might be from yanquanmin1@huawei.com are

mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable.patch
mm-damon-sysfs-change-next_update_jiffies-to-a-global-variable.patch
mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch
mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

