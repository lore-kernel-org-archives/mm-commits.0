From: akpm@linux-foundation.org
Subject: + ocfs2-create-remove-sysfile-for-online-file-check.patch added
 to -mm tree
Date: Tue, 29 Dec 2015 13:41:31 -0800
Message-ID: <5682fe0b.PyIc55kq2LXtPlri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbbL2Vlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:41:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: create/remove sysfile for online file check
has been added to the -mm tree.  Its filename is
     ocfs2-create-remove-sysfile-for-online-file-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-create-remove-sysfile-for-online-file-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-create-remove-sysfile-for-online-file-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: create/remove sysfile for online file check

Create online file check sysfile when ocfs2 mount, remove the related
sysfile when ocfs2 umount.

Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
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
@@ -1198,6 +1199,9 @@ static int ocfs2_fill_super(struct super
 	/* Start this when the mount is almost sure of being successful */
 	ocfs2_orphan_scan_start(osb);
 
+	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
+	ocfs2_filecheck_create_sysfs(sb);
+
 	return status;
 
 read_super_error:
@@ -1648,6 +1652,7 @@ static void ocfs2_put_super(struct super
 
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
+	ocfs2_filecheck_remove_sysfs(sb);
 }
 
 static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-export-ocfs2_kset-for-online-file-check.patch
ocfs2-sysfile-interfaces-for-online-file-check.patch
ocfs2-create-remove-sysfile-for-online-file-check.patch
ocfs2-check-fix-inode-block-for-online-file-check.patch

