From: akpm@linux-foundation.org
Subject: + vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts.patch added to -mm tree
Date: Wed, 18 Jan 2012 12:40:44 -0800
Message-ID: <20120118204045.2511D10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56876 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2ARUkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 15:40:46 -0500
Received: by yhjj52 with SMTP id j52so641745yhj.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 12:40:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, davem@davemloft.net, viro@zeniv.linux.org.uk


The patch titled
     Subject: vfs: fix panic in __d_lookup() with high dentry hashtable counts
has been added to the -mm tree.  Its filename is
     vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dimitri Sivanich <sivanich@sgi.com>
Subject: vfs: fix panic in __d_lookup() with high dentry hashtable counts

When the number of dentry cache hash table entries gets too high
(2147483648 entries), as happens by default on a 16TB system, use of a
signed integer in the dcache_init() initialization loop prevents the
dentry_hashtable from getting initialized, causing a panic in
__d_lookup().  Fix this in dcache_init() and similar areas.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c     |    8 ++++----
 fs/inode.c      |    8 ++++----
 kernel/pid.c    |    4 ++--
 mm/page_alloc.c |    1 +
 net/ipv4/tcp.c  |    5 +++--
 5 files changed, 14 insertions(+), 12 deletions(-)

diff -puN fs/dcache.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts fs/dcache.c
--- a/fs/dcache.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts
+++ a/fs/dcache.c
@@ -2981,7 +2981,7 @@ __setup("dhash_entries=", set_dhash_entr
 
 static void __init dcache_init_early(void)
 {
-	int loop;
+	unsigned int loop;
 
 	/* If hashes are distributed across NUMA nodes, defer
 	 * hash allocation until vmalloc space is available.
@@ -2999,13 +2999,13 @@ static void __init dcache_init_early(voi
 					&d_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << d_hash_shift); loop++)
+	for (loop = 0; loop < (1U << d_hash_shift); loop++)
 		INIT_HLIST_BL_HEAD(dentry_hashtable + loop);
 }
 
 static void __init dcache_init(void)
 {
-	int loop;
+	unsigned int loop;
 
 	/* 
 	 * A constructor could be added for stable state like the lists,
@@ -3029,7 +3029,7 @@ static void __init dcache_init(void)
 					&d_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << d_hash_shift); loop++)
+	for (loop = 0; loop < (1U << d_hash_shift); loop++)
 		INIT_HLIST_BL_HEAD(dentry_hashtable + loop);
 }
 
diff -puN fs/inode.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts fs/inode.c
--- a/fs/inode.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts
+++ a/fs/inode.c
@@ -1568,7 +1568,7 @@ __setup("ihash_entries=", set_ihash_entr
  */
 void __init inode_init_early(void)
 {
-	int loop;
+	unsigned int loop;
 
 	/* If hashes are distributed across NUMA nodes, defer
 	 * hash allocation until vmalloc space is available.
@@ -1586,13 +1586,13 @@ void __init inode_init_early(void)
 					&i_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << i_hash_shift); loop++)
+	for (loop = 0; loop < (1U << i_hash_shift); loop++)
 		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
 void __init inode_init(void)
 {
-	int loop;
+	unsigned int loop;
 
 	/* inode slab cache */
 	inode_cachep = kmem_cache_create("inode_cache",
@@ -1616,7 +1616,7 @@ void __init inode_init(void)
 					&i_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << i_hash_shift); loop++)
+	for (loop = 0; loop < (1U << i_hash_shift); loop++)
 		INIT_HLIST_HEAD(&inode_hashtable[loop]);
 }
 
diff -puN kernel/pid.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts kernel/pid.c
--- a/kernel/pid.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts
+++ a/kernel/pid.c
@@ -541,12 +541,12 @@ struct pid *find_ge_pid(int nr, struct p
  */
 void __init pidhash_init(void)
 {
-	int i, pidhash_size;
+	unsigned int i, pidhash_size;
 
 	pid_hash = alloc_large_system_hash("PID", sizeof(*pid_hash), 0, 18,
 					   HASH_EARLY | HASH_SMALL,
 					   &pidhash_shift, NULL, 4096);
-	pidhash_size = 1 << pidhash_shift;
+	pidhash_size = 1U << pidhash_shift;
 
 	for (i = 0; i < pidhash_size; i++)
 		INIT_HLIST_HEAD(&pid_hash[i]);
diff -puN mm/page_alloc.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts mm/page_alloc.c
--- a/mm/page_alloc.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts
+++ a/mm/page_alloc.c
@@ -5430,6 +5430,7 @@ void *__init alloc_large_system_hash(con
 		max = ((unsigned long long)nr_all_pages << PAGE_SHIFT) >> 4;
 		do_div(max, bucketsize);
 	}
+	max = min(max, 0x80000000ULL);
 
 	if (numentries > max)
 		numentries = max;
diff -puN net/ipv4/tcp.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts
+++ a/net/ipv4/tcp.c
@@ -3216,7 +3216,8 @@ void __init tcp_init(void)
 {
 	struct sk_buff *skb = NULL;
 	unsigned long limit;
-	int i, max_share, cnt;
+	int max_share, cnt;
+	unsigned int i;
 	unsigned long jiffy = jiffies;
 
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
@@ -3259,7 +3260,7 @@ void __init tcp_init(void)
 					&tcp_hashinfo.bhash_size,
 					NULL,
 					64 * 1024);
-	tcp_hashinfo.bhash_size = 1 << tcp_hashinfo.bhash_size;
+	tcp_hashinfo.bhash_size = 1U << tcp_hashinfo.bhash_size;
 	for (i = 0; i < tcp_hashinfo.bhash_size; i++) {
 		spin_lock_init(&tcp_hashinfo.bhash[i].lock);
 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash[i].chain);
_
Subject: Subject: vfs: fix panic in __d_lookup() with high dentry hashtable counts

Patches currently in -mm which might be from sivanich@sgi.com are

vfs-fix-panic-in-__d_lookup-with-high-dentry-hashtable-counts.patch

