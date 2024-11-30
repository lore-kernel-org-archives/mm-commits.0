Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88769156CA
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 06:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732949140; cv=none; b=fsBrNpVsznl56Ne65g1av81TIzFw2q0QtOqoJCMGii22Yv/aO98cqNGE9HTXTn9VngY4d1KALxNo326jWuR390DCasjPEA0cHghHEtt4/9ZXQZZkpbsilKKtVQfDkcXkXSCCpN5YfdjVyeq/5w361spZO6tUpMeJO4bMnlrsSq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732949140; c=relaxed/simple;
	bh=hrBR00A5XCWBvmnn9J1NaL1YwuLJ34TBjSE3J0Mh06Y=;
	h=Date:To:From:Subject:Message-Id; b=QfqXss3aSnNFLexC1HnH1gSlqmMPEfLIRDkEk+0wKtxRTSTlznA/luPhX30BWUaepdn24ci+PKLzL3gkXByN9wqxs8AHFoUIPeTOojVUBvHlOpDZEkoFevnraJLEnHox5v3u/bap1JDsOVzSFg9Y2LPzJyi2aHyPrNLYGxcAytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OyFnoch9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OyFnoch9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00617C4CECC;
	Sat, 30 Nov 2024 06:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732949140;
	bh=hrBR00A5XCWBvmnn9J1NaL1YwuLJ34TBjSE3J0Mh06Y=;
	h=Date:To:From:Subject:From;
	b=OyFnoch9l8aL0AMesAcj4XJ7wAX81S7/2PuXGcc61bvu6hWYoS+QjwXzBRnA6TMfB
	 cgFNDTv0bXNG827HhwICXqVQDsPgiZenCWTo6AcN9tDSh9oAWwAYRRe4XQpubrPtRN
	 DcHmYGXfa+YylzWTFxocA4UZqefw2q/qm5fHlgP0=
Date: Fri, 29 Nov 2024 22:45:39 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch added to mm-unstable branch
Message-Id: <20241130064540.00617C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch

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
Subject: mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix
Date: Fri Nov 29 08:09:32 PM PST 2024

s/vfree/kvfree/, per Shakeel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix
+++ a/mm/swap_cgroup.c
@@ -158,5 +158,5 @@ void swap_cgroup_swapoff(int type)
 	ctrl->map = NULL;
 	mutex_unlock(&swap_cgroup_mutex);
 
-	kvfree(map);
+	vfree(map);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-vmcorec-fix-warning-when-config_mmu=n.patch
mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm-fix.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
drivers-iio-magnetometer-yamaha-yas530c-hack-around-build-error.patch

