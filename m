From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 25 Nov 2013 12:12:08 -0800
Message-ID: <5293af18.vZ/+Vxz1SIKQ/g70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3KYUMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Nov 2013 15:12:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 25 Nov 2013 12:12:08 -0800


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

 crypto/Makefile               |    3 
 include/linux/mm_types.h      |    3 
 security/keys/big_key.c       |    3 
 security/keys/gc.c            |    7 
 security/keys/keyring.c       |  255 --------------------------------
 security/keys/persistent.c    |    5 
 sound/pci/hda/patch_realtek.c |    3 
 7 files changed, 279 deletions(-)

diff -puN crypto/Makefile~linux-next-git-rejects crypto/Makefile
--- a/crypto/Makefile~linux-next-git-rejects
+++ a/crypto/Makefile
@@ -109,8 +109,5 @@ obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) +
 obj-$(CONFIG_XOR_BLOCKS) += xor.o
 obj-$(CONFIG_ASYNC_CORE) += async_tx/
 obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_CRYPTO_ABLK_HELPER) += ablk_helper.o
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_CRYPTO_HASH_INFO) += hash_info.o
diff -puN include/linux/mm_types.h~linux-next-git-rejects include/linux/mm_types.h
--- a/include/linux/mm_types.h~linux-next-git-rejects
+++ a/include/linux/mm_types.h
@@ -140,12 +140,9 @@ struct page {
 		struct rcu_head rcu_head;	/* Used by SLAB
 						 * when destroying via RCU
 						 */
-<<<<<<< HEAD
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
 		pgtable_t pmd_huge_pte; /* protected by page->ptl */
 #endif
-=======
->>>>>>> linux-next/akpm-base
 	};
 
 	/* Remainder is not double word aligned */
diff -puN security/keys/big_key.c~linux-next-git-rejects security/keys/big_key.c
--- a/security/keys/big_key.c~linux-next-git-rejects
+++ a/security/keys/big_key.c
@@ -78,10 +78,7 @@ int big_key_instantiate(struct key *key,
 
 		written = kernel_write(file, prep->data, prep->datalen, 0);
 		if (written != datalen) {
-<<<<<<< HEAD
 			ret = written;
-=======
->>>>>>> linux-next/akpm-base
 			if (written >= 0)
 				ret = -ENOMEM;
 			goto err_fput;
diff -puN security/keys/gc.c~linux-next-git-rejects security/keys/gc.c
--- a/security/keys/gc.c~linux-next-git-rejects
+++ a/security/keys/gc.c
@@ -138,8 +138,6 @@ static int key_gc_keyring_func(const voi
 }
 
 /*
-<<<<<<< HEAD
-=======
  * Garbage collect pointers from a keyring.
  *
  * Not called with any locks held.  The keyring's key struct will not be
@@ -173,7 +171,6 @@ do_gc:
 }
 
 /*
->>>>>>> linux-next/akpm-base
  * Garbage collect a list of unreferenced, detached keys
  */
 static noinline void key_gc_unused_keys(struct list_head *keys)
@@ -391,11 +388,7 @@ found_unreferenced_key:
 	 */
 found_keyring:
 	spin_unlock(&key_serial_lock);
-<<<<<<< HEAD
-	keyring_gc(key, limit);
-=======
 	key_gc_keyring(key, limit);
->>>>>>> linux-next/akpm-base
 	goto maybe_resched;
 
 	/* We found a dead key that is still referenced.  Reset its type and
diff -puN security/keys/keyring.c~linux-next-git-rejects security/keys/keyring.c
--- a/security/keys/keyring.c~linux-next-git-rejects
+++ a/security/keys/keyring.c
@@ -215,7 +215,6 @@ static unsigned long hash_key_type_and_d
  *	hash	desclen	typeptr	desc[]
  *
  * We return it one word-sized chunk at a time.
-<<<<<<< HEAD
  */
 static unsigned long keyring_get_key_chunk(const void *data, int level)
 {
@@ -346,138 +345,6 @@ differ:
 }
 
 /*
-=======
- */
-static unsigned long keyring_get_key_chunk(const void *data, int level)
-{
-	const struct keyring_index_key *index_key = data;
-	unsigned long chunk = 0;
-	long offset = 0;
-	int desc_len = index_key->desc_len, n = sizeof(chunk);
-
-	level /= ASSOC_ARRAY_KEY_CHUNK_SIZE;
-	switch (level) {
-	case 0:
-		return hash_key_type_and_desc(index_key);
-	case 1:
-		return ((unsigned long)index_key->type << 8) | desc_len;
-	case 2:
-		if (desc_len == 0)
-			return (u8)((unsigned long)index_key->type >>
-				    (ASSOC_ARRAY_KEY_CHUNK_SIZE - 8));
-		n--;
-		offset = 1;
-	default:
-		offset += sizeof(chunk) - 1;
-		offset += (level - 3) * sizeof(chunk);
-		if (offset >= desc_len)
-			return 0;
-		desc_len -= offset;
-		if (desc_len > n)
-			desc_len = n;
-		offset += desc_len;
-		do {
-			chunk <<= 8;
-			chunk |= ((u8*)index_key->description)[--offset];
-		} while (--desc_len > 0);
-
-		if (level == 2) {
-			chunk <<= 8;
-			chunk |= (u8)((unsigned long)index_key->type >>
-				      (ASSOC_ARRAY_KEY_CHUNK_SIZE - 8));
-		}
-		return chunk;
-	}
-}
-
-static unsigned long keyring_get_object_key_chunk(const void *object, int level)
-{
-	const struct key *key = keyring_ptr_to_key(object);
-	return keyring_get_key_chunk(&key->index_key, level);
-}
-
-static bool keyring_compare_object(const void *object, const void *data)
-{
-	const struct keyring_index_key *index_key = data;
-	const struct key *key = keyring_ptr_to_key(object);
-
-	return key->index_key.type == index_key->type &&
-		key->index_key.desc_len == index_key->desc_len &&
-		memcmp(key->index_key.description, index_key->description,
-		       index_key->desc_len) == 0;
-}
-
-/*
- * Compare the index keys of a pair of objects and determine the bit position
- * at which they differ - if they differ.
- */
-static int keyring_diff_objects(const void *_a, const void *_b)
-{
-	const struct key *key_a = keyring_ptr_to_key(_a);
-	const struct key *key_b = keyring_ptr_to_key(_b);
-	const struct keyring_index_key *a = &key_a->index_key;
-	const struct keyring_index_key *b = &key_b->index_key;
-	unsigned long seg_a, seg_b;
-	int level, i;
-
-	level = 0;
-	seg_a = hash_key_type_and_desc(a);
-	seg_b = hash_key_type_and_desc(b);
-	if ((seg_a ^ seg_b) != 0)
-		goto differ;
-
-	/* The number of bits contributed by the hash is controlled by a
-	 * constant in the assoc_array headers.  Everything else thereafter we
-	 * can deal with as being machine word-size dependent.
-	 */
-	level += ASSOC_ARRAY_KEY_CHUNK_SIZE / 8;
-	seg_a = a->desc_len;
-	seg_b = b->desc_len;
-	if ((seg_a ^ seg_b) != 0)
-		goto differ;
-
-	/* The next bit may not work on big endian */
-	level++;
-	seg_a = (unsigned long)a->type;
-	seg_b = (unsigned long)b->type;
-	if ((seg_a ^ seg_b) != 0)
-		goto differ;
-
-	level += sizeof(unsigned long);
-	if (a->desc_len == 0)
-		goto same;
-
-	i = 0;
-	if (((unsigned long)a->description | (unsigned long)b->description) &
-	    (sizeof(unsigned long) - 1)) {
-		do {
-			seg_a = *(unsigned long *)(a->description + i);
-			seg_b = *(unsigned long *)(b->description + i);
-			if ((seg_a ^ seg_b) != 0)
-				goto differ_plus_i;
-			i += sizeof(unsigned long);
-		} while (i < (a->desc_len & (sizeof(unsigned long) - 1)));
-	}
-
-	for (; i < a->desc_len; i++) {
-		seg_a = *(unsigned char *)(a->description + i);
-		seg_b = *(unsigned char *)(b->description + i);
-		if ((seg_a ^ seg_b) != 0)
-			goto differ_plus_i;
-	}
-
-same:
-	return -1;
-
-differ_plus_i:
-	level += i;
-differ:
-	i = level * 8 + __ffs(seg_a ^ seg_b);
-	return i;
-}
-
-/*
->>>>>>> linux-next/akpm-base
  * Free an object after stripping the keyring flag off of the pointer.
  */
 static void keyring_free_object(void *object)
@@ -586,18 +453,6 @@ static long keyring_read(const struct ke
 	nr_keys = keyring->keys.nr_leaves_on_tree;
 	if (nr_keys == 0)
 		return 0;
-<<<<<<< HEAD
-
-	/* Calculate how much data we could return */
-	ctx.qty = nr_keys * sizeof(key_serial_t);
-
-	if (!buffer || !buflen)
-		return ctx.qty;
-
-	if (buflen > ctx.qty)
-		ctx.qty = buflen;
-
-=======
 
 	/* Calculate how much data we could return */
 	ctx.qty = nr_keys * sizeof(key_serial_t);
@@ -608,7 +463,6 @@ static long keyring_read(const struct ke
 	if (buflen > ctx.qty)
 		ctx.qty = buflen;
 
->>>>>>> linux-next/akpm-base
 	/* Copy the IDs of the subscribed keys into the buffer */
 	ctx.buffer = (key_serial_t __user *)buffer;
 	ctx.count = 0;
@@ -779,16 +633,6 @@ static bool search_nested_keyrings(struc
 	ctx->skipped_ret = 0;
 	if (ctx->flags & KEYRING_SEARCH_NO_STATE_CHECK)
 		ctx->flags &= ~KEYRING_SEARCH_DO_STATE_CHECK;
-<<<<<<< HEAD
-
-	/* Start processing a new keyring */
-descend_to_keyring:
-	kdebug("descend to %d", keyring->serial);
-	if (keyring->flags & ((1 << KEY_FLAG_INVALIDATED) |
-			      (1 << KEY_FLAG_REVOKED)))
-		goto not_this_keyring;
-
-=======
 
 	/* Start processing a new keyring */
 descend_to_keyring:
@@ -797,7 +641,6 @@ descend_to_keyring:
 			      (1 << KEY_FLAG_REVOKED)))
 		goto not_this_keyring;
 
->>>>>>> linux-next/akpm-base
 	/* Search through the keys in this keyring before its searching its
 	 * subtrees.
 	 */
@@ -891,37 +734,6 @@ ascend_to_node:
 		/* begin again with the new keyring */
 		keyring = key;
 		goto descend_to_keyring;
-<<<<<<< HEAD
-	}
-
-	/* We've dealt with all the slots in the current node, so now we need
-	 * to ascend to the parent and continue processing there.
-	 */
-	ptr = ACCESS_ONCE(node->back_pointer);
-	slot = node->parent_slot;
-
-	if (ptr && assoc_array_ptr_is_shortcut(ptr)) {
-		shortcut = assoc_array_ptr_to_shortcut(ptr);
-		smp_read_barrier_depends();
-		ptr = ACCESS_ONCE(shortcut->back_pointer);
-		slot = shortcut->parent_slot;
-	}
-	if (!ptr)
-		goto not_this_keyring;
-	node = assoc_array_ptr_to_node(ptr);
-	smp_read_barrier_depends();
-	slot++;
-
-	/* If we've ascended to the root (zero backpointer), we must have just
-	 * finished processing the leftmost branch rather than the root slots -
-	 * so there can't be any more keyrings for us to find.
-	 */
-	if (node->back_pointer) {
-		kdebug("ascend %d", slot);
-		goto ascend_to_node;
-	}
-
-=======
 	}
 
 	/* We've dealt with all the slots in the current node, so now we need
@@ -951,7 +763,6 @@ ascend_to_node:
 		goto ascend_to_node;
 	}
 
->>>>>>> linux-next/akpm-base
 	/* The keyring we're looking at was disqualified or didn't contain a
 	 * matching key.
 	 */
@@ -1232,17 +1043,10 @@ int __key_link_begin(struct key *keyring
 {
 	struct assoc_array_edit *edit;
 	int ret;
-<<<<<<< HEAD
 
 	kenter("%d,%s,%s,",
 	       keyring->serial, index_key->type->name, index_key->description);
 
-=======
-
-	kenter("%d,%s,%s,",
-	       keyring->serial, index_key->type->name, index_key->description);
-
->>>>>>> linux-next/akpm-base
 	BUG_ON(index_key->desc_len == 0);
 
 	if (keyring->type != &key_type_keyring)
@@ -1491,35 +1295,6 @@ EXPORT_SYMBOL(keyring_clear);
 static void keyring_revoke(struct key *keyring)
 {
 	struct assoc_array_edit *edit;
-<<<<<<< HEAD
-
-	edit = assoc_array_clear(&keyring->keys, &keyring_assoc_array_ops);
-	if (!IS_ERR(edit)) {
-		if (edit)
-			assoc_array_apply_edit(edit);
-		key_payload_reserve(keyring, 0);
-	}
-}
-
-static bool keyring_gc_select_iterator(void *object, void *iterator_data)
-{
-	struct key *key = keyring_ptr_to_key(object);
-	time_t *limit = iterator_data;
-
-	if (key_is_dead(key, *limit))
-		return false;
-	key_get(key);
-	return true;
-}
-
-static int keyring_gc_check_iterator(const void *object, void *iterator_data)
-{
-	const struct key *key = keyring_ptr_to_key(object);
-	time_t *limit = iterator_data;
-
-	key_check(key);
-	return key_is_dead(key, *limit);
-=======
 
 	edit = assoc_array_clear(&keyring->keys, &keyring_assoc_array_ops);
 	if (!IS_ERR(edit)) {
@@ -1538,7 +1313,6 @@ static bool gc_iterator(void *object, vo
 		return false;
 	key_get(key);
 	return true;
->>>>>>> linux-next/akpm-base
 }
 
 /*
@@ -1549,34 +1323,6 @@ static bool gc_iterator(void *object, vo
  */
 void keyring_gc(struct key *keyring, time_t limit)
 {
-<<<<<<< HEAD
-	int result;
-
-	kenter("%x{%s}", keyring->serial, keyring->description ?: "");
-
-	if (keyring->flags & ((1 << KEY_FLAG_INVALIDATED) |
-			      (1 << KEY_FLAG_REVOKED)))
-		goto dont_gc;
-
-	/* scan the keyring looking for dead keys */
-	rcu_read_lock();
-	result = assoc_array_iterate(&keyring->keys,
-				     keyring_gc_check_iterator, &limit);
-	rcu_read_unlock();
-	if (result == true)
-		goto do_gc;
-
-dont_gc:
-	kleave(" [no gc]");
-	return;
-
-do_gc:
-	down_write(&keyring->sem);
-	assoc_array_gc(&keyring->keys, &keyring_assoc_array_ops,
-		       keyring_gc_select_iterator, &limit);
-	up_write(&keyring->sem);
-	kleave(" [gc]");
-=======
 	kenter("{%x,%s}", key_serial(keyring), keyring->description);
 
 	down_write(&keyring->sem);
@@ -1585,5 +1331,4 @@ do_gc:
 	up_write(&keyring->sem);
 
 	kleave("");
->>>>>>> linux-next/akpm-base
 }
diff -puN security/keys/persistent.c~linux-next-git-rejects security/keys/persistent.c
--- a/security/keys/persistent.c~linux-next-git-rejects
+++ a/security/keys/persistent.c
@@ -144,15 +144,10 @@ long keyctl_get_persistent(uid_t _uid, k
 		/* You can only see your own persistent cache if you're not
 		 * sufficiently privileged.
 		 */
-<<<<<<< HEAD
-		if (!uid_eq(uid, current_uid()) &&
-		    !uid_eq(uid, current_euid()) &&
-=======
 		if (uid_eq(uid, current_uid()) &&
 		    uid_eq(uid, current_suid()) &&
 		    uid_eq(uid, current_euid()) &&
 		    uid_eq(uid, current_fsuid()) &&
->>>>>>> linux-next/akpm-base
 		    !ns_capable(ns, CAP_SETUID))
 			return -EPERM;
 	}
diff -puN sound/pci/hda/patch_realtek.c~linux-next-git-rejects sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_realtek.c
@@ -1679,10 +1679,7 @@ static const struct snd_pci_quirk alc260
 	SND_PCI_QUIRK(0x1025, 0x008f, "Acer", ALC260_FIXUP_GPIO1),
 	SND_PCI_QUIRK(0x103c, 0x280a, "HP dc5750", ALC260_FIXUP_HP_DC5750),
 	SND_PCI_QUIRK(0x103c, 0x30ba, "HP Presario B1900", ALC260_FIXUP_HP_B1900),
-<<<<<<< HEAD
 	SND_PCI_QUIRK(0x104d, 0x81bb, "Sony VAIO", ALC260_FIXUP_VAIO_PINS),
-=======
->>>>>>> linux-next/akpm-base
 	SND_PCI_QUIRK(0x104d, 0x81e2, "Sony VAIO TX", ALC260_FIXUP_HP_PIN_0F),
 	SND_PCI_QUIRK(0x10cf, 0x1326, "FSC LifeBook S7020", ALC260_FIXUP_FSC_S7020),
 	SND_PCI_QUIRK(0x1509, 0x4540, "Favorit 100XS", ALC260_FIXUP_GPIO1),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

