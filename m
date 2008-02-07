From: akpm@linux-foundation.org
Subject: - use-ilog2-in-fs-namespacec.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:09 -0800
Message-ID: <200802070024.m170OoIi006656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33139 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935062AbYBGAop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mm-commits@vger.kernel.org


The patch titled
     Use ilog2() in fs/namespace.c
has been removed from the -mm tree.  Its filename was
     use-ilog2-in-fs-namespacec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use ilog2() in fs/namespace.c
From: Eric Dumazet <dada1@cosmosbay.com>

We can use ilog2() in fs/namespace.c to compute hash_bits and hash_mask at
compile time, not runtime.

[akpm@linux-foundation.org: clean it all up]
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   43 ++++++++++---------------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff -puN fs/namespace.c~use-ilog2-in-fs-namespacec fs/namespace.c
--- a/fs/namespace.c~use-ilog2-in-fs-namespacec
+++ a/fs/namespace.c
@@ -25,18 +25,21 @@
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/ramfs.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
 #include "internal.h"
 
+#define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
+#define HASH_SIZE (1UL << HASH_SHIFT)
+
 /* spinlock for vfsmount related operations, inplace of dcache_lock */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
 
 static int event;
 
 static struct list_head *mount_hashtable __read_mostly;
-static int hash_mask __read_mostly, hash_bits __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
@@ -48,8 +51,8 @@ static inline unsigned long hash(struct 
 {
 	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
 	tmp += ((unsigned long)dentry / L1_CACHE_BYTES);
-	tmp = tmp + (tmp >> hash_bits);
-	return tmp & hash_mask;
+	tmp = tmp + (tmp >> HASH_SHIFT);
+	return tmp & (HASH_SIZE - 1);
 }
 
 struct vfsmount *alloc_vfsmnt(const char *name)
@@ -1813,9 +1816,7 @@ static void __init init_mount_tree(void)
 
 void __init mnt_init(void)
 {
-	struct list_head *d;
-	unsigned int nr_hash;
-	int i;
+	unsigned u;
 	int err;
 
 	init_rwsem(&namespace_sem);
@@ -1828,35 +1829,11 @@ void __init mnt_init(void)
 	if (!mount_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
-	/*
-	 * Find the power-of-two list-heads that can fit into the allocation..
-	 * We don't guarantee that "sizeof(struct list_head)" is necessarily
-	 * a power-of-two.
-	 */
-	nr_hash = PAGE_SIZE / sizeof(struct list_head);
-	hash_bits = 0;
-	do {
-		hash_bits++;
-	} while ((nr_hash >> hash_bits) != 0);
-	hash_bits--;
-
-	/*
-	 * Re-calculate the actual number of entries and the mask
-	 * from the number of bits we can fit.
-	 */
-	nr_hash = 1UL << hash_bits;
-	hash_mask = nr_hash - 1;
+	printk("Mount-cache hash table entries: %lu\n", HASH_SIZE);
 
-	printk("Mount-cache hash table entries: %d\n", nr_hash);
+	for (u = 0; u < HASH_SIZE; u++)
+		INIT_LIST_HEAD(&mount_hashtable[u]);
 
-	/* And initialize the newly allocated array */
-	d = mount_hashtable;
-	i = nr_hash;
-	do {
-		INIT_LIST_HEAD(d);
-		d++;
-		i--;
-	} while (i);
 	err = sysfs_init();
 	if (err)
 		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
