From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:45 -0700
Message-ID: <5723dab9.4RhNg1eUMCreqdS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbcD2WFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: return zero if deref_done message is successfully handled
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: return zero if deref_done message is successfully handled

dlm_deref_lockres_done_handler() should return zero if the message is
successfully handled.

Fixes: 60d663cb5273 ("ocfs2/dlm: add DEREF_DONE message").
Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled fs/ocfs2/dlm/dlmmaster.c
--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-dlm-return-zero-if-deref_done-message-is-successfully-handled
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2455,6 +2455,8 @@ int dlm_deref_lockres_done_handler(struc
 
 	spin_unlock(&dlm->spinlock);
 
+	ret = 0;
+
 done:
 	dlm_put(dlm);
 	return ret;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are


