From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:02 -0700
Message-ID: <51db1196.B0W9wHA+CijCAycl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:02 -0700


The patch titled
     Subject: fs/ocfs2/dlm/dlmrecovery.c:dlm_request_all_locks(): ret should be int instead of enum
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: fs/ocfs2/dlm/dlmrecovery.c:dlm_request_all_locks(): ret should be int instead of enum

In dlm_request_all_locks, ret is type enum.  But o2net_send_message
returns a type int value.  Then it will never run into the following error
branch.  So we should change the ret type from enum to int.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -786,7 +786,7 @@ static int dlm_request_all_locks(struct
 				 u8 dead_node)
 {
 	struct dlm_lock_request lr;
-	enum dlm_status ret;
+	int ret;
 
 	mlog(0, "\n");
 
@@ -799,7 +799,6 @@ static int dlm_request_all_locks(struct
 	lr.dead_node = dead_node;
 
 	// send message
-	ret = DLM_NOLOCKMGR;
 	ret = o2net_send_message(DLM_LOCK_REQUEST_MSG, dlm->key,
 				 &lr, sizeof(lr), request_from, NULL);
 
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch

