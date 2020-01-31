From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-remove-redundant-assignment-to-ret.patch removed from -mm tree
Date: Fri, 31 Jan 2020 15:17:03 -0800
Message-ID: <20200131231703.NxpLjimUS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXRE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2/dlm: remove redundant assignment to ret
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-remove-redundant-assignment-to-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2/dlm: remove redundant assignment to ret

The variable ret is being initialized with a value that is never read and
it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses Coverity ("Unused value")

Link: http://lkml.kernel.org/r/20191202164833.62865-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-remove-redundant-assignment-to-ret
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1668,7 +1668,7 @@ static int dlm_lockres_master_requery(st
 int dlm_do_master_requery(struct dlm_ctxt *dlm, struct dlm_lock_resource *res,
 			  u8 nodenum, u8 *real_master)
 {
-	int ret = -EINVAL;
+	int ret;
 	struct dlm_master_requery req;
 	int status = DLM_LOCK_RES_OWNER_UNKNOWN;
 
_

Patches currently in -mm which might be from colin.king@canonical.com are
