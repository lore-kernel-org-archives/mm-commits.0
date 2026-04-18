Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F87326D51;
	Sat, 18 Apr 2026 07:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498874; cv=none; b=hZq6EY+wTU0p9TCAiUQbuE0+QEno/SWRZXZZEG2W6e+ZJiR2YD0KKLWh/thWIYpdFzL+XD1i+EBFV0aVJduM0noqtcjo6iCOkII81GHZhfRFWDgmL/QvW8sNM3+Uw6hYlX2ppX6T0FGH3jTZbJtR1/dY9Ykrqe9hQeOq+8Ousw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498874; c=relaxed/simple;
	bh=XUXhQWuQtU52nsNT/1b8EJVu0SnxPMsDQqXQzlfZxUI=;
	h=Date:To:From:Subject:Message-Id; b=JV2CZ+DrkOYo9EaBA+Z2l3RUQgihQSB3hQhATsihtfyE2CmtYfIzMy0tQlBl04lR16S5suTXLo0C8tsoPtYuC2Lgygi0w4ZH2GnEGEdjA0N8gNq20AlazveHE2G3ptM/TvrspoZ8tsB7crKNhJ/s3CyGMH5ZnQTVYBW+k9r2AgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Imh2OZsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Imh2OZsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFD4C19424;
	Sat, 18 Apr 2026 07:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498874;
	bh=XUXhQWuQtU52nsNT/1b8EJVu0SnxPMsDQqXQzlfZxUI=;
	h=Date:To:From:Subject:From;
	b=Imh2OZsJ68XSVf7KjFshU5Q5+HB/uG3SbJKBdYxLCybDFQBSHgHyhZ33zd3eXsjgP
	 iRBf22dtIRxR6ebfWg/ZSnUjzxWrWamAmkXQGVfhbUyvPJTQa/za0yomL/wg8/6g7z
	 wi6PJ5EuyBeo4sJjL0ih2WSiy9PSn+lLg5mZTy84=
Date: Sat, 18 Apr 2026 00:54:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,liuyun01@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-fix-memory-leak-on-damon_start-failure-in-damon_stat_start.patch removed from -mm tree
Message-Id: <20260418075433.BDFD4C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-fix-memory-leak-on-damon_start-failure-in-damon_stat_start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
Date: Tue, 31 Mar 2026 18:15:53 +0800

Destroy the DAMON context and reset the global pointer when damon_start()
fails.  Otherwise, the context allocated by damon_stat_build_ctx() is
leaked, and the stale damon_stat_context pointer will be overwritten on
the next enable attempt, making the old allocation permanently
unreachable.

Link: https://lore.kernel.org/20260331101553.88422-1-liu.yun@linux.dev
Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-stat-fix-memory-leak-on-damon_start-failure-in-damon_stat_start
+++ a/mm/damon/stat.c
@@ -249,8 +249,11 @@ static int damon_stat_start(void)
 	if (!damon_stat_context)
 		return -ENOMEM;
 	err = damon_start(&damon_stat_context, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
 		return err;
+	}
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are


