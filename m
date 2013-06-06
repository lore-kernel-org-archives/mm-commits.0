From: akpm@linux-foundation.org
Subject: + dentry-move-to-per-sb-lru-locks.patch added to -mm tree
Date: Thu, 06 Jun 2013 14:11:17 -0700
Message-ID: <51b0faf5.P769/RARA7tAvx4q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3FFVLT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 17:11:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: + dentry-move-to-per-sb-lru-locks.patch added to -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 14:11:17 -0700


The patch titled
     Subject: dentry: move to per-sb LRU locks
has been added to the -mm tree.  Its filename is
     dentry-move-to-per-sb-lru-locks.patch

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
Subject: dentry: move to per-sb LRU locks

With the dentry LRUs being per-sb structures, there is no real need for
a global dentry_lru_lock. The locking can be made more fine-grained by
moving to a per-sb LRU lock, isolating the LRU operations of different
filesytsems completely from each other. The need for this is independent
of any performance consideration that may arise: in the interest of
abstracting the lru operations away, it is mandatory that each lru works
around its own lock instead of a global lock for all of them.

[glommer@openvz.org: updated changelog ]
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Rientjes <rientjes@google.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c        |   33 ++++++++++++++++-----------------
 fs/super.c         |    1 +
 include/linux/fs.h |    4 +++-
 3 files changed, 20 insertions(+), 18 deletions(-)

diff -puN fs/dcache.c~dentry-move-to-per-sb-lru-locks fs/dcache.c
--- a/fs/dcache.c~dentry-move-to-per-sb-lru-locks
+++ a/fs/dcache.c
@@ -48,7 +48,7 @@
  *   - the dcache hash table
  * s_anon bl list spinlock protects:
  *   - the s_anon list (see __d_drop)
- * dcache_lru_lock protects:
+ * dentry->d_sb->s_dentry_lru_lock protects:
  *   - the dcache lru lists and counters
  * d_lock protects:
  *   - d_flags
@@ -63,7 +63,7 @@
  * Ordering:
  * dentry->d_inode->i_lock
  *   dentry->d_lock
- *     dcache_lru_lock
+ *     dentry->d_sb->s_dentry_lru_lock
  *     dcache_hash_bucket lock
  *     s_anon lock
  *
@@ -81,7 +81,6 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
-static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
@@ -333,11 +332,11 @@ static void dentry_unlink_inode(struct d
 static void dentry_lru_add(struct dentry *dentry)
 {
 	if (list_empty(&dentry->d_lru)) {
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
 		this_cpu_inc(nr_dentry_unused);
-		spin_unlock(&dcache_lru_lock);
+		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 	}
 }
 
@@ -355,15 +354,15 @@ static void __dentry_lru_del(struct dent
 static void dentry_lru_del(struct dentry *dentry)
 {
 	if (!list_empty(&dentry->d_lru)) {
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 		__dentry_lru_del(dentry);
-		spin_unlock(&dcache_lru_lock);
+		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 	}
 }
 
 static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 {
-	spin_lock(&dcache_lru_lock);
+	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, list);
 		dentry->d_sb->s_nr_dentry_unused++;
@@ -371,7 +370,7 @@ static void dentry_lru_move_list(struct
 	} else {
 		list_move_tail(&dentry->d_lru, list);
 	}
-	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 }
 
 /**
@@ -851,14 +850,14 @@ void prune_dcache_sb(struct super_block
 	LIST_HEAD(tmp);
 
 relock:
-	spin_lock(&dcache_lru_lock);
+	spin_lock(&sb->s_dentry_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		dentry = list_entry(sb->s_dentry_lru.prev,
 				struct dentry, d_lru);
 		BUG_ON(dentry->d_sb != sb);
 
 		if (!spin_trylock(&dentry->d_lock)) {
-			spin_unlock(&dcache_lru_lock);
+			spin_unlock(&sb->s_dentry_lru_lock);
 			cpu_relax();
 			goto relock;
 		}
@@ -874,11 +873,11 @@ relock:
 			if (!--count)
 				break;
 		}
-		cond_resched_lock(&dcache_lru_lock);
+		cond_resched_lock(&sb->s_dentry_lru_lock);
 	}
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
-	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&sb->s_dentry_lru_lock);
 
 	shrink_dentry_list(&tmp);
 }
@@ -894,14 +893,14 @@ void shrink_dcache_sb(struct super_block
 {
 	LIST_HEAD(tmp);
 
-	spin_lock(&dcache_lru_lock);
+	spin_lock(&sb->s_dentry_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
-		spin_unlock(&dcache_lru_lock);
+		spin_unlock(&sb->s_dentry_lru_lock);
 		shrink_dentry_list(&tmp);
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&sb->s_dentry_lru_lock);
 	}
-	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&sb->s_dentry_lru_lock);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
 
diff -puN fs/super.c~dentry-move-to-per-sb-lru-locks fs/super.c
--- a/fs/super.c~dentry-move-to-per-sb-lru-locks
+++ a/fs/super.c
@@ -182,6 +182,7 @@ static struct super_block *alloc_super(s
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
+		spin_lock_init(&s->s_dentry_lru_lock);
 		INIT_LIST_HEAD(&s->s_inode_lru);
 		spin_lock_init(&s->s_inode_lru_lock);
 		INIT_LIST_HEAD(&s->s_mounts);
diff -puN include/linux/fs.h~dentry-move-to-per-sb-lru-locks include/linux/fs.h
--- a/include/linux/fs.h~dentry-move-to-per-sb-lru-locks
+++ a/include/linux/fs.h
@@ -1264,7 +1264,9 @@ struct super_block {
 	struct list_head	s_files;
 #endif
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
-	/* s_dentry_lru, s_nr_dentry_unused protected by dcache.c lru locks */
+
+	/* s_dentry_lru_lock protects s_dentry_lru and s_nr_dentry_unused */
+	spinlock_t		s_dentry_lru_lock ____cacheline_aligned_in_smp;
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	long			s_nr_dentry_unused;	/* # of dentry on lru */
 
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
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
list_lru-dynamically-adjust-node-arrays.patch

