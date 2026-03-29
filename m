Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226626461F
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744899; cv=none; b=Cz38VAWuBX4rKJ4unyeLwT3I/NyBbD6IHfn2aOIOKz/KGiRq6kHSl5YxzAinJ9WS6TThVIJUM509mBwqnV/PkS3ZGNUUVA6JK1sVxD/zZg7Ueh8woJg5omH4C/XOt+j+Qwgh8MQwErunbNCiI4Ct08M4K/hZEVsvCyQYXJk091c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744899; c=relaxed/simple;
	bh=p0NLoP8OvI+EADSCraNTHhBcVIY5vw0Luqf+C74tx7k=;
	h=Date:To:From:Subject:Message-Id; b=MWPLrV2CRpJid55iBbCC9NiEPtBs6B2tjF7sPvIKpSr15FOYPzqHxg4O6GyfTVnpDbeipf9BqvTMoXxZ5qcivE4eYCFuDaahqn9HuXPdl10rC3cbnpNEZfUhl9joXMgDOUE4WyrerpOsokTvQyFfeCjKogSUtVlh5neQ0UGVEKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cPdq84hy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cPdq84hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91669C4CEF7;
	Sun, 29 Mar 2026 00:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744899;
	bh=p0NLoP8OvI+EADSCraNTHhBcVIY5vw0Luqf+C74tx7k=;
	h=Date:To:From:Subject:From;
	b=cPdq84hyPtO+M6Av4UPxR1NPf+yEEQNev7D3qznR0RJBwrmZjJ8rxRB1GJY8BrszH
	 bKmWyJE7f+W5hWxZFIECK79fEAgZHmh9A/MzeIs/TML1GGxhFI8Kl16QCCC3Bmwr7I
	 h6NzeQp/FuZ8wuCPj00ySPnDy43jxo3RNfuw1fvA=
Date: Sat, 28 Mar 2026 17:41:39 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch removed from -mm tree
Message-Id: <20260329004139.91669C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: respect addr_unit on default monitoring region setup
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: respect addr_unit on default monitoring region setup
Date: Tue, 10 Mar 2026 22:29:26 -0700

In the past, damon_set_region_biggest_system_ram_default(), which is the
core function for setting the default monitoring target region of
DAMON_LRU_SORT, didn't support addr_unit.  Hence DAMON_LRU_SORT was
silently ignoring the user input for addr_unit when the user doesn't
explicitly set the monitoring target regions, and therefore the default
target region is being used.  No real problem from that ignorance was
reported so far.  But, the implicit rule is only making things confusing. 
Also, the default target region setup function is updated to support
addr_unit.  Hence there is no reason to keep ignoring it.  Respect the
user-passed addr_unit for the default target monitoring region use case.

Link: https://lkml.kernel.org/r/20260311052927.93921-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup
+++ a/mm/damon/lru_sort.c
@@ -291,12 +291,6 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
-	/*
-	 * If monitor_region_start/end are unset, always silently
-	 * reset addr_unit to 1.
-	 */
-	if (!monitor_region_start && !monitor_region_end)
-		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

