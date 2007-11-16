From: akpm@linux-foundation.org
Subject: + document-i_sync-and-i_datasync.patch added to -mm tree
Date: Fri, 16 Nov 2007 15:04:23 -0800
Message-ID: <200711162304.lAGN4Ntq008030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760428AbXKPXFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 18:05:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joern@logfs.org


The patch titled
     Document I_SYNC and I_DATASYNC
has been added to the -mm tree.  Its filename is
     document-i_sync-and-i_datasync.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1285,8 +1285,10 @@ struct super_operations {
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
@@ -1318,8 +1320,6 @@ struct super_operations {
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

eccbuf-is-statically-defined-and-always-evaluate-to-true.patch
document-i_sync-and-i_datasync.patch
