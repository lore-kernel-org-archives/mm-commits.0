From: akpm@linux-foundation.org
Subject: + ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch
 added to -mm tree
Date: Thu, 26 Feb 2015 13:34:45 -0800
Message-ID: <54ef9175.Kzr7uXNoXNBXBxFN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbbBZVeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 16:34:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove extra mlog_errno() call in __ocfs2_add_entry()
has been added to the -mm tree.  Its filename is
     ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: ocfs2: remove extra mlog_errno() call in __ocfs2_add_entry()

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry
+++ a/fs/ocfs2/dir.c
@@ -1689,10 +1689,8 @@ int __ocfs2_add_entry(handle_t *handle,
 		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
-			if (retval < 0) {
-				mlog_errno(retval);
+			if (retval < 0)
 				goto bail;
-			}
 
 			if (insert_bh == parent_fe_bh)
 				retval = ocfs2_journal_access_di(handle,
@@ -1709,10 +1707,8 @@ int __ocfs2_add_entry(handle_t *handle,
 					retval = ocfs2_dx_dir_insert(dir,
 								handle,
 								lookup);
-					if (retval) {
-						mlog_errno(retval);
+					if (retval)
 						goto bail;
-					}
 				}
 			}
 
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

ocfs2-remove-unneeded-rc-for-kfree.patch
ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch
ocfs2-remove-unneeded-variable-status.patch
ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch
ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

