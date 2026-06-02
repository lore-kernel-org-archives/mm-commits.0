Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED193C063E
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439163; cv=none; b=p8xTiNHXri2ACwPI1ZawSCwxDgzrmAAChqsG59PzfrxdlldQLDHksmq5AfEUiDy12W0GI7ac5if6dIZXX78SC+frAneH0cCsocYlk6NNElAo8N+QGKwffO/JZ7ihaKB1PJCUB6+8HNBXHWXbtLt5kil5QPlAEMpkHbqAYTtzs5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439163; c=relaxed/simple;
	bh=yGtJ7YWgc4UvbAfshfnMbvLCEGfEQ5dZ3dHrSPrXDYs=;
	h=Date:To:From:Subject:Message-Id; b=JCF8lJosOauBdQYhqR3S3miZcKV8eTo85A4aqqlz3ahh52PuO0iZ8wQ8RZEunvejnbdA4n4blUYe5rcS+yfVxLZ/yEDHNEd8d/9k/CPrgmIvg/L+xySvlC4oA+/rGn1I9aEyw/YxUZQqcMVmf0V5vVJqjm9LaRQFwGvX5YsFqxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JkmszKef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JkmszKef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F411F00898;
	Tue,  2 Jun 2026 22:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439162;
	bh=5n+z/4wtJ4M6InpT4pVRx5qdlxJsGjSggmQ9MEwN/Nw=;
	h=Date:To:From:Subject;
	b=JkmszKef03CbL0zJndH9sI+jnlJ3PAhoV62D4AUCCxxlXXRTMLfJD1vJlUAsk4ge5
	 JpY65XxnCb723g8Pn7ya8EDxPqD/SLXIPi5ZhVWPrv7GQIagN6alUGOFKn7iCnfWXA
	 7/m1aAFhI15yCg70yqGq0+GADH9qcq7EkyDkhbLs=
Date: Tue, 02 Jun 2026 15:26:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,maksym.shcherba@lnu.edu.ua,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-fix-missing-parens-in-macro-arguments.patch removed from -mm tree
Message-Id: <20260602222602.59F411F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fix missing parens in macro arguments
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-missing-parens-in-macro-arguments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: mm/damon: fix missing parens in macro arguments
Date: Thu, 21 May 2026 23:20:19 +0300

Patch series "mm/damon: fix macro arguments and clarify quota goals doc",
v2.


This patch (of 2):

The DAMON iterator macros do not wrap their pointer arguments with
parentheses.  This can cause build failures when the argument is a complex
expression due to operator precedence issues.

Add missing parentheses around the arguments in the following macros
to prevent potential build failures:
- damon_for_each_region()
- damon_for_each_region_from()
- damon_for_each_region_safe()
- damos_for_each_quota_goal()

Link: https://lore.kernel.org/20260521202020.126500-1-maksym.shcherba@lnu.edu.ua
Link: https://lore.kernel.org/20260521202020.126500-2-maksym.shcherba@lnu.edu.ua
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Reviewed-by: SeongJae Park <sj@kernel.org>
Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-fix-missing-parens-in-macro-arguments
+++ a/include/linux/damon.h
@@ -963,13 +963,13 @@ static inline unsigned long damon_sz_reg
 	list_for_each_entry_safe(p, next, &(ctx)->probes, list)
 
 #define damon_for_each_region(r, t) \
-	list_for_each_entry(r, &t->regions_list, list)
+	list_for_each_entry(r, &(t)->regions_list, list)
 
 #define damon_for_each_region_from(r, t) \
-	list_for_each_entry_from(r, &t->regions_list, list)
+	list_for_each_entry_from(r, &(t)->regions_list, list)
 
 #define damon_for_each_region_safe(r, next, t) \
-	list_for_each_entry_safe(r, next, &t->regions_list, list)
+	list_for_each_entry_safe(r, next, &(t)->regions_list, list)
 
 #define damon_for_each_target(t, ctx) \
 	list_for_each_entry(t, &(ctx)->adaptive_targets, list)
@@ -984,7 +984,7 @@ static inline unsigned long damon_sz_reg
 	list_for_each_entry_safe(s, next, &(ctx)->schemes, list)
 
 #define damos_for_each_quota_goal(goal, quota) \
-	list_for_each_entry(goal, &quota->goals, list)
+	list_for_each_entry(goal, &(quota)->goals, list)
 
 #define damos_for_each_quota_goal_safe(goal, next, quota) \
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
_

Patches currently in -mm which might be from maksym.shcherba@lnu.edu.ua are


