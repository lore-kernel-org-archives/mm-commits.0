From: akpm@linux-foundation.org
Subject: + mm-updated-callers-to-use-hash_zero-flag.patch added to -mm
 tree
Date: Fri, 03 Mar 2017 15:36:08 -0800
Message-ID: <58b9fde8.CP+eQTvdgvlABSpB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdCCXpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, babu.moger@oracle.com, davem@davemloft.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update callers to use HASH_ZERO flag
has been added to the -mm tree.  Its filename is
     mm-updated-callers-to-use-hash_zero-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-updated-callers-to-use-hash_zero-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-updated-callers-to-use-hash_zero-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: update callers to use HASH_ZERO flag

Update dcache, inode, pid, mountpoint, and mount hash tables to use
HASH_ZERO, and remove initialization after allocations.  In case of places
where HASH_EARLY was used such as in __pv_init_lock_hash the zeroed hash
table was already assumed, because memblock zeroes the memory.

CPU: SPARC M6, Memory: 7T
Before fix:
Dentry cache hash table entries: 1073741824
Inode-cache hash table entries: 536870912
Mount-cache hash table entries: 16777216
Mountpoint-cache hash table entries: 16777216
ftrace: allocating 20414 entries in 40 pages
Total time: 11.798s

After fix:
Dentry cache hash table entries: 1073741824
Inode-cache hash table entries: 536870912
Mount-cache hash table entries: 16777216
Mountpoint-cache hash table entries: 16777216
ftrace: allocating 20414 entries in 40 pages
Total time: 3.198s

CPU: Intel Xeon E5-2630, Memory: 2.2T:
Before fix:
Dentry cache hash table entries: 536870912
Inode-cache hash table entries: 268435456
Mount-cache hash table entries: 8388608
Mountpoint-cache hash table entries: 8388608
CPU: Physical Processor ID: 0
Total time: 3.245s

After fix:
Dentry cache hash table entries: 536870912
Inode-cache hash table entries: 268435456
Mount-cache hash table entries: 8388608
Mountpoint-cache hash table entries: 8388608
CPU: Physical Processor ID: 0
Total time: 3.244s

Link: http://lkml.kernel.org/r/1488432825-92126-4-git-send-email-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Babu Moger <babu.moger@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c                         |   18 ++++--------------
 fs/inode.c                          |   14 ++------------
 fs/namespace.c                      |   10 ++--------
 kernel/locking/qspinlock_paravirt.h |    3 ++-
 kernel/pid.c                        |    7 ++-----
 5 files changed, 12 insertions(+), 40 deletions(-)

diff -puN fs/dcache.c~mm-updated-callers-to-use-hash_zero-flag fs/dcache.c
--- a/fs/dcache.c~mm-updated-callers-to-use-hash_zero-flag
+++ a/fs/dcache.c
@@ -3548,8 +3548,6 @@ __setup("dhash_entries=", set_dhash_entr
 
 static void __init dcache_init_early(void)
 {
-	unsigned int loop;
-
 	/* If hashes are distributed across NUMA nodes, defer
 	 * hash allocation until vmalloc space is available.
 	 */
@@ -3561,24 +3559,19 @@ static void __init dcache_init_early(voi
 					sizeof(struct hlist_bl_head),
 					dhash_entries,
 					13,
-					HASH_EARLY,
+					HASH_EARLY | HASH_ZERO,
 					&d_hash_shift,
 					&d_hash_mask,
 					0,
 					0);
-
-	for (loop = 0; loop < (1U << d_hash_shift); loop++)
-		INIT_HLIST_BL_HEAD(dentry_hashtable + loop);
 }
 
 static void __init dcache_init(void)
 {
-	unsigned int loop;
-
-	/* 
+	/*
 	 * A constructor could be added for stable state like the lists,
 	 * but it is probably not worth it because of the cache nature
-	 * of the dcache. 
+	 * of the dcache.
 	 */
 	dentry_cache = KMEM_CACHE(dentry,
 		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD|SLAB_ACCOUNT);
@@ -3592,14 +3585,11 @@ static void __init dcache_init(void)
 					sizeof(struct hlist_bl_head),
 					dhash_entries,
 					13,
-					0,
+					HASH_ZERO,
 					&d_hash_shift,
 					&d_hash_mask,
 					0,
 					0);
-
-	for (loop = 0; loop < (1U << d_hash_shift); loop++)
-		INIT_HLIST_BL_HEAD(dentry_hashtable + loop);
 }
 
 /* SLAB cache for __getname() consumers */
diff -puN fs/inode.c~mm-updated-callers-to-use-hash_zero-flag fs/inode.c
--- a/fs/inode.c~mm-updated-callers-to-use-hash_zero-flag
+++ a/fs/inode.c
@@ -1916,8 +1916,6 @@ __setup("ihash_entries=", set_ihash_entr
  */
 void __init inode_init_early(void)
 {
-	unsigned int loop;
-
 	/* If hashes are distributed across NUMA nodes, defer
 	 * hash allocation until vmalloc space is available.
 	 */
@@ -1929,20 +1927,15 @@ void __init inode_init_early(void)
 					sizeof(struct hlist_head),
 					ihash_entries,
 					14,
-					HASH_EARLY,
+					HASH_EARLY | HASH_ZERO,
 					&i_hash_shift,
 					&i_hash_mask,
 					0,
 					0);
-
-	for (loop = 0; loop < (1U << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
 void __init inode_init(void)
 {
-	unsigned int loop;
-
 	/* inode slab cache */
 	inode_cachep = kmem_cache_create("inode_cache",
 					 sizeof(struct inode),
@@ -1960,14 +1953,11 @@ void __init inode_init(void)
 					sizeof(struct hlist_head),
 					ihash_entries,
 					14,
-					0,
+					HASH_ZERO,
 					&i_hash_shift,
 					&i_hash_mask,
 					0,
 					0);
-
-	for (loop = 0; loop < (1U << i_hash_shift); loop++)
-		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
 void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
diff -puN fs/namespace.c~mm-updated-callers-to-use-hash_zero-flag fs/namespace.c
--- a/fs/namespace.c~mm-updated-callers-to-use-hash_zero-flag
+++ a/fs/namespace.c
@@ -3241,7 +3241,6 @@ static void __init init_mount_tree(void)
 
 void __init mnt_init(void)
 {
-	unsigned u;
 	int err;
 
 	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
@@ -3250,22 +3249,17 @@ void __init mnt_init(void)
 	mount_hashtable = alloc_large_system_hash("Mount-cache",
 				sizeof(struct hlist_head),
 				mhash_entries, 19,
-				0,
+				HASH_ZERO,
 				&m_hash_shift, &m_hash_mask, 0, 0);
 	mountpoint_hashtable = alloc_large_system_hash("Mountpoint-cache",
 				sizeof(struct hlist_head),
 				mphash_entries, 19,
-				0,
+				HASH_ZERO,
 				&mp_hash_shift, &mp_hash_mask, 0, 0);
 
 	if (!mount_hashtable || !mountpoint_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
-	for (u = 0; u <= m_hash_mask; u++)
-		INIT_HLIST_HEAD(&mount_hashtable[u]);
-	for (u = 0; u <= mp_hash_mask; u++)
-		INIT_HLIST_HEAD(&mountpoint_hashtable[u]);
-
 	kernfs_init();
 
 	err = sysfs_init();
diff -puN kernel/locking/qspinlock_paravirt.h~mm-updated-callers-to-use-hash_zero-flag kernel/locking/qspinlock_paravirt.h
--- a/kernel/locking/qspinlock_paravirt.h~mm-updated-callers-to-use-hash_zero-flag
+++ a/kernel/locking/qspinlock_paravirt.h
@@ -193,7 +193,8 @@ void __init __pv_init_lock_hash(void)
 	 */
 	pv_lock_hash = alloc_large_system_hash("PV qspinlock",
 					       sizeof(struct pv_hash_entry),
-					       pv_hash_size, 0, HASH_EARLY,
+					       pv_hash_size, 0,
+					       HASH_EARLY | HASH_ZERO,
 					       &pv_lock_hash_bits, NULL,
 					       pv_hash_size, pv_hash_size);
 }
diff -puN kernel/pid.c~mm-updated-callers-to-use-hash_zero-flag kernel/pid.c
--- a/kernel/pid.c~mm-updated-callers-to-use-hash_zero-flag
+++ a/kernel/pid.c
@@ -573,16 +573,13 @@ struct pid *find_ge_pid(int nr, struct p
  */
 void __init pidhash_init(void)
 {
-	unsigned int i, pidhash_size;
+	unsigned int pidhash_size;
 
 	pid_hash = alloc_large_system_hash("PID", sizeof(*pid_hash), 0, 18,
-					   HASH_EARLY | HASH_SMALL,
+					   HASH_EARLY | HASH_SMALL | HASH_ZERO,
 					   &pidhash_shift, NULL,
 					   0, 4096);
 	pidhash_size = 1U << pidhash_shift;
