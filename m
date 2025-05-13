Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A061EBA0C
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119220; cv=none; b=PhS4bkvMQzUPk7lI1CzDzq6h0Tyw+FrXq+q88+HwZZVXcYNjE+hWxXT+Dwx+zzJa9DPwGzi73wlDggZIaJSPeCAQbGd34eOCprruABUXy9XHCt/1++6vhfDt40r0mnFnHf0JvqIBN6gIav3p0tw5HoZ3yRAcPvawxSEyvhadtCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119220; c=relaxed/simple;
	bh=PW1xupsdHYuKYOFZnF4yE99VMlKIJ8GftI+9dbF5XWM=;
	h=Date:To:From:Subject:Message-Id; b=cSRNcf2aWWii3S08ty+HxhTxi3lzAVJUIRrIkVYO+1b0/TZqGfADITseM8O/ay4Lnd7t0PvuG7DndYx8lfZ38CTzWAU2U4Fg5kQQv5T9sE+r15+6bf2k3oFRj8SET0neCGA0WoCKqwP65mA5tMEdQhu5lpY2t/slawAKPeIV+8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FMitsXbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FMitsXbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20429C4CEE4;
	Tue, 13 May 2025 06:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119220;
	bh=PW1xupsdHYuKYOFZnF4yE99VMlKIJ8GftI+9dbF5XWM=;
	h=Date:To:From:Subject:From;
	b=FMitsXbm4g61bTly4vVeSce4tfhpDi7OJI2VZG4wnvPMAEFYWW2E+8aW5+kbKmahZ
	 fJyixTlX4c+z0Z13KBqN5hndLQAlzPBaFRJ0qanIdc0Zb7SRvv90d1SgRna+G7u5aE
	 yzw+wvrkmPua5+1G4QL/+yppUrr5zYiqkb+MntJk=
Date: Mon, 12 May 2025 23:53:39 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,hannes@cmpxchg.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed.patch removed from -mm tree
Message-Id: <20250513065340.20429C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cpuset: rename cpuset_node_allowed to cpuset_current_node_allowed
has been removed from the -mm tree.  Its filename was
     cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: cpuset: rename cpuset_node_allowed to cpuset_current_node_allowed
Date: Thu, 24 Apr 2025 16:28:05 -0400

Patch series "vmscan: enforce mems_effective during demotion", v5.

Change reclaim to respect cpuset.mems_effective during demotion when
possible.  Presently, reclaim explicitly ignores cpuset.mems_effective
when demoting, which may cause the cpuset settings to violated.

Implement cpuset_node_allowed() to check the cpuset.mems_effective
associated wih the mem_cgroup of the lruvec being scanned.  This only
applies to cgroup/cpuset v2, as cpuset exists in a different hierarchy
than mem_cgroup in v1.

This requires renaming the existing cpuset_node_allowed() to be
cpuset_current_now_allowed() - which is more descriptive anyway - to
implement the new cpuset_node_allowed() which takes a target cgroup.


This patch (of 2):

Rename cpuset_node_allowed to reflect that the function checks the current
task's cpuset.mems.  This allows us to make a new cpuset_node_allowed
function that checks a target cgroup's cpuset.mems.

Link: https://lkml.kernel.org/r/20250424202806.52632-1-gourry@gourry.net
Link: https://lkml.kernel.org/r/20250424202806.52632-2-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    4 ++--
 kernel/cgroup/cpuset.c |    4 ++--
 mm/page_alloc.c        |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/cpuset.h~cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed
+++ a/include/linux/cpuset.h
@@ -82,11 +82,11 @@ extern nodemask_t cpuset_mems_allowed(st
 void cpuset_init_current_mems_allowed(void);
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
 
-extern bool cpuset_node_allowed(int node, gfp_t gfp_mask);
+extern bool cpuset_current_node_allowed(int node, gfp_t gfp_mask);
 
 static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 {
-	return cpuset_node_allowed(zone_to_nid(z), gfp_mask);
+	return cpuset_current_node_allowed(zone_to_nid(z), gfp_mask);
 }
 
 static inline bool cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
--- a/kernel/cgroup/cpuset.c~cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed
+++ a/kernel/cgroup/cpuset.c
@@ -4164,7 +4164,7 @@ static struct cpuset *nearest_hardwall_a
 }
 
 /*
- * cpuset_node_allowed - Can we allocate on a memory node?
+ * cpuset_current_node_allowed - Can current task allocate on a memory node?
  * @node: is this an allowed node?
  * @gfp_mask: memory allocation flags
  *
@@ -4203,7 +4203,7 @@ static struct cpuset *nearest_hardwall_a
  *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  */
-bool cpuset_node_allowed(int node, gfp_t gfp_mask)
+bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 {
 	struct cpuset *cs;		/* current cpuset ancestors */
 	bool allowed;			/* is allocation in zone z allowed? */
--- a/mm/page_alloc.c~cpuset-rename-cpuset_node_allowed-to-cpuset_current_node_allowed
+++ a/mm/page_alloc.c
@@ -3543,7 +3543,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
+	 * See also cpuset_current_node_allowed() comment in kernel/cgroup/cpuset.c.
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
@@ -4230,7 +4230,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsig
 		/*
 		 * Ignore cpuset mems for non-blocking __GFP_HIGH (probably
 		 * GFP_ATOMIC) rather than fail, see the comment for
-		 * cpuset_node_allowed().
+		 * cpuset_current_node_allowed().
 		 */
 		if (alloc_flags & ALLOC_MIN_RESERVE)
 			alloc_flags &= ~ALLOC_CPUSET;
_

Patches currently in -mm which might be from gourry@gourry.net are


