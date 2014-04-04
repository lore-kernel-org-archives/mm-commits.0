From: akpm@linux-foundation.org
Subject: [merged] ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:26 -0700
Message-ID: <533f0852.6bYb9iEWx4l4nv4Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaDDTa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, alex.chen@huawei.com

Subject: [merged] ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch removed from -mm tree
To: alex.chen@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,srinivas.eeda@oracle.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:26 -0700


The patch titled
     Subject: ocfs2: do not put bh when buffer_uptodate failed
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-put-bh-when-buffer_uptodate-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: do not put bh when buffer_uptodate failed

Do not put bh when buffer_uptodate failed in ocfs2_write_block and
ocfs2_write_super_or_backup, because it will put bh in b_end_io. 
Otherwise it will hit a warning "VFS: brelse: Trying to free free buffer".

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/buffer_head_io.c~ocfs2-do-not-put-bh-when-buffer_uptodate-failed fs/ocfs2/buffer_head_io.c
--- a/fs/ocfs2/buffer_head_io.c~ocfs2-do-not-put-bh-when-buffer_uptodate-failed
+++ a/fs/ocfs2/buffer_head_io.c
@@ -90,7 +90,6 @@ int ocfs2_write_block(struct ocfs2_super
 		 * information for this bh as it's not marked locally
 		 * uptodate. */
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 
@@ -420,7 +419,6 @@ int ocfs2_write_super_or_backup(struct o
 
 	if (!buffer_uptodate(bh)) {
 		ret = -EIO;
-		put_bh(bh);
 		mlog_errno(ret);
 	}
 
_

Patches currently in -mm which might be from alex.chen@huawei.com are

origin.patch

