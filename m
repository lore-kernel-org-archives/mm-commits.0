From: akpm@linux-foundation.org
Subject: [patch 011/126] ocfs2: fix a redundant re-initialization
Date: Tue, 26 Jul 2016 15:21:29 -0700
Message-ID: <5797e269.uSfmJchMtuJSyXER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbcGZWVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zren@suse.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de

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
