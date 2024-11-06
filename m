Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E446318800D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854874; cv=none; b=esP8ut37Ft2tZByMkrQCZ6EyA6a9JcEIDNUOAjUgnNJWbaarj9798ryexR/SnSQTKajICoUtcKGGx5lBN+flomnxyNTxOu22xhoTdwt2oVyWxbpBFcde0idgxQhgTkzd+Fi9UDz7Q4BTSRGY55mv+ryIeFvMuJdHUt+gPtfDDH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854874; c=relaxed/simple;
	bh=+XNPqilQeTJ6kPrgJBQTteuRvNjnVGTNO81MBuB4A1Y=;
	h=Date:To:From:Subject:Message-Id; b=JpsKkx9PrRXRAXa56uzgp/VnNDSNv5u/9/583IxURS41YdMfg8B94XzckQGiZm4SHBBTz+K6VubajfVGDz1sHTay+u2foKvPckN3Z5hRtxchU/S93Y5z/EA4IPRH3BIEh8eBLLDDTuNJSmB9tkq4v7Bd6s0y2pStmCCVFeaF1YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cv0+34Vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cv0+34Vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB54FC4CECF;
	Wed,  6 Nov 2024 01:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854873;
	bh=+XNPqilQeTJ6kPrgJBQTteuRvNjnVGTNO81MBuB4A1Y=;
	h=Date:To:From:Subject:From;
	b=cv0+34Vydb/GncQtBcEmr1+T6PEqzZMWqnMHzA1HdiVPz+eSStePcFfH8/7O2jkQh
	 5QEFbdHA9wRpypbEKRIYMT/mfOPpPlMgkjukOXLfjr+OL0tmYgqHTNCE0IoFbOcx+U
	 BA+QhKBpi4rzdVgtJex04UkGO2BVVP2fABKDMTok=
Date: Tue, 05 Nov 2024 17:01:13 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-fully-deprecate-move_charge_at_immigrate.patch removed from -mm tree
Message-Id: <20241106010113.BB54FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1: fully deprecate move_charge_at_immigrate
has been removed from the -mm tree.  Its filename was
     memcg-v1-fully-deprecate-move_charge_at_immigrate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1: fully deprecate move_charge_at_immigrate
Date: Thu, 24 Oct 2024 18:22:58 -0700

Patch series "memcg-v1: fully deprecate charge moving".

The memcg v1's charge moving feature has been deprecated for almost 2
years and the kernel warns if someone try to use it.  This warning has
been backported to all stable kernel and there have not been any report of
the warning or the request to support this feature anymore.  Let's proceed
to fully deprecate this feature.


This patch (of 6):

Proceed with the complete deprecation of memcg v1's charge moving feature.
The deprecation warning has been in the kernel for almost two years and
has been ported to all stable kernel since.  Now is the time to fully
deprecate this feature.

Link: https://lkml.kernel.org/r/20241025012304.2473312-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20241025012304.2473312-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   82 ---------------
 mm/memcontrol-v1.c                             |   14 --
 2 files changed, 5 insertions(+), 91 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-v1-fully-deprecate-move_charge_at_immigrate
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -90,9 +90,7 @@ Brief summary of control files.
                                      used.
  memory.swappiness		     set/show swappiness parameter of vmscan
 				     (See sysctl's vm.swappiness)
- memory.move_charge_at_immigrate     set/show controls of moving charges
-                                     This knob is deprecated and shouldn't be
-                                     used.
+ memory.move_charge_at_immigrate     This knob is deprecated.
  memory.oom_control		     set/show oom controls.
                                      This knob is deprecated and shouldn't be
                                      used.
@@ -243,10 +241,6 @@ behind this approach is that a cgroup th
 page will eventually get charged for it (once it is uncharged from
 the cgroup that brought it in -- this will happen on memory pressure).
 
-But see :ref:`section 8.2 <cgroup-v1-memory-movable-charges>` when moving a
-task to another cgroup, its pages may be recharged to the new cgroup, if
-move_charge_at_immigrate has been chosen.
-
 2.4 Swap Extension
 --------------------------------------
 
@@ -756,78 +750,8 @@ If we want to change this to 1G, we can
 
 THIS IS DEPRECATED!
 
-It's expensive and unreliable! It's better practice to launch workload
-tasks directly from inside their target cgroup. Use dedicated workload
-cgroups to allow fine-grained policy adjustments without having to
-move physical pages between control domains.
-
-Users can move charges associated with a task along with task migration, that
-is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
-This feature is not supported in !CONFIG_MMU environments because of lack of
-page tables.
-
-8.1 Interface
--------------
-
-This feature is disabled by default. It can be enabled (and disabled again) by
-writing to memory.move_charge_at_immigrate of the destination cgroup.
-
-If you want to enable it::
-
-	# echo (some positive value) > memory.move_charge_at_immigrate
-
-.. note::
-      Each bits of move_charge_at_immigrate has its own meaning about what type
-      of charges should be moved. See :ref:`section 8.2
-      <cgroup-v1-memory-movable-charges>` for details.
-
-.. note::
-      Charges are moved only when you move mm->owner, in other words,
-      a leader of a thread group.
-
-.. note::
-      If we cannot find enough space for the task in the destination cgroup, we
-      try to make space by reclaiming memory. Task migration may fail if we
-      cannot make enough space.
-
-.. note::
-      It can take several seconds if you move charges much.
-
-And if you want disable it again::
-
-	# echo 0 > memory.move_charge_at_immigrate
-
-.. _cgroup-v1-memory-movable-charges:
-
-8.2 Type of charges which can be moved
---------------------------------------
-
-Each bit in move_charge_at_immigrate has its own meaning about what type of
-charges should be moved. But in any case, it must be noted that an account of
-a page or a swap can be moved only when it is charged to the task's current
-(old) memory cgroup.
-
-+---+--------------------------------------------------------------------------+
-|bit| what type of charges would be moved ?                                    |
-+===+==========================================================================+
-| 0 | A charge of an anonymous page (or swap of it) used by the target task.   |
-|   | You must enable Swap Extension (see 2.4) to enable move of swap charges. |
-+---+--------------------------------------------------------------------------+
-| 1 | A charge of file pages (normal file, tmpfs file (e.g. ipc shared memory) |
-|   | and swaps of tmpfs file) mmapped by the target task. Unlike the case of  |
-|   | anonymous pages, file pages (and swaps) in the range mmapped by the task |
-|   | will be moved even if the task hasn't done page fault, i.e. they might   |
-|   | not be the task's "RSS", but other task's "RSS" that maps the same file. |
-|   | The mapcount of the page is ignored (the page can be moved independent   |
-|   | of the mapcount). You must enable Swap Extension (see 2.4) to            |
-|   | enable move of swap charges.                                             |
-+---+--------------------------------------------------------------------------+
-
-8.3 TODO
---------
-
-- All of moving charge operations are done under cgroup_mutex. It's not good
-  behavior to hold the mutex too long, so we may need some trick.
+Reading memory.move_charge_at_immigrate will always return 0 and writing
+to it will always return -EINVAL.
 
 9. Memory thresholds
 ====================
--- a/mm/memcontrol-v1.c~memcg-v1-fully-deprecate-move_charge_at_immigrate
+++ a/mm/memcontrol-v1.c
@@ -593,29 +593,19 @@ static inline int mem_cgroup_move_swap_a
 static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
 				struct cftype *cft)
 {
-	return mem_cgroup_from_css(css)->move_charge_at_immigrate;
+	return 0;
 }
 
 #ifdef CONFIG_MMU
 static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 				 struct cftype *cft, u64 val)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-
 	pr_warn_once("Cgroup memory moving (move_charge_at_immigrate) is deprecated. "
 		     "Please report your usecase to linux-mm@kvack.org if you "
 		     "depend on this functionality.\n");
 
-	if (val & ~MOVE_MASK)
+	if (val != 0)
 		return -EINVAL;
-
-	/*
-	 * No kind of locking is needed in here, because ->can_attach() will
-	 * check this value once in the beginning of the process, and then carry
-	 * on with stale data. This means that changes to this value will only
-	 * affect task migrations starting after the change.
-	 */
-	memcg->move_charge_at_immigrate = val;
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


