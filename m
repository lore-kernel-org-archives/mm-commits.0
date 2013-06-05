From: akpm@linux-foundation.org
Subject: +
 dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch added
 to -mm tree
Date: Wed, 05 Jun 2013 16:10:38 -0700
Message-ID: <51afc56e.saRmUPOH+H9f7mcO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:10:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: + dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch added to -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:10:38 -0700


The patch titled
     Subject: dcache: remove dentries from LRU before putting on dispose list
has been added to the -mm tree.  Its filename is
     dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: dcache: remove dentries from LRU before putting on dispose list

One of the big problems with modifying the way the dcache shrinker and LRU
implementation works is that the LRU is abused in several ways.  One of
these is shrink_dentry_list().

Basically, we can move a dentry off the LRU onto a different list without
doing any accounting changes, and then use dentry_lru_prune() to remove it
from what-ever list it is now on to do the LRU accounting at that point.

This makes it -really hard- to change the LRU implementation.  The use of
the per-sb LRU lock serialises movement of the dentries between the
different lists and the removal of them, and this is the only reason that
it works.  If we want to break up the dentry LRU lock and lists into, say,
per-node lists, we remove the only serialisation that allows this lru
list/dispose list abuse to work.

To make this work effectively, the dispose list has to be isolated from
the LRU list - dentries have to be removed from the LRU *before* being
placed on the dispose list.  This means that the LRU accounting and
isolation is completed before disposal is started, and that means we can
change the LRU implementation freely in future.

This means that dentries *must* be marked with DCACHE_SHRINK_LIST when
they are placed on the dispose list so that we don't think that parent
dentries found in try_prune_one_dentry() are on the LRU when the are
actually on the dispose list.  This would result in accounting the dentry
to the LRU a second time.  Hence dentry_lru_del() has to handle the
DCACHE_SHRINK_LIST case

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   98 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 77 insertions(+), 21 deletions(-)

diff -puN fs/dcache.c~dcache-remove-dentries-from-lru-before-putting-on-dispose-list fs/dcache.c
--- a/fs/dcache.c~dcache-remove-dentries-from-lru-before-putting-on-dispose-list
+++ a/fs/dcache.c
@@ -315,7 +315,7 @@ static void dentry_unlink_inode(struct d
 }
 
 /*
- * dentry_lru_(add|del|prune|move_tail) must be called with d_lock held.
+ * dentry_lru_(add|del|move_list) must be called with d_lock held.
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
@@ -331,16 +331,25 @@ static void dentry_lru_add(struct dentry
 static void __dentry_lru_del(struct dentry *dentry)
 {
 	list_del_init(&dentry->d_lru);
-	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
 	this_cpu_dec(nr_dentry_unused);
 }
 
 /*
  * Remove a dentry with references from the LRU.
+ *
+ * If we are on the shrink list, then we can get to try_prune_one_dentry() and
+ * lose our last reference through the parent walk. In this case, we need to
+ * remove ourselves from the shrink list, not the LRU.
  */
 static void dentry_lru_del(struct dentry *dentry)
 {
+	if (dentry->d_flags & DCACHE_SHRINK_LIST) {
+		list_del_init(&dentry->d_lru);
+		dentry->d_flags &= ~DCACHE_SHRINK_LIST;
+		return;
+	}
+
 	if (!list_empty(&dentry->d_lru)) {
 		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 		__dentry_lru_del(dentry);
@@ -350,13 +359,15 @@ static void dentry_lru_del(struct dentry
 
 static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 {
+	BUG_ON(dentry->d_flags & DCACHE_SHRINK_LIST);
+
 	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, list);
-		dentry->d_sb->s_nr_dentry_unused++;
-		this_cpu_inc(nr_dentry_unused);
 	} else {
 		list_move_tail(&dentry->d_lru, list);
+		dentry->d_sb->s_nr_dentry_unused--;
+		this_cpu_dec(nr_dentry_unused);
 	}
 	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 }
@@ -454,7 +465,8 @@ EXPORT_SYMBOL(d_drop);
  * If ref is non-zero, then decrement the refcount too.
  * Returns dentry requiring refcount drop, or NULL if we're done.
  */
-static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
+static inline struct dentry *
+dentry_kill(struct dentry *dentry, int ref, int unlock_on_failure)
 	__releases(dentry->d_lock)
 {
 	struct inode *inode;
@@ -463,8 +475,10 @@ static inline struct dentry *dentry_kill
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		spin_unlock(&dentry->d_lock);
-		cpu_relax();
+		if (unlock_on_failure) {
+			spin_unlock(&dentry->d_lock);
+			cpu_relax();
+		}
 		return dentry; /* try again with same dentry */
 	}
 	if (IS_ROOT(dentry))
@@ -551,7 +565,7 @@ repeat:
 	return;
 
 kill_it:
-	dentry = dentry_kill(dentry, 1);
+	dentry = dentry_kill(dentry, 1, 1);
 	if (dentry)
 		goto repeat;
 }
@@ -750,12 +764,12 @@ EXPORT_SYMBOL(d_prune_aliases);
  *
  * This may fail if locks cannot be acquired no problem, just try again.
  */
-static void try_prune_one_dentry(struct dentry *dentry)
+static struct dentry * try_prune_one_dentry(struct dentry *dentry)
 	__releases(dentry->d_lock)
 {
 	struct dentry *parent;
 
-	parent = dentry_kill(dentry, 0);
+	parent = dentry_kill(dentry, 0, 0);
 	/*
 	 * If dentry_kill returns NULL, we have nothing more to do.
 	 * if it returns the same dentry, trylocks failed. In either
@@ -767,9 +781,9 @@ static void try_prune_one_dentry(struct
 	 * fragmentation.
 	 */
 	if (!parent)
-		return;
+		return NULL;
 	if (parent == dentry)
-		return;
+		return dentry;
 
 	/* Prune ancestors. */
 	dentry = parent;
@@ -778,10 +792,11 @@ static void try_prune_one_dentry(struct
 		if (dentry->d_count > 1) {
 			dentry->d_count--;
 			spin_unlock(&dentry->d_lock);
-			return;
+			return NULL;
 		}
-		dentry = dentry_kill(dentry, 1);
+		dentry = dentry_kill(dentry, 1, 1);
 	}
+	return NULL;
 }
 
 static void shrink_dentry_list(struct list_head *list)
@@ -800,21 +815,31 @@ static void shrink_dentry_list(struct li
 		}
 
 		/*
+		 * The dispose list is isolated and dentries are not accounted
+		 * to the LRU here, so we can simply remove it from the list
+		 * here regardless of whether it is referenced or not.
+		 */
+		list_del_init(&dentry->d_lru);
+		dentry->d_flags &= ~DCACHE_SHRINK_LIST;
+
+		/*
 		 * We found an inuse dentry which was not removed from
-		 * the LRU because of laziness during lookup.  Do not free
-		 * it - just keep it off the LRU list.
+		 * the LRU because of laziness during lookup. Do not free it.
 		 */
 		if (dentry->d_count) {
-			dentry_lru_del(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-
 		rcu_read_unlock();
 
-		try_prune_one_dentry(dentry);
+		dentry = try_prune_one_dentry(dentry);
 
 		rcu_read_lock();
+		if (dentry) {
+			dentry->d_flags |= DCACHE_SHRINK_LIST;
+			list_add(&dentry->d_lru, list);
+			spin_unlock(&dentry->d_lock);
+		}
 	}
 	rcu_read_unlock();
 }
@@ -855,8 +880,10 @@ relock:
 			list_move(&dentry->d_lru, &referenced);
 			spin_unlock(&dentry->d_lock);
 		} else {
-			list_move_tail(&dentry->d_lru, &tmp);
+			list_move(&dentry->d_lru, &tmp);
 			dentry->d_flags |= DCACHE_SHRINK_LIST;
+			this_cpu_dec(nr_dentry_unused);
+			sb->s_nr_dentry_unused--;
 			spin_unlock(&dentry->d_lock);
 			if (!--count)
 				break;
@@ -870,6 +897,27 @@ relock:
 	shrink_dentry_list(&tmp);
 }
 
+/*
+ * Mark all the dentries as on being the dispose list so we don't think they are
+ * still on the LRU if we try to kill them from ascending the parent chain in
+ * try_prune_one_dentry() rather than directly from the dispose list.
+ */
+static void
+shrink_dcache_list(
+	struct list_head *dispose)
+{
+	struct dentry *dentry;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(dentry, dispose, d_lru) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_SHRINK_LIST;
+		spin_unlock(&dentry->d_lock);
+	}
+	rcu_read_unlock();
+	shrink_dentry_list(dispose);
+}
+
 /**
  * shrink_dcache_sb - shrink dcache for a superblock
  * @sb: superblock
@@ -883,9 +931,17 @@ void shrink_dcache_sb(struct super_block
 
 	spin_lock(&sb->s_dentry_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
+		/*
+		 * account for removal here so we don't need to handle it later
+		 * even though the dentry is no longer on the lru list.
+		 */
 		list_splice_init(&sb->s_dentry_lru, &tmp);
+		this_cpu_sub(nr_dentry_unused, sb->s_nr_dentry_unused);
+		sb->s_nr_dentry_unused = 0;
 		spin_unlock(&sb->s_dentry_lru_lock);
-		shrink_dentry_list(&tmp);
+
+		shrink_dcache_list(&tmp);
+
 		spin_lock(&sb->s_dentry_lru_lock);
 	}
 	spin_unlock(&sb->s_dentry_lru_lock);
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

