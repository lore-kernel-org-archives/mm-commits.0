From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:58:04 -0700
Message-ID: <51ba163c.z51cqJXOza+h+qwQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: [merged] ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler.patch removed from -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:58:04 -0700


The patch titled
     Subject: ocfs2: add missing lockres put in dlm_mig_lockres_handler
has been removed from the -mm tree.  Its filename was
     ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: add missing lockres put in dlm_mig_lockres_handler

dlm_mig_lockres_handler() is missing a dlm_lockres_put() on an error path.

Signed-off-by: joyce <xuejiufei@huawei.com>
Reviewed-by: shencanquan <shencanquan@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-missing-lockres-put-in-dlm_mig_lockres_handler
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1408,6 +1408,7 @@ int dlm_mig_lockres_handler(struct o2net
 				     mres->lockname_len, mres->lockname);
 				ret = -EFAULT;
 				spin_unlock(&res->spinlock);
+				dlm_lockres_put(res);
 				goto leave;
 			}
 			res->state |= DLM_LOCK_RES_MIGRATING;
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

origin.patch
linux-next.patch
ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch

