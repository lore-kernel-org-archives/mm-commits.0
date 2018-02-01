From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?ocfs2-using-the-ocfs2=5Fxattr=5Froot=5Fsize-macro-in-ocfs?=
 =?US-ASCII?Q?2=5Freflink=5Fxattr=5Fheader.patch?= removed from -mm tree
Date: Thu, 01 Feb 2018 11:29:16 -0800
Message-ID: <20180201192916.DMKm8fV5X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754695AbeBAT3R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: use the OCFS2_XATTR_ROOT_SIZE macro in ocfs2_reflink_xattr_header()
has been removed from the -mm tree.  Its filename was
     ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from alex.chen@huawei.com are


