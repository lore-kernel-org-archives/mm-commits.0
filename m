From: akpm@linux-foundation.org
Subject: [merged] ocfs2-return-non-zero-st_blocks-for-inline-data.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:29 -0800
Message-ID: <56997341.Zw4Y9wyNaZEIi8ce%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbcAOWba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.haxby@oracle.com, ghe@suse.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: return non-zero st_blocks for inline data
has been removed from the -mm tree.  Its filename was
     ocfs2-return-non-zero-st_blocks-for-inline-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Haxby <john.haxby@oracle.com>
Subject: ocfs2: return non-zero st_blocks for inline data

Some versions of tar assume that files with st_blocks == 0 do not contain
any data and will skip reading them entirely.  See also commit
9206c561554c ("ext4: return non-zero st_blocks for inline data").

Signed-off-by: John Haxby <john.haxby@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Acked-by: Gang He <ghe@suse.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-return-non-zero-st_blocks-for-inline-data fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-return-non-zero-st_blocks-for-inline-data
+++ a/fs/ocfs2/file.c
@@ -1302,6 +1302,14 @@ int ocfs2_getattr(struct vfsmount *mnt,
 	}
 
 	generic_fillattr(inode, stat);
+	/*
+	 * If there is inline data in the inode, the inode will normally not
+	 * have data blocks allocated (it may have an external xattr block).
+	 * Report at least one sector for such files, so tools like tar, rsync,
+	 * others don't incorrectly think the file is completely sparse.
+	 */
+	if (unlikely(OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL))
+		stat->blocks += (stat->size + 511)>>9;
 
 	/* We set the blksize from the cluster size for performance */
 	stat->blksize = osb->s_clustersize;
_

Patches currently in -mm which might be from john.haxby@oracle.com are


