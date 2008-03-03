From: akpm@linux-foundation.org
Subject: + docbook-fix-filesystemstmpl-source-files.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:23:31 -0800
Message-ID: <200803030723.m237NVxF004376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbYCCHXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:23:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docbook: fix filesystems.tmpl source files
has been added to the -mm tree.  Its filename is
     docbook-fix-filesystemstmpl-source-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix filesystems.tmpl source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in filesystems.tmpl.  These cause the generated docbook
to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c          |    3 +--
 fs/jbd/transaction.c |   17 +++++++++--------
 fs/mpage.c           |   11 +++--------
 3 files changed, 13 insertions(+), 18 deletions(-)

diff -puN fs/buffer.c~docbook-fix-filesystemstmpl-source-files fs/buffer.c
--- a/fs/buffer.c~docbook-fix-filesystemstmpl-source-files
+++ a/fs/buffer.c
@@ -637,8 +637,7 @@ repeat:
 }
 
 /**
- * sync_mapping_buffers - write out and wait upon a mapping's "associated"
- *                        buffers
+ * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
  *
  * Starts I/O against the buffers at mapping->private_list, and waits upon
diff -puN fs/jbd/transaction.c~docbook-fix-filesystemstmpl-source-files fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~docbook-fix-filesystemstmpl-source-files
+++ a/fs/jbd/transaction.c
@@ -369,7 +369,7 @@ out:
 
 
 /**
- * int journal_restart() - restart a handle .
+ * int journal_restart() - restart a handle.
  * @handle:  handle to restart
  * @nblocks: nr credits requested
  *
@@ -857,8 +857,7 @@ out:
 }
 
 /**
- * int journal_get_undo_access() -  Notify intent to modify metadata with
- *     non-rewindable consequences
+ * int journal_get_undo_access() - Notify intent to modify metadata with non-rewindable consequences
  * @handle: transaction
  * @bh: buffer to undo
  * @credits: store the number of taken credits here (if not NULL)
@@ -934,12 +933,14 @@ out:
 }
 
 /**
- * int journal_dirty_data() -  mark a buffer as containing dirty data which
- *                             needs to be flushed before we can commit the
- *                             current transaction.
+ * int journal_dirty_data() - mark a buffer as containing dirty data to be flushed
  * @handle: transaction
  * @bh: bufferhead to mark
  *
+ * Description:
+ * Mark a buffer as containing dirty data which needs to be flushed before
+ * we can commit the current transaction.
+ *
  * The buffer is placed on the transaction's data list and is marked as
  * belonging to the transaction.
  *
@@ -1111,11 +1112,11 @@ no_journal:
 }
 
 /**
- * int journal_dirty_metadata() -  mark a buffer as containing dirty metadata
+ * int journal_dirty_metadata() - mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
  * @bh: buffer to mark
  *
- * mark dirty metadata which needs to be journaled as part of the current
+ * Mark dirty metadata which needs to be journaled as part of the current
  * transaction.
  *
  * The buffer is placed on the transaction's metadata list and is marked
diff -puN fs/mpage.c~docbook-fix-filesystemstmpl-source-files fs/mpage.c
--- a/fs/mpage.c~docbook-fix-filesystemstmpl-source-files
+++ a/fs/mpage.c
@@ -330,16 +330,12 @@ confused:
 }
 
 /**
- * mpage_readpages - populate an address space with some pages, and
- *                       start reads against them.
- *
+ * mpage_readpages - populate an address space with some pages & start reads against them
  * @mapping: the address_space
  * @pages: The address of a list_head which contains the target pages.  These
  *   pages have their ->index populated and are otherwise uninitialised.
- *
  *   The page at @pages->prev has the lowest file offset, and reads should be
  *   issued in @pages->prev to @pages->next order.
- *
  * @nr_pages: The number of pages at *@pages
  * @get_block: The filesystem's block mapper function.
  *
@@ -365,6 +361,7 @@ confused:
  * So an mpage read of the first 16 blocks of an ext2 file will cause I/O to be
  * submitted in the following order:
  * 	12 0 1 2 3 4 5 6 7 8 9 10 11 13 14 15 16
+ *
  * because the indirect block has to be read to get the mappings of blocks
  * 13,14,15,16.  Obviously, this impacts performance.
  *
@@ -662,9 +659,7 @@ out:
 }
 
 /**
- * mpage_writepages - walk the list of dirty pages of the given
- * address space and writepage() all of them.
- * 
+ * mpage_writepages - walk the list of dirty pages of the given address space & writepage() all of them
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
  * @get_block: the filesystem's block mapper function.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kprobes-move-kprobe-examples-to-samples.patch
x86-visws-fix-printk-format-warnings.patch
apanel-fix-kconfig-dependencies.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
profile-likely-unlikely-macros.patch
docbook-fix-filesystemstmpl-source-files.patch
docbook-fix-rapidio-source-files.patch
docbook-fix-scsi-source-file.patch
docbook-fix-kernel-api-source-files.patch
docbook-fix-fusion-source-files.patch

