From: akpm@linux-foundation.org
Subject: +
 fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch added to -mm tree
Date: Tue, 28 May 2013 16:22:36 -0700
Message-ID: <51a53c3c.MuuWEu2ARQpvWE4V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab3E1XWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 19:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 16:22:36 -0700


The patch titled
     Subject: fs/ocfs2/dlm/dlmrecovery.c:dlm_request_all_locks(): ret should be int instead of enum
has been added to the -mm tree.  Its filename is
     fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: fs/ocfs2/dlm/dlmrecovery.c:dlm_request_all_locks(): ret should be int instead of enum

In dlm_request_all_locks, ret is type enum.  But o2net_send_message
returns a type int value.  Then it will never run into the following error
branch.  So we should change the ret type from enum to int.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
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

fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch
fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch

