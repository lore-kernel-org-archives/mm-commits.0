From: akpm@linux-foundation.org
Subject: + jbd2-ext4-cleanups-convert-to-kzalloc.patch added to -mm tree
Date: Wed, 26 Sep 2007 12:54:57 -0700
Message-ID: <200709261954.l8QJsvM9001117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbXIZTzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 15:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com


The patch titled
     JBD2/ext4 cleanups: convert to kzalloc
has been added to the -mm tree.  Its filename is
     jbd2-ext4-cleanups-convert-to-kzalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: JBD2/ext4 cleanups: convert to kzalloc
From: Mingming Cao <cmm@us.ibm.com>

Convert kmalloc to kzalloc() and get rid of the memset().

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ext4/xattr.c~jbd2-ext4-cleanups-convert-to-kzalloc fs/ext4/xattr.c
--- a/fs/ext4/xattr.c~jbd2-ext4-cleanups-convert-to-kzalloc
+++ a/fs/ext4/xattr.c
@@ -750,12 +750,11 @@ ext4_xattr_block_set(handle_t *handle, s
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-		s->base = kmalloc(sb->s_blocksize, GFP_KERNEL);
+		s->base = kzalloc(sb->s_blocksize, GFP_KERNEL);
 		/* assert(header == s->base) */
 		error = -ENOMEM;
 		if (s->base == NULL)
 			goto cleanup;
-		memset(s->base, 0, sb->s_blocksize);
 		header(s->base)->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
 		header(s->base)->h_blocks = cpu_to_le32(1);
 		header(s->base)->h_refcount = cpu_to_le32(1);
diff -puN fs/jbd2/journal.c~jbd2-ext4-cleanups-convert-to-kzalloc fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-ext4-cleanups-convert-to-kzalloc
+++ a/fs/jbd2/journal.c
@@ -955,10 +955,9 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
-	memset(journal, 0, sizeof(*journal));
 
 	init_waitqueue_head(&journal->j_wait_transaction_locked);
 	init_waitqueue_head(&journal->j_wait_logspace);
diff -puN fs/jbd2/transaction.c~jbd2-ext4-cleanups-convert-to-kzalloc fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-ext4-cleanups-convert-to-kzalloc
+++ a/fs/jbd2/transaction.c
@@ -99,12 +99,11 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction), GFP_NOFS);
+		new_transaction = kzalloc(sizeof(*new_transaction), GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
 		}
-		memset(new_transaction, 0, sizeof(*new_transaction));
 	}
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
_

Patches currently in -mm which might be from cmm@us.ibm.com are

convert-ill-defined-log2-to-ilog2.patch
ext2-ext3-ext4-add-block-bitmap-validation.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
jbd-slab-cleanups.patch
jbd-slab-cleanups-2.patch
jbd-slab-cleanups-3.patch
jbd-ext3-cleanups-convert-to-kzalloc.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
ext4-uninitialized-block-groups.patch
ext4-uninitialized-block-groups-fix.patch
jbd2-ext4-cleanups-convert-to-kzalloc.patch
jbd2-ext4-naming-cleanup.patch
