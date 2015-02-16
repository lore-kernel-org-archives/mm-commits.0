From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch removed from -mm tree
Date: Mon, 16 Feb 2015 15:48:30 -0800
Message-ID: <54e281ce.k5WfSU7qvk1dUygG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbBPXtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 18:49:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, fengguang.wu@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch

This patch was dropped because it was folded into ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix

avoid dynamic stack allocation

Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Xuejiufei <xuejiufei@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix
+++ a/fs/ocfs2/namei.c
@@ -2296,8 +2296,7 @@ int ocfs2_orphan_del(struct ocfs2_super
 		     struct buffer_head *orphan_dir_bh,
 		     bool dio)
 {
-	int namelen = dio ? OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN :
-			OCFS2_ORPHAN_NAMELEN;
+	const int namelen = OCFS2_DIO_ORPHAN_PREFIX_LEN + OCFS2_ORPHAN_NAMELEN;
 	char name[namelen + 1];
 	struct ocfs2_dinode *orphan_fe;
 	int status = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
dax-add-dax_zero_page_range.patch
ext4-add-dax-functionality.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch

