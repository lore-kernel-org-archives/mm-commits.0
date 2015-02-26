From: akpm@linux-foundation.org
Subject: +
 ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch added to
 -mm tree
Date: Thu, 26 Feb 2015 13:34:47 -0800
Message-ID: <54ef9177.GOEncNZtaxii7zq7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbbBZVes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 16:34:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: need to handle error for ocfs2_journal_access_di() call
has been added to the -mm tree.  Its filename is
     ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

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

ocfs2-remove-unneeded-rc-for-kfree.patch
ocfs2-avoid-a-pointless-delay-in-o2cb_cluster_check.patch
ocfs2-remove-unneeded-variable-status.patch
ocfs2-remove-extra-mlog_errno-call-in-__ocfs2_add_entry.patch
ocfs2-need-to-handle-error-for-ocfs2_journal_access_di-call.patch

