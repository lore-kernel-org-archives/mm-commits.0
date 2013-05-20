From: akpm@linux-foundation.org
Subject: +
 fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch added to -mm tree
Date: Mon, 20 May 2013 15:38:53 -0700
Message-ID: <519aa5fd.N+7x96QWTylwtPb/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3ETWiy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 18:38:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, rgoldwyn@gmail.com

Subject: + fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch added to -mm tree
To: rgoldwyn@gmail.com,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 15:38:53 -0700


The patch titled
     Subject: fs/ocfs2/namei.c: remove unecessary ERROR when removing non-empty directory
has been added to the -mm tree.  Its filename is
     fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: fs/ocfs2/namei.c: remove unecessary ERROR when removing non-empty directory

While removing a non-empty directory, the kernel dumps a message:
(rmdir,21743,1):ocfs2_unlink:953 ERROR: status = -39

Suppress the error message from being printed in the dmesg so users
don't panic.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory
+++ a/fs/ocfs2/namei.c
@@ -947,7 +947,7 @@ leave:
 	ocfs2_free_dir_lookup_result(&orphan_insert);
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	if (status)
+	if (status && (status != -ENOTEMPTY))
 		mlog_errno(status);
 
 	return status;
_

Patches currently in -mm which might be from rgoldwyn@gmail.com are

fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch

