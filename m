Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB4613CA8C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292056; cv=none; b=XQfchoemPDuog2JmFfPGbpXp3PFuYy13L3B/ICWPXYBIt1mddsAQrH43rrsGTHApQzwFnyczljbL0EN1+ZBf0rKMN10MABNh9O8HG4NtXq6GtNMlFqCOGKHVYI9Ys8/tt320yP773LjMivCSAEzN4/bmGG67elYts85lHeLWVsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292056; c=relaxed/simple;
	bh=a5t94vAMh++TjBCeQ/iItJOiCIkZZGTCuzjACxWqprw=;
	h=Date:To:From:Subject:Message-Id; b=W+kvG55B/0yeaqrF2jeV+j2Xp/f6pMqeHl8aIziY/W0qhnRS0PMzPXpQRQbr5ir9Ny5nHu5ha4gGdWSRhvo/4G3fDsk2JBgM5XPkULFwvqrEA0NbJSFZaSxNHuHSvHlX4S1kuoIfEquSv+8GdrhW2KRbgXu8Q5PoFGpCYWKaSUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eh2TbsDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eh2TbsDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BFBC2BD10;
	Sat,  6 Jul 2024 18:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292056;
	bh=a5t94vAMh++TjBCeQ/iItJOiCIkZZGTCuzjACxWqprw=;
	h=Date:To:From:Subject:From;
	b=eh2TbsDIsJrHrc9J1XOgAUpusskugWBDfcMAQJ9nkFYwF/xii5DYGMxNa+xScDMnn
	 bZTUeSKQwPqOsjCXWo4Wvxv5lK1C7fVdLX/jtTm4UoVG1L435g6I69awl0WUwznlPg
	 tgYO4ptRimhjnjoCOHPhWH5T1gReLjArr5YeifDc=
Date: Sat, 06 Jul 2024 11:54:15 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch removed from -mm tree
Message-Id: <20240706185415.E0BFBC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: add cache line padding to mem_cgroup_per_node
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg: add cache line padding to mem_cgroup_per_node
Date: Mon, 1 Jul 2024 18:59:32 +0000

Memcg v1-specific fields serve a buffer function between read-mostly and
update often parts of the mem_cgroup_per_node structure.  If
CONFIG_MEMCG_V1 is not set and these fields are not present, an explicit
cacheline padding is needed.

Link: https://lkml.kernel.org/r/20240701185932.704807-2-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node
+++ a/include/linux/memcontrol.h
@@ -95,14 +95,16 @@ struct mem_cgroup_per_node {
 #ifdef CONFIG_MEMCG_V1
 	/*
 	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
-	 * and update often fields to avoid false sharing. Once v1 stuff is
-	 * moved in a separate struct, an explicit padding is needed.
+	 * and update often fields to avoid false sharing. If v1 stuff is
+	 * not present, an explicit padding is needed.
 	 */
 
 	struct rb_node		tree_node;	/* RB tree node */
 	unsigned long		usage_in_excess;/* Set to the value by which */
 						/* the soft limit is exceeded*/
 	bool			on_tree;
+#else
+	CACHELINE_PADDING(_pad1_);
 #endif
 
 	/* Fields which get updated often at the end. */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


