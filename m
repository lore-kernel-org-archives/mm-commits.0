From: akpm@linux-foundation.org
Subject: - readahead-nfsd-case.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:23 -0700
Message-ID: <200705080815.l488FNk7019050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934600AbXEHIPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     readahead: nfsd case
has been removed from the -mm tree.  Its filename was
     readahead-nfsd-case.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: nfsd case
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Bypass nfsd raparms cache -- the new logic do not rely on it.

Also try to work in peace with the chaotic nfsd requests.

For nfsd reads, the new read-ahead logic can handle
+ disordered nfsd requests
+ concurrent sequential requests on large files

Notes about the chaotic nfsd requests issue:

nfsd read requests can be out of order, concurrent and with no ra-state info.
They are handled by the context based read-ahead method, which does the job
in the following steps:

1. scan in page cache
2. make read-ahead decisions
3. alloc new pages
4. insert new pages to page cache

A single read-ahead chunk in the client side will be dissembled and serviced
by many concurrent nfsd in the server side. It is highly possible for two or
more of these parallel nfsd instances to be in step 1/2/3 at the same time.
Without knowing others working on the same file region, they will issue
overlapped read-ahead requests, which lead to many conflicts at step 4.

To work with the tricky situation, readahead decision of nfsd requests is
delayed a bit.

Benchmark results with local mounted nfs(tcp,rsize=32768):

SMALL FILES
readahead_ratio = 8, ra_max = 1024kb
92.99s real  10.32s system  3.23s user  145004+1826 cs  diff -r $NFSDIR $NFSDIR2
readahead_ratio = 70, ra_max = 1024kb
90.96s real  10.68s system  3.22s user  144414+2520 cs  diff -r $NFSDIR $NFSDIR2

BIG FILES
readahead_ratio = 8, ra_max = 1024kb (old logic)
48.36s real  2.22s system  1.51s user  7209+4110 cs  diff $NFSFILE $NFSFILE2
readahead_ratio = 70, ra_max = 1024kb (new logic)
30.04s real  2.46s system  1.33s user  5420+2492 cs  diff $NFSFILE $NFSFILE2

[akpm@osdl.org: warning fix]
Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c    |    3 +++
 fs/nfsd/vfs.c      |    6 +++++-
 include/linux/fs.h |    1 +
 mm/readahead.c     |   42 ++++++++++++++++++++++++++++++++----------
 4 files changed, 41 insertions(+), 11 deletions(-)

diff -puN fs/nfs/client.c~readahead-nfsd-case fs/nfs/client.c
--- a/fs/nfs/client.c~readahead-nfsd-case
+++ a/fs/nfs/client.c
@@ -658,6 +658,9 @@ static void nfs_server_set_fsinfo(struct
 		server->rsize = NFS_MAX_FILE_IO_SIZE;
 	server->rpages = (server->rsize + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	server->backing_dev_info.ra_pages = server->rpages * NFS_MAX_READAHEAD;
+	server->backing_dev_info.ra_pages0 = min_t(unsigned, server->rpages,
+				VM_MIN_READAHEAD >> (PAGE_CACHE_SHIFT - 10));
+	server->backing_dev_info.ra_thrash_bytes = server->rsize * NFS_MAX_READAHEAD;
 
 	if (server->wsize > max_rpc_payload)
 		server->wsize = max_rpc_payload;
diff -puN fs/nfsd/vfs.c~readahead-nfsd-case fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~readahead-nfsd-case
+++ a/fs/nfsd/vfs.c
@@ -856,7 +856,11 @@ nfsd_vfs_read(struct svc_rqst *rqstp, st
 #endif
 
 	/* Get readahead parameters */
-	ra = nfsd_get_raparms(inode->i_sb->s_dev, inode->i_ino);
+	if (prefer_adaptive_readahead()) {
+		ra = NULL;
+		file->f_ra.flags |= RA_FLAG_NFSD;
+	} else
+		ra = nfsd_get_raparms(inode->i_sb->s_dev, inode->i_ino);
 
 	if (ra && ra->p_set)
 		file->f_ra = ra->p_ra;
diff -puN include/linux/fs.h~readahead-nfsd-case include/linux/fs.h
--- a/include/linux/fs.h~readahead-nfsd-case
+++ a/include/linux/fs.h
@@ -746,6 +746,7 @@ struct file_ra_state {
 #define RA_FLAG_INCACHE	(1UL<<30) /* file is already in cache */
 #define RA_FLAG_MMAP	(1UL<<29) /* mmap page access */
 #define RA_FLAG_LOOP	(1UL<<28) /* loopback file */
+#define RA_FLAG_NFSD	(1UL<<27) /* nfsd read */
 
 struct file {
 	/*
diff -puN mm/readahead.c~readahead-nfsd-case mm/readahead.c
--- a/mm/readahead.c~readahead-nfsd-case
+++ a/mm/readahead.c
@@ -1292,7 +1292,6 @@ static unsigned long count_history_pages
 	pgoff_t head;
 	unsigned long count;
 	unsigned long lookback;
-	unsigned long hit_rate;
 
 	/*
 	 * Scan backward and check the near @ra_max pages.
@@ -1306,11 +1305,13 @@ static unsigned long count_history_pages
 	count = offset - head;
 
 	/*
-	 * Ensure readahead hit rate
+	 * Ensure readahead hit rate, when it's not a chaotic nfsd read.
 	 */
-	hit_rate = max(readahead_hit_rate, 1);
-	if (count_cache_hit(mapping, head, offset) * hit_rate < count)
-		count = 0;
+	if (!(ra->flags & RA_FLAG_NFSD)) {
+		unsigned long hit_rate = max(readahead_hit_rate, 1);
+		if (__count_cache_hit(mapping, head, offset) * hit_rate < count)
+			count = 0;
+	}
 
 	/*
 	 * Unnecessary to count more?
@@ -1634,6 +1635,10 @@ page_cache_readahead_adaptive(struct add
 	unsigned long ra_max;
 	int ret;
 
+	/* no read-ahead */
+	if (!ra->ra_pages)
+		return 0;
+
 	if (page) {
 		ClearPageReadahead(page);
 
@@ -1662,11 +1667,13 @@ page_cache_readahead_adaptive(struct add
 
 	ra_max = get_max_readahead(ra);
 
-	/* read-ahead disabled? */
-	if (unlikely(!ra_max || !readahead_ratio)) {
-		ra_size = max_sane_readahead(req_size);
+	/* read as is */
+	if (!readahead_ratio)
+		goto readit;
+
+	/* nfsd read */
+	if (!page && (ra->flags & RA_FLAG_NFSD))
 		goto readit;
-	}
 
 	/*
 	 * Start of file.
@@ -1713,17 +1720,32 @@ page_cache_readahead_adaptive(struct add
 		return 0;
 	}
 
+readit:
 	/*
 	 * Random read.
 	 */
 	ra_size = min(req_size, ra_max);
-readit:
 	ra_size = __do_page_cache_readahead(mapping, filp, offset, ra_size, 0);
 
 	ra_account(ra, RA_EVENT_RANDOM_READ, ra_size);
 	dprintk("random_read(ino=%lu, req=%lu+%lu) = %lu\n",
 		mapping->host->i_ino, offset, req_size, ra_size);
 
+	/*
+	 * nfsd read-ahead, starting stage.
+	 */
+	if (ra->flags & RA_FLAG_NFSD) {
+		pgoff_t ra_index = offset + ra_size;
+		if (probe_page(mapping, offset - 1) &&
+		   !probe_page(mapping, ra_index)) {
+			ra->prev_index = ra_index - 1;
+			ret = try_context_based_readahead(mapping, ra, NULL,
+						 ra_index, req_size, ra_max);
+			if (ret > 0)
+				ra_size += ra_submit(ra, mapping, filp);
+		}
+	}
+
 	return ra_size;
 }
 EXPORT_SYMBOL_GPL(page_cache_readahead_adaptive);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
