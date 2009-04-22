From: akpm@linux-foundation.org
Subject: [merged] reiserfs-fix-printk-format-warning.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:30 -0700
Message-ID: <200904221831.n3MIVURL006761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbZDVSpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix printk format warning
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix printk format warning
From: Alexander Beregalov <a.beregalov@gmail.com>

Fix following warning message
fs/reiserfs/procfs.c:393: warning: format '%u' expects type 'unsigned int', but argument 22 has type 'long unsigned int'
introduced in 600ed4167
(reiserfs: audit transaction ids to always be unsigned ints)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reiserfs_fs_sb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/reiserfs_fs_sb.h~reiserfs-fix-printk-format-warning include/linux/reiserfs_fs_sb.h
--- a/include/linux/reiserfs_fs_sb.h~reiserfs-fix-printk-format-warning
+++ a/include/linux/reiserfs_fs_sb.h
@@ -193,7 +193,7 @@ struct reiserfs_journal {
 	atomic_t j_wcount;	/* count of writers for current commit */
 	unsigned long j_bcount;	/* batch count. allows turning X transactions into 1 */
 	unsigned long j_first_unflushed_offset;	/* first unflushed transactions offset */
-	unsigned long j_last_flush_trans_id;	/* last fully flushed journal timestamp */
+	unsigned int j_last_flush_trans_id;	/* last fully flushed journal timestamp */
 	struct buffer_head *j_header_bh;
 
 	time_t j_trans_start_time;	/* time this transaction started */
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch

