From: akpm@linux-foundation.org
Subject: + ocfs2-load-global_inode_alloc.patch added to -mm tree
Date: Wed, 17 Jun 2020 14:02:12 -0700
Message-ID: <20200617210212.Ko2YX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQVCN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 17:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn, junxiao.bi@oracle.com


The patch titled
     Subject: ocfs2: load global_inode_alloc
has been added to the -mm tree.  Its filename is
     ocfs2-load-global_inode_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-load-global_inode_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-load-global_inode_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: load global_inode_alloc

Set global_inode_alloc as OCFS2_FIRST_ONLINE_SYSTEM_INODE, that will make
it load during mount.  It can be used to test whether some global/system
inodes are valid.  One use case is that nfsd will test whether root inode
is valid.

Link: http://lkml.kernel.org/r/20200616183829.87211-3-junxiao.bi@oracle.com
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-load-global_inode_alloc
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -326,8 +326,8 @@ struct ocfs2_system_inode_info {
 enum {
 	BAD_BLOCK_SYSTEM_INODE = 0,
 	GLOBAL_INODE_ALLOC_SYSTEM_INODE,
+#define OCFS2_FIRST_ONLINE_SYSTEM_INODE GLOBAL_INODE_ALLOC_SYSTEM_INODE
 	SLOT_MAP_SYSTEM_INODE,
-#define OCFS2_FIRST_ONLINE_SYSTEM_INODE SLOT_MAP_SYSTEM_INODE
 	HEARTBEAT_SYSTEM_INODE,
 	GLOBAL_BITMAP_SYSTEM_INODE,
 	USER_QUOTA_SYSTEM_INODE,
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-avoid-inode-removed-while-nfsd-access-it.patch
ocfs2-load-global_inode_alloc.patch
ocfs2-fix-panic-on-nfs-server-over-ocfs2.patch
ocfs2-fix-value-of-ocfs2_invalid_slot.patch
