Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AF31758B
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337167; cv=none; b=OoXHXC2iLBKs+IktaSEpjAdFl7zqvNWCxnfqMfl0oWeV9gxW9/71XTcFGKxBDVydE+Dnq//ykJ+10nvVPqkLn4ursf7XKTLzJA6UncliHUterZ9UPKgO8OjDtpuFSKVnL+N/zot2Q+dwGbaq4tYnCFKNfL6+Yoln//oCTwxez9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337167; c=relaxed/simple;
	bh=bZhuNtEAmUDW+Ri4hK5WscH26buyXKKpRznXuvwtpTI=;
	h=Date:To:From:Subject:Message-Id; b=AvIkqjU0jxiJ3/jJOO4ooe+rDulPTL9kklUTK3ZScJ35lYJCUy+CVhnQYHoHjEilHu2ghEGqQfWulKYhlN6NOjja+TwNbo97aZbroqVF15259sIXejWyPZU1Zuysv+ljU+S4Vy7sTGyPiRmOG3YvZry4wLMg7FGoHq5BWZ3tttc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v4A2XvtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v4A2XvtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6217EC4CED6;
	Mon, 20 Jan 2025 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337167;
	bh=bZhuNtEAmUDW+Ri4hK5WscH26buyXKKpRznXuvwtpTI=;
	h=Date:To:From:Subject:From;
	b=v4A2XvtWgThh2PicDpP/Rw9UnoOGbuXkkVp7VJym5ByAWg/lz8Ff8clWn5pBmxfip
	 +OgL/Z+Qm7qcF1xp7lPFyy/+420/UN64zWs0dwuH1L5/AVcNJT7O6j+sZJQG2IrX/q
	 mszTi1y7mC+8CiR7kguakxP/dA1R4453wXfdGI8s=
Date: Sun, 19 Jan 2025 17:39:26 -0800
To: mm-commits@vger.kernel.org,mhocko@suse.com,yuntao.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-the-incorrect-and-misleading-comment.patch removed from -mm tree
Message-Id: <20250120013927.6217EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: remove the incorrect and misleading comment
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-the-incorrect-and-misleading-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <yuntao.wang@linux.dev>
Subject: mm/page_alloc: remove the incorrect and misleading comment
Date: Wed, 15 Jan 2025 12:16:34 +0800

The comment removed in this patch originally belonged to the
build_zonelists_in_zone_order() function, which was introduced by commit
f0c0b2b808f2 ("change zonelist order: zonelist order selection logic").

Later, commit c9bff3eebc09 ("mm, page_alloc: rip out ZONELIST_ORDER_ZONE")
removed build_zonelists_in_zone_order() but left its comment behind.

Subsequently, commit 9d3be21bf9c0 ("mm, page_alloc: simplify zonelist
initialization") moved the node_order variable into build_zonelists(),
making the comment originally belonged to build_zonelists_in_zone_order()
appear as if it were part of build_zonelists().

Remove this misleading comment.

Link: https://lkml.kernel.org/r/20250115041634.63387-1-yuntao.wang@linux.dev
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-the-incorrect-and-misleading-comment
+++ a/mm/page_alloc.c
@@ -5159,13 +5159,6 @@ static void build_thisnode_zonelists(pg_
 	zonerefs->zone_idx = 0;
 }
 
-/*
- * Build zonelists ordered by zone and nodes within zones.
- * This results in conserving DMA zone[s] until all Normal memory is
- * exhausted, but results in overflowing to remote node while memory
- * may still exist in local DMA zone.
- */
-
 static void build_zonelists(pg_data_t *pgdat)
 {
 	static int node_order[MAX_NUMNODES];
_

Patches currently in -mm which might be from yuntao.wang@linux.dev are


