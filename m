Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E8137E
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752796883; cv=none; b=PnWXAqohADUMQsjn8jddkAWpu2dJxr4kIG9Jn0PizBMbz/MkqKOV0FRW5G8duoCf4/36HXnCG6pHiSHl2QzAS9z2GVsrZJ32F/sVlIcl6hY69jt/2QCrxBGIS8XpgaoHdQGzcWai10UVcOwfQnJs4tzxiJxTREOvtEx00qy9CXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752796883; c=relaxed/simple;
	bh=oYoWqkBpwGh8n9Z3dhpCs1b1czc7r09KQYUkJ0q6lPw=;
	h=Date:To:From:Subject:Message-Id; b=GESQX5bczmZFyH9jdbI0HWhQ4CEKrTeIPNnusgztPj+Xe/IRKWRJTdAqNgUtUnrbgV+8+fwcULZFG5FjfYYxWBbLfju/Dit+k5LgJj5J41BJ8jPdLneez+p9zk+t2dMTdDK6uP7GHgs6mOyZj/odCGYiYtK4hiMfN5Cc4BO3twk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bg9CSY1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bg9CSY1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D20C4CEE3;
	Fri, 18 Jul 2025 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752796882;
	bh=oYoWqkBpwGh8n9Z3dhpCs1b1czc7r09KQYUkJ0q6lPw=;
	h=Date:To:From:Subject:From;
	b=bg9CSY1Ugv6KSuUOAXPMj5SX3l6v5A+nFplRbEejhXJEGFDBQafIb4Q2thVrRBsz5
	 TJ5GVxiUQDgIPhAtPJjnj2Ns65plbYJCU9OPbNzGr2eJZrgWBc3rau8M3pBGvXZQXT
	 g4OPSqyGP3XUYq/O/084P/rTw3DcCnpMKHmtuhdo=
Date: Thu, 17 Jul 2025 17:01:21 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-per-node-proactive-reclaim-interface-fix-2.patch added to mm-nonmm-unstable branch
Message-Id: <20250718000122.B7D20C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-introduce-per-node-proactive-reclaim-interface-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-introduce-per-node-proactive-reclaim-interface-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-per-node-proactive-reclaim-interface-fix-2.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm-introduce-per-node-proactive-reclaim-interface-fix
Date: Thu, 17 Jul 2025 16:53:24 -0700

memcg && node is also a bogus case, per Shakeel.

Link: https://lkml.kernel.org/r/20250717235604.2atyx2aobwowpge3@offworld
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-introduce-per-node-proactive-reclaim-interface-fix-2
+++ a/mm/vmscan.c
@@ -7758,7 +7758,7 @@ int user_proactive_reclaim(char *buf,
 	substring_t args[MAX_OPT_ARGS];
 	gfp_t gfp_mask = GFP_KERNEL;
 
-	if (!buf || (!memcg && !pgdat))
+	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
 		return -EINVAL;
 
 	buf = strstrip(buf);
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-vmscan-respect-psi_memstall-region-in-node-reclaim.patch
mm-memcg-make-memoryreclaim-interface-generic.patch
mm-vmscan-make-__node_reclaim-more-generic.patch
mm-introduce-per-node-proactive-reclaim-interface.patch
mm-introduce-per-node-proactive-reclaim-interface-fix-2.patch

