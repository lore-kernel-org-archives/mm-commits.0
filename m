From: akpm@linux-foundation.org
Subject: + ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch added
 to -mm tree
Date: Tue, 05 Dec 2017 16:17:50 -0800
Message-ID: <5a27372e.XtW5Rl5lZmqB4WY1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753044AbdLFARv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 19:17:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/cluster: neaten a member of o2net_msg_handler
has been added to the -mm tree.  Its filename is
     ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changwei Ge <ge.changwei@h3c.com>
Subject: ocfs2/cluster: neaten a member of o2net_msg_handler

It's odd that o2net_msg_handler::nh_func_data is declared as type
o2net_msg_handler_func*.  So neaten it.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F1F554DA@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
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

ocfs2-dlm-clean-dead-code-up.patch
ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch

