From: akpm@linux-foundation.org
Subject: +
 ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header.patch added to -mm tree
Date: Tue, 12 Dec 2017 15:34:04 -0800
Message-ID: <5a30676c.JhwdMeHGZfsZKKHB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdLLXeF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 18:34:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use the OCFS2_XATTR_ROOT_SIZE macro in ocfs2_reflink_xattr_header()
has been added to the -mm tree.  Its filename is
     ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-check-the-metadate-alloc-before-marking-extent-written.patch
ocfs2-using-the-ocfs2_xattr_root_size-macro-in-ocfs2_reflink_xattr_header.patch

