From: akpm@linux-foundation.org
Subject: [merged]
 reiserfs-prevent-null-pointer-dereference-in-reiserfs_insert_item.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:21:06 -0800
Message-ID: <20200131232106.i_ZR7PySN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXVH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hushiyuan@huawei.com, jack@suse.cz, linfeilong@huawei.com, mm-commits@vger.kernel.org, yeyunfeng@huawei.com, zhengbin13@huawei.com


The patch titled
     Subject: reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()
has been removed from the -mm tree.  Its filename was
     reiserfs-prevent-null-pointer-dereference-in-reiserfs_insert_item.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yunfeng Ye <yeyunfeng@huawei.com>
Subject: reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

The variable inode may be NULL in reiserfs_insert_item(), but there is
no check before accessing the member of inode.

Fix this by adding NULL pointer check before calling reiserfs_debug().

Link: http://lkml.kernel.org/r/79c5135d-ff25-1cc9-4e99-9f572b88cc00@huawei.com
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Cc: zhengbin <zhengbin13@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/stree.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/reiserfs/stree.c~reiserfs-prevent-null-pointer-dereference-in-reiserfs_insert_item
+++ a/fs/reiserfs/stree.c
@@ -2246,7 +2246,8 @@ error_out:
 	/* also releases the path */
 	unfix_nodes(&s_ins_balance);
 #ifdef REISERQUOTA_DEBUG
-	reiserfs_debug(th->t_super, REISERFS_DEBUG_CODE,
+	if (inode)
+		reiserfs_debug(th->t_super, REISERFS_DEBUG_CODE,
 		       "reiserquota insert_item(): freeing %u id=%u type=%c",
 		       quota_bytes, inode->i_uid, head2type(ih));
 #endif
_

Patches currently in -mm which might be from yeyunfeng@huawei.com are
