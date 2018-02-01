From: akpm@linux-foundation.org
Subject: [patch 014/119] ocfs2/xattr: assign errno to 'ret' in
 ocfs2_calc_xattr_init()
Date: Wed, 31 Jan 2018 16:14:51 -0800
Message-ID: <20180201001451.Q49v8epWa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:14:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: piaojun <piaojun@huawei.com>
Subject: ocfs2/xattr: assign errno to 'ret' in ocfs2_calc_xattr_init()

We need catch the errno returned by ocfs2_xattr_get_nolock() and assign
it to 'ret' for printing and noticing upper callers.

Link: http://lkml.kernel.org/r/5A571CAF.8050709@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Acked-by: Gang He <ghe@suse.com>
Acked-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/xattr.c~ocfs2-xattr-assign-errno-to-ret-in-ocfs2_calc_xattr_init fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-xattr-assign-errno-to-ret-in-ocfs2_calc_xattr_init
+++ a/fs/ocfs2/xattr.c
@@ -646,6 +646,7 @@ int ocfs2_calc_xattr_init(struct inode *
 			if (S_ISDIR(mode))
 				a_size <<= 1;
 		} else if (acl_len != 0 && acl_len != -ENODATA) {
+			ret = acl_len;
 			mlog_errno(ret);
 			return ret;
 		}
_
