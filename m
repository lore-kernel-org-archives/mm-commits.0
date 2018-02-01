From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:29:10 -0800
Message-ID: <20180201192910.dgho-Ghnk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754710AbeBAT3L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:29:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: give an obvious tip for mismatched cluster names
has been removed from the -mm tree.  Its filename was
     ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: give an obvious tip for mismatched cluster names

Add an obvious error message, due to mismatched cluster names between
on-disk and in the current cluster.  We can meet this case during OCFS2
cluster migration.

If we can give the user an obvious tip for why they can not mount the file
system after migration, they can quickly fix this mismatch problem. 

Second, also move printing ocfs2_fill_super() errno to the front of
ocfs2_dismount_volume(), since ocfs2_dismount_volume() will also print
its own message.

I looked through all the code of OCFS2 (include o2cb); there is not any
place which returns this error.  In fact, the function calling path
ocfs2_fill_super -> ocfs2_mount_volume -> ocfs2_dlm_init ->
dlm_new_lockspace is a very specific one.  We can use this errno to give
the user a more clear tip, since this case is a little common during
cluster migration, but the customer can quickly get the failure cause if
there is a error printed.  Also, I think it is not possible to add this
errno in the o2cb path during ocfs2_dlm_init(), since the o2cb code has
been stable for a long time.  

We only print this error tip when the user uses pcmk stack, since using
the o2cb stack the user will not meet this error.

[ghe@suse.com: v2]
  Link: http://lkml.kernel.org/r/1495419305-3780-1-git-send-email-ghe@suse.com
Link: http://lkml.kernel.org/r/1495089336-19312-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@versity.com>
Acked-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names
+++ a/fs/ocfs2/super.c
@@ -1208,14 +1208,15 @@ static int ocfs2_fill_super(struct super
 read_super_error:
 	brelse(bh);
 
+	if (status)
+		mlog_errno(status);
+
 	if (osb) {
 		atomic_set(&osb->vol_state, VOLUME_DISABLED);
 		wake_up(&osb->osb_mount_event);
 		ocfs2_dismount_volume(sb, 1);
 	}
 
-	if (status)
-		mlog_errno(status);
 	return status;
 }
 
@@ -1843,6 +1844,9 @@ static int ocfs2_mount_volume(struct sup
 	status = ocfs2_dlm_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
+		if (status == -EBADR && ocfs2_userspace_stack(osb))
+			mlog(ML_ERROR, "couldn't mount because cluster name on"
+			" disk does not match the running cluster name.\n");
 		goto leave;
 	}
 
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch

