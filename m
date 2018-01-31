From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-add-ocfs2_overwrite_io-function-v3.patch
 removed from -mm tree
Date: Wed, 31 Jan 2018 15:47:34 -0800
Message-ID: <5a725596.aa1ZKXRqf6QVfUDg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbeAaXrg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-add-ocfs2_overwrite_io-function-v3
has been removed from the -mm tree.  Its filename was
     ocfs2-add-ocfs2_overwrite_io-function-v3.patch

This patch was dropped because it was folded into ocfs2-add-ocfs2_overwrite_io-function.patch

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2-add-ocfs2_overwrite_io-function-v3

Link: http://lkml.kernel.org/r/1514455665-16325-3-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function-v3 fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-add-ocfs2_overwrite_io-function-v3
+++ a/fs/ocfs2/extent_map.c
@@ -38,6 +38,7 @@
 #include "inode.h"
 #include "super.h"
 #include "symlink.h"
+#include "aops.h"
 #include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
@@ -841,9 +842,12 @@ int ocfs2_overwrite_io(struct inode *ino
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_extent_rec rec;
 
-	if ((OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
-	   ((map_start + map_len) <= i_size_read(inode)))
-		goto out;
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
+		if (ocfs2_size_fits_inline_data(di_bh, map_start + map_len))
+			return ret;
+		else
+			return -EAGAIN;
+	}
 
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-try-a-blocking-lock-before-return-aop_truncated_page.patch
ocfs2-add-trimfs-dlm-lock-resource.patch
ocfs2-add-trimfs-lock-to-avoid-duplicated-trims-in-cluster.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-nowait-aio-support.patch
ocfs2-nowait-aio-support-v4.patch

