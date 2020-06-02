From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 002/128] ocfs2: add missing annotation for
 dlm_empty_lockres()
Date: Tue, 02 Jun 2020 13:09:59 -0700
Message-ID: <20200602200959.LpcYDpAVU%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgFBUKA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:10:00 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jbi.octave@gmail.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Jules Irenge <jbi.octave@gmail.com>
Subject: ocfs2: add missing annotation for dlm_empty_lockres()

Sparse reports a warning at dlm_empty_lockres()

warning: context imbalance in dlm_purge_lockres() - unexpected unlock

The root cause is the missing annotation at dlm_purge_lockres()

Add the missing __must_hold(&dlm->spinlock)

Link: http://lkml.kernel.org/r/20200403160505.2832-4-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-add-missing-annotation-for-dlm_empty_lockres
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -2760,6 +2760,7 @@ leave:
  * Returns: 1 if dlm->spinlock was dropped/retaken, 0 if never dropped
  */
 int dlm_empty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res)
+	__must_hold(&dlm->spinlock)
 {
 	int ret;
 	int lock_dropped = 0;
_
