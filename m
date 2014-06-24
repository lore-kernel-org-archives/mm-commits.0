From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:55 -0700
Message-ID: <53a9cb5f.8kQcZpfu7V8Wm+O4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaFXTC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xuejiufei@huawei.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: revert "ocfs2: fix NULL pointer dereference when dismount and ocfs2rec simultaneously"
has been removed from the -mm tree.  Its filename was
     ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: revert "ocfs2: fix NULL pointer dereference when dismount and ocfs2rec simultaneously"

75f82eaa502c ("ocfs2: fix NULL pointer dereference when dismount and
ocfs2rec simultaneously") may cause umount hang while shutting down
truncate log.

The situation is as followes:
ocfs2_dismout_volume
-> ocfs2_recovery_exit
  -> free osb->recovery_map
-> ocfs2_truncate_shutdown
  -> lock global bitmap inode
    -> ocfs2_wait_for_recovery
	  -> check whether osb->recovery_map->rm_used is zero
	
Because osb->recovery_map is already freed, rm_used can be any other
values, so it may yield umount hang.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously
+++ a/fs/ocfs2/super.c
@@ -1925,15 +1925,11 @@ static void ocfs2_dismount_volume(struct
 
 	ocfs2_shutdown_local_alloc(osb);
 
+	ocfs2_truncate_log_shutdown(osb);
+
 	/* This will disable recovery and flush any recovery work. */
 	ocfs2_recovery_exit(osb);
 
-	/*
-	 * During dismount, when it recovers another node it will call
-	 * ocfs2_recover_orphans and queue delayed work osb_truncate_log_wq.
-	 */
-	ocfs2_truncate_log_shutdown(osb);
