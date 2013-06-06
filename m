From: akpm@linux-foundation.org
Subject: + fs-bump-inode-and-dentry-counters-to-long.patch added to -mm
 tree
Date: Thu, 06 Jun 2013 14:10:49 -0700
Message-ID: <51b0fad9.hx4vewzup7J2zwQS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3FFVKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 17:10:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, gleb@redhat.com, dchinner@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, glommer@openvz.org

Subject: + fs-bump-inode-and-dentry-counters-to-long.patch added to -mm tree
To: glommer@openvz.org,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,dchinner@redhat.com,gleb@redhat.com,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 14:10:49 -0700


The patch titled
     Subject: fs: bump inode and dentry counters to long
has been added to the -mm tree.  Its filename is
     fs-bump-inode-and-dentry-counters-to-long.patch

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
Subject: fs: bump inode and dentry counters to long

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
@@ -117,13 +117,13 @@ struct dentry_stat_t dentry_stat = {
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
@@ -133,7 +133,7 @@ int proc_nr_dentry(ctl_table *table, int
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
@@ -70,33 +70,33 @@ EXPORT_SYMBOL(empty_aops);
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
 
@@ -109,7 +109,7 @@ int proc_nr_inodes(ctl_table *table, int
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
@@ -117,7 +117,7 @@ extern void inode_add_lru(struct inode *
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
@@ -1266,12 +1266,12 @@ struct super_block {
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
@@ -1456,14 +1456,14 @@ static struct ctl_table fs_table[] = {
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
@@ -1493,7 +1493,7 @@ static struct ctl_table fs_table[] = {
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

fs-bump-inode-and-dentry-counters-to-long.patch
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

