Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9337826ED3D
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744898; cv=none; b=rTg7xGivlT7ohWpCYoi9/FVSPeIeYXoFVnbs1hi7SFn9sjUa7vHIqCfXVl5Cvtviqrc+FYrL2oJncfWG+DX4DbF0GJxX9lb9Rhyt4wNDRh/KuojXs86HkGvOtwCwmfWx5rubuLyisoQyXmKif5xAJgMcrTyDZq2ei51WYpucl8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744898; c=relaxed/simple;
	bh=8kl0fIYthHdt2ZRLB53Vgl2W+9fKKlml25FdEmNEFsU=;
	h=Date:To:From:Subject:Message-Id; b=KohkExyFOoDLBCM8LLGVUs9WSNVyJYw/PE1KTPi+8QG5XYuf/OMXIr842mv5YkjqOXzZUWnudgHWplzufxMnrlF+CFuq1I2i9TOnyOXMCV8nQaiF1q2RCD98n802yVOsVjbdez6UCtm8uEsRxTyTqqeWt4NUsO4Eh2jtpbQZQaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjWIBS6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjWIBS6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA32C4CEF7;
	Sun, 29 Mar 2026 00:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744898;
	bh=8kl0fIYthHdt2ZRLB53Vgl2W+9fKKlml25FdEmNEFsU=;
	h=Date:To:From:Subject:From;
	b=NjWIBS6O9PpEUb4P8oFtiGSYJdFzGfd3vKXuRroGMvEK7UotisLXPM0fOBGHFKpl/
	 5GDu7Q9F+rLHIk0JIcJl985k3B7N6442aQyy5gRczVh+f9MRTu3SecZrkQDX7xMhTH
	 5J83dcI0KgZxKn/RQ/F5kOT2xcK0x1RAQyAKcDGs=
Date: Sat, 28 Mar 2026 17:41:37 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch removed from -mm tree
Message-Id: <20260329004138.6DA32C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: respect addr_unit on default monitoring region setup
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: respect addr_unit on default monitoring region setup
Date: Tue, 10 Mar 2026 22:29:25 -0700

In the past, damon_set_region_biggest_system_ram_default(), which is the
core function for setting the default monitoring target region of
DAMON_RECLAIM, didn't support addr_unit.  Hence DAMON_RECLAIM was silently
ignoring the user input for addr_unit when the user doesn't explicitly set
the monitoring target regions, and therefore the default target region is
being used.  No real problem from that ignorance was reported so far. 
But, the implicit rule is only making things confusing.  Also, the default
target region setup function is updated to support addr_unit.  Hence there
is no reason to keep ignoring it.  Respect the user-passed addr_unit for
the default target monitoring region use case.

Link: https://lkml.kernel.org/r/20260311052927.93921-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup
+++ a/mm/damon/reclaim.c
@@ -201,12 +201,6 @@ static int damon_reclaim_apply_parameter
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

