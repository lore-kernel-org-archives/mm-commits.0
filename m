From: akpm@linux-foundation.org
Subject: [merged] memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:51 -0700
Message-ID: <20130430184651.B17A25A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40280 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab3D3Sqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:52 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so84851yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: keep prev's css alive for the whole mem_cgroup_iter
has been removed from the -mm tree.  Its filename was
     memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: keep prev's css alive for the whole mem_cgroup_iter

The patchset tries to make mem_cgroup_iter saner in the way how it walks
hierarchies.  css->id based traversal is far from being ideal as it is not
deterministic because it depends on the creation ordering.  Additional to
that css_id is considered a burden for cgroup maintainers because it is
quite some code and memcg is the last user of it.  After this series only
the swap accounting uses css_id but that one will follow up later.

Diffstat (if we exclude removed/added comments) looks quite
promissing. We got rid of some code:
$ git diff mmotm... | grep -v "^[+-][[:space:]]*[/ ]\*" | diffstat
 b/include/linux/cgroup.h |    3 ---
 kernel/cgroup.c          |   33 ---------------------------------
 mm/memcontrol.c          |    4 +++-
 3 files changed, 3 insertions(+), 37 deletions(-)

The first patch is just preparatory and it changes when we release css of
the previously returned memcg.  Nothing controlversial.

The second patch is the core of the patchset and it replaces css_get_next
based on css_id by the generic cgroup pre-order.  This brings some
chalanges for the last visited group caching during the reclaim
(mem_cgroup_per_zone::reclaim_iter).  We have to use memcg pointers
directly now which means that we have to keep a reference to those groups'
css to keep them alive.

I also folded iter_lock introduced by https://lkml.org/lkml/2013/1/3/295
in the previous version into this patch.  Johannes felt the race I was
describing should be mostly harmless and I haven't been able to trigger it
so the lock doesn't deserve its own patch.  It is still needed
temporarily, though, because the reference counting on iter->last_visited
depends on it.  It will go away with the next patch.

The next patch fixups an unbounded cgroup removal holdoff caused by the
elevated css refcount.  The issue has been observed by Ying Han.  Johannes
wasn't impressed by the previous version of the fix
(https://lkml.org/lkml/2013/2/8/379) which cleaned up pending references
during mem_cgroup_css_offline when a group is removed.  He has suggested a
different way when the iterator checks whether a cached memcg is still
valid or no.  More on that in the patch but the basic idea is that every
memcg tracks the number removed subgroups and iterator records this number
when a group is cached.  These numbers are checked before
iter->last_visited is about to be used and the iteration is restarted if
it is invalid.

The fourth and fifth patches are an attempt for simplification of the
mem_cgroup_iter.  css juggling is removed and the iteration logic is moved
to a helper so that the reference counting and iteration are separated.

The last patch just removes css_get_next as there is no user for it any
longer.

My testing looked as follows:
        A (use_hierarchy=1, limit_in_bytes=150M)
       /|\
      1 2 3

Children groups were created so that the number is never higher than 3 and
their limits were random between 50-100M.  Each group hosts a kernel build
(starting with tar -xf so the tree is not shared and make -jNUM_CPUs/3)
and terminated after random time - up to 5 minutes) and then it is
removed.

This should exercise both leaf and hierarchical reclaim as well as races
with cgroup removals and debugging messages I added on top proved that. 
100 groups were created during the test.



This patch:

css reference counting keeps the cgroup alive even though it has been
already removed.  mem_cgroup_iter relies on this fact and takes a
reference to the returned group.  The reference is then released on the
next iteration or mem_cgroup_iter_break.  mem_cgroup_iter currently
releases the reference right after it gets the last css_id.

This is correct because neither prev's memcg nor cgroup are accessed after
then.  This will change in the next patch so we need to hold the group
alive a bit longer so let's move the css_put at the end of the function.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ying Han <yinghan@google.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-keep-prevs-css-alive-for-the-whole-mem_cgroup_iter
+++ a/mm/memcontrol.c
@@ -1100,12 +1100,9 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	if (prev && !reclaim)
 		id = css_id(&prev->css);
 
-	if (prev && prev != root)
-		css_put(&prev->css);
-
 	if (!root->use_hierarchy && root != root_mem_cgroup) {
 		if (prev)
-			return NULL;
+			goto out_css_put;
 		return root;
 	}
 
@@ -1121,7 +1118,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
 			if (prev && reclaim->generation != iter->generation)
-				return NULL;
+				goto out_css_put;
 			id = iter->position;
 		}
 
@@ -1143,8 +1140,12 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		}
 
 		if (prev && !css)
-			return NULL;
+			goto out_css_put;
 	}
+out_css_put:
+	if (prev && prev != root)
+		css_put(&prev->css);
+
 	return memcg;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

