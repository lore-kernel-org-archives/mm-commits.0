Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4160072601
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976351; cv=none; b=Va5u0G6lY3cqsZYOOq52mPezVfHXLn0NZTdBG8jYCYDh57UCzdrJlnXcqKcJPVUu7sUl+9CWjUF2ASeaRAXqO7/lXQHUQVcISTPwKP5Z38aF07YdLTKr8oz1uwZlMb8WphYLXgUNmiVt/7qwwqzgIovAcmI10QZYM8WykRqE1l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976351; c=relaxed/simple;
	bh=r08EMYxyOA22wiHrI4Ves8/C40ryakl/7tZ499CO9Fg=;
	h=Date:To:From:Subject:Message-Id; b=VVOwc36RE7lO2fQ0eDQk47g0mJYPBSs56MCBC6MmSOVXSf9fPrYO5WYqoEm0RzacqDPqnCNlfbfLnicDBaGe0bFIZPMaWW7qtWz+t1/GNVGZUAXP1RcuR3PnnmQyO6RwZO7wL5oF88ZTz51PdLBslZOkHDn9RNVE7QWXGSnxFSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pZN/4sPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pZN/4sPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BB2C4CEE3;
	Sun, 20 Jul 2025 01:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976350;
	bh=r08EMYxyOA22wiHrI4Ves8/C40ryakl/7tZ499CO9Fg=;
	h=Date:To:From:Subject:From;
	b=pZN/4sPbNpTLoFzebFQ1g/VOLeRczqFvR+L2XK2BBlVMA7ipfU+yv//Yg6HEGdi6G
	 4zVyQX1jPBkm0ata6NZpRTiPBLDDEVQxe+hNZlvB9L6nAhXd1FtkaJyDMRTbfaiGW/
	 QJpodSkJqeKyStVjNx1TffjRku+BQiFAPEvl6gDc=
Date: Sat, 19 Jul 2025 18:52:30 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-introduce-per-node-proactive-reclaim-interface-fix-2.patch removed from -mm tree
Message-Id: <20250720015230.C1BB2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-introduce-per-node-proactive-reclaim-interface-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-per-node-proactive-reclaim-interface-fix-2.patch

This patch was dropped because it was folded into mm-introduce-per-node-proactive-reclaim-interface.patch

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
@@ -7748,7 +7748,7 @@ int user_proactive_reclaim(char *buf,
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

