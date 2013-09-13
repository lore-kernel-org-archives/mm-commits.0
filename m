From: akpm@linux-foundation.org
Subject: [merged]
 dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch removed from
 -mm tree
Date: Fri, 13 Sep 2013 14:15:45 -0700
Message-ID: <52338081.3YfyFZ+cppW/5IRm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3IMVPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 17:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu, thellstrom@vmware.com, swhiteho@redhat.com, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, koverstreet@google.com, kirill.shutemov@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, john.stultz@linaro.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de, gthelen@google.com, glommer@openvz.org, gleb@redhat.com, daniel.vetter@ffwll.ch, cmaiolino@redhat.com, chuck.lever@oracle.com, bfields@redhat.com, arve@android.com, artem.bityutskiy@linux.intel.com, adrian.hunter@intel.com, Trond.Myklebust@netapp.com, dchinner@redhat.com

Subject: [merged] dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch removed from -mm tree
To: dchinner@redhat.com,Trond.Myklebust@netapp.com,adrian.hunter@intel.com,artem.bityutskiy@linux.intel.com,arve@android.com,bfields@redhat.com,chuck.lever@oracle.com,cmaiolino@redhat.com,daniel.vetter@ffwll.ch,gleb@redhat.com,glommer@openvz.org,gthelen@google.com,hch@lst.de,jack@suse.cz,jglisse@redhat.com,john.stultz@linaro.org,kamezawa.hiroyu@jp.fujitsu.com,kirill.shutemov@linux.intel.com,koverstreet@google.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,swhiteho@redhat.com,thellstrom@vmware.com,tytso@mit.edu,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 14:15:45 -0700


The patch titled
     Subject: dcache: convert dentry_stat.nr_unused to per-cpu counters
has been removed from the -mm tree.  Its filename was
     dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: dcache: convert dentry_stat.nr_unused to per-cpu counters

Before we split up the dcache_lru_lock, the unused dentry counter needs to
be made independent of the global dcache_lru_lock.  Convert it to per-cpu
counters to do this.

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

 fs/dcache.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN fs/dcache.c~dcache-convert-dentry_statnr_unused-to-per-cpu-counters fs/dcache.c
--- a/fs/dcache.c~dcache-convert-dentry_statnr_unused-to-per-cpu-counters
+++ a/fs/dcache.c
@@ -119,8 +119,22 @@ struct dentry_stat_t dentry_stat = {
 };
 
 static DEFINE_PER_CPU(long, nr_dentry);
+static DEFINE_PER_CPU(long, nr_dentry_unused);
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+
+/*
+ * Here we resort to our own counters instead of using generic per-cpu counters
+ * for consistency with what the vfs inode code does. We are expected to harvest
+ * better code and performance by having our own specialized counters.
+ *
+ * Please note that the loop is done over all possible CPUs, not over all online
+ * CPUs. The reason for this is that we don't want to play games with CPUs going
+ * on and off. If one of them goes off, we will just keep their counters.
+ *
+ * glommer: See cffbc8a for details, and if you ever intend to change this,
+ * please update all vfs counters to match.
+ */
 static long get_nr_dentry(void)
 {
 	int i;
@@ -130,10 +144,20 @@ static long get_nr_dentry(void)
 	return sum < 0 ? 0 : sum;
 }
 
+static long get_nr_dentry_unused(void)
+{
+	int i;
+	long sum = 0;
+	for_each_possible_cpu(i)
+		sum += per_cpu(nr_dentry_unused, i);
+	return sum < 0 ? 0 : sum;
+}
+
 int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
 		   size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
+	dentry_stat.nr_unused = get_nr_dentry_unused();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
 #endif
@@ -313,7 +337,7 @@ static void dentry_lru_add(struct dentry
 		spin_lock(&dcache_lru_lock);
 		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
-		dentry_stat.nr_unused++;
+		this_cpu_inc(nr_dentry_unused);
 		spin_unlock(&dcache_lru_lock);
 	}
 }
@@ -323,7 +347,7 @@ static void __dentry_lru_del(struct dent
 	list_del_init(&dentry->d_lru);
 	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
 	dentry->d_sb->s_nr_dentry_unused--;
-	dentry_stat.nr_unused--;
+	this_cpu_dec(nr_dentry_unused);
 }
 
 /*
@@ -344,7 +368,7 @@ static void dentry_lru_move_list(struct
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, list);
 		dentry->d_sb->s_nr_dentry_unused++;
-		dentry_stat.nr_unused++;
+		this_cpu_inc(nr_dentry_unused);
 	} else {
 		list_move_tail(&dentry->d_lru, list);
 	}
_

Patches currently in -mm which might be from dchinner@redhat.com are

origin.patch
linux-next.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
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
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

