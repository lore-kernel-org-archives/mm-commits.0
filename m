From: akpm@linux-foundation.org
Subject: [patch 007/119] ocfs2/cluster: neaten a member of
 o2net_msg_handler
Date: Wed, 31 Jan 2018 16:14:25 -0800
Message-ID: <20180201001425.e5XNYpjIy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754313AbeBAAO1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:14:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
