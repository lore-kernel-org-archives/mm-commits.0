From: akpm@linux-foundation.org
Subject: + ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch
 added to -mm tree
Date: Wed, 21 May 2014 15:29:49 -0700
Message-ID: <537d28dd.15dfnGEIDEnDaUio%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaEUW3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 May 2014 18:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Wed, 21 May 2014 15:29:49 -0700


The patch titled
     Subject: ocfs2: fix umount hang while shutting down truncate log
has been added to the -mm tree.  Its filename is
     ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch

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
Subject: ocfs2: fix umount hang while shutting down truncate log

Revert XXXX because it may cause umount hang while shutting down truncate
log.

fix NULL pointer dereference when dismount and ocfs2rec simultaneously

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

To prevent NULL pointer dereference while getting sys_root_inode, we
use a osb_tl_disable flag to disable schedule osb_truncate_log_wq after
truncate log shutdown.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    6 +++++-
 fs/ocfs2/ocfs2.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-fix-umount-hang-while-shutting-down-truncate-log fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-fix-umount-hang-while-shutting-down-truncate-log
+++ a/fs/ocfs2/alloc.c
@@ -6046,7 +6046,8 @@ static void ocfs2_truncate_log_worker(st
 void ocfs2_schedule_truncate_log_flush(struct ocfs2_super *osb,
 				       int cancel)
 {
-	if (osb->osb_tl_inode) {
+	if (osb->osb_tl_inode &&
+			atomic_read(&osb->osb_tl_disable) == 0) {
 		/* We want to push off log flushes while truncates are
 		 * still running. */
 		if (cancel)
@@ -6223,6 +6224,8 @@ void ocfs2_truncate_log_shutdown(struct
 	int status;
 	struct inode *tl_inode = osb->osb_tl_inode;
 
+	atomic_set(&osb->osb_tl_disable, 1);
+
 	if (tl_inode) {
 		cancel_delayed_work(&osb->osb_truncate_log_wq);
 		flush_workqueue(ocfs2_wq);
@@ -6254,6 +6257,7 @@ int ocfs2_truncate_log_init(struct ocfs2
 	 * until we're sure all is well. */
 	INIT_DELAYED_WORK(&osb->osb_truncate_log_wq,
 			  ocfs2_truncate_log_worker);
+	atomic_set(&osb->osb_tl_disable, 0);
 	osb->osb_tl_bh    = tl_bh;
 	osb->osb_tl_inode = tl_inode;
 
diff -puN fs/ocfs2/ocfs2.h~ocfs2-fix-umount-hang-while-shutting-down-truncate-log fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-fix-umount-hang-while-shutting-down-truncate-log
+++ a/fs/ocfs2/ocfs2.h
@@ -422,6 +422,7 @@ struct ocfs2_super
 	struct inode			*osb_tl_inode;
 	struct buffer_head		*osb_tl_bh;
 	struct delayed_work		osb_truncate_log_wq;
+	atomic_t			osb_tl_disable;
 	/*
 	 * How many clusters in our truncate log.
 	 * It must be protected by osb_tl_inode->i_mutex.
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-dlm-fix-possible-convertion-deadlock.patch
ocfs2-fix-umount-hang-while-shutting-down-truncate-log.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch

