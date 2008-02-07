From: akpm@linux-foundation.org
Subject: - document-i_sync-and-i_datasync.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:39 -0800
Message-ID: <200802070022.m170MKWs006413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764912AbYBGAoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joern@logfs.org, mm-commits@vger.kernel.org


The patch titled
     Document I_SYNC and I_DATASYNC
has been removed from the -mm tree.  Its filename was
     document-i_sync-and-i_datasync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Document I_SYNC and I_DATASYNC
From: Joern Engel <joern@logfs.org>

After some archeology (see http://logfs.org/logfs/inode_state_bits) I
finally figured out what the three I_DIRTY bits do.  Maybe others would
prefer less effort to reach this insight.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/fs.h~document-i_sync-and-i_datasync include/linux/fs.h
--- a/include/linux/fs.h~document-i_sync-and-i_datasync
+++ a/include/linux/fs.h
@@ -1279,8 +1279,10 @@ struct super_operations {
  *
  * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
  *
- * I_DIRTY_SYNC		Inode itself is dirty.
- * I_DIRTY_DATASYNC	Data-related inode changes pending
+ * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
+ *			fdatasync().  i_atime is the usual cause.
+ * I_DIRTY_DATASYNC	Inode is dirty and must be written on fdatasync(), f.e.
+ *			because i_size changed.
  * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
  * I_NEW		get_new_inode() sets i_state to I_LOCK|I_NEW.  Both
  *			are cleared by unlock_new_inode(), called from iget().
@@ -1312,8 +1314,6 @@ struct super_operations {
  *			purpose reduces latency and prevents some filesystem-
  *			specific deadlocks.
  *
- * Q: Why does I_DIRTY_DATASYNC exist?  It appears as if it could be replaced
- *    by (I_DIRTY_SYNC|I_DIRTY_PAGES).
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  * Q: igrab() only checks on (I_FREEING|I_WILL_FREE).  Should it also check on
  *    I_CLEAR?  If not, why?
_

Patches currently in -mm which might be from joern@logfs.org are

origin.patch
git-mtd.patch
eccbuf-is-statically-defined-and-always-evaluate-to-true.patch
