From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-implement-ocfs2_direct_io_write-fix.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 15:48:53 -0800
Message-ID: <54e281e5.TqArU/6bjI/JI4lz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbbBPXta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:49:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-implement-ocfs2_direct_io_write-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-implement-ocfs2_direct_io_write-fix.patch

This patch was dropped because it was folded into ocfs2-implement-ocfs2_direct_io_write.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-implement-ocfs2_direct_io_write-fix

fix it for "block: Add discard flag to blkdev_issue_zeroout() function"

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-implement-ocfs2_direct_io_write-fix fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-implement-ocfs2_direct_io_write-fix
+++ a/fs/ocfs2/aops.c
@@ -748,8 +748,7 @@ static ssize_t ocfs2_direct_IO_write(str
 
 		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
 				p_cpos << (osb->s_clustersize_bits - 9),
-				zero_len >> 9,
-				GFP_KERNEL);
+				zero_len >> 9, GFP_KERNEL, false);
 		if (ret < 0)
 			mlog_errno(ret);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
dax-add-dax_zero_page_range.patch
ext4-add-dax-functionality.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-implement-ocfs2_direct_io_write.patch

