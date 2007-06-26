From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:29 -0700
Message-ID: <200706260346.l5Q3kTfG017638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbXFZDql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: meelap@umich.edu, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: vary maximum delegation limit based on RAM size
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c       |   15 ++++++++++++++-
 include/linux/nfsd/nfsd.h |    1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size
+++ a/fs/nfsd/nfs4state.c
@@ -150,6 +150,7 @@ get_nfs4_file(struct nfs4_file *fi)
 }
 
 static int num_delegations;
+unsigned int max_delegations = 0;
 
 /*
  * Open owner state (share locks)
@@ -193,7 +194,7 @@ alloc_init_deleg(struct nfs4_client *clp
 	struct nfs4_callback *cb = &stp->st_stateowner->so_client->cl_callback;
 
 	dprintk("NFSD alloc_init_deleg\n");
-	if (num_delegations > STATEID_HASH_SIZE * 4)
+	if (num_delegations > max_delegations)
 		return NULL;
 	dp = kmem_cache_alloc(deleg_slab, GFP_KERNEL);
 	if (dp == NULL)
@@ -3198,6 +3199,17 @@ get_nfs4_grace_period(void)
 	return max(user_lease_time, lease_time) * HZ;
 }
 
+static void
+set_max_delegations()
+{
+	struct sysinfo sys;
+
+	si_meminfo(&sys);
+	sys.totalram *= sys.mem_unit;
+	sys.totalram >>= (18 - PAGE_SHIFT);
+	max_delegations = (unsigned int) sys.totalram;
+}
+
 /* initialization to perform when the nfsd service is started: */
 
 static void
@@ -3213,6 +3225,7 @@ __nfs4_state_start(void)
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
_

Patches currently in -mm which might be from meelap@umich.edu are

knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
knfsd-nfsd4-dont-delegate-files-that-have-had-conflicts.patch
