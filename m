From: akpm@linux-foundation.org
Subject: - jbd-slab-cleanups-3.patch removed from -mm tree
Date: Thu, 11 Oct 2007 20:00:33 -0700
Message-ID: <200710120300.l9C30X31028962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633AbXJLDAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Oct 2007 23:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     JBD slab cleanups 3
has been removed from the -mm tree.  Its filename was
     jbd-slab-cleanups-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: JBD slab cleanups 3
From: Mingming Cao <cmm@us.ibm.com>

Here is the patch to clean up __GFP_NOFAIL flag in jbd/jbd2. In all
cases except one handles memory allocation failure so I get rid of those
GFP_NOFAIL flags.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c      |    2 +-
 fs/jbd/transaction.c  |    3 +--
 fs/jbd2/journal.c     |    2 +-
 fs/jbd2/transaction.c |    3 +--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/jbd2/journal.c~jbd-slab-cleanups-3 fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd-slab-cleanups-3
+++ a/fs/jbd2/journal.c
@@ -654,7 +654,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
diff -puN fs/jbd2/transaction.c~jbd-slab-cleanups-3 fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd-slab-cleanups-3
+++ a/fs/jbd2/transaction.c
@@ -96,8 +96,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+		new_transaction = kmalloc(sizeof(*new_transaction), GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
diff -puN fs/jbd/journal.c~jbd-slab-cleanups-3 fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-slab-cleanups-3
+++ a/fs/jbd/journal.c
@@ -653,7 +653,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
diff -puN fs/jbd/transaction.c~jbd-slab-cleanups-3 fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-slab-cleanups-3
+++ a/fs/jbd/transaction.c
@@ -96,8 +96,7 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kmalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+		new_transaction = kmalloc(sizeof(*new_transaction), GFP_NOFS);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
_

Patches currently in -mm which might be from cmm@us.ibm.com are

convert-ill-defined-log2-to-ilog2.patch
ext2-ext3-ext4-add-block-bitmap-validation.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
ext4-uninitialized-block-groups.patch
jbd-ext3-cleanups-convert-to-kzalloc.patch
ext3-support-large-blocksize-up-to-pagesize.patch
