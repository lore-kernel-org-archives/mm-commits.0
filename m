From: akpm@linux-foundation.org
Subject: - fs-fix-kernel-doc-notation-warnings.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:46 -0700
Message-ID: <200803212029.m2LKTkJ1008898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758082AbYCUU36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs: fix kernel-doc notation warnings
has been removed from the -mm tree.  Its filename was
     fs-fix-kernel-doc-notation-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: fix kernel-doc notation warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation warnings in fs/.

Warning(mmotm-2008-0314-1449//fs/super.c:560): missing initial short description on line:
 *	mark_files_ro
Warning(mmotm-2008-0314-1449//fs/locks.c:1277): missing initial short description on line:
 *	lease_get_mtime
Warning(mmotm-2008-0314-1449//fs/locks.c:1277): missing initial short description on line:
 *	lease_get_mtime
Warning(mmotm-2008-0314-1449//fs/namei.c:1368): missing initial short description on line:
 * lookup_one_len:  filesystem helper to lookup single pathname component
Warning(mmotm-2008-0314-1449//fs/buffer.c:3221): missing initial short description on line:
 * bh_uptodate_or_lock: Test whether the buffer is uptodate
Warning(mmotm-2008-0314-1449//fs/buffer.c:3240): missing initial short description on line:
 * bh_submit_read: Submit a locked buffer for reading
Warning(mmotm-2008-0314-1449//fs/fs-writeback.c:30): missing initial short description on line:
 * writeback_acquire: attempt to get exclusive writeback access to a device
Warning(mmotm-2008-0314-1449//fs/fs-writeback.c:47): missing initial short description on line:
 * writeback_in_progress: determine whether there is writeback in progress
Warning(mmotm-2008-0314-1449//fs/fs-writeback.c:58): missing initial short description on line:
 * writeback_release: relinquish exclusive writeback access against a device.
Warning(mmotm-2008-0314-1449//include/linux/jbd.h:351): contents before sections
Warning(mmotm-2008-0314-1449//include/linux/jbd.h:561): contents before sections
Warning(mmotm-2008-0314-1449//fs/jbd/transaction.c:1935): missing initial short description on line:
 * void journal_invalidatepage()

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c          |    4 ++--
 fs/fs-writeback.c    |    6 +++---
 fs/jbd/transaction.c |    5 ++---
 fs/locks.c           |    4 ++--
 fs/namei.c           |    6 +++---
 fs/super.c           |    6 +++---
 include/linux/jbd.h  |   11 ++---------
 7 files changed, 17 insertions(+), 25 deletions(-)

diff -puN fs/buffer.c~fs-fix-kernel-doc-notation-warnings fs/buffer.c
--- a/fs/buffer.c~fs-fix-kernel-doc-notation-warnings
+++ a/fs/buffer.c
@@ -3213,7 +3213,7 @@ static int buffer_cpu_notify(struct noti
 }
 
 /**
- * bh_uptodate_or_lock: Test whether the buffer is uptodate
+ * bh_uptodate_or_lock - Test whether the buffer is uptodate
  * @bh: struct buffer_head
  *
  * Return true if the buffer is up-to-date and false,
@@ -3232,7 +3232,7 @@ int bh_uptodate_or_lock(struct buffer_he
 EXPORT_SYMBOL(bh_uptodate_or_lock);
 
 /**
- * bh_submit_read: Submit a locked buffer for reading
+ * bh_submit_read - Submit a locked buffer for reading
  * @bh: struct buffer_head
  *
  * Returns zero on success and -EIO on error.
diff -puN fs/fs-writeback.c~fs-fix-kernel-doc-notation-warnings fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-fix-kernel-doc-notation-warnings
+++ a/fs/fs-writeback.c
@@ -751,7 +751,7 @@ int generic_osync_inode(struct inode *in
 EXPORT_SYMBOL(generic_osync_inode);
 
 /**
- * writeback_acquire: attempt to get exclusive writeback access to a device
+ * writeback_acquire - attempt to get exclusive writeback access to a device
  * @bdi: the device's backing_dev_info structure
  *
  * It is a waste of resources to have more than one pdflush thread blocked on
@@ -768,7 +768,7 @@ int writeback_acquire(struct backing_dev
 }
 
 /**
- * writeback_in_progress: determine whether there is writeback in progress
+ * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
  *
  * Determine whether there is writeback in progress against a backing device.
@@ -779,7 +779,7 @@ int writeback_in_progress(struct backing
 }
 
 /**
- * writeback_release: relinquish exclusive writeback access against a device.
+ * writeback_release - relinquish exclusive writeback access against a device.
  * @bdi: the device's backing_dev_info structure
  */
 void writeback_release(struct backing_dev_info *bdi)
diff -puN fs/jbd/transaction.c~fs-fix-kernel-doc-notation-warnings fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~fs-fix-kernel-doc-notation-warnings
+++ a/fs/jbd/transaction.c
@@ -1904,13 +1904,12 @@ zap_buffer_unlocked:
 }
 
 /**
- * void journal_invalidatepage()
- * @journal: journal to use for flush...
+ * void journal_invalidatepage() - invalidate a journal page
+ * @journal: journal to use for flush
  * @page:    page to flush
  * @offset:  length of page to invalidate.
  *
  * Reap page buffers containing data after offset in page.
- *
  */
 void journal_invalidatepage(journal_t *journal,
 		      struct page *page,
diff -puN fs/locks.c~fs-fix-kernel-doc-notation-warnings fs/locks.c
--- a/fs/locks.c~fs-fix-kernel-doc-notation-warnings
+++ a/fs/locks.c
@@ -1275,13 +1275,13 @@ out:
 EXPORT_SYMBOL(__break_lease);
 
 /**
- *	lease_get_mtime
+ *	lease_get_mtime - get the last modified time of an inode
  *	@inode: the inode
  *      @time:  pointer to a timespec which will contain the last modified time
  *
  * This is to force NFS clients to flush their caches for files with
  * exclusive leases.  The justification is that if someone has an
- * exclusive lease, then they could be modifiying it.
+ * exclusive lease, then they could be modifying it.
  */
 void lease_get_mtime(struct inode *inode, struct timespec *time)
 {
diff -puN fs/namei.c~fs-fix-kernel-doc-notation-warnings fs/namei.c
--- a/fs/namei.c~fs-fix-kernel-doc-notation-warnings
+++ a/fs/namei.c
@@ -1364,13 +1364,13 @@ static int __lookup_one_len(const char *
 }
 
 /**
- * lookup_one_len:  filesystem helper to lookup single pathname component
+ * lookup_one_len - filesystem helper to lookup single pathname component
  * @name:	pathname component to lookup
  * @base:	base directory to lookup from
  * @len:	maximum length @len should be interpreted to
  *
- * Note that this routine is purely a helper for filesystem useage and should
- * not be called by generic code.  Also note that by using this function to
+ * Note that this routine is purely a helper for filesystem usage and should
+ * not be called by generic code.  Also note that by using this function the
  * nameidata argument is passed to the filesystem methods and a filesystem
  * using this helper needs to be prepared for that.
  */
diff -puN fs/super.c~fs-fix-kernel-doc-notation-warnings fs/super.c
--- a/fs/super.c~fs-fix-kernel-doc-notation-warnings
+++ a/fs/super.c
@@ -556,11 +556,11 @@ out:
 }
 
 /**
- *	mark_files_ro
+ *	mark_files_ro - mark all files read-only
  *	@sb: superblock in question
  *
- *	All files are marked read/only.  We don't care about pending
- *	delete files so this should be used in 'force' mode only
+ *	All files are marked read-only.  We don't care about pending
+ *	delete files so this should be used in 'force' mode only.
  */
 
 static void mark_files_ro(struct super_block *sb)
diff -puN include/linux/jbd.h~fs-fix-kernel-doc-notation-warnings include/linux/jbd.h
--- a/include/linux/jbd.h~fs-fix-kernel-doc-notation-warnings
+++ a/include/linux/jbd.h
@@ -348,8 +348,7 @@ static inline void jbd_unlock_bh_journal
 struct jbd_revoke_table_s;
 
 /**
- * struct handle_s - The handle_s type is the concrete type associated with
- *     handle_t.
+ * struct handle_s - this is the concrete type associated with handle_t.
  * @h_transaction: Which compound transaction is this update a part of?
  * @h_buffer_credits: Number of remaining buffers we are allowed to dirty.
  * @h_ref: Reference count on this handle
@@ -358,12 +357,7 @@ struct jbd_revoke_table_s;
  * @h_jdata: flag to force data journaling
  * @h_aborted: flag indicating fatal error on handle
  * @h_lockdep_map: lockdep info for debugging lock problems
- **/
-
-/* Docbook can't yet cope with the bit fields, but will leave the documentation
- * in so it can be fixed later.
  */
-
 struct handle_s
 {
 	/* Which compound transaction is this update a part of? */
@@ -558,8 +552,7 @@ struct transaction_s
 };
 
 /**
- * struct journal_s - The journal_s type is the concrete type associated with
- *     journal_t.
+ * struct journal_s - this is the concrete type associated with journal_t.
  * @j_flags:  General journaling state flags
  * @j_errno:  Is there an outstanding uncleared error on the journal (from a
  *     prior abort)?
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-x86.patch
rapidio-fix-docbook-references.patch
pm-remove-legacy-pm-fix.patch
git-kvm.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
scsi-add-iscsi-ibft-support-fix.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
x86-dont-allow-kvm_clock-without-have_kvm.patch
mempolicy-update-numa-memory-policy-documentation.patch
mempolicy-disallow-static-or-relative-flags-for-local-preferred-mode.patch
let-log_buf_shift-default-to-17.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch
isolate-ratelimit-from-printkc-for-other-use-update.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
add-a-document-describing-the-resource-counter-abstraction-v2.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
jbd2-fix-kernel-doc-notation.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
kernel-add-bit-rotation-helpers-for-16-and-8-bit.patch
profile-likely-unlikely-macros.patch

