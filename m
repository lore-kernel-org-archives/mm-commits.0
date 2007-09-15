From: akpm@linux-foundation.org
Subject: + jbd-slab-cleanups.patch added to -mm tree
Date: Sat, 15 Sep 2007 00:25:38 -0700
Message-ID: <200709150725.l8F7PcZA021347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbXIOHZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 03:25:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, cmm@us.ibm.com


The patch titled
     jbd/jbd2: Replace slab allocations with page cache allocations
has been added to the -mm tree.  Its filename is
     jbd-slab-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jbd/jbd2: Replace slab allocations with page cache allocations
From: Christoph Lameter <clameter@sgi.com>

JBD should not pass slab pages down to the block layer.  Use page allocator
pages instead.  This will also prepare JBD for the large blocksize
patchset.

Tested on 2.6.23-rc6 with fsx runs fine.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/checkpoint.c   |    2 
 fs/jbd/commit.c       |    6 +-
 fs/jbd/journal.c      |  107 +++------------------------------------
 fs/jbd/transaction.c  |   10 +--
 fs/jbd2/checkpoint.c  |    2 
 fs/jbd2/commit.c      |    6 +-
 fs/jbd2/journal.c     |  109 +++-------------------------------------
 fs/jbd2/transaction.c |   18 +++---
 include/linux/jbd.h   |   23 +++++++-
 include/linux/jbd2.h  |   28 ++++++++--
 10 files changed, 83 insertions(+), 228 deletions(-)

diff -puN fs/jbd2/checkpoint.c~jbd-slab-cleanups fs/jbd2/checkpoint.c
--- a/fs/jbd2/checkpoint.c~jbd-slab-cleanups
+++ a/fs/jbd2/checkpoint.c
@@ -693,5 +693,5 @@ void __jbd2_journal_drop_transaction(jou
 	J_ASSERT(journal->j_running_transaction != transaction);
 
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-	kfree(transaction);
+	jbd2_kfree(transaction);
 }
diff -puN fs/jbd2/commit.c~jbd-slab-cleanups fs/jbd2/commit.c
--- a/fs/jbd2/commit.c~jbd-slab-cleanups
+++ a/fs/jbd2/commit.c
@@ -384,7 +384,7 @@ void jbd2_journal_commit_transaction(jou
 			struct buffer_head *bh = jh2bh(jh);
 
 			jbd_lock_bh_state(bh);
-			jbd2_slab_free(jh->b_committed_data, bh->b_size);
+			jbd2_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			jbd_unlock_bh_state(bh);
 		}
@@ -801,14 +801,14 @@ restart_loop:
 		 * Otherwise, we can just throw away the frozen data now.
 		 */
 		if (jh->b_committed_data) {
-			jbd2_slab_free(jh->b_committed_data, bh->b_size);
+			jbd2_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			if (jh->b_frozen_data) {
 				jh->b_committed_data = jh->b_frozen_data;
 				jh->b_frozen_data = NULL;
 			}
 		} else if (jh->b_frozen_data) {
-			jbd2_slab_free(jh->b_frozen_data, bh->b_size);
+			jbd2_free(jh->b_frozen_data, bh->b_size);
 			jh->b_frozen_data = NULL;
 		}
 
diff -puN fs/jbd2/journal.c~jbd-slab-cleanups fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd-slab-cleanups
+++ a/fs/jbd2/journal.c
@@ -84,7 +84,6 @@ EXPORT_SYMBOL(jbd2_journal_force_commit)
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
-static int jbd2_journal_create_jbd_slab(size_t slab_size);
 
 /*
  * Helper function used to manage commit timeouts
@@ -335,10 +334,10 @@ repeat:
 		char *tmp;
 
 		jbd_unlock_bh_state(bh_in);
-		tmp = jbd2_slab_alloc(bh_in->b_size, GFP_NOFS);
+		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		jbd_lock_bh_state(bh_in);
 		if (jh_in->b_frozen_data) {
-			jbd2_slab_free(tmp, bh_in->b_size);
+			jbd2_free(tmp, bh_in->b_size);
 			goto repeat;
 		}
 
@@ -655,7 +654,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = jbd_kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = jbd2_kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
@@ -680,7 +679,7 @@ static journal_t * journal_init_common (
 	/* Set up a default-sized revoke table for the new mount. */
 	err = jbd2_journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
 	if (err) {
-		kfree(journal);
+		jbd2_kfree(journal);
 		goto fail;
 	}
 	return journal;
@@ -729,7 +728,7 @@ journal_t * jbd2_journal_init_dev(struct
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		kfree(journal);
+		jbd2_kfree(journal);
 		journal = NULL;
 		goto out;
 	}
@@ -783,7 +782,7 @@ journal_t * jbd2_journal_init_inode (str
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		kfree(journal);
+		jbd2_kfree(journal);
 		return NULL;
 	}
 
@@ -792,7 +791,7 @@ journal_t * jbd2_journal_init_inode (str
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
 		       __FUNCTION__);
-		kfree(journal);
+		jbd2_kfree(journal);
 		return NULL;
 	}
 
@@ -1096,13 +1095,6 @@ int jbd2_journal_load(journal_t *journal
 		}
 	}
 
-	/*
-	 * Create a slab for this blocksize
-	 */
-	err = jbd2_journal_create_jbd_slab(be32_to_cpu(sb->s_blocksize));
-	if (err)
-		return err;
-
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
 	if (jbd2_journal_recover(journal))
@@ -1167,7 +1159,7 @@ void jbd2_journal_destroy(journal_t *jou
 	if (journal->j_revoke)
 		jbd2_journal_destroy_revoke(journal);
 	kfree(journal->j_wbuf);
-	kfree(journal);
+	jbd2_kfree(journal);
 }
 
 
@@ -1627,86 +1619,6 @@ size_t journal_tag_bytes(journal_t *jour
 }
 
 /*
- * Simple support for retrying memory allocations.  Introduced to help to
- * debug different VM deadlock avoidance strategies.
- */
-void * __jbd2_kmalloc (const char *where, size_t size, gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-
-/*
- * jbd slab management: create 1k, 2k, 4k, 8k slabs as needed
- * and allocate frozen and commit buffers from these slabs.
- *
- * Reason for doing this is to avoid, SLAB_DEBUG - since it could
- * cause bh to cross page boundary.
- */
-
-#define JBD_MAX_SLABS 5
-#define JBD_SLAB_INDEX(size)  (size >> 11)
-
-static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
-static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd2_1k", "jbd2_2k", "jbd2_4k", NULL, "jbd2_8k"
-};
-
-static void jbd2_journal_destroy_jbd_slabs(void)
-{
-	int i;
-
-	for (i = 0; i < JBD_MAX_SLABS; i++) {
-		if (jbd_slab[i])
-			kmem_cache_destroy(jbd_slab[i]);
-		jbd_slab[i] = NULL;
-	}
-}
-
-static int jbd2_journal_create_jbd_slab(size_t slab_size)
-{
-	int i = JBD_SLAB_INDEX(slab_size);
-
-	BUG_ON(i >= JBD_MAX_SLABS);
-
-	/*
-	 * Check if we already have a slab created for this size
-	 */
-	if (jbd_slab[i])
-		return 0;
-
-	/*
-	 * Create a slab and force alignment to be same as slabsize -
-	 * this will make sure that allocations won't cross the page
-	 * boundary.
-	 */
-	jbd_slab[i] = kmem_cache_create(jbd_slab_names[i],
-				slab_size, slab_size, 0, NULL);
-	if (!jbd_slab[i]) {
-		printk(KERN_EMERG "JBD: no memory for jbd_slab cache\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-void * jbd2_slab_alloc(size_t size, gfp_t flags)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	return kmem_cache_alloc(jbd_slab[idx], flags | __GFP_NOFAIL);
-}
-
-void jbd2_slab_free(void *ptr,  size_t size)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	kmem_cache_free(jbd_slab[idx], ptr);
-}
-
-/*
  * Journal_head storage management
  */
 static struct kmem_cache *jbd2_journal_head_cache;
@@ -1893,13 +1805,13 @@ static void __journal_remove_journal_hea
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
 						__FUNCTION__);
-				jbd2_slab_free(jh->b_frozen_data, bh->b_size);
+				jbd2_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
 						__FUNCTION__);
-				jbd2_slab_free(jh->b_committed_data, bh->b_size);
+				jbd2_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
 			jh->b_bh = NULL;	/* debug, really */
@@ -2040,7 +1952,6 @@ static void jbd2_journal_destroy_caches(
 	jbd2_journal_destroy_revoke_caches();
 	jbd2_journal_destroy_jbd2_journal_head_cache();
 	jbd2_journal_destroy_handle_cache();
-	jbd2_journal_destroy_jbd_slabs();
 }
 
 static int __init journal_init(void)
diff -puN fs/jbd2/transaction.c~jbd-slab-cleanups fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd-slab-cleanups
+++ a/fs/jbd2/transaction.c
@@ -96,7 +96,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = jbd_kmalloc(sizeof(*new_transaction),
+		new_transaction = jbd2_kmalloc(sizeof(*new_transaction),
 						GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
@@ -229,14 +229,14 @@ repeat_locked:
 	spin_unlock(&journal->j_state_lock);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
+		jbd2_kfree(new_transaction);
 	return ret;
 }
 
 /* Allocate a new handle.  This should probably be in a slab... */
 static handle_t *new_handle(int nblocks)
 {
-	handle_t *handle = jbd_alloc_handle(GFP_NOFS);
+	handle_t *handle = jbd2_alloc_handle(GFP_NOFS);
 	if (!handle)
 		return NULL;
 	memset(handle, 0, sizeof(*handle));
@@ -282,7 +282,7 @@ handle_t *jbd2_journal_start(journal_t *
 
 	err = start_this_handle(journal, handle);
 	if (err < 0) {
-		jbd_free_handle(handle);
+		jbd2_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
 	}
@@ -668,7 +668,7 @@ repeat:
 				JBUFFER_TRACE(jh, "allocate memory for buffer");
 				jbd_unlock_bh_state(bh);
 				frozen_buffer =
-					jbd2_slab_alloc(jh2bh(jh)->b_size,
+					jbd2_alloc(jh2bh(jh)->b_size,
 							 GFP_NOFS);
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
@@ -728,7 +728,7 @@ done:
 
 out:
 	if (unlikely(frozen_buffer))	/* It's usually NULL */
-		jbd2_slab_free(frozen_buffer, bh->b_size);
+		jbd2_free(frozen_buffer, bh->b_size);
 
 	JBUFFER_TRACE(jh, "exit");
 	return error;
@@ -881,7 +881,7 @@ int jbd2_journal_get_undo_access(handle_
 
 repeat:
 	if (!jh->b_committed_data) {
-		committed_data = jbd2_slab_alloc(jh2bh(jh)->b_size, GFP_NOFS);
+		committed_data = jbd2_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
 				__FUNCTION__);
@@ -908,7 +908,7 @@ repeat:
 out:
 	jbd2_journal_put_journal_head(jh);
 	if (unlikely(committed_data))
-		jbd2_slab_free(committed_data, bh->b_size);
+		jbd2_free(committed_data, bh->b_size);
 	return err;
 }
 
@@ -1411,7 +1411,7 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	jbd_free_handle(handle);
+	jbd2_free_handle(handle);
 	return err;
 }
 
diff -puN fs/jbd/checkpoint.c~jbd-slab-cleanups fs/jbd/checkpoint.c
--- a/fs/jbd/checkpoint.c~jbd-slab-cleanups
+++ a/fs/jbd/checkpoint.c
@@ -693,5 +693,5 @@ void __journal_drop_transaction(journal_
 	J_ASSERT(journal->j_running_transaction != transaction);
 
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-	kfree(transaction);
+	jbd_kfree(transaction);
 }
diff -puN fs/jbd/commit.c~jbd-slab-cleanups fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-slab-cleanups
+++ a/fs/jbd/commit.c
@@ -375,7 +375,7 @@ void journal_commit_transaction(journal_
 			struct buffer_head *bh = jh2bh(jh);
 
 			jbd_lock_bh_state(bh);
-			jbd_slab_free(jh->b_committed_data, bh->b_size);
+			jbd_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			jbd_unlock_bh_state(bh);
 		}
@@ -792,14 +792,14 @@ restart_loop:
 		 * Otherwise, we can just throw away the frozen data now.
 		 */
 		if (jh->b_committed_data) {
-			jbd_slab_free(jh->b_committed_data, bh->b_size);
+			jbd_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			if (jh->b_frozen_data) {
 				jh->b_committed_data = jh->b_frozen_data;
 				jh->b_frozen_data = NULL;
 			}
 		} else if (jh->b_frozen_data) {
-			jbd_slab_free(jh->b_frozen_data, bh->b_size);
+			jbd_free(jh->b_frozen_data, bh->b_size);
 			jh->b_frozen_data = NULL;
 		}
 
diff -puN fs/jbd/journal.c~jbd-slab-cleanups fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-slab-cleanups
+++ a/fs/jbd/journal.c
@@ -83,7 +83,6 @@ EXPORT_SYMBOL(journal_force_commit);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
-static int journal_create_jbd_slab(size_t slab_size);
 
 /*
  * Helper function used to manage commit timeouts
@@ -334,10 +333,10 @@ repeat:
 		char *tmp;
 
 		jbd_unlock_bh_state(bh_in);
-		tmp = jbd_slab_alloc(bh_in->b_size, GFP_NOFS);
+		tmp = jbd_alloc(bh_in->b_size, GFP_NOFS);
 		jbd_lock_bh_state(bh_in);
 		if (jh_in->b_frozen_data) {
-			jbd_slab_free(tmp, bh_in->b_size);
+			jbd_free(tmp, bh_in->b_size);
 			goto repeat;
 		}
 
@@ -679,7 +678,7 @@ static journal_t * journal_init_common (
 	/* Set up a default-sized revoke table for the new mount. */
 	err = journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
 	if (err) {
-		kfree(journal);
+		jbd_kfree(journal);
 		goto fail;
 	}
 	return journal;
@@ -728,7 +727,7 @@ journal_t * journal_init_dev(struct bloc
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		kfree(journal);
+		jbd_kfree(journal);
 		journal = NULL;
 		goto out;
 	}
@@ -782,7 +781,7 @@ journal_t * journal_init_inode (struct i
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
-		kfree(journal);
+		jbd_kfree(journal);
 		return NULL;
 	}
 
@@ -791,7 +790,7 @@ journal_t * journal_init_inode (struct i
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
 		       __FUNCTION__);
-		kfree(journal);
+		jbd_kfree(journal);
 		return NULL;
 	}
 
@@ -1095,13 +1094,6 @@ int journal_load(journal_t *journal)
 		}
 	}
 
-	/*
-	 * Create a slab for this blocksize
-	 */
-	err = journal_create_jbd_slab(be32_to_cpu(sb->s_blocksize));
-	if (err)
-		return err;
-
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
 	if (journal_recover(journal))
@@ -1166,7 +1158,7 @@ void journal_destroy(journal_t *journal)
 	if (journal->j_revoke)
 		journal_destroy_revoke(journal);
 	kfree(journal->j_wbuf);
-	kfree(journal);
+	jbd_kfree(journal);
 }
 
 
@@ -1615,86 +1607,6 @@ int journal_blocks_per_page(struct inode
 }
 
 /*
- * Simple support for retrying memory allocations.  Introduced to help to
- * debug different VM deadlock avoidance strategies.
- */
-void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-
-/*
- * jbd slab management: create 1k, 2k, 4k, 8k slabs as needed
- * and allocate frozen and commit buffers from these slabs.
- *
- * Reason for doing this is to avoid, SLAB_DEBUG - since it could
- * cause bh to cross page boundary.
- */
-
-#define JBD_MAX_SLABS 5
-#define JBD_SLAB_INDEX(size)  (size >> 11)
-
-static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
-static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd_1k", "jbd_2k", "jbd_4k", NULL, "jbd_8k"
-};
-
-static void journal_destroy_jbd_slabs(void)
-{
-	int i;
-
-	for (i = 0; i < JBD_MAX_SLABS; i++) {
-		if (jbd_slab[i])
-			kmem_cache_destroy(jbd_slab[i]);
-		jbd_slab[i] = NULL;
-	}
-}
-
-static int journal_create_jbd_slab(size_t slab_size)
-{
-	int i = JBD_SLAB_INDEX(slab_size);
-
-	BUG_ON(i >= JBD_MAX_SLABS);
-
-	/*
-	 * Check if we already have a slab created for this size
-	 */
-	if (jbd_slab[i])
-		return 0;
-
-	/*
-	 * Create a slab and force alignment to be same as slabsize -
-	 * this will make sure that allocations won't cross the page
-	 * boundary.
-	 */
-	jbd_slab[i] = kmem_cache_create(jbd_slab_names[i],
-				slab_size, slab_size, 0, NULL);
-	if (!jbd_slab[i]) {
-		printk(KERN_EMERG "JBD: no memory for jbd_slab cache\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-void * jbd_slab_alloc(size_t size, gfp_t flags)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	return kmem_cache_alloc(jbd_slab[idx], flags | __GFP_NOFAIL);
-}
-
-void jbd_slab_free(void *ptr,  size_t size)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	kmem_cache_free(jbd_slab[idx], ptr);
-}
-
-/*
  * Journal_head storage management
  */
 static struct kmem_cache *journal_head_cache;
@@ -1881,13 +1793,13 @@ static void __journal_remove_journal_hea
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
 						__FUNCTION__);
-				jbd_slab_free(jh->b_frozen_data, bh->b_size);
+				jbd_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
 						__FUNCTION__);
-				jbd_slab_free(jh->b_committed_data, bh->b_size);
+				jbd_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
 			jh->b_bh = NULL;	/* debug, really */
@@ -2042,7 +1954,6 @@ static void journal_destroy_caches(void)
 	journal_destroy_revoke_caches();
 	journal_destroy_journal_head_cache();
 	journal_destroy_handle_cache();
-	journal_destroy_jbd_slabs();
 }
 
 static int __init journal_init(void)
diff -puN fs/jbd/transaction.c~jbd-slab-cleanups fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-slab-cleanups
+++ a/fs/jbd/transaction.c
@@ -229,7 +229,7 @@ repeat_locked:
 	spin_unlock(&journal->j_state_lock);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
+		jbd_kfree(new_transaction);
 	return ret;
 }
 
@@ -668,7 +668,7 @@ repeat:
 				JBUFFER_TRACE(jh, "allocate memory for buffer");
 				jbd_unlock_bh_state(bh);
 				frozen_buffer =
-					jbd_slab_alloc(jh2bh(jh)->b_size,
+					jbd_alloc(jh2bh(jh)->b_size,
 							 GFP_NOFS);
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
@@ -728,7 +728,7 @@ done:
 
 out:
 	if (unlikely(frozen_buffer))	/* It's usually NULL */
-		jbd_slab_free(frozen_buffer, bh->b_size);
+		jbd_free(frozen_buffer, bh->b_size);
 
 	JBUFFER_TRACE(jh, "exit");
 	return error;
@@ -881,7 +881,7 @@ int journal_get_undo_access(handle_t *ha
 
 repeat:
 	if (!jh->b_committed_data) {
-		committed_data = jbd_slab_alloc(jh2bh(jh)->b_size, GFP_NOFS);
+		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
 				__FUNCTION__);
@@ -908,7 +908,7 @@ repeat:
 out:
 	journal_put_journal_head(jh);
 	if (unlikely(committed_data))
-		jbd_slab_free(committed_data, bh->b_size);
+		jbd_free(committed_data, bh->b_size);
 	return err;
 }
 
diff -puN include/linux/jbd2.h~jbd-slab-cleanups include/linux/jbd2.h
--- a/include/linux/jbd2.h~jbd-slab-cleanups
+++ a/include/linux/jbd2.h
@@ -71,11 +71,27 @@ extern u8 jbd2_journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-extern void * __jbd2_kmalloc (const char *where, size_t size, gfp_t flags, int retry);
-extern void * jbd2_slab_alloc(size_t size, gfp_t flags);
-extern void jbd2_slab_free(void *ptr, size_t size);
+static inline void *__jbd2_kmalloc(const char *where, size_t size,
+						gfp_t flags, int retry)
+{
+	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
+}
+static inline void jbd2_kfree(void *ptr)
+{
+	return kfree(ptr);
+}
+
+static inline void *jbd2_alloc(size_t size, gfp_t flags)
+{
+	return (void *)__get_free_pages(flags, get_order(size));
+}
+
+static inline void jbd2_free(void *ptr, size_t size)
+{
+	free_pages((unsigned long)ptr, get_order(size));
+};
 
-#define jbd_kmalloc(size, flags) \
+#define jbd2_kmalloc(size, flags) \
 	__jbd2_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
 #define jbd_rep_kmalloc(size, flags) \
 	__jbd2_kmalloc(__FUNCTION__, (size), (flags), 1)
@@ -945,12 +961,12 @@ void jbd2_journal_put_journal_head(struc
  */
 extern struct kmem_cache *jbd2_handle_cache;
 
-static inline handle_t *jbd_alloc_handle(gfp_t gfp_flags)
+static inline handle_t *jbd2_alloc_handle(gfp_t gfp_flags)
 {
 	return kmem_cache_alloc(jbd2_handle_cache, gfp_flags);
 }
 
-static inline void jbd_free_handle(handle_t *handle)
+static inline void jbd2_free_handle(handle_t *handle)
 {
 	kmem_cache_free(jbd2_handle_cache, handle);
 }
diff -puN include/linux/jbd.h~jbd-slab-cleanups include/linux/jbd.h
--- a/include/linux/jbd.h~jbd-slab-cleanups
+++ a/include/linux/jbd.h
@@ -71,9 +71,26 @@ extern int journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-extern void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry);
-extern void * jbd_slab_alloc(size_t size, gfp_t flags);
-extern void jbd_slab_free(void *ptr, size_t size);
+static inline void *__jbd_kmalloc(const char *where, size_t size,
+						gfp_t flags, int retry)
+{
+	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
+}
+
+static inline void jbd_kfree(void *ptr)
+{
+	return kfree(ptr);
+}
+
+static inline void *jbd_alloc(size_t size, gfp_t flags)
+{
+	return (void *)__get_free_pages(flags, get_order(size));
+}
+
+static inline void jbd_free(void *ptr, size_t size)
+{
+	free_pages((unsigned long)ptr, get_order(size));
+};
 
 #define jbd_kmalloc(size, flags) \
 	__jbd_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
_

Patches currently in -mm which might be from clameter@sgi.com are

revert-highmem-catch-illegal-nesting.patch
slub-accurately-compare-debug-flags-during-slab-cache-merge.patch
infiniband-work-around-gcc-slub-problem.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags.patch
categorize-gfp-flags-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
slub-do-not-use-page-mapping.patch
slub-do-not-use-page-mapping-fix.patch
slub-move-page-offset-to-kmem_cache_cpu-offset.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
slub-optimize-cacheline-use-for-zeroing.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
config_zone_movable-zone-ifdef-cleanup-by-renumbering.patch
config_zone_movable-config-zone-movable.patch
add-node-states-sysfs-class-attributes-v5.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
jbd-slab-cleanups.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
page-owner-tracking-leak-detector.patch
