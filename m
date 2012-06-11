From: akpm@linux-foundation.org
Subject: + memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch added to -mm tree
Date: Mon, 11 Jun 2012 15:11:50 -0700
Message-ID: <20120611221151.043EEA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:34773 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2FKWLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 18:11:52 -0400
Received: by qcsp5 with SMTP id p5so132266qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 15:11:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, mhocko@suse.cz


The patch titled
     Subject: memcg: fix use_hierarchy css_is_ancestor oops regression
has been added to the -mm tree.  Its filename is
     memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix use_hierarchy css_is_ancestor oops regression

If use_hierarchy is set, reclaim testing soon oopses in css_is_ancestor()
called from __mem_cgroup_same_or_subtree() called from page_referenced():
when processes are exiting, it's easy for mm_match_cgroup() to pass along
a NULL memcg coming from a NULL mm->owner.

Check for that in __mem_cgroup_same_or_subtree().  Return true or false? 
False because we cannot know if it was in the hierarchy, but also false
because it's better not to count a reference from an exiting process.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-use_hierarchy-css_is_ancestor-oops-regression mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-use_hierarchy-css_is_ancestor-oops-regression
+++ a/mm/memcontrol.c
@@ -1148,7 +1148,7 @@ bool __mem_cgroup_same_or_subtree(const 
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy)
+	if (!root_memcg->use_hierarchy || !memcg)
 		return false;
 	return css_is_ancestor(&memcg->css, &root_memcg->css);
 }
_
Subject: Subject: memcg: fix use_hierarchy css_is_ancestor oops regression

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
thp-avoid-atomic64_read-in-pmd_read_atomic-for-32bit-pae.patch
memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2.patch
prio_tree-debugging-patch.patch

