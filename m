From: akpm@osdl.org
Subject: - nfsd-replace-kmallocmemset-with-kcalloc.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:06 -0800
Message-ID: <200612082011.kB8KB6YN002876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59001 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946551AbWLHULL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: burman.yan@gmail.com, neilb@cse.unsw.edu.au, mm-commits@vger.kernel.org


The patch titled
     nfsd: replace kmalloc+memset with kcalloc + simplify NULL check
has been removed from the -mm tree.  Its filename was
     nfsd-replace-kmallocmemset-with-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd: replace kmalloc+memset with kcalloc + simplify NULL check
From: Yan Burman <burman.yan@gmail.com>

Replace kmalloc+memset with kcalloc and simplify

Signed-off-by: Yan Burman <burman.yan@gmail.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfscache.c |    3 +--
 fs/nfsd/vfs.c      |   35 +++++++++++++++++------------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff -puN fs/nfsd/nfscache.c~nfsd-replace-kmallocmemset-with-kcalloc fs/nfsd/nfscache.c
--- a/fs/nfsd/nfscache.c~nfsd-replace-kmallocmemset-with-kcalloc
+++ a/fs/nfsd/nfscache.c
@@ -66,14 +66,13 @@ nfsd_cache_init(void)
 		printk (KERN_ERR "nfsd: cannot allocate all %d cache entries, only got %d\n",
 			CACHESIZE, CACHESIZE-i);
 
-	hash_list = kmalloc (HASHSIZE * sizeof(struct hlist_head), GFP_KERNEL);
+	hash_list = kcalloc (HASHSIZE, sizeof(struct hlist_head), GFP_KERNEL);
 	if (!hash_list) {
 		nfsd_cache_shutdown();
 		printk (KERN_ERR "nfsd: cannot allocate %Zd bytes for hash list\n",
 			HASHSIZE * sizeof(struct hlist_head));
 		return;
 	}
-	memset(hash_list, 0, HASHSIZE * sizeof(struct hlist_head));
 
 	cache_disabled = 0;
 }
diff -puN fs/nfsd/vfs.c~nfsd-replace-kmallocmemset-with-kcalloc fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-replace-kmallocmemset-with-kcalloc
+++ a/fs/nfsd/vfs.c
@@ -1885,28 +1885,27 @@ nfsd_racache_init(int cache_size)
 		return 0;
 	if (cache_size < 2*RAPARM_HASH_SIZE)
 		cache_size = 2*RAPARM_HASH_SIZE;
-	raparml = kmalloc(sizeof(struct raparms) * cache_size, GFP_KERNEL);
+	raparml = kcalloc(cache_size, sizeof(struct raparms), GFP_KERNEL);
 
-	if (raparml != NULL) {
-		dprintk("nfsd: allocating %d readahead buffers.\n",
-			cache_size);
-		for (i = 0 ; i < RAPARM_HASH_SIZE ; i++) {
-			raparm_hash[i].pb_head = NULL;
-			spin_lock_init(&raparm_hash[i].pb_lock);
-		}
-		nperbucket = cache_size >> RAPARM_HASH_BITS;
-		memset(raparml, 0, sizeof(struct raparms) * cache_size);
-		for (i = 0; i < cache_size - 1; i++) {
-			if (i % nperbucket == 0)
-				raparm_hash[j++].pb_head = raparml + i;
-			if (i % nperbucket < nperbucket-1)
-				raparml[i].p_next = raparml + i + 1;
-		}
-	} else {
+	if (!raparml) {
 		printk(KERN_WARNING
-		       "nfsd: Could not allocate memory read-ahead cache.\n");
+			"nfsd: Could not allocate memory read-ahead cache.\n");
 		return -ENOMEM;
 	}
+
+	dprintk("nfsd: allocating %d readahead buffers.\n", cache_size);
+	for (i = 0 ; i < RAPARM_HASH_SIZE ; i++) {
+		raparm_hash[i].pb_head = NULL;
+		spin_lock_init(&raparm_hash[i].pb_lock);
+	}
+	nperbucket = cache_size >> RAPARM_HASH_BITS;
+	for (i = 0; i < cache_size - 1; i++) {
+		if (i % nperbucket == 0)
+			raparm_hash[j++].pb_head = raparml + i;
+		if (i % nperbucket < nperbucket-1)
+			raparml[i].p_next = raparml + i + 1;
+	}
+
 	nfsdstats.ra_size = cache_size;
 	return 0;
 }
_

Patches currently in -mm which might be from burman.yan@gmail.com are

origin.patch
nfsd-replace-kmallocmemset-with-kcalloc.patch
jffs2-replace-kmallocmemset-with-kzalloc.patch

