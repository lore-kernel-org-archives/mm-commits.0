From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:46 -0700
Message-ID: <51ba162a.GXH22rfNutD19lfH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab3FMS5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, rgoldwyn@suse.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, rgoldwyn@gmail.com

Subject: [merged] fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch removed from -mm tree
To: rgoldwyn@gmail.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,rgoldwyn@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:46 -0700


The patch titled
     Subject: fs/ocfs2/namei.c: remove unecessary ERROR when removing non-empty directory
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-nameic-remove-unecessary-error-when-removing-non-empty-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
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

origin.patch
ocfs2-remove-unecessary-variable-needs_checkpoint.patch

