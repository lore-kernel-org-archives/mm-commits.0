From: akpm@linux-foundation.org
Subject: + ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch
 added to -mm tree
Date: Mon, 22 May 2017 12:34:09 -0700
Message-ID: <59233d31.4NCUfrwSl1Ez13DW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757285AbdEVTeK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 May 2017 15:34:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2
has been added to the -mm tree.  Its filename is
     ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch

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
Subject: ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2

Compare with initial version, we only print this error tip when the user
uses pcmk stack.  since in o2cb stack, the user will not meet this error.

Link: http://lkml.kernel.org/r/1495419305-3780-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2 fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2
+++ a/fs/ocfs2/super.c
@@ -1844,7 +1844,7 @@ static int ocfs2_mount_volume(struct sup
 	status = ocfs2_dlm_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		if (status == -EBADR)
+		if (status == -EBADR && ocfs2_userspace_stack(osb))
 			mlog(ML_ERROR, "couldn't mount because cluster name on"
 			" disk does not match the running cluster name.\n");
 		goto leave;
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch

