Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8854980B
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 05:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743486346; cv=none; b=oBfqHqpZJxc4hlfv4JnTu5bAkWMT8OW5CeD0Bwyf8vILezay5L2Rv2V3Q3xjJfXEnyP8Bkch/vntymfhtx03OYELOEniZxVMFUlTW36E6KrNnN2L6n+gEv8+4Z2Ju3J/Mtt2qED0zABla4y4LV8sModNT31l4ilg2yUKmhM6gDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743486346; c=relaxed/simple;
	bh=JVjv5L1E+92QnneyWpkf/Wf4nfpPhGL2URO0k9yztM0=;
	h=Date:To:From:Subject:Message-Id; b=AGiWbKxsEJVu0T9gT2sxRgA+JJrQUqv6CqYpUYk+mIYbGeJeb/UMFKxOLmNMEahz3eImWNuHlFhdycrrgSWLdqjtm5wEwVRz0cDnwe0E2OyFwqhZWa7aIQCev0IFyzOY8qACOA+gZzOFxanWhbL4SnBpLBGhru5Sr2DjbdT5rKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=scjoPXN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="scjoPXN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BA5C4CEE8;
	Tue,  1 Apr 2025 05:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743486345;
	bh=JVjv5L1E+92QnneyWpkf/Wf4nfpPhGL2URO0k9yztM0=;
	h=Date:To:From:Subject:From;
	b=scjoPXN7VjOdrprzy2GtAHRD7q5SQiyPWWsmUm2oXtvaMoARGD+6Lt1ibuF1V/zEJ
	 J5f4OsDOfVH0VwLU0fsMKhqUY4COiGH8162YgLO6+Y7ZkZHzwJCw/5KUf9o4JTYtgE
	 b/hgr68GjHhHfZWBIkhylEq3WVThph3OJCqUstH4=
Date: Mon, 31 Mar 2025 22:45:45 -0700
To: mm-commits@vger.kernel.org,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-defrag_modes-retry-oom-path.patch added to mm-unstable branch
Message-Id: <20250401054545.D4BA5C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: fix defrag_mode's retry & OOM path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-fix-defrag_modes-retry-oom-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-defrag_modes-retry-oom-path.patch

This patch will later appear in the mm-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix defrag_mode's retry & OOM path
Date: Sat, 22 Mar 2025 19:21:45 -0400

Brendan points out that defrag_mode doesn't properly clear
ALLOC_NOFRAGMENT on its last-ditch attempt to allocate.  But looking
closer, the problem is actually more severe: it doesn't actually *check*
whether it's already retried, and keeps looping.  This means the OOM path
is never taken, and the thread can loop indefinitely.

This is verified with an intentional OOM test on defrag_mode=1, which
results in the machine hanging.  After this patch, it triggers the OOM
kill reliably and recovers.

Clear ALLOC_NOFRAGMENT properly, and only retry once.

Link: https://lkml.kernel.org/r/20250401041231.GA2117727@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-defrag_modes-retry-oom-path
+++ a/mm/page_alloc.c
@@ -4543,8 +4543,8 @@ retry:
 		goto retry;
 
 	/* Reclaim/compaction failed to prevent the fallback */
-	if (defrag_mode) {
-		alloc_flags &= ALLOC_NOFRAGMENT;
+	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
+		alloc_flags &= ~ALLOC_NOFRAGMENT;
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-defrag_modes-retry-oom-path.patch

