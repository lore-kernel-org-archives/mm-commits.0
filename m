Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96743A28B
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467326; cv=none; b=AW9T1wlftHc246VuLnvLMEVJ/yMqcjU5s7zhAaHAudnDo0uSBQzpRAop3OVYPoqO5ln6yfY9DXivLxynnnCh0hs++IP2X8TeBRhQbsRKNAk+K2uaq5uaU63uRbjvcgbpwUXst/DYctTZqfQhupvCUbw5kDabo80eGp9qvBHaIr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467326; c=relaxed/simple;
	bh=NDUI+eIrIIVBLU0hQncJQX7syWSWY8McdZ0FlKfAYMY=;
	h=Date:To:From:Subject:Message-Id; b=OU+CPrB4MTav3I9/7IyeIXtUTyh6Cclx51HwanebWrADGJAwoI/OfPfam0K9vlNttpPfncrfB8qLd5rgsJqw2zx3quxs/DTAB4fUzhLqw+I/uUvZvDGwQD8qyE9S7w7fB7BQmY4GQ0miM2R/0IoEGfGcccMhTHIoaVgtLLFdwtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTIMB+1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTIMB+1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DBAC2BBFC;
	Sat, 11 May 2024 22:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467326;
	bh=NDUI+eIrIIVBLU0hQncJQX7syWSWY8McdZ0FlKfAYMY=;
	h=Date:To:From:Subject:From;
	b=qTIMB+1bflKgHNbFr0Dc8u99P+bJpAQ717nIZwPDvVTT3jJPVSLx4q4rJpLpHZf4B
	 rjdehN63kes+NycLYdjHMAWZqNXkIS1bln3vRMgj/lMsoBG6hqG9wi/Fa1opZ7Ah7u
	 I1Pbz+/Bev5fP43niDKcXhh/QPeYT+vIO9/GcAXc=
Date: Sat, 11 May 2024 15:42:06 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch removed from -mm tree
Message-Id: <20240511224206.93DBAC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: initialize ->esz_bp from damos_quota_init_priv()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: initialize ->esz_bp from damos_quota_init_priv()
Date: Fri, 3 May 2024 11:03:09 -0700

Patch series "mm/damon: misc fixes and improvements".

Add miscelleneous and non-urgent fixes and improvements for DAMON code,
selftests, and documents.


This patch (of 10):

damos_quota_init_priv() function should initialize all private fields of
struct damos_quota.  However, it is not initializing ->esz_bp field.  This
could result in use of uninitialized variable from
damon_feed_loop_next_input() function.  There is no such issue at the
moment because every caller of the function is passing damos_quota object
that already having the field zero value.  But we cannot guarantee the
future, and the function is not doing what it is promising.  A bug is a
bug.  This fix is for preventing possible future issues.

Link: https://lkml.kernel.org/r/20240503180318.72798-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240503180318.72798-2-sj@kernel.org
Fixes: 9294a037c015 ("mm/damon/core: implement goal-oriented feedback-driven quota auto-tuning")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv
+++ a/mm/damon/core.c
@@ -346,6 +346,7 @@ static struct damos_quota *damos_quota_i
 	quota->charged_from = 0;
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
+	quota->esz_bp = 0;
 	return quota;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


