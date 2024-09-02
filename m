Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E85DEEC8
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725240360; cv=none; b=OYEKnhmS36ZLvrKeYaQYXgXKpSHmQFO4FKj4Ze5WUx/qBla3nTk5VTe2JM465RwZSlhCohW+rxNWIDUtTFrbF+C2NkxQN/A+Juwgq+WGAS+LbTCz2Wu3a6taYfqj9Atsh4RXGyrUiopbsHqJTmGo0QUW6AZGs4dpdxnyj5BWEOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725240360; c=relaxed/simple;
	bh=VvtsdtXmMGq/IfhKc45DjgS3NAjrzKeoKHrINqYzqVE=;
	h=Date:To:From:Subject:Message-Id; b=k8Neq8Qu7fap/B4x1Fmg9wrbNNaHlrI4zr+zbR/Mzy+q8B62E8Pt6YWF7RLx+L7DTzOQw6oABH5L13RvqHOi6t+oi9yBdhtRyPGIPlWKrPpUS/jzWRSM+aARYc+E4IWL8xgkmv0ZikjpSIsiey9TQwzIxzqJ/cI4KmNk8U3F0fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F3T87q5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F3T87q5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C282C4CEC3;
	Mon,  2 Sep 2024 01:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725240360;
	bh=VvtsdtXmMGq/IfhKc45DjgS3NAjrzKeoKHrINqYzqVE=;
	h=Date:To:From:Subject:From;
	b=F3T87q5d/TXYhwl49qZv2Ssr6tG6vUFt5lPl2fZUlBOrCDmc2mJaJ++oWww5bUjx6
	 LXEUzUeppDzf5lHfhyZBgDxsOESYn6HEX0T3TZ5mN0SLRIZ6fShB/c4OyD4JNHkIvt
	 ZaaS0TtlBSFHT5eRbUINurwGvuqg9TPfH0eGt3aA=
Date: Sun, 01 Sep 2024 18:25:59 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix.patch added to mm-unstable branch
Message-Id: <20240902012600.4C282C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix
Date: Fri, 2 Aug 2024 21:14:17 -0700

move the spin_lock/unlock() closer to the loop to make the critical
section more obvious, and unify the comments above and below into a single
block.

Link: https://lkml.kernel.org/r/CAJD7tkaScz+SbB90Q1d5mMD70UfM2a-J2zhXDT9sePR7Qap45Q@mail.gmail.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Takero Funaki <flintglass@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix
+++ a/mm/zswap.c
@@ -1335,24 +1335,22 @@ static void shrink_worker(struct work_st
 	 * until the next run of shrink_worker().
 	 */
 	do {
-		spin_lock(&zswap_shrink_lock);
-
 		/*
 		 * Start shrinking from the next memcg after zswap_next_shrink.
 		 * When the offline cleaner has already advanced the cursor,
 		 * advancing the cursor here overlooks one memcg, but this
 		 * should be negligibly rare.
+		 *
+		 * If we get an online memcg, keep the extra reference in case
+		 * the original one obtained by mem_cgroup_iter() is dropped by
+		 * zswap_memcg_offline_cleanup() while we are shrinking the
+		 * memcg.
 		 */
+		spin_lock(&zswap_shrink_lock);
 		do {
 			memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
 			zswap_next_shrink = memcg;
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
-		/*
-		 * Note that if we got an online memcg, we will keep the extra
-		 * reference in case the original reference obtained by mem_cgroup_iter
-		 * is dropped by the zswap memcg offlining callback, ensuring that the
-		 * memcg is not killed when we are reclaiming.
-		 */
 		spin_unlock(&zswap_shrink_lock);
 
 		if (!memcg) {
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-fix-global-shrinker-memcg-iterationpatch-fix.patch
mm-zswap-make-the-lock-critical-section-obvious-in-shrink_worker.patch

