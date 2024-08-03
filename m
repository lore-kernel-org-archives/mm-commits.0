Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C44B15E89
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722709076; cv=none; b=KMEUCFvItgPTnNuZNk4NLCE05wDahC5F0aj4k4iMRAjx086TWgC9APfK/9aG0AOUjRPXB9wlDzkpoF8Ti1NX1OsZzbbzAixVY/d4dyqoWYb8luP+5TAzh/BUG+8pJ4IT2bEvvqZNVpTnmSIEEDTYW/bng0+w2HiB6oIHiBsdRmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722709076; c=relaxed/simple;
	bh=NCSsnwYlF6BB9KNjWlW4BXPt2VHFd5EyUL7ciRnA+W0=;
	h=Date:To:From:Subject:Message-Id; b=r4LIqq8DEUWzwZx43zzEnpel1IZB+IoxdhseUiKiSNjsNkYbd7HGWpK00CYx+Aklac3EiiZKPei3MdTCKjzBRjnzpozKYfg5T2QEwOrKw6o6wnZ/6Jl9EEcJuUiyn2S7BV60Z28VZBl5/Xk/qz3FzgLiZ05m7E51prDsjNXrSOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h7yvGSdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h7yvGSdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71772C116B1;
	Sat,  3 Aug 2024 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722709075;
	bh=NCSsnwYlF6BB9KNjWlW4BXPt2VHFd5EyUL7ciRnA+W0=;
	h=Date:To:From:Subject:From;
	b=h7yvGSdYPMsvLppuyWdoP0DX9VSvC+Fi0RCIGXc+ZqHd7kYoBOeizCd5ZPpnCgey9
	 pTVW/5Xor8Rfom9fw0m98HaF169pyKQ/UdM2E9OWOEbcGOwERnkXHWscEKJJkmZWMG
	 VGBimNrDT+64uba9c55wvcojVP5P3ykKSlwtQw8I=
Date: Sat, 03 Aug 2024 11:17:54 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,flintglass@gmail.com,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-make-the-lock-critical-section-obvious-in-shrink_worker.patch added to mm-unstable branch
Message-Id: <20240803181755.71772C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: make the lock critical section obvious in shrink_worker()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-make-the-lock-critical-section-obvious-in-shrink_worker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-make-the-lock-critical-section-obvious-in-shrink_worker.patch

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
Subject: mm: zswap: make the lock critical section obvious in shrink_worker()
Date: Sat, 3 Aug 2024 05:33:06 +0000

Move the comments and spin_{lock/unlock}() calls around in shrink_worker()
to make it obvious the lock is protecting the loop updating
zswap_next_shrink.

Link: https://lkml.kernel.org/r/20240803053306.2685541-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Takero Funaki <flintglass@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-make-the-lock-critical-section-obvious-in-shrink_worker
+++ a/mm/zswap.c
@@ -1364,24 +1364,22 @@ static void shrink_worker(struct work_st
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

mm-zswap-make-the-lock-critical-section-obvious-in-shrink_worker.patch

