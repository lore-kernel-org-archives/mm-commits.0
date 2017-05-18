From: akpm@linux-foundation.org
Subject: + ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
 added to -mm tree
Date: Thu, 18 May 2017 13:25:37 -0700
Message-ID: <591e0341.xcgXst9zDEMS8ooW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdERUZi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 16:25:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: give an obvious tip for mismatched cluster names
has been added to the -mm tree.  Its filename is
     ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch

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

Link: http://lkml.kernel.org/r/1495089336-19312-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
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
+		if (status == -EBADR)
+			mlog(ML_ERROR, "couldn't mount because cluster name on"
+			" disk does not match the running cluster name.\n");
 		goto leave;
 	}
 
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch

