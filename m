Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ADA481A3
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976350; cv=none; b=DMMGiaWoY9qI0AB4ljrzTRht25ALUX2Fd8ClALRBp9k0BhkcDpFbVpY84fJSCYaCg6fgOlELmpTUlGpDpTRDllUdduYdJ7yxRUuVVrSEWzwlHGO5R59qXcZjdlUMaZsHOsCCk3TYZHmMT96/FD+9RgnLghlPI43cQs42/mDST5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976350; c=relaxed/simple;
	bh=xcJk9mprG3mYcckRxMtA+jfcFodhDYpa9pZx5xWy56w=;
	h=Date:To:From:Subject:Message-Id; b=tV9BA1Ns9SYyMhycQMot3D0BztUMb3KM6ThvJZHe+1hOBdJPmHJ2FA8nA2GQliDtG7TdTQYRIvnVqNGxoKkusmp98Q70cE/cLY99XNrpaNMrUkpdyGrN+LCC1lv7HgoCGa7nU/BN2/fypO4Dof0SJLEyRKv1ymbg+RDrM/3n4Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nI4BwcOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nI4BwcOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A887C4CEE3;
	Sun, 20 Jul 2025 01:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976349;
	bh=xcJk9mprG3mYcckRxMtA+jfcFodhDYpa9pZx5xWy56w=;
	h=Date:To:From:Subject:From;
	b=nI4BwcOf2RNh+tNcMFCTaHMFgR0fhQasSwQXOVESHZJk0xFkvw/q/r4gsvdpvfdU5
	 OVPXKXWWZddGeRcJLtxJZRBQ6jFfdGdBuxMb71i0TJq9fPPJypjWQAVl128v3hvO2f
	 KzT2kExLtxqBbAjEZG5VGweZDiwBAPx3HACDYpFI=
Date: Sat, 19 Jul 2025 18:52:28 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-introduce-per-node-proactive-reclaim-interface-fix.patch removed from -mm tree
Message-Id: <20250720015229.7A887C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-introduce-per-node-proactive-reclaim-interface-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-per-node-proactive-reclaim-interface-fix.patch

This patch was dropped because it was folded into mm-introduce-per-node-proactive-reclaim-interface.patch

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

mm-introduce-per-node-proactive-reclaim-interface.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
kasan-add-shadow-checks-to-wrappers-and-rename-kasan_arch_is_ready-fix.patch
squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call-fix.patch
init-kconfig-restore-config_broken-help-text.patch

