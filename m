Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353E91547CC
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752792416; cv=none; b=Cw0ggNZFPl55BF30ygxA5m0lzzaJ8a4ovFe8MYs7nmboQKgyi9zSWySmBjGHkOxgz7YMw4SefN4WYjcYH3HkdWxF1moVMg4XnTVss8yAiZ+JkhpUZhlX7pVCloBjqexKP9ivp7/Dms76Pt4KDd557koa4diGSPICN2PeNOwjS0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752792416; c=relaxed/simple;
	bh=rNHlP8wh/qTHlca0a2KREMugW6qYwSevxsBqJKabfdE=;
	h=Date:To:From:Subject:Message-Id; b=ggo8LRPfIiK3CJ0j2gcvsSVsuYMT45W7vcfYmAOcHeHsObjD3FqmKenyhTEuN1sKbBSYfgR6FgKOFJLGKjXI5sLAhPapCOdDs/QabBkr//dtL0ul96hU2u1+NA/AOsV7Qr3zDLWLmEeMkR0a23qxXopvVc06fT1BmX08rTgpgO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jckdzFV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jckdzFV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AEDC4CEEB;
	Thu, 17 Jul 2025 22:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752792415;
	bh=rNHlP8wh/qTHlca0a2KREMugW6qYwSevxsBqJKabfdE=;
	h=Date:To:From:Subject:From;
	b=jckdzFV3mf/Z9JG+OteARkLvUlcJ+lc3DWf0eJE1uxsfH8EPaX8G4uIOgCPMAhRgD
	 hHYPzA53utNAT/9CWUeCkKGArQ+9niHsvq7645DIhtPRNtsRhB0FuXhO2vuQQn5oDz
	 gFx00GHS9/GzWCR8r4Mtql3wF/ZyRgmXxaIoagoo=
Date: Thu, 17 Jul 2025 15:46:55 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-per-node-proactive-reclaim-interface-fix.patch added to mm-unstable branch
Message-Id: <20250717224655.95AEDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-introduce-per-node-proactive-reclaim-interface-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-per-node-proactive-reclaim-interface-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-per-node-proactive-reclaim-interface-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-per-node-proactive-reclaim-interface-fix
Date: Thu Jul 17 03:44:14 PM PDT 2025

user_proactive_reclaim(): return -EBUSY on PGDAT_RECLAIM_LOCKED
contention, per Roman

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-introduce-per-node-proactive-reclaim-interface-fix
+++ a/mm/vmscan.c
@@ -7818,7 +7818,7 @@ int user_proactive_reclaim(char *buf,
 
 			if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED,
 						  &pgdat->flags))
-				return -EAGAIN;
+				return -EBUSY;
 
 			reclaimed = __node_reclaim(pgdat, gfp_mask,
 						   batch_size, &sc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-make-memoryreclaim-interface-generic-fix.patch
mm-introduce-per-node-proactive-reclaim-interface-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch
init-kconfig-restore-config_broken-help-text.patch

