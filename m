From: akpm@linux-foundation.org
Subject: [merged] shmem-fix-negative-rss-in-memcg-memorystat.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:32 -0700
Message-ID: <20120712193733.312CB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:44293 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab2GLThf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:35 -0400
Received: by wibhr14 with SMTP id hr14so146132wib.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: fix negative rss in memcg memory.stat
has been removed from the -mm tree.  Its filename was
     shmem-fix-negative-rss-in-memcg-memorystat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: fix negative rss in memcg memory.stat

When adding the page_private checks before calling shmem_replace_page(), I
did realize that there is a further race, but thought it too unlikely to
need a hurried fix.

But independently I've been chasing why a mem cgroup's memory.stat
sometimes shows negative rss after all tasks have gone: I expected it to
be a stats gathering bug, but actually it's shmem swapping's fault.

It's an old surprise, that when you lock_page(lookup_swap_cache(swap)),
the page may have been removed from swapcache before getting the lock; or
it may have been freed and reused and be back in swapcache; and it can
even be using the same swap location as before (page_private same).

The swapoff case is already secure against this (swap cannot be reused
until the whole area has been swapped off, and a new swapped on); and
shmem_getpage_gfp() is protected by shmem_add_to_page_cache()'s check for
the expected radix_tree entry - but a little too late.

By that time, we might have already decided to shmem_replace_page(): I
don't know of a problem from that, but I'd feel more at ease not to do so
spuriously.  And we have already done mem_cgroup_cache_charge(), on
perhaps the wrong mem cgroup: and this charge is not then undone on the
error path, because PageSwapCache ends up preventing that.

It's this last case which causes the occasional negative rss in
memory.stat: the page is charged here as cache, but (sometimes) found to
be anon when eventually it's uncharged - and in between, it's an
undeserved charge on the wrong memcg.

Fix this by adding an earlier check on the radix_tree entry: it's
inelegant to descend the tree twice, but swapping is not the fast path,
and a better solution would need a pair (try+commit) of memcg calls, and a
rework of shmem_replace_page() to keep out of the swapcache.

We can use the added shmem_confirm_swap() function to replace the
find_get_page+page_cache_release we were already doing on the error path. 
And add a comment on that -EEXIST: it seems a peculiar errno to be using,
but originates from its use in radix_tree_insert().

[It can be surprising to see positive rss left in a memcg's memory.stat
after all tasks have gone, since it is supposed to count anonymous but not
shmem.  Aside from sharing anon pages via fork with a task in some other
memcg, it often happens after swapping: because a swap page can't be freed
while under writeback, nor while locked.  So it's not an error, and these
residual pages are easily freed once pressure demands.]

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff -puN mm/shmem.c~shmem-fix-negative-rss-in-memcg-memorystat mm/shmem.c
--- a/mm/shmem.c~shmem-fix-negative-rss-in-memcg-memorystat
+++ a/mm/shmem.c
@@ -264,6 +264,24 @@ static int shmem_radix_tree_replace(stru
 }
 
 /*
+ * Sometimes, before we decide whether to proceed or to fail, we must check
+ * that an entry was not already brought back from swap by a racing thread.
+ *
+ * Checking page is not enough: by the time a SwapCache page is locked, it
+ * might be reused, and again be SwapCache, using the same swap as before.
+ */
+static bool shmem_confirm_swap(struct address_space *mapping,
+			       pgoff_t index, swp_entry_t swap)
+{
+	void *item;
+
+	rcu_read_lock();
+	item = radix_tree_lookup(&mapping->page_tree, index);
+	rcu_read_unlock();
+	return item == swp_to_radix_entry(swap);
+}
+
+/*
  * Like add_to_page_cache_locked, but error if expected item has gone.
  */
 static int shmem_add_to_page_cache(struct page *page,
@@ -1124,9 +1142,9 @@ repeat:
 		/* We have to do this with page locked to prevent races */
 		lock_page(page);
 		if (!PageSwapCache(page) || page_private(page) != swap.val ||
-		    page->mapping) {
+		    !shmem_confirm_swap(mapping, index, swap)) {
 			error = -EEXIST;	/* try again */
-			goto failed;
+			goto unlock;
 		}
 		if (!PageUptodate(page)) {
 			error = -EIO;
@@ -1142,9 +1160,12 @@ repeat:
 
 		error = mem_cgroup_cache_charge(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
-		if (!error)
+		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
 						gfp, swp_to_radix_entry(swap));
+			/* We already confirmed swap, and make no allocation */
+			VM_BUG_ON(error);
+		}
 		if (error)
 			goto failed;
 
@@ -1245,14 +1266,10 @@ decused:
 unacct:
 	shmem_unacct_blocks(info->flags, 1);
 failed:
-	if (swap.val && error != -EINVAL) {
-		struct page *test = find_get_page(mapping, index);
-		if (test && !radix_tree_exceptional_entry(test))
-			page_cache_release(test);
-		/* Have another try if the entry has changed */
-		if (test != swp_to_radix_entry(swap))
-			error = -EEXIST;
-	}
+	if (swap.val && error != -EINVAL &&
+	    !shmem_confirm_swap(mapping, index, swap))
+		error = -EEXIST;
+unlock:
 	if (page) {
 		unlock_page(page);
 		page_cache_release(page);
@@ -1264,7 +1281,7 @@ failed:
 		spin_unlock(&info->lock);
 		goto repeat;
 	}
-	if (error == -EEXIST)
+	if (error == -EEXIST)	/* from above or from radix_tree_insert */
 		goto repeat;
 	return error;
 }
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
shmem-provide-vm_ops-when-also-providing-a-mem-policy.patch
tmpfs-interleave-the-starting-node-of-dev-shmem.patch
prio_tree-debugging-patch.patch

