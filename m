From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-a-redundant-re-initialization.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 11:58:52 -0700
Message-ID: <5799046c.WAP5lVmGx6l9AUZ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbcG0S6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:58:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zren@suse.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a redundant re-initialization
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-redundant-re-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Ren <zren@suse.com>
Subject: ocfs2: fix a redundant re-initialization

Obviously, memset() has zeroed the whole struct locking_max_version.
So, it's no need to zero its two fields individually.

Link: http://lkml.kernel.org/r/1463970605-18354-1-git-send-email-zren@suse.com
Signed-off-by: Eric Ren <zren@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stackglue.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/stackglue.c~ocfs2-fix-a-redundant-re-initialization fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~ocfs2-fix-a-redundant-re-initialization
+++ a/fs/ocfs2/stackglue.c
@@ -735,8 +735,6 @@ static void __exit ocfs2_stack_glue_exit
 {
 	memset(&locking_max_version, 0,
 	       sizeof(struct ocfs2_protocol_version));
-	locking_max_version.pv_major = 0;
-	locking_max_version.pv_minor = 0;
 	ocfs2_sysfs_exit();
 	if (ocfs2_table_header)
 		unregister_sysctl_table(ocfs2_table_header);
_

Patches currently in -mm which might be from zren@suse.com are

ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log.patch
ocfs2-retry-on-enospc-if-sufficient-space-in-truncate-log-v3.patch

