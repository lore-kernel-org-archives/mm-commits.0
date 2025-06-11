Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8686113AA2E
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607075; cv=none; b=mO/zBGFP+nZjyuag3lQzaSrbJoV/BnnuxtZXrKORT68HzDTZ5uEeMCW83OcWc6u8lB0VbNnARXezaL6Z6XvqDL70fdBhaMcOxmyIKqsaXyQRb2rc2kMdo9fDW8L5e3xAzmYHfw1yB8zf9Aue5FK8oKLNunjfe5g8FsTrWpApFpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607075; c=relaxed/simple;
	bh=4kFZIAWCYe0OUtMbAoYeQ/YqX8KU4compBZQMMkx8VE=;
	h=Date:To:From:Subject:Message-Id; b=Sl6mpavmJ0+nARPOm4e38gWaZpd0i695zwo2Lhgx7oCSjndWHgSXcHu0/+I7F3wSaAOu823RemtBkI0qCZidZO5dQgBgn3Ej7L4KzKhn474Ut3hZ5VoFSCoDuSWnwPySn0kCFXqZojb0xQdckw5PjE8adFLF+fSCvdIfDSyXlKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SWInuRTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SWInuRTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13884C4CEED;
	Wed, 11 Jun 2025 01:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607075;
	bh=4kFZIAWCYe0OUtMbAoYeQ/YqX8KU4compBZQMMkx8VE=;
	h=Date:To:From:Subject:From;
	b=SWInuRTxCiWCBbtE1YTabro+ZSahv8omk+o3PHGYZIp26kYIpfxoxawlzv01CZ/K4
	 eO7sYjGm8pk4hYCPQ/VtTkpLzzw4/IJm+kazqGxQBtHwv8mghmziVAQNjHIbF33dqg
	 nuclkUjjd5o3mvcMcn5baNzyjrjWBAwdDUa6frMc=
Date: Tue, 10 Jun 2025 18:57:54 -0700
To: mm-commits@vger.kernel.org,igor.b@beldev.am,vitaly.wool@konsulko.se,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zblock-make-active_list-rcu_list.patch removed from -mm tree
Message-Id: <20250611015755.13884C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zblock: make active_list rcu_list
has been removed from the -mm tree.  Its filename was
     mm-zblock-make-active_list-rcu_list.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Vitaly Wool <vitaly.wool@konsulko.se>
Subject: mm/zblock: make active_list rcu_list
Date: Thu, 8 May 2025 14:29:25 +0200

Since it is okay for several concurrent threads to have read access to the
active_list's head for slot reservation, make active_list rcu_list.  This
improves performance for heavy multi-thread loads.

E. g. for 'make -j55 bzImage' on a 12-core Ryzen:
* before:
real	8m52.194s
user	41m9.743s
sys	36m08.622s
Zswap:            303520 kB
Zswapped:         802004 kB
zswpin 18434225
zswpout 42848557

* after:
real	8m25.244s
user	40m10.184s
sys	31m55.413s
Zswap:            311020 kB
Zswapped:         842396 kB
zswpin 16984983
zswpout 38587329

* zsmalloc (for comparison):
real	9m5.550s
user	41m30.424s
sys	38m27.165s
Zswap:            204044 kB
Zswapped:         838176 kB
zswpin 20213653
zswpout 45038266

Link: https://lkml.kernel.org/r/20250508122925.2600217-1-vitaly.wool@konsulko.se
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Tested-by: Igor Belousov <igor.b@beldev.am>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.c |   34 ++++++++++++++++++++--------------
 mm/zblock.h |    2 ++
 2 files changed, 22 insertions(+), 14 deletions(-)

--- a/mm/zblock.c~mm-zblock-make-active_list-rcu_list
+++ a/mm/zblock.c
@@ -18,10 +18,10 @@
 
 #include <linux/atomic.h>
 #include <linux/debugfs.h>
-#include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/preempt.h>
+#include <linux/rcupdate.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
@@ -53,13 +53,20 @@ static inline struct zblock_block *find_
 {
 	struct list_head *l = &b->active_list;
 	unsigned int slot;
+	struct zblock_block *z;
 
-	spin_lock(&b->lock);
-	if (likely(!list_empty(l))) {
-		struct zblock_block *z = list_first_entry(l, typeof(*z), link);
-
+	rcu_read_lock();
+retry_claim:
+	z = list_first_or_null_rcu(l, typeof(*z), link);
+	if (z) {
+		spin_lock(&b->lock);
+		if (unlikely(!z->free_slots)) {
+			spin_unlock(&b->lock);
+			goto retry_claim;
+		}
 		if (--z->free_slots == 0)
-			__list_del_clearprev(&z->link);
+			list_bidir_del_rcu(&z->link);
+		spin_unlock(&b->lock);
 		/*
 		 * There is a slot in the block and we just made sure it will
 		 * remain.
@@ -74,13 +81,11 @@ static inline struct zblock_block *find_
 			if (!test_and_set_bit(slot, z->slot_info))
 				break;
 		}
-		spin_unlock(&b->lock);
 
 		*handle = metadata_to_handle(z, slot);
-		return z;
 	}
-	spin_unlock(&b->lock);
-	return NULL;
+	rcu_read_unlock();
+	return z;
 }
 
 /*
@@ -100,6 +105,7 @@ static struct zblock_block *alloc_block(
 		return NULL;
 
 	/* init block data */
+	init_rcu_head(&block->rcu);
 	block->block_type = block_type;
 	block->free_slots = block_desc[block_type].slots_per_block - 1;
 	memset(&block->slot_info, 0, sizeof(block->slot_info));
@@ -107,7 +113,7 @@ static struct zblock_block *alloc_block(
 	*handle = metadata_to_handle(block, 0);
 
 	spin_lock(&block_list->lock);
-	list_add(&block->link, &block_list->active_list);
+	list_add_rcu(&block->link, &block_list->active_list);
 	block_list->block_count++;
 	spin_unlock(&block_list->lock);
 	return block;
@@ -263,12 +269,12 @@ static void zblock_free(struct zblock_po
 	/* if all slots in block are empty delete the whole block */
 	if (++block->free_slots == block_desc[block_type].slots_per_block) {
 		block_list->block_count--;
-		__list_del_clearprev(&block->link);
+		list_bidir_del_rcu(&block->link);
 		spin_unlock(&block_list->lock);
-		vfree(block);
+		kvfree_rcu(block, rcu);
 		return;
 	} else if (block->free_slots == 1)
-		list_add(&block->link, &block_list->active_list);
+		list_add_tail_rcu(&block->link, &block_list->active_list);
 	spin_unlock(&block_list->lock);
 }
 
--- a/mm/zblock.h~mm-zblock-make-active_list-rcu_list
+++ a/mm/zblock.h
@@ -8,6 +8,7 @@
 
 #include <linux/mm.h>
 #include <linux/rbtree.h>
+#include <linux/rculist.h>
 #include <linux/types.h>
 
 #if PAGE_SIZE == 0x1000
@@ -42,6 +43,7 @@
 struct zblock_block {
 	DECLARE_BITMAP(slot_info, 1 << SLOT_BITS);
 	struct list_head link;
+	struct rcu_head rcu;
 	unsigned short block_type;
 	unsigned short free_slots;
 };
_

Patches currently in -mm which might be from vitaly.wool@konsulko.se are

mm-add-zblock-allocator.patch

