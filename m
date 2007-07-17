From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:36 -0700
Message-ID: <200707172304.l6HN4abC011817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936650AbXGQXQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: meelap@umich.edu, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: vary maximum delegation limit based on RAM size
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: vary maximum delegation limit based on RAM size
From: Meelap Shah <meelap@umich.edu>

Our original NFSv4 delegation policy was to give out a read delegation on any
open when it was possible to.

Since the lifetime of a delegation isn't limited to that of an open, a client
may quite reasonably hang on to a delegation as long as it has the inode
cached.  This becomes an obvious problem the first time a client's inode cache
approaches the size of the server's total memory.

Our first quick solution was to add a hard-coded limit.  This patch makes a
mild incremental improvement by varying that limit according to the server's
total memory size, allowing at most 4 delegations per megabyte of RAM.

My quick back-of-the-envelope calculation finds that in the worst case (where
every delegation is for a different inode), a delegation could take about
1.5K, which would make the worst case usage about 6% of memory.  The new limit
works out to be about the same as the old on a 1-gig server.

[akpm@linux-foundation.org: Don't needlessly bloat vmlinux]
[akpm@linux-foundation.org: Make it right for highmem machines]
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c       |   26 +++++++++++++++++++++++++-
 include/linux/nfsd/nfsd.h |    1 +
 mm/page_alloc.c           |    1 +
 3 files changed, 27 insertions(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size
+++ a/fs/nfsd/nfs4state.c
@@ -49,6 +49,7 @@
 #include <linux/nfsd/state.h>
 #include <linux/nfsd/xdr4.h>
 #include <linux/namei.h>
+#include <linux/swap.h>
 #include <linux/mutex.h>
 #include <linux/lockd/bind.h>
 #include <linux/module.h>
@@ -150,6 +151,7 @@ get_nfs4_file(struct nfs4_file *fi)
 }
 
 static int num_delegations;
+unsigned int max_delegations;
 
 /*
  * Open owner state (share locks)
@@ -193,7 +195,7 @@ alloc_init_deleg(struct nfs4_client *clp
 	struct nfs4_callback *cb = &stp->st_stateowner->so_client->cl_callback;
 
 	dprintk("NFSD alloc_init_deleg\n");
-	if (num_delegations > STATEID_HASH_SIZE * 4)
+	if (num_delegations > max_delegations)
 		return NULL;
 	dp = kmem_cache_alloc(deleg_slab, GFP_KERNEL);
 	if (dp == NULL)
@@ -3197,6 +3199,27 @@ get_nfs4_grace_period(void)
 	return max(user_lease_time, lease_time) * HZ;
 }
 
+/*
+ * Since the lifetime of a delegation isn't limited to that of an open, a
+ * client may quite reasonably hang on to a delegation as long as it has
+ * the inode cached.  This becomes an obvious problem the first time a
+ * client's inode cache approaches the size of the server's total memory.
+ *
+ * For now we avoid this problem by imposing a hard limit on the number
+ * of delegations, which varies according to the server's memory size.
+ */
+static void
+set_max_delegations(void)
+{
+	/*
+	 * Allow at most 4 delegations per megabyte of RAM.  Quick
+	 * estimates suggest that in the worst case (where every delegation
+	 * is for a different inode), a delegation could take about 1.5K,
+	 * giving a worst case usage of about 6% of memory.
+	 */
+	max_delegations = nr_free_buffer_pages() >> (20 - 2 - PAGE_SHIFT);
+}
+
 /* initialization to perform when the nfsd service is started: */
 
 static void
@@ -3212,6 +3235,7 @@ __nfs4_state_start(void)
 	       grace_time/HZ);
 	laundry_wq = create_singlethread_workqueue("nfsd4");
 	queue_delayed_work(laundry_wq, &laundromat_work, grace_time);
+	set_max_delegations();
 }
 
 int
diff -puN include/linux/nfsd/nfsd.h~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size
+++ a/include/linux/nfsd/nfsd.h
@@ -148,6 +148,7 @@ extern int nfsd_max_blksize;
  * NFSv4 State
  */
 #ifdef CONFIG_NFSD_V4
+extern unsigned int max_delegations;
 void nfs4_state_init(void);
 int nfs4_state_start(void);
 void nfs4_state_shutdown(void);
diff -puN mm/page_alloc.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size mm/page_alloc.c
--- a/mm/page_alloc.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size
+++ a/mm/page_alloc.c
@@ -1484,6 +1484,7 @@ unsigned int nr_free_buffer_pages(void)
 {
 	return nr_free_zone_pages(gfp_zone(GFP_USER));
 }
+EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
 /*
  * Amount of free RAM allocatable within all zones
_

Patches currently in -mm which might be from meelap@umich.edu are

origin.patch
