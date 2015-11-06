From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fill-in-the-unused-portion-of-the-block-with-zeros-by-dio_zero_block.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:43 -0800
Message-ID: <563d0817.1Cf5XDRdvcqcxIgW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032955AbbKFUFn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fill in the unused portion of the block with zeros by dio_zero_block()
has been removed from the -mm tree.  Its filename was
     ocfs2-fill-in-the-unused-portion-of-the-block-with-zeros-by-dio_zero_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: fill in the unused portion of the block with zeros by dio_zero_block()

A simplified test case is (this case from Ryan):
1) dd if=/dev/zero of=/mnt/hello bs=512 count=1 oflag=direct;
2) truncate /mnt/hello -s 2097152
file 'hello' is not exist before test. After this command,
file 'hello' should be all zero. But 512~4096 is some random data.

Setting bh state to new when get a new block, if so,
direct_io_worker()->dio_zero_block() will fill-in the unused portion
of the block with zero.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/aops.c~ocfs2-fill-in-the-unused-portion-of-the-block-with-zeros-by-dio_zero_block fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fill-in-the-unused-portion-of-the-block-with-zeros-by-dio_zero_block
+++ a/fs/ocfs2/aops.c
@@ -589,6 +589,7 @@ static int ocfs2_direct_IO_get_blocks(st
 			ret = -EIO;
 			goto bail;
 		}
+		set_buffer_new(bh_result);
 		up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	}
 
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-avoid-occurring-deadlock-by-changing-ocfs2_wq-from-global-to-local.patch
ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups.patch

