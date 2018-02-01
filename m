From: akpm@linux-foundation.org
Subject: [patch 010/119] ocfs2: use the OCFS2_XATTR_ROOT_SIZE macro
 in ocfs2_reflink_xattr_header()
Date: Wed, 31 Jan 2018 16:14:36 -0800
Message-ID: <20180201001436.nkk-vanma%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAOi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:14:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: use the OCFS2_XATTR_ROOT_SIZE macro in ocfs2_reflink_xattr_header()

Use the OCFS2_XATTR_ROOT_SIZE macro improves the readability of the code.

Link: http://lkml.kernel.org/r/5A2E2488.70301@huawei.com
Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header
+++ a/fs/ocfs2/xattr.c
@@ -6415,7 +6415,7 @@ static int ocfs2_reflink_xattr_header(ha
 		 * and then insert the extents one by one.
 		 */
 		if (xv->xr_list.l_tree_depth) {
-			memcpy(new_xv, &def_xv, sizeof(def_xv));
+			memcpy(new_xv, &def_xv, OCFS2_XATTR_ROOT_SIZE);
 			vb->vb_xv = new_xv;
 			vb->vb_bh = value_bh;
 			ocfs2_init_xattr_value_extent_tree(&data_et,
_
