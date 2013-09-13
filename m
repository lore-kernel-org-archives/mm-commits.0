From: akpm@linux-foundation.org
Subject: [merged] fs-bump-inode-and-dentry-counters-to-long.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 14:15:41 -0700
Message-ID: <5233807d.xxSn2TlNvy1p6+JN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3IMVPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: [merged] fs-bump-inode-and-dentry-counters-to-long.patch removed from -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:15:41 -0700


The patch titled
     Subject: fs: bump inode and dentry counters to long
has been removed from the -mm tree.  Its filename was
     fs-bump-inode-and-dentry-counters-to-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@openvz.org>
Subject: fs: bump inode and dentry counters to long

This series reworks our current object cache shrinking infrastructure in
two main ways:

 * Noticing that a lot of users copy and paste their own version of LRU
   lists for objects, we put some effort in providing a generic version. 
   It is modeled after the filesystem users: dentries, inodes, and xfs
   (for various tasks), but we expect that other users could benefit in
   the near future with little or no modification.  Let us know if you
   have any issues.

 * The underlying list_lru being proposed automatically and
   transparently keeps the elements in per-node lists, and is able to
   manipulate the node lists individually.  Given this infrastructure, we
   are able to modify the up-to-now hammer called shrink_slab to proceed
   with node-reclaim instead of always searching memory from all over like
   it has been doing.

Per-node lru lists are also expected to lead to less contention in the lru
locks on multi-node scans, since we are now no longer fighting for a
global lock.  The locks usually disappear from the profilers with this
change.

Although we have no official benchmarks for this version - be our guest to
independently evaluate this - earlier versions of this series were
performance tested (details at
http://permalink.gmane.org/gmane.linux.kernel.mm/100537) yielding no
visible performance regressions while yielding a better qualitative
behavior in NUMA machines.

With this infrastructure in place, we can use the list_lru entry point to
provide memcg isolation and per-memcg targeted reclaim.  Historically,
those two pieces of work have been posted together.  This version presents
only the infrastructure work, deferring the memcg work for a later time,
so we can focus on getting this part tested.  You can see more about the
history of such work at http://lwn.net/Articles/552769/

Dave Chinner (18):
  dcache: convert dentry_stat.nr_unused to per-cpu counters
  dentry: move to per-sb LRU locks
  dcache: remove dentries from LRU before putting on dispose list
  mm: new shrinker API
  shrinker: convert superblock shrinkers to new API
  list: add a new LRU list type
  inode: convert inode lru list to generic lru list code.
  dcache: convert to use new lru list infrastructure
  list_lru: per-node list infrastructure
  shrinker: add node awareness
  fs: convert inode and dentry shrinking to be node aware
  xfs: convert buftarg LRU to generic code
  xfs: rework buffer dispose list tracking
  xfs: convert dquot cache lru to list_lru
  fs: convert fs shrinkers to new scan/count API
  drivers: convert shrinkers to new count/scan API
  shrinker: convert remaining shrinkers to count/scan API
  shrinker: Kill old ->shrink API.

Glauber Costa (7):
  fs: bump inode and dentry counters to long
  super: fix calculation of shrinkable objects for small numbers
  list_lru: per-node API
  vmscan: per-node deferred work
  i915: bail out earlier when shrinker cannot acquire mutex
  hugepage: convert huge zero page shrinker to new shrinker API
  list_lru: dynamically adjust node arrays


This patch:

There are situations in very large machines in which we can have a large
quantity of dirty inodes, unused dentries, etc.  This is particularly true
when umounting a filesystem, where eventually since every live object will
eventually be discarded.

Dave Chinner reported a problem with this while experimenting with the
shrinker revamp patchset.  So we believe it is time for a change.  This
patch just moves int to longs.  Machines where it matters should have a
big long anyway.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Chinner <dchinner@redhat.com>
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

 fs/dcache.c             |    8 ++++----
 fs/inode.c              |   18 +++++++++---------
 fs/internal.h           |    2 +-
 include/linux/dcache.h  |   10 +++++-----
 include/linux/fs.h      |    4 ++--
 include/uapi/linux/fs.h |    6 +++---
 kernel/sysctl.c         |    6 +++---
 7 files changed, 27 insertions(+), 27 deletions(-)

diff -puN fs/dcache.c~fs-bump-inode-and-dentry-counters-to-long fs/dcache.c
--- a/fs/dcache.c~fs-bump-inode-and-dentry-counters-to-long
+++ a/fs/dcache.c
@@ -118,13 +118,13 @@ struct dentry_stat_t dentry_stat = {
 	.age_limit = 45,
 };
 
-static DEFINE_PER_CPU(unsigned int, nr_dentry);
+static DEFINE_PER_CPU(long, nr_dentry);
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
-static int get_nr_dentry(void)
+static long get_nr_dentry(void)
 {
 	int i;
-	int sum = 0;
+	long sum = 0;
 	for_each_possible_cpu(i)
 		sum += per_cpu(nr_dentry, i);
 	return sum < 0 ? 0 : sum;
@@ -134,7 +134,7 @@ int proc_nr_dentry(ctl_table *table, int
 		   size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
-	return proc_dointvec(table, write, buffer, lenp, ppos);
+	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #endif
 
diff -puN fs/inode.c~fs-bump-inode-and-dentry-counters-to-long fs/inode.c
--- a/fs/inode.c~fs-bump-inode-and-dentry-counters-to-long
+++ a/fs/inode.c
@@ -71,33 +71,33 @@ EXPORT_SYMBOL(empty_aops);
  */
 struct inodes_stat_t inodes_stat;
 
-static DEFINE_PER_CPU(unsigned int, nr_inodes);
-static DEFINE_PER_CPU(unsigned int, nr_unused);
+static DEFINE_PER_CPU(unsigned long, nr_inodes);
+static DEFINE_PER_CPU(unsigned long, nr_unused);
 
 static struct kmem_cache *inode_cachep __read_mostly;
 
-static int get_nr_inodes(void)
+static long get_nr_inodes(void)
 {
 	int i;
-	int sum = 0;
+	long sum = 0;
 	for_each_possible_cpu(i)
 		sum += per_cpu(nr_inodes, i);
 	return sum < 0 ? 0 : sum;
 }
 
-static inline int get_nr_inodes_unused(void)
+static inline long get_nr_inodes_unused(void)
 {
 	int i;
-	int sum = 0;
+	long sum = 0;
 	for_each_possible_cpu(i)
 		sum += per_cpu(nr_unused, i);
 	return sum < 0 ? 0 : sum;
 }
 
-int get_nr_dirty_inodes(void)
+long get_nr_dirty_inodes(void)
 {
 	/* not actually dirty inodes, but a wild approximation */
-	int nr_dirty = get_nr_inodes() - get_nr_inodes_unused();
+	long nr_dirty = get_nr_inodes() - get_nr_inodes_unused();
 	return nr_dirty > 0 ? nr_dirty : 0;
 }
 
@@ -110,7 +110,7 @@ int proc_nr_inodes(ctl_table *table, int
 {
 	inodes_stat.nr_inodes = get_nr_inodes();
 	inodes_stat.nr_unused = get_nr_inodes_unused();
-	return proc_dointvec(table, write, buffer, lenp, ppos);
+	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #endif
 
diff -puN fs/internal.h~fs-bump-inode-and-dentry-counters-to-long fs/internal.h
--- a/fs/internal.h~fs-bump-inode-and-dentry-counters-to-long
+++ a/fs/internal.h
@@ -118,7 +118,7 @@ extern void inode_add_lru(struct inode *
  */
 extern void inode_wb_list_del(struct inode *inode);
 
-extern int get_nr_dirty_inodes(void);
+extern long get_nr_dirty_inodes(void);
 extern void evict_inodes(struct super_block *);
 extern int invalidate_inodes(struct super_block *, bool);
 
diff -puN include/linux/dcache.h~fs-bump-inode-and-dentry-counters-to-long include/linux/dcache.h
--- a/include/linux/dcache.h~fs-bump-inode-and-dentry-counters-to-long
+++ a/include/linux/dcache.h
@@ -54,11 +54,11 @@ struct qstr {
 #define hashlen_len(hashlen)  ((u32)((hashlen) >> 32))
 
 struct dentry_stat_t {
-	int nr_dentry;
-	int nr_unused;
-	int age_limit;          /* age in seconds */
-	int want_pages;         /* pages requested by system */
-	int dummy[2];
+	long nr_dentry;
+	long nr_unused;
+	long age_limit;          /* age in seconds */
+	long want_pages;         /* pages requested by system */
+	long dummy[2];
 };
 extern struct dentry_stat_t dentry_stat;
 
diff -puN include/linux/fs.h~fs-bump-inode-and-dentry-counters-to-long include/linux/fs.h
--- a/include/linux/fs.h~fs-bump-inode-and-dentry-counters-to-long
+++ a/include/linux/fs.h
@@ -1363,12 +1363,12 @@ struct super_block {
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
 	/* s_dentry_lru, s_nr_dentry_unused protected by dcache.c lru locks */
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
-	int			s_nr_dentry_unused;	/* # of dentry on lru */
+	long			s_nr_dentry_unused;	/* # of dentry on lru */
 
 	/* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
 	spinlock_t		s_inode_lru_lock ____cacheline_aligned_in_smp;
 	struct list_head	s_inode_lru;		/* unused inode lru */
-	int			s_nr_inodes_unused;	/* # of inodes on lru */
+	long			s_nr_inodes_unused;	/* # of inodes on lru */
 
 	struct block_device	*s_bdev;
 	struct backing_dev_info *s_bdi;
diff -puN include/uapi/linux/fs.h~fs-bump-inode-and-dentry-counters-to-long include/uapi/linux/fs.h
--- a/include/uapi/linux/fs.h~fs-bump-inode-and-dentry-counters-to-long
+++ a/include/uapi/linux/fs.h
@@ -49,9 +49,9 @@ struct files_stat_struct {
 };
 
 struct inodes_stat_t {
-	int nr_inodes;
-	int nr_unused;
-	int dummy[5];		/* padding for sysctl ABI compatibility */
+	long nr_inodes;
+	long nr_unused;
+	long dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
 
diff -puN kernel/sysctl.c~fs-bump-inode-and-dentry-counters-to-long kernel/sysctl.c
--- a/kernel/sysctl.c~fs-bump-inode-and-dentry-counters-to-long
+++ a/kernel/sysctl.c
@@ -1471,14 +1471,14 @@ static struct ctl_table fs_table[] = {
 	{
 		.procname	= "inode-nr",
 		.data		= &inodes_stat,
-		.maxlen		= 2*sizeof(int),
+		.maxlen		= 2*sizeof(long),
 		.mode		= 0444,
 		.proc_handler	= proc_nr_inodes,
 	},
 	{
 		.procname	= "inode-state",
 		.data		= &inodes_stat,
-		.maxlen		= 7*sizeof(int),
+		.maxlen		= 7*sizeof(long),
 		.mode		= 0444,
 		.proc_handler	= proc_nr_inodes,
 	},
@@ -1508,7 +1508,7 @@ static struct ctl_table fs_table[] = {
 	{
 		.procname	= "dentry-state",
 		.data		= &dentry_stat,
-		.maxlen		= 6*sizeof(int),
+		.maxlen		= 6*sizeof(long),
 		.mode		= 0444,
 		.proc_handler	= proc_nr_dentry,
 	},
_

Patches currently in -mm which might be from glommer@openvz.org are

origin.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
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

