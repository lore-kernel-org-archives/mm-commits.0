From: akpm@linux-foundation.org
Subject: [merged] ocfs2-create-remove-sysfile-for-online-file-check.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:40:19 -0700
Message-ID: <56f2d503.mYdBBMAVfhb2B/IS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbcCWRkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: create/remove sysfile for online file check
has been removed from the -mm tree.  Its filename was
     ocfs2-create-remove-sysfile-for-online-file-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: create/remove sysfile for online file check

Create online file check sysfile when ocfs2 mount, remove the related
sysfile when ocfs2 umount.

Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/super.c~ocfs2-create-remove-sysfile-for-online-file-check fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-create-remove-sysfile-for-online-file-check
+++ a/fs/ocfs2/super.c
@@ -74,6 +74,7 @@
 #include "suballoc.h"
 
 #include "buffer_head_io.h"
+#include "filecheck.h"
 
 static struct kmem_cache *ocfs2_inode_cachep;
 struct kmem_cache *ocfs2_dquot_cachep;
@@ -1205,6 +1206,9 @@ static int ocfs2_fill_super(struct super
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
+	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
+	ocfs2_filecheck_create_sysfs(sb);
+
 	return status;
 
 read_super_error:
@@ -1668,6 +1672,7 @@ static void ocfs2_put_super(struct super
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
+	ocfs2_filecheck_remove_sysfs(sb);
 }
 
 static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
_

Patches currently in -mm which might be from ghe@suse.com are


