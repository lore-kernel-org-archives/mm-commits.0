From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:29:07 -0800
Message-ID: <20180201192907.dAkwl6lQe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754695AbeBAT3I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:29:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/cluster: neaten a member of o2net_msg_handler
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2/cluster: neaten a member of o2net_msg_handler

It's odd that o2net_msg_handler::nh_func_data is declared as type
o2net_msg_handler_func*.  So neaten it.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F1F554DA@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp_internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp_internal.h~ocfs2-cluster-neaten-a-member-of-o2net_msg_handler fs/ocfs2/cluster/tcp_internal.h
--- a/fs/ocfs2/cluster/tcp_internal.h~ocfs2-cluster-neaten-a-member-of-o2net_msg_handler
+++ a/fs/ocfs2/cluster/tcp_internal.h
@@ -196,7 +196,7 @@ struct o2net_msg_handler {
 	u32			nh_msg_type;
 	u32			nh_key;
 	o2net_msg_handler_func	*nh_func;
-	o2net_msg_handler_func	*nh_func_data;
+	void			*nh_func_data;
 	o2net_post_msg_handler_func
 				*nh_post_func;
 	struct kref		nh_kref;
_

Patches currently in -mm which might be from ge.changwei@h3c.com are


