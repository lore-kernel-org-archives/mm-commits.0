From: akpm@linux-foundation.org
Subject: + super-targeted-memcg-reclaim.patch added to -mm tree
Date: Wed, 05 Jun 2013 16:11:33 -0700
Message-ID: <51afc5a5.t57cKmqBZjRWoFAQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab3FEXLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:11:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, riel@redhat.com, penberg@kernel.org, mtosatti@redhat.com, mhocko@suse.cz, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, js1304@gmail.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hughd@google.com, hch@lst.de, hannes@cmpxchg.org, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, anton@enomsg.org, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + super-targeted-memcg-reclaim.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,anton@enomsg.org,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hannes@cmpxchg.org,hch@lst.de,hughd@google.com,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,js1304@gmail.com,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mhocko@suse.cz,mtosatti@redhat.com,penberg@kernel.org,riel@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:11:33 -0700


The patch titled
     Subject: super: targeted memcg reclaim
has been added to the -mm tree.  Its filename is
     super-targeted-memcg-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: super: targeted memcg reclaim

We now have all our dentries and inodes placed in memcg-specific LRU
lists.  All we have to do is restrict the reclaim to the said lists in
case of memcg pressure.

That can't be done so easily for the fs_objects part of the equation,
since this is heavily fs-specific.  What we do is pass on the context, and
let the filesystems decide if they ever chose or want to.  At this time,
we just don't shrink them in memcg pressure (none is supported), leaving
that for global pressure only.

Marking the superblock shrinker and its LRUs as memcg-aware will guarantee
that the shrinkers will get invoked during targetted reclaim.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
Cc: J. Bruce Fields <bfields@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c   |    7 ++++---
 fs/inode.c    |    7 ++++---
 fs/internal.h |    5 +++--
 fs/super.c    |   39 ++++++++++++++++++++++++++-------------
 4 files changed, 37 insertions(+), 21 deletions(-)

diff -puN fs/dcache.c~super-targeted-memcg-reclaim fs/dcache.c
--- a/fs/dcache.c~super-targeted-memcg-reclaim
+++ a/fs/dcache.c
@@ -889,13 +889,14 @@ dentry_lru_isolate(struct list_head *ite
  * use.
  */
 long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
-		     int nid)
+		     int nid, struct mem_cgroup *memcg)
 {
 	LIST_HEAD(dispose);
 	long freed;
 
-	freed = list_lru_walk_node(&sb->s_dentry_lru, nid, dentry_lru_isolate,
-				       &dispose, &nr_to_scan);
+	freed = list_lru_walk_node_memcg(&sb->s_dentry_lru, nid,
+					dentry_lru_isolate, &dispose,
+					&nr_to_scan, memcg);
 	shrink_dentry_list(&dispose);
 	return freed;
 }
diff -puN fs/inode.c~super-targeted-memcg-reclaim fs/inode.c
--- a/fs/inode.c~super-targeted-memcg-reclaim
+++ a/fs/inode.c
@@ -747,13 +747,14 @@ inode_lru_isolate(struct list_head *item
  * then are freed outside inode_lock by dispose_list().
  */
 long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan,
-		     int nid)
+		     int nid, struct mem_cgroup *memcg)
 {
 	LIST_HEAD(freeable);
 	long freed;
 
-	freed = list_lru_walk_node(&sb->s_inode_lru, nid, inode_lru_isolate,
-				       &freeable, &nr_to_scan);
+	freed = list_lru_walk_node_memcg(&sb->s_inode_lru, nid,
+					inode_lru_isolate, &freeable,
+					&nr_to_scan, memcg);
 	dispose_list(&freeable);
 	return freed;
 }
diff -puN fs/internal.h~super-targeted-memcg-reclaim fs/internal.h
--- a/fs/internal.h~super-targeted-memcg-reclaim
+++ a/fs/internal.h
@@ -16,6 +16,7 @@ struct file_system_type;
 struct linux_binprm;
 struct path;
 struct mount;
+struct mem_cgroup;
 
 /*
  * block_dev.c
@@ -111,7 +112,7 @@ extern int open_check_o_direct(struct fi
  */
 extern spinlock_t inode_sb_list_lock;
 extern long prune_icache_sb(struct super_block *sb, unsigned long nr_to_scan,
-			    int nid);
+			    int nid, struct mem_cgroup *memcg);
 extern void inode_add_lru(struct inode *inode);
 
 /*
@@ -128,7 +129,7 @@ extern int invalidate_inodes(struct supe
  */
 extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
 extern long prune_dcache_sb(struct super_block *sb, unsigned long nr_to_scan,
-			    int nid);
+			    int nid, struct mem_cgroup *memcg);
 
 /*
  * read_write.c
diff -puN fs/super.c~super-targeted-memcg-reclaim fs/super.c
--- a/fs/super.c~super-targeted-memcg-reclaim
+++ a/fs/super.c
@@ -34,6 +34,7 @@
 #include <linux/cleancache.h>
 #include <linux/fsnotify.h>
 #include <linux/lockdep.h>
+#include <linux/memcontrol.h>
 #include "internal.h"
 
 
@@ -56,6 +57,7 @@ static char *sb_writers_name[SB_FREEZE_L
 static long super_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct super_block *sb;
+	struct mem_cgroup *memcg = sc->target_mem_cgroup;
 	long	fs_objects = 0;
 	long	total_objects;
 	long	freed = 0;
@@ -74,11 +76,12 @@ static long super_cache_scan(struct shri
 	if (!grab_super_passive(sb))
 		return -1;
 
-	if (sb->s_op && sb->s_op->nr_cached_objects)
+	if (sb->s_op && sb->s_op->nr_cached_objects && !memcg)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc->nid);
 
-	inodes = list_lru_count_node(&sb->s_inode_lru, sc->nid);
-	dentries = list_lru_count_node(&sb->s_dentry_lru, sc->nid);
+	inodes = list_lru_count_node_memcg(&sb->s_inode_lru, sc->nid, memcg);
+	dentries = list_lru_count_node_memcg(&sb->s_dentry_lru, sc->nid, memcg);
+
 	total_objects = dentries + inodes + fs_objects + 1;
 
 	/* proportion the scan between the caches */
@@ -89,8 +92,8 @@ static long super_cache_scan(struct shri
 	 * prune the dcache first as the icache is pinned by it, then
 	 * prune the icache, followed by the filesystem specific caches
 	 */
-	freed = prune_dcache_sb(sb, dentries, sc->nid);
-	freed += prune_icache_sb(sb, inodes, sc->nid);
+	freed = prune_dcache_sb(sb, dentries, sc->nid, memcg);
+	freed += prune_icache_sb(sb, inodes, sc->nid, memcg);
 
 	if (fs_objects) {
 		fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
@@ -107,20 +110,26 @@ static long super_cache_count(struct shr
 {
 	struct super_block *sb;
 	long	total_objects = 0;
+	struct mem_cgroup *memcg = sc->target_mem_cgroup;
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
 	if (!grab_super_passive(sb))
 		return 0;
 
-	if (sb->s_op && sb->s_op->nr_cached_objects)
+	/*
+	 * Ideally we would pass memcg to nr_cached_objects, and
+	 * let the underlying filesystem decide. Most likely the
+	 * path will be if (!memcg) return;, but even then.
+	 */
+	if (sb->s_op && sb->s_op->nr_cached_objects && !memcg)
 		total_objects = sb->s_op->nr_cached_objects(sb,
 						 sc->nid);
 
-	total_objects += list_lru_count_node(&sb->s_dentry_lru,
-						 sc->nid);
-	total_objects += list_lru_count_node(&sb->s_inode_lru,
-						 sc->nid);
+	total_objects += list_lru_count_node_memcg(&sb->s_dentry_lru,
+						 sc->nid, memcg);
+	total_objects += list_lru_count_node_memcg(&sb->s_inode_lru,
+						 sc->nid, memcg);
 
 	total_objects = vfs_pressure_ratio(total_objects);
 	drop_super(sb);
@@ -199,8 +208,10 @@ static struct super_block *alloc_super(s
 		INIT_HLIST_NODE(&s->s_instances);
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
-		list_lru_init(&s->s_dentry_lru);
-		list_lru_init(&s->s_inode_lru);
+
+		list_lru_init_memcg(&s->s_dentry_lru);
+		list_lru_init_memcg(&s->s_inode_lru);
+
 		INIT_LIST_HEAD(&s->s_mounts);
 		init_rwsem(&s->s_umount);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
@@ -236,7 +247,7 @@ static struct super_block *alloc_super(s
 		s->s_shrink.scan_objects = super_cache_scan;
 		s->s_shrink.count_objects = super_cache_count;
 		s->s_shrink.batch = 1024;
-		s->s_shrink.flags = SHRINKER_NUMA_AWARE;
+		s->s_shrink.flags = SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE;
 	}
 out:
 	return s;
@@ -319,6 +330,8 @@ void deactivate_locked_super(struct supe
 
 		/* caches are now gone, we can safely kill the shrinker now */
 		unregister_shrinker(&s->s_shrink);
+		list_lru_destroy(&s->s_dentry_lru);
+		list_lru_destroy(&s->s_inode_lru);
 		put_filesystem(fs);
 		put_super(s);
 	} else {
_

Patches currently in -mm which might be from glommer@openvz.org are

fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
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
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

