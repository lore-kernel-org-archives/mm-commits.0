From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 27 May 2016 11:42:01 -0700
Message-ID: <574894f9.u59ynk437XE43YA/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcE0SmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/flexfilelayout/flexfilelayout.h    |    4 ----
 fs/nfs/flexfilelayout/flexfilelayoutdev.c |    3 ---
 fs/nfs/pnfs.c                             |    4 ----
 fs/nfs/write.c                            |    5 -----
 tools/perf/util/machine.c                 |   17 -----------------
 5 files changed, 33 deletions(-)

diff -puN fs/nfs/flexfilelayout/flexfilelayout.h~linux-next-git-rejects fs/nfs/flexfilelayout/flexfilelayout.h
--- a/fs/nfs/flexfilelayout/flexfilelayout.h~linux-next-git-rejects
+++ a/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -199,9 +199,5 @@ struct rpc_cred *ff_layout_get_ds_cred(s
 				       u32 ds_idx, struct rpc_cred *mdscred);
 bool ff_layout_has_available_ds(struct pnfs_layout_segment *lseg);
 bool ff_layout_avoid_mds_available_ds(struct pnfs_layout_segment *lseg);
-<<<<<<< HEAD
 bool ff_layout_avoid_read_on_rw(struct pnfs_layout_segment *lseg);
-
-=======
->>>>>>> linux-next/akpm-base
 #endif /* FS_NFS_NFS4FLEXFILELAYOUT_H */
diff -puN fs/nfs/flexfilelayout/flexfilelayoutdev.c~linux-next-git-rejects fs/nfs/flexfilelayout/flexfilelayoutdev.c
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c~linux-next-git-rejects
+++ a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -557,15 +557,12 @@ bool ff_layout_avoid_mds_available_ds(st
 	       ff_layout_has_available_ds(lseg);
 }
 
-<<<<<<< HEAD
 bool ff_layout_avoid_read_on_rw(struct pnfs_layout_segment *lseg)
 {
 	return lseg->pls_range.iomode == IOMODE_RW &&
 	       ff_layout_no_read_on_rw(lseg);
 }
 
-=======
->>>>>>> linux-next/akpm-base
 module_param(dataserver_retrans, uint, 0644);
 MODULE_PARM_DESC(dataserver_retrans, "The  number of times the NFSv4.1 client "
 			"retries a request before it attempts further "
diff -puN fs/nfs/pnfs.c~linux-next-git-rejects fs/nfs/pnfs.c
--- a/fs/nfs/pnfs.c~linux-next-git-rejects
+++ a/fs/nfs/pnfs.c
@@ -1547,11 +1547,7 @@ lookup_again:
 		goto out_unlock;
 	}
 
-<<<<<<< HEAD
 	lseg = pnfs_find_lseg(lo, &arg, strict_iomode);
-=======
-	lseg = pnfs_find_lseg(lo, &arg);
->>>>>>> linux-next/akpm-base
 	if (lseg) {
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				PNFS_UPDATE_LAYOUT_FOUND_CACHED);
diff -puN fs/nfs/write.c~linux-next-git-rejects fs/nfs/write.c
--- a/fs/nfs/write.c~linux-next-git-rejects
+++ a/fs/nfs/write.c
@@ -1739,13 +1739,8 @@ int nfs_commit_file(struct file *file, s
 
 	open = get_nfs_open_context(nfs_file_open_context(file));
 	req  = nfs_create_request(open, NULL, NULL, 0, i_size_read(inode));
-<<<<<<< HEAD
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
-=======
-	if (!req) {
-		ret = -ENOMEM;
->>>>>>> linux-next/akpm-base
 		goto out_put;
 	}
 
diff -puN tools/perf/util/machine.c~linux-next-git-rejects tools/perf/util/machine.c
--- a/tools/perf/util/machine.c~linux-next-git-rejects
+++ a/tools/perf/util/machine.c
@@ -1810,11 +1810,7 @@ static int thread__resolve_callchain_sam
 	struct ip_callchain *chain = sample->callchain;
 	int chain_nr = chain->nr;
 	u8 cpumode = PERF_RECORD_MISC_USER;
-<<<<<<< HEAD
-	int i, j, err, nr_entries;
-=======
 	int i, j, err, nr_entries, nr_contexts;
->>>>>>> linux-next/akpm-base
 	int skip_idx = -1;
 	int first_call = 0;
 
@@ -1829,12 +1825,8 @@ static int thread__resolve_callchain_sam
 	 * Based on DWARF debug information, some architectures skip
 	 * a callchain entry saved by the kernel.
 	 */
-<<<<<<< HEAD
-	skip_idx = arch_skip_callchain_idx(thread, chain);
-=======
 	if (chain_nr < sysctl_perf_event_max_stack)
 		skip_idx = arch_skip_callchain_idx(thread, chain);
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * Add branches to call stack for easier browsing. This gives
@@ -1894,11 +1886,7 @@ static int thread__resolve_callchain_sam
 	}
 
 check_calls:
-<<<<<<< HEAD
-	for (i = first_call, nr_entries = 0;
-=======
 	for (i = first_call, nr_entries = 0, nr_contexts = 0;
->>>>>>> linux-next/akpm-base
 	     i < chain_nr && nr_entries < max_stack; i++) {
 		u64 ip;
 
@@ -1913,10 +1901,6 @@ check_calls:
 #endif
 		ip = chain->ips[j];
 
-<<<<<<< HEAD
-		if (ip < PERF_CONTEXT_MAX)
-                       ++nr_entries;
-=======
 		if (ip >= PERF_CONTEXT_MAX) {
 			if (++nr_contexts > sysctl_perf_event_max_contexts_per_stack)
 				goto out_corrupted_callchain;
@@ -1924,7 +1908,6 @@ check_calls:
 			if (++nr_entries > sysctl_perf_event_max_stack)
 				goto out_corrupted_callchain;
 		}
->>>>>>> linux-next/akpm-base
 
 		err = add_callchain_ip(thread, cursor, parent, root_al, &cpumode, ip);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

