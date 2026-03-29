Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB416246774
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744832; cv=none; b=EXz8n0iWIAfpU0rAaKmdACTvxlw82t9SZ0OmFUN0xHr4/DaK1n9VzgFicQOTeKiTxH7L6k083R85VX1sqVHcNyMw7d/JMPNnkLSilvDW5jP34F6w66zVK5ed9aH0Fnwro4+LowEbVGEQqj66KOF8ny28PyHI7NtMdqwWNfE2ufU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744832; c=relaxed/simple;
	bh=7k55EsylsQUCNN4ZcAjfOUMS2vdaNeVd/zAJkRUaaCc=;
	h=Date:To:From:Subject:Message-Id; b=IaBaKvkykm6Kz8/5ewuA9F5Kbv9i4hbfKWriqHvKYJT3rWQ6ZJ/zv+icNz1szxBnz7DKl0HoGW5AyuXl+Zndd6M9ZFPWzJ+rAGax3I/QWkPw+sZao+ZKgIrF3k/XELHYUjg9PrXWw6RHqRTnSMD9/cVAgn5nxjDb79WCQmN7/Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CxLjbj79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CxLjbj79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FB8C4CEF7;
	Sun, 29 Mar 2026 00:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744832;
	bh=7k55EsylsQUCNN4ZcAjfOUMS2vdaNeVd/zAJkRUaaCc=;
	h=Date:To:From:Subject:From;
	b=CxLjbj79OflG8rc1y0N7BGrGrgpezCi4uppKpwN3hLTVzJOfGkXuGU3xqf/Ic1o2W
	 7j65qYWdQQb74Rag/13pJ17Z9105WbBkIK8czZbZkpMZvy2cIc2Alw4pfCG5ZH5a2e
	 vzBD3iVcS9758424aZCJ7V4SBHzVDjNfxc2SfNeo=
Date: Sat, 28 Mar 2026 17:40:32 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-time_before-for-next_apply_sis.patch removed from -mm tree
Message-Id: <20260329004032.A3FB8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use time_before() for next_apply_sis
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-time_before-for-next_apply_sis.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use time_before() for next_apply_sis
Date: Sat, 7 Mar 2026 11:49:13 -0800

damon_ctx->passed_sample_intervals and damos->next_apply_sis are unsigned
long, and compared via normal comparison operators.  It is unsafe from
overflow.  Use time_before(), which is safe from overflow when correctly
used, instead.

Link: https://lkml.kernel.org/r/20260307194915.203169-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-time_before-for-next_apply_sis
+++ a/mm/damon/core.c
@@ -2097,7 +2097,7 @@ static void damon_do_apply_schemes(struc
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
 
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
 		if (!s->wmarks.activated)
@@ -2455,7 +2455,7 @@ static void kdamond_apply_schemes(struct
 	bool has_schemes_to_apply = false;
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
 		if (!s->wmarks.activated)
@@ -2479,7 +2479,7 @@ static void kdamond_apply_schemes(struct
 	}
 
 	damon_for_each_scheme(s, c) {
-		if (c->passed_sample_intervals < s->next_apply_sis)
+		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 		damos_walk_complete(c, s);
 		damos_set_next_apply_sis(s, c);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

