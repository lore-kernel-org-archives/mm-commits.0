From: akpm@linux-foundation.org
Subject: - quota-le_add_cpu-conversion.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:25 -0700
Message-ID: <200805010932.m419WPqX030984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757071AbYEAJca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: le*_add_cpu conversion
has been removed from the -mm tree.  Its filename was
     quota-le_add_cpu-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: le*_add_cpu conversion
From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota_v2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/quota_v2.c~quota-le_add_cpu-conversion fs/quota_v2.c
--- a/fs/quota_v2.c~quota-le_add_cpu-conversion
+++ a/fs/quota_v2.c
@@ -306,7 +306,7 @@ static uint find_free_dqentry(struct dqu
 			printk(KERN_ERR "VFS: find_free_dqentry(): Can't remove block (%u) from entry free list.\n", blk);
 			goto out_buf;
 		}
-	dh->dqdh_entries = cpu_to_le16(le16_to_cpu(dh->dqdh_entries)+1);
+	le16_add_cpu(&dh->dqdh_entries, 1);
 	memset(&fakedquot, 0, sizeof(struct v2_disk_dqblk));
 	/* Find free structure in block */
 	for (i = 0; i < V2_DQSTRINBLK && memcmp(&fakedquot, ddquot+i, sizeof(struct v2_disk_dqblk)); i++);
@@ -448,7 +448,7 @@ static int free_dqentry(struct dquot *dq
 		goto out_buf;
 	}
 	dh = (struct v2_disk_dqdbheader *)buf;
-	dh->dqdh_entries = cpu_to_le16(le16_to_cpu(dh->dqdh_entries)-1);
+	le16_add_cpu(&dh->dqdh_entries, -1);
 	if (!le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
 		if ((ret = remove_free_dqentry(sb, type, buf, blk)) < 0 ||
 		    (ret = put_free_dqblk(sb, type, buf, blk)) < 0) {
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
ntfs-le_add_cpu-conversion.patch

