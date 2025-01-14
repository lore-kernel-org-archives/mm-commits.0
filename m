Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE0C23A119
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836964; cv=none; b=CSG6ad7P+fr5pFYZmv4NhHb8G9TqWWugrkV7Yvibp43Iv7YfrQBx0GbcvShp9LX5eDnbQunX0VL0W7+vcDDtBKqbim/flLgSW1vspW7gploRE7aboEcX4dItOt9Ri+JI3bf0ov0CsJUsXenqYiAb4C1F7XYLjDw14fLj/WFW9Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836964; c=relaxed/simple;
	bh=ieJG6je2fx1unyIfFGYtRmlOCh9l6Ic/9b5sjrIe7oI=;
	h=Date:To:From:Subject:Message-Id; b=E/XYkSL3DVkMAFfzHiKPfd2AGMvshYCuYpmr7Fcq7OHYsWp7wguNQWjh36MfAjy9+MKSgyDnHKhOMFtgPu8bMaTi/TRyJ2jh7LEBpSFOdENJSQGOnfAQCB2a+xR3ZpTSl+OuOaoUAVQwPfnMF6g52dbHcR6C2i4My4Lo7gUYqz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BOF1yvBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BOF1yvBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E87C4CEE4;
	Tue, 14 Jan 2025 06:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836964;
	bh=ieJG6je2fx1unyIfFGYtRmlOCh9l6Ic/9b5sjrIe7oI=;
	h=Date:To:From:Subject:From;
	b=BOF1yvBbuBWX8dKfQ3ZStHTMvBzX9pr5UIP/dhBPRFWkKLlaDKSZ0cK06LJrmKRNm
	 h2ntcySHwVOiRq917JgUhJk2iQtQhm+tKc3bMNEaSXdzU08ubFbrvBKaqLW4fU3CYO
	 Os2BYQbNIojqqmfEVWj9jnGUyMwHaBCV8TLUWohA=
Date: Mon, 13 Jan 2025 22:42:43 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup.patch removed from -mm tree
Message-Id: <20250114064243.E3E87C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap_cgroup: get rid of __lookup_swap_cgroup()
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: swap_cgroup: get rid of __lookup_swap_cgroup()
Date: Fri, 15 Nov 2024 19:02:29 +0000

Because swap_cgroup map is now virtually contiguous, swap_cgroup_record()
can be simplified, which eliminates a need to use __lookup_swap_cgroup().

Now as __lookup_swap_cgroup() is really trivial and is used only once, it
can be inlined.

Link: https://lkml.kernel.org/r/20241115190229.676440-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-get-rid-of-__lookup_swap_cgroup
+++ a/mm/swap_cgroup.c
@@ -33,13 +33,6 @@ static struct swap_cgroup_ctrl swap_cgro
  *
  * TODO: we can push these buffers out to HIGHMEM.
  */
-
-static struct swap_cgroup *__lookup_swap_cgroup(struct swap_cgroup_ctrl *ctrl,
-						pgoff_t offset)
-{
-	return &ctrl->map[offset];
-}
-
 static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
 					struct swap_cgroup_ctrl **ctrlp)
 {
@@ -49,7 +42,7 @@ static struct swap_cgroup *lookup_swap_c
 	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
 	if (ctrlp)
 		*ctrlp = ctrl;
-	return __lookup_swap_cgroup(ctrl, offset);
+	return &ctrl->map[offset];
 }
 
 /**
@@ -104,16 +97,9 @@ unsigned short swap_cgroup_record(swp_en
 
 	spin_lock_irqsave(&ctrl->lock, flags);
 	old = sc->id;
-	for (;;) {
+	for (; offset < end; offset++, sc++) {
 		VM_BUG_ON(sc->id != old);
 		sc->id = id;
-		offset++;
-		if (offset == end)
-			break;
-		if (offset % SC_PER_PAGE)
-			sc++;
-		else
-			sc = __lookup_swap_cgroup(ctrl, offset);
 	}
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


