From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch added to -mm tree
Date: Wed, 16 Apr 2014 14:34:35 -0700
Message-ID: <534ef76b.tmQqdEcV4Qz9Q8dE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbaDPVeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 17:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, mhocko@suse.cz, hannes@cmpxchg.org

Subject: + mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch added to -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,rientjes@google.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 14:34:35 -0700


The patch titled
     Subject: mm: memcontrol: remove hierarchy restrictions for swappiness and oom_control
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove hierarchy restrictions for swappiness and oom_control

Per-memcg swappiness and oom killing can currently not be tweaked on a
memcg that is part of a hierarchy, but not the root of that hierarchy. 
Users have complained that they can't configure this when they turned on
hierarchy mode.  In fact, with hierarchy mode becoming the default, this
restriction disables the tunables entirely.

But there is no good reason for this restriction.  The settings for
swappiness and OOM killing are taken from whatever memcg whose limit
triggered reclaim and OOM invocation, regardless of its position in the
hierarchy tree.

Allow setting swappiness on any group.  The knob on the root memcg already
reads the global VM swappiness, make it writable as well.

Allow disabling the OOM killer on any non-root memcg.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control
+++ a/mm/memcontrol.c
@@ -5443,22 +5443,14 @@ static int mem_cgroup_swappiness_write(s
 				       struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
-	if (val > 100 || !parent)
+	if (val > 100)
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-
-	/* If under hierarchy, only empty-root can set this value */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
-
-	memcg->swappiness = val;
-
-	mutex_unlock(&memcg_create_mutex);
+	if (css_parent(css))
+		memcg->swappiness = val;
+	else
+		vm_swappiness = val;
 
 	return 0;
 }
@@ -5790,22 +5782,15 @@ static int mem_cgroup_oom_control_write(
 	struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!parent || !((val == 0) || (val == 1)))
+	if (!css_parent(css) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
 	memcg->oom_kill_disable = val;
 	if (!val)
 		memcg_oom_recover(memcg);
-	mutex_unlock(&memcg_create_mutex);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

