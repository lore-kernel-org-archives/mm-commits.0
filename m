Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C174018D647
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925314; cv=none; b=hlp5hh3wKHrLRGXjeEeiWpkj0LgB39DnupcmeaAzp4zBDHOIOD8od8tjQClG/ZjnuEJHamgOP0TSH6Yru+n0HGAtgnfPcr+qusVdRfQeM5I395j6dBk0FLhEfIgG7ZvHTicaB7ha1BD7PHUnPd2NPkPs9DPFAtDSu4fnQkeIYRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925314; c=relaxed/simple;
	bh=qTtcP5w0v41EWGW7VmprWXEUJxr144B6XVa9M5CKAbU=;
	h=Date:To:From:Subject:Message-Id; b=hTQKdEckUVImuYKW9pHFH8YmChzdAWGArcDMAiKy4dBhTEukNo0B+02ONrvtTbh4iLGMOO1fLZYUWp/BAbbowxAlYzAarOstBHazdKlg7feS8RFvWWosno1MHFJapSnANEk5GmcHtu5mLR5k33NvYfzQYhczaubv1R2CxnzqnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hgTiMQKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hgTiMQKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967DFC4CEC5;
	Mon,  9 Sep 2024 23:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925314;
	bh=qTtcP5w0v41EWGW7VmprWXEUJxr144B6XVa9M5CKAbU=;
	h=Date:To:From:Subject:From;
	b=hgTiMQKRPs/C9bnHSS5fuWnG49/Faa/gyxHPsa0/N6btgHdVhIo0hkyLlQJan1nle
	 zFqKshAcpW5SlxvJeV8TKKLHiHK8yUtYu0B2g8d0edbJQf7NQUj6tzs0NjApA7tfXD
	 Zn8AQ7vP4eKeUgjYQ5aczqZAvFLf4tyR63r2tex4=
Date: Mon, 09 Sep 2024 16:41:54 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-increment-gen-before-restarting-traversal.patch removed from -mm tree
Message-Id: <20240909234154.967DFC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: increment gen # before restarting traversal
has been removed from the -mm tree.  Its filename was
     mm-increment-gen-before-restarting-traversal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: mm: increment gen # before restarting traversal
Date: Thu, 5 Sep 2024 00:30:52 +0000

The generation number in struct mem_cgroup_reclaim_iter should be
incremented on every round-trip.  Currently, it is possible for a
concurrent reclaimer to jump in at the end of the hierarchy, causing a
traversal restart (resetting the iteration position) without incrementing
the generation number.

By resetting the position without incrementing the generation, it's
possible for another ongoing mem_cgroup_iter() thread to walk the tree
twice.

Move the traversal restart such that the generation number is
incremented before the restart.

Link: https://lkml.kernel.org/r/20240905003058.1859929-4-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-increment-gen-before-restarting-traversal
+++ a/mm/memcontrol.c
@@ -997,7 +997,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		root = root_mem_cgroup;
 
 	rcu_read_lock();
-
+restart:
 	if (reclaim) {
 		struct mem_cgroup_per_node *mz;
 
@@ -1024,14 +1024,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	for (;;) {
 		css = css_next_descendant_pre(css, &root->css);
 		if (!css) {
-			/*
-			 * Reclaimers share the hierarchy walk, and a
-			 * new one might jump in right at the end of
-			 * the hierarchy - make sure they see at least
-			 * one group and restart from the beginning.
-			 */
-			if (!prev)
-				continue;
 			break;
 		}
 
@@ -1054,8 +1046,18 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 */
 		(void)cmpxchg(&iter->position, pos, memcg);
 
-		if (!memcg)
+		if (!memcg) {
 			iter->generation++;
+
+			/*
+			 * Reclaimers share the hierarchy walk, and a
+			 * new one might jump in right at the end of
+			 * the hierarchy - make sure they see at least
+			 * one group and restart from the beginning.
+			 */
+			if (!prev)
+				goto restart;
+		}
 	}
 
 out_unlock:
_

Patches currently in -mm which might be from kinseyho@google.com are


