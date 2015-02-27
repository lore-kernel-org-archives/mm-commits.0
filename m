From: akpm@linux-foundation.org
Subject: [wrecked]
 ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch removed
 from -mm tree
Date: Fri, 27 Feb 2015 12:52:03 -0800
Message-ID: <54f0d8f3.QGs2tDjGst6Ii7qV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbbB0UwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 15:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: need to handle error for ocfs2_journal_access_di() call
has been removed from the -mm tree.  Its filename was
     ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: need to handle error for ocfs2_journal_access_di() call

There is no error handle when ocfs2_journal_access_di() is failed.  And
also it doesn't need to call ocfs2_dx_dir_insert() when
ocfs2_journal_access_db() is failed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call
+++ a/fs/ocfs2/dir.c
@@ -1703,15 +1703,15 @@ int __ocfs2_add_entry(handle_t *handle,
 								 insert_bh,
 					      OCFS2_JOURNAL_ACCESS_WRITE);
 
-				if (ocfs2_dir_indexed(dir)) {
+				if (!retval && ocfs2_dir_indexed(dir))
 					retval = ocfs2_dx_dir_insert(dir,
 								handle,
 								lookup);
-					if (retval)
-						goto bail;
-				}
 			}
 
+			if (retval)
+				goto bail;
+
 			/* By now the buffer is marked for journaling */
 			offset += le16_to_cpu(de->rec_len);
 			if (le64_to_cpu(de->inode)) {
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch

