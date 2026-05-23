Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DF73438AB
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 03:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779507579; cv=none; b=En8mmfDlQoc3fkwqacWVBG45I7/p2LvZLP9gf5elu4kN7GIuaX1X0CytkzPX+2gRFsk/bA2Sh1Vu3DS78H3t+KTe410QARnaT1QCKi8Oj9lJo4gdJJH8l4EMByr9esDc5g4q/Z4mLvR9GjMUnpOaIYps9SvnkZloutPU2+C/1MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779507579; c=relaxed/simple;
	bh=GsaIF2LmtZ+ZZ6b1cbVmVeDgG9Jo4RzaXDzWYQB4QDE=;
	h=Date:To:From:Subject:Message-Id; b=l4+x6//rvKHY+ZSYgRNseX5ipsXiZm3wc47yVyiU6a6s5HIwEd1xtghJZOAy3Rifyi79xXhka9IYnZUYf+8szanw2nPU0eQDbyaJ3RVc8CYTDFS/emBUHkmElfJuV/Um4zJjS3VoHV//K+yFh9H9dsBcA6PWgy82R8ihkFZ7ixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xkhZS2at; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xkhZS2at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E386A1F000E9;
	Sat, 23 May 2026 03:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779507577;
	bh=VRM/+fb93ODKjpvzvyz8qsn90DH0jgL7oxUPhtXLVi4=;
	h=Date:To:From:Subject;
	b=xkhZS2at8N8vxGlnxf/McVK18/P1l8hdXOEEKkdYAA/UZeqdNrUH093Ou0cfNjXNq
	 1dKu6PDnmkNzetN+LeO1wr5TCrR+3esOyMQHaMEyHmSaVSzSolcgtmeLKfebixDzE4
	 GFvNWMHvo0gy3CY9RyimZEYoBIrWfAEbTJL21X48=
Date: Fri, 22 May 2026 20:39:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,maksym.shcherba@lnu.edu.ua,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-missing-parens-in-macro-arguments.patch added to mm-new branch
Message-Id: <20260523033936.E386A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix missing parens in macro arguments
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-fix-missing-parens-in-macro-arguments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-missing-parens-in-macro-arguments.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

mm-damon-fix-missing-parens-in-macro-arguments.patch
docs-admin-guide-mm-damon-usage-clarify-current_value-of-quota-goals.patch

