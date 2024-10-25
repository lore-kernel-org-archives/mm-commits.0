Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC8F17C9E8
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 20:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729887516; cv=none; b=XQNs9krQRACpVxTKezZEc4mLYdMEl+QltgJlMaWc/Eje48xqjzyt4DbdSK2WETalGhnKITKWBGOLQJtErJ5+9+6fMphGsR3LsRkJV1H0/WJ9RFcCRcRRTy1P3okiYqAVdCY+3X3WI9XnTnzdr/jY2CoVxljA4X2NN0XCzkKmStU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729887516; c=relaxed/simple;
	bh=qhDn2izQBSLzHUVnNOfH1y3hpP9BQ4qwIj+Wso2HOOI=;
	h=Date:To:From:Subject:Message-Id; b=WF+UubHvA3J/LVP6PdKdq2XioufhmLeNOAS/O9SfVu+WdaqC9MjtM9hMEj+T75nORsCREemlXhAJ5161kOGjwvKyZCco2rzEyHd4bW7fSIil8GZ8XzkQwh4105qavJNye6bWw3MzIoCenbfUqObxJEyXQwSbwY1AIicmrKPmSh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=llmbu+j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="llmbu+j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FECC4CECC;
	Fri, 25 Oct 2024 20:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729887514;
	bh=qhDn2izQBSLzHUVnNOfH1y3hpP9BQ4qwIj+Wso2HOOI=;
	h=Date:To:From:Subject:From;
	b=llmbu+j27EngncHZqpwrp+sbmSl78S4LUxksfC3NDOHWvwayZznTW0A/5DdrcaPqS
	 Xs6f6QPFNUq92LEzOqQI+JjYkm5yz3V8EUw7e7TovVvOsLzoNAl2bmC7/sKpW0TNFE
	 6IcspQ9sAjz/q/psNPoZusa6eBGu57XpIr4utlOc=
Date: Fri, 25 Oct 2024 13:18:33 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-v1-fully-deprecate-move_charge_at_immigrate.patch added to mm-unstable branch
Message-Id: <20241025201833.E0FECC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-v1: fully deprecate move_charge_at_immigrate
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-v1-fully-deprecate-move_charge_at_immigrate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-v1-fully-deprecate-move_charge_at_immigrate.patch

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
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

mm-optimize-truncation-of-shadow-entries.patch
mm-optimize-invalidation-of-shadow-entries.patch
mm-truncate-reset-xa_has_values-flag-on-each-iteration.patch
memcg-add-tracing-for-memcg-stat-updates.patch
memcg-add-tracing-for-memcg-stat-updates-v2.patch
memcg-v1-fully-deprecate-move_charge_at_immigrate.patch
memcg-v1-remove-charge-move-code.patch
memcg-v1-no-need-for-memcg-locking-for-dirty-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-writeback-tracking.patch
memcg-v1-no-need-for-memcg-locking-for-mglru.patch
memcg-v1-remove-memcg-move-locking-code.patch

