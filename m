From: akpm@linux-foundation.org
Subject: + reiserfs-fix-printk-format-warning.patch added to -mm tree
Date: Thu, 09 Apr 2009 13:58:08 -0700
Message-ID: <200904092058.n39Kw8Hb022387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757810AbZDIU7w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 16:59:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, jeffm@suse.com


The patch titled
     reiserfs: fix printk format warning
has been added to the -mm tree.  Its filename is
     reiserfs-fix-printk-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
reiserfs-fix-printk-format-warning.patch

