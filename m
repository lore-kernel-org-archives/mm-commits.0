From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 011/118] fs: ocfs: remove unnecessary assertion in
 dlm_migrate_lockres
Date: Thu, 30 Jan 2020 22:11:33 -0800
Message-ID: <20200131061133.LZL0L4s-N%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:34 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, pakki001@umn.edu, piaojun@huawei.com, torvalds@linux-foundation.org

From: Aditya Pakki <pakki001@umn.edu>
Subject: fs: ocfs: remove unnecessary assertion in dlm_migrate_lockres

In the only caller of dlm_migrate_lockres() - dlm_empty_lockres(), target
is checked for O2NM_MAX_NODES.  Thus, the assertion in
dlm_migrate_lockres() is unnecessary and can be removed.  The patch
eliminates such a check.

Link: http://lkml.kernel.org/r/20191218194111.26041-1-pakki001@umn.edu
Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/dlm/dlmmaster.c~fs-ocfs-remove-unnecessary-assertion-in-dlm_migrate_lockres
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2554,8 +2554,6 @@ static int dlm_migrate_lockres(struct dl
 	if (!dlm_grab(dlm))
 		return -EINVAL;
 
-	BUG_ON(target == O2NM_MAX_NODES);
