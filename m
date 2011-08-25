From: akpm@linux-foundation.org
Subject: + fs-pipec-add-statfs-callback-for-pipefs.patch added to -mm tree
Date: Wed, 24 Aug 2011 22:16:13 -0700
Message-ID: <201108250513.p7P5D5qR029001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab1HYFNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 01:13:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@parallels.com, gorcunov@openvz.org, serge.hallyn@canonical.com, tj@kernel.org, viro@ZenIV.linux.org.uk


The patch titled
     fs/pipe.c: add ->statfs callback for pipefs
has been added to the -mm tree.  Its filename is
     fs-pipec-add-statfs-callback-for-pipefs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/pipe.c: add ->statfs callback for pipefs
From: Pavel Emelyanov <xemul@parallels.com>

Currently a statfs on a pipe's /proc/<pid>/fd/ link returns -ENOSYS.  Wire
pipfs up so that the statfs succeeds.

This is required by checkpoint-restart in the userspace to make it
possible to distinguish pipes from fifos.

When we dump information about task's open files we use the /proc/pid/fd
directoy's symlinks and the fact that opening any of them gives us exactly
the same dentry->inode pair as the original process has.  Now if a task
we're dumping has opened pipe and fifo we need to detect this and act
accordingly.  Knowing that an fd with type S_ISFIFO resides on a pipefs is
the most precise way.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/pipe.c~fs-pipec-add-statfs-callback-for-pipefs fs/pipe.c
--- a/fs/pipe.c~fs-pipec-add-statfs-callback-for-pipefs
+++ a/fs/pipe.c
@@ -1254,6 +1254,7 @@ out:
 
 static const struct super_operations pipefs_ops = {
 	.destroy_inode = free_inode_nonrcu,
+	.statfs = simple_statfs,
 };
 
 /*
_

Patches currently in -mm which might be from xemul@parallels.com are

fs-pipec-add-statfs-callback-for-pipefs.patch

