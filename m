From: akpm@linux-foundation.org
Subject: [merged]
 super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch removed from -mm tree
Date: Fri, 13 Sep 2013 14:15:43 -0700
Message-ID: <5233807f.a+xdGb1uDEI1um1I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3IMVPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, gleb@redhat.com, david@fromorbit.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: [merged] super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch removed from -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,david@fromorbit.com,gleb@redhat.com,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:15:43 -0700


The patch titled
     Subject: super: fix calculation of shrinkable objects for small numbers
has been removed from the -mm tree.  Its filename was
     super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: super: fix calculation of shrinkable objects for small numbers

The sysctl knob sysctl_vfs_cache_pressure is used to determine which
percentage of the shrinkable objects in our cache we should actively try
to shrink.

It works great in situations in which we have many objects (at least more
than 100), because the aproximation errors will be negligible.  But if
this is not the case, specially when total_objects < 100, we may end up
concluding that we have no objects at all (total / 100 = 0, if total <
100).

This is certainly not the biggest killer in the world, but may matter in
very low kernel memory situations.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

 fs/gfs2/glock.c        |    2 +-
 fs/gfs2/quota.c        |    2 +-
 fs/mbcache.c           |    2 +-
 fs/nfs/dir.c           |    2 +-
 fs/quota/dquot.c       |    5 ++---
 fs/super.c             |   14 +++++++-------
 fs/xfs/xfs_qm.c        |    2 +-
 include/linux/dcache.h |    4 ++++
 8 files changed, 18 insertions(+), 15 deletions(-)

diff -puN fs/gfs2/glock.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/fs/gfs2/glock.c
@@ -1463,7 +1463,7 @@ static int gfs2_shrink_glock_memory(stru
 		gfs2_scan_glock_lru(sc->nr_to_scan);
 	}
 
-	return (atomic_read(&lru_count) / 100) * sysctl_vfs_cache_pressure;
+	return vfs_pressure_ratio(atomic_read(&lru_count));
 }
 
 static struct shrinker glock_shrinker = {
diff -puN fs/gfs2/quota.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers fs/gfs2/quota.c
--- a/fs/gfs2/quota.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/fs/gfs2/quota.c
@@ -114,7 +114,7 @@ int gfs2_shrink_qd_memory(struct shrinke
 	spin_unlock(&qd_lru_lock);
 
 out:
-	return (atomic_read(&qd_lru_count) * sysctl_vfs_cache_pressure) / 100;
+	return vfs_pressure_ratio(atomic_read(&qd_lru_count));
 }
 
 static u64 qd2index(struct gfs2_quota_data *qd)
diff -puN fs/mbcache.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers fs/mbcache.c
--- a/fs/mbcache.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/fs/mbcache.c
@@ -189,7 +189,7 @@ mb_cache_shrink_fn(struct shrinker *shri
 	list_for_each_entry_safe(entry, tmp, &free_list, e_lru_list) {
 		__mb_cache_entry_forget(entry, gfp_mask);
 	}
-	return (count / 100) * sysctl_vfs_cache_pressure;
+	return vfs_pressure_ratio(count);
 }
 
 
diff -puN fs/nfs/dir.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers fs/nfs/dir.c
--- a/fs/nfs/dir.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/fs/nfs/dir.c
@@ -2040,7 +2040,7 @@ remove_lru_entry:
 	}
 	spin_unlock(&nfs_access_lru_lock);
 	nfs_access_free_list(&head);
-	return (atomic_long_read(&nfs_access_nr_entries) / 100) * sysctl_vfs_cache_pressure;
+	return vfs_pressure_ratio(atomic_long_read(&nfs_access_nr_entries));
 }
 
 static void __nfs_access_zap_cache(struct nfs_inode *nfsi, struct list_head *head)
diff -puN fs/quota/dquot.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers fs/quota/dquot.c
--- a/fs/quota/dquot.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/fs/quota/dquot.c
@@ -719,9 +719,8 @@ static int shrink_dqcache_memory(struct
 		prune_dqcache(nr);
 		spin_unlock(&dq_list_lock);
 	}
-	return ((unsigned)
-		percpu_counter_read_positive(&dqstats.counter[DQST_FREE_DQUOTS])
-		/100) * sysctl_vfs_cache_pressure;
+	return vfs_pressure_ratio(
+	percpu_counter_read_positive(&dqstats.counter[DQST_FREE_DQUOTS]));
 }
 
 static struct shrinker dqcache_shrinker = {
diff -puN fs/super.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers fs/super.c
--- a/fs/super.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/fs/super.c
@@ -82,13 +82,13 @@ static int prune_super(struct shrinker *
 		int	inodes;
 
 		/* proportion the scan between the caches */
-		dentries = (sc->nr_to_scan * sb->s_nr_dentry_unused) /
-							total_objects;
-		inodes = (sc->nr_to_scan * sb->s_nr_inodes_unused) /
-							total_objects;
+		dentries = mult_frac(sc->nr_to_scan, sb->s_nr_dentry_unused,
+							total_objects);
+		inodes = mult_frac(sc->nr_to_scan, sb->s_nr_inodes_unused,
+							total_objects);
 		if (fs_objects)
-			fs_objects = (sc->nr_to_scan * fs_objects) /
-							total_objects;
+			fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
+							total_objects);
 		/*
 		 * prune the dcache first as the icache is pinned by it, then
 		 * prune the icache, followed by the filesystem specific caches
@@ -104,7 +104,7 @@ static int prune_super(struct shrinker *
 				sb->s_nr_inodes_unused + fs_objects;
 	}
 
-	total_objects = (total_objects / 100) * sysctl_vfs_cache_pressure;
+	total_objects = vfs_pressure_ratio(total_objects);
 	drop_super(sb);
 	return total_objects;
 }
diff -puN fs/xfs/xfs_qm.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers fs/xfs/xfs_qm.c
--- a/fs/xfs/xfs_qm.c~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/fs/xfs/xfs_qm.c
@@ -1722,7 +1722,7 @@ xfs_qm_shake(
 	}
 
 out:
-	return (qi->qi_lru_count / 100) * sysctl_vfs_cache_pressure;
+	return vfs_pressure_ratio(qi->qi_lru_count);
 }
 
 /*
diff -puN include/linux/dcache.h~super-fix-calculation-of-shrinkable-objects-for-small-numbers include/linux/dcache.h
--- a/include/linux/dcache.h~super-fix-calculation-of-shrinkable-objects-for-small-numbers
+++ a/include/linux/dcache.h
@@ -416,4 +416,8 @@ static inline bool d_mountpoint(struct d
 
 extern int sysctl_vfs_cache_pressure;
 
+static inline unsigned long vfs_pressure_ratio(unsigned long val)
+{
+	return mult_frac(val, sysctl_vfs_cache_pressure, 100);
+}
 #endif	/* __LINUX_DCACHE_H */
_

Patches currently in -mm which might be from glommer@openvz.org are

origin.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
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

