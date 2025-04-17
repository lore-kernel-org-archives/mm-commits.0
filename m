Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C621A20458A
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744928502; cv=none; b=qqnY2S+xe6x1tGayScG4ygCyxJ4EjHG/qzkG2Eg3/tIUvY+PW3d0cyfKZ2ruqUKL2W898WIzpFx1rfhG3ZHfQVGu8pUqM336oOHpqUnolpxtE1zASL8WRBUqPnsiK3MNFCWuQODht0YVr0hIAcm5HWbEUEKrMJIbC9Ef1hIBZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744928502; c=relaxed/simple;
	bh=cS0B6o7x5jI5w5ESlqKJoXK2kYtKSzzXuxFdz4Z1TL8=;
	h=Date:To:From:Subject:Message-Id; b=TETfe5RSTr7cZiFR91KmRrkc+zusTMRoFtogPT78PmwmQdVTTCz1BqK4wKORaJwnkH10+zFb0yL/D70mU4f2SeOflnvWIzSA4rsK4AJ1d8rAzQGjDoEPsa0oEnVtj5cvzc9oNihp6jKFFQJfOL1NUUQS62wloti/KOIqs7GfAC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uTmEV/3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uTmEV/3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA082C4CEE4;
	Thu, 17 Apr 2025 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744928502;
	bh=cS0B6o7x5jI5w5ESlqKJoXK2kYtKSzzXuxFdz4Z1TL8=;
	h=Date:To:From:Subject:From;
	b=uTmEV/3wSPJc8f1x1/PLIHzlJMw1l3BDW6l+Xs5p9CkxPQWEnVg1xNC4vWXiNdalE
	 kbTivIshpMFSIoaKamfFd32G4MIP8bHv9Mdc+rlWSSoUctSCT6vtW5AFbFpzcQYZsY
	 Jzo2UOMfO3YUYAb+btezka/HdQcAM56Xbm4tFQ0E=
Date: Thu, 17 Apr 2025 15:21:41 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-remove-unnecessary-null-check-before-free_percpu.patch added to mm-new branch
Message-Id: <20250417222141.EA082C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: remove unnecessary NULL check before free_percpu()
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-remove-unnecessary-null-check-before-free_percpu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-remove-unnecessary-null-check-before-free_percpu.patch

This patch will later appear in the mm-new branch at
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
From: Chen Ni <nichen@iscas.ac.cn>
Subject: mm: memcontrol: remove unnecessary NULL check before free_percpu()
Date: Thu, 17 Apr 2025 16:43:30 +0800

free_percpu() checks for NULL pointers internally.  Remove unneeded NULL
check here.

Link: https://lkml.kernel.org/r/20250417084330.937380-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcontrol-remove-unnecessary-null-check-before-free_percpu
+++ a/mm/memcontrol-v1.c
@@ -2198,8 +2198,7 @@ bool memcg1_alloc_events(struct mem_cgro
 
 void memcg1_free_events(struct mem_cgroup *memcg)
 {
-	if (memcg->events_percpu)
-		free_percpu(memcg->events_percpu);
+	free_percpu(memcg->events_percpu);
 }
 
 static int __init memcg1_init(void)
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are

mm-memcontrol-remove-unnecessary-null-check-before-free_percpu.patch

