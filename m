Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79C52D77E2;
	Mon, 10 Nov 2025 05:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752035; cv=none; b=Z1l5ZOPRKD2ZTNOT3+tV1gsWLHpqFwJQr5SkpyKOdrjo2RnHK5MqT6SJdVWNzCApiRqO8SNdcviAUWcU9NCD8yMsomGxYLpvTKM714nFB14s5mqGL0r880RmU7D77hhFPHvb/Ba5vKWpIB9cNtTcI/302WmeyowX1AmPxW5CANo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752035; c=relaxed/simple;
	bh=o1jtJAveZ8L3cpYUjlG554fwK/NldTW0zQ/jVXMdW7c=;
	h=Date:To:From:Subject:Message-Id; b=KVZw/NWrI/8L9g2oJpBHfLlRkl1gBRTMe68VKH+rVeq/qoO4PU7KYGJwSyTxzbmsgK0YyMrB+L6X3bJmgg+5cZqFxE/hs/DxH4y0E4BIc7V7RdCNqeJ3qi1UNSK51v/Vo8z8ZVUi3ZGt+qEsuPvIUXHhDXaHwnduUUu/+ULJ/5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aZOKeMTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZOKeMTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCEDC19424;
	Mon, 10 Nov 2025 05:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752034;
	bh=o1jtJAveZ8L3cpYUjlG554fwK/NldTW0zQ/jVXMdW7c=;
	h=Date:To:From:Subject:From;
	b=aZOKeMTnEvLzbicU7O5AI/iM03C7OmwxSi2OiCkOtKwLFzgyTGI1/Q7lG3ddv25MC
	 57ALiGAaqUkkNb2qnfDAcATvlRayNN1rYS5bFClW1t9V9/o7kzyvY/LNJ1FhvSwn+w
	 pDjTCIxLu5B/wYNifusDRbeOJ8GQ6AltE/5xTJ3M=
Date: Sun, 09 Nov 2025 21:20:33 -0800
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,sj@kernel.org,yanquanmin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable.patch removed from -mm tree
Message-Id: <20251110052034.6BCEDC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: change last_refresh_jiffies to a global variable
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-change-last_refresh_jiffies-to-a-global-variable.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-add-a-min_sz_region-parameter-to-damon_set_region_biggest_system_ram_default.patch
mm-damon-reclaim-use-min_sz_region-for-core-address-alignment-when-setting-regions.patch

