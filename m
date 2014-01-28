From: akpm@linux-foundation.org
Subject: [merged] ocfs2-do-not-log-enoent-in-unlink.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:13 -0800
Message-ID: <52e80059.QOl/khG7B9QWADDw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joe.jin@oracle.com, jlbec@evilplan.org, xiaowei.hu@oracle.com

Subject: [merged] ocfs2-do-not-log-enoent-in-unlink.patch removed from -mm tree
To: xiaowei.hu@oracle.com,jlbec@evilplan.org,joe.jin@oracle.com,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:13 -0800


The patch titled
     Subject: ocfs2: do not log ENOENT in unlink()
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-log-enoent-in-unlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Xiaowei.Hu" <xiaowei.hu@oracle.com>
Subject: ocfs2: do not log ENOENT in unlink()

Suppress log message like this: (open_delete,8328,0):ocfs2_unlink:951
ERROR: status = -2

Orabug:17445485

Signed-off-by: Xiaowei Hu <xiaowei.hu@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/namei.c~ocfs2-do-not-log-enoent-in-unlink fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-do-not-log-enoent-in-unlink
+++ a/fs/ocfs2/namei.c
@@ -948,7 +948,7 @@ leave:
 	ocfs2_free_dir_lookup_result(&orphan_insert);
 	ocfs2_free_dir_lookup_result(&lookup);
 
-	if (status && (status != -ENOTEMPTY))
+	if (status && (status != -ENOTEMPTY) && (status != -ENOENT))
 		mlog_errno(status);
 
 	return status;
_

Patches currently in -mm which might be from xiaowei.hu@oracle.com are

origin.patch

