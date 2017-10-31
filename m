From: akpm@linux-foundation.org
Subject: + ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch added to -mm tree
Date: Tue, 31 Oct 2017 13:58:36 -0700
Message-ID: <59f8e3fc.+GoARCI1zXZZ8MGW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48128 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdJaU6i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Oct 2017 16:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: ip_alloc_sem should be taken in ocfs2_get_block()
has been added to the -mm tree.  Its filename is
     ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block.patch

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
Subject: ocfs2: ip_alloc_sem should be taken in ocfs2_get_block()

ip_alloc_sem should be taken in ocfs2_get_block() when reading file in
DIRECT mode to prevent concurrent access to extent tree with
ocfs2_dio_end_io_write(), which may cause BUGON in
ocfs2_get_clusters_nocache()->BUG_ON(v_cluster < le32_to_cpu(rec->e_cpos))

Link: http://lkml.kernel.org/r/59E9BBEF.1060601@huawei.com
Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-the-ip_alloc_sem-should-be-taken-in-ocfs2_get_block
+++ a/fs/ocfs2/aops.c
@@ -134,6 +134,19 @@ bail:
 	return err;
 }
 
+static int ocfs2_get_block_lock(struct inode *inode, sector_t iblock,
+		    struct buffer_head *bh_result, int create)
+{
+	int ret;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+	down_read(&oi->ip_alloc_sem);
+	ret = ocfs2_get_block(inode, iblock, bh_result, create);
+	up_read(&oi->ip_alloc_sem);
+
+	return ret;
+}
+
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create)
 {
@@ -2154,12 +2167,8 @@ static int ocfs2_dio_get_block(struct in
 	 * while file size will be changed.
 	 */
 	if (pos + total_len <= i_size_read(inode)) {
-		down_read(&oi->ip_alloc_sem);
 		/* This is the fast path for re-write. */
-		ret = ocfs2_get_block(inode, iblock, bh_result, create);
-
-		up_read(&oi->ip_alloc_sem);
