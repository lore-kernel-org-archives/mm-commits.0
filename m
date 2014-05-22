From: akpm@linux-foundation.org
Subject: +
 ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch added to -mm tree
Date: Thu, 22 May 2014 10:56:03 -0700
Message-ID: <537e3a33.U1erEOVe4w0ZFD4H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaEVR4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 May 2014 13:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 22 May 2014 10:56:03 -0700


The patch titled
     Subject: ocfs2: revert "ocfs2: fix NULL pointer dereference when dismount and ocfs2rec simultaneously"
has been added to the -mm tree.  Its filename is
     ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-revert-the-patch-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mark Fasheh <mfasheh@suse.com>
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
