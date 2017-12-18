From: akpm@linux-foundation.org
Subject: +
 ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch added to -mm tree
Date: Mon, 18 Dec 2017 13:54:53 -0800
Message-ID: <5a38392d.da0GwErgbQ0JHsGY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935229AbdLRVyy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Dec 2017 16:54:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fall back to buffer IO when append dio is disabled with file hole existing
has been added to the -mm tree.  Its filename is
     ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch

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
Subject: ocfs2: fall back to buffer IO when append dio is disabled with file hole existing

Before ocfs2 supporting allocating clusters while doing append-dio, all
append dio will fall back to buffer io to allocate clusters firstly. 
Also, when it steps on a file hole, it will fall back to buffer io, too. 
But for current code, writing to file hole will leverage dio to allocate
clusters.  This is not right, since whether append-io is enabled tells the
capability whether ocfs2 can allocate space while doing dio.

So introduce file hole check function back into ocfs2.  Once ocfs2 is
doing dio upon a file hole with append-dio disabled, it will fall back to
buffer IO to allocate clusters.

Link: http://lkml.kernel.org/r/63ADC13FD55D6546B7DECE290D39E373F1F5C2CE@H3CMLB14-EX.srv.huawei-3com.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing
+++ a/fs/ocfs2/aops.c
@@ -2465,6 +2465,44 @@ static int ocfs2_dio_end_io(struct kiocb
 	return ret;
 }
 
+/*
+ * Will look for holes and unwritten extents in the range starting at
+ * pos for count bytes (inclusive).
+ */
+static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
+				       size_t count)
+{
+	int ret = 0;
+	unsigned int extent_flags;
+	u32 cpos, clusters, extent_len, phys_cpos;
+	struct super_block *sb = inode->i_sb;
+
+	cpos = pos >> OCFS2_SB(sb)->s_clustersize_bits;
+	clusters = ocfs2_clusters_for_bytes(sb, pos + count) - cpos;
+
+	while (clusters) {
+		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &extent_len,
+					 &extent_flags);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
+			ret = 1;
+			break;
+		}
+
+		if (extent_len > clusters)
+			extent_len = clusters;
+
+		clusters -= extent_len;
+		cpos += extent_len;
+	}
+out:
+	return ret;
+}
+
 static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
@@ -2480,8 +2518,10 @@ static ssize_t ocfs2_direct_IO(struct ki
 		return 0;
 
 	/* Fallback to buffered I/O if we do not support append dio. */
-	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
-	    !ocfs2_supports_append_dio(osb))
+	if (!ocfs2_supports_append_dio(osb) &&
+			(iocb->ki_pos + iter->count > i_size_read(inode) ||
+			 ocfs2_check_range_for_holes(inode, iocb->ki_pos,
+						     iter->count)))
 		return 0;
 
 	if (iov_iter_rw(iter) == READ)
_

Patches currently in -mm which might be from ge.changwei@h3c.com are

ocfs2-dlm-clean-dead-code-up.patch
ocfs2-cluster-neaten-a-member-of-o2net_msg_handler.patch
ocfs2-clean-dead-code-in-suballocc.patch
ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch

