From: akpm@linux-foundation.org
Subject: + ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch
 added to -mm tree
Date: Thu, 02 Jun 2016 16:32:29 -0700
Message-ID: <5750c20d.cbxHjSr9kouZT15a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbcFBXca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, rgoldwyn@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: ensure that dlm lockspace is created by kernel module
has been added to the -mm tree.  Its filename is
     ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch

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
Subject: ocfs2: ensure that dlm lockspace is created by kernel module

We encountered a bug from the customer, the user did a fsck.ocfs2 on the
file system and exited unusually, the lockspace (with LVB size = 32) was
left in the kernel space, next, the user mounted this file system, the
kernel module did not create a new lockspace (LVB size = 64) via calling
dlm_new_lockspace() function in mounting stage, just used the existing
lockspace, created by the user space tool, this would lead the user was
not able to mount this file system from the other nodes, with the error
message like:

dlm: 032F5......: config mismatch: 64,0 nodeid 177127961: 32,0
(mount.ocfs2,26981,46):ocfs2_dlm_init:2995 ERROR: status = -71
ocfs2_mount_volume:1881 ERROR: status = -71
ocfs2_fill_super:1236 ERROR: status = -71

The user found it very difficult to find the root cause, then, we brought
out this patch to relieve such problem.  

First, we add one more flag in calling dlm_new_lockspace() function, to
make sure the lockspace is created by kernel module itself, and this
change will not affect the backward compatibility.

Second, the obvious error message is reported in the kernel log, let the
user be more easy to find the root cause.



This patch will be used to insure the dlm lockspace is created by kernel
module when mounting a ocfs2 file system.  There are two ways to create a
lockspace, from user space and kernel space, but the same name lockspaces
probably have different lvblen lengths/flags.

To avoid this mix using, we add one more flag DLM_LSFL_NEWEXCL, it will
make sure the dlm lockspace is created by kernel module when mounting. 
Secondly, if a user space program (ocfs2-tools) is running on a file
system, the user tries to mount this file system in the cluster, DLM
module will return a -EEXIST or -EPROTO errno, we should give the user a
obvious error message, then, the user can let that user space tool exit
before mounting the file system again.

Link: http://lkml.kernel.org/r/1463731940-13044-2-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/stack_user.c~ocfs2-insure-dlm-lockspace-is-created-by-kernel-module fs/ocfs2/stack_user.c
--- a/fs/ocfs2/stack_user.c~ocfs2-insure-dlm-lockspace-is-created-by-kernel-module
+++ a/fs/ocfs2/stack_user.c
@@ -1007,10 +1007,17 @@ static int user_cluster_connect(struct o
 	lc->oc_type = NO_CONTROLD;
 
 	rc = dlm_new_lockspace(conn->cc_name, conn->cc_cluster_name,
-			       DLM_LSFL_FS, DLM_LVB_LEN,
+			       DLM_LSFL_FS | DLM_LSFL_NEWEXCL, DLM_LVB_LEN,
 			       &ocfs2_ls_ops, conn, &ops_rv, &fsdlm);
-	if (rc)
+	if (rc) {
+		if (rc == -EEXIST || rc == -EPROTO)
+			printk(KERN_ERR "ocfs2: Unable to create the "
+				"lockspace %s (%d), because a ocfs2-tools "
+				"program is running on this file system "
+				"with the same name lockspace\n",
+				conn->cc_name, rc);
 		goto out;
+	}
 
 	if (ops_rv == -EOPNOTSUPP) {
 		lc->oc_type = WITH_CONTROLD;
_

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-insure-dlm-lockspace-is-created-by-kernel-module.patch

