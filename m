From: akpm@linux-foundation.org
Subject: + use-ilog2-in-fs-namespacec.patch added to -mm tree
Date: Fri, 21 Dec 2007 02:29:51 -0800
Message-ID: <200712211029.lBLATpiL008860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbXLUKaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 05:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com


The patch titled
     Use ilog2() in fs/namespace.c
has been added to the -mm tree.  Its filename is
     use-ilog2-in-fs-namespacec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use ilog2() in fs/namespace.c
From: Eric Dumazet <dada1@cosmosbay.com>

We can use ilog2() in fs/namespace.c to compute hash_bits and hash_mask at
compile time, not runtime.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff -puN fs/namespace.c~use-ilog2-in-fs-namespacec fs/namespace.c
--- a/fs/namespace.c~use-ilog2-in-fs-namespacec
+++ a/fs/namespace.c
@@ -25,6 +25,7 @@
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/ramfs.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -36,7 +37,8 @@ __cacheline_aligned_in_smp DEFINE_SPINLO
 static int event;
 
 static struct list_head *mount_hashtable __read_mostly;
-static int hash_mask __read_mostly, hash_bits __read_mostly;
+#define hash_bits ilog2(PAGE_SIZE / sizeof(struct list_head))
+#define hash_mask ((1UL << hash_bits) - 1)
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
@@ -1828,24 +1830,7 @@ void __init mnt_init(void)
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
 	nr_hash = 1UL << hash_bits;
-	hash_mask = nr_hash - 1;
 
 	printk("Mount-cache hash table entries: %d\n", nr_hash);
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
git-net.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
lib-extablec-removes-an-expensive-integer-divide-in-search_extable.patch
kernel-sysc-get-rid-of-expensive-divides-in-groups_sort.patch
use-ilog2-in-fs-namespacec.patch
use-ilog2-in-fs-namespacec-fix.patch
