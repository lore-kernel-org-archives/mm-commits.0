From: akpm@linux-foundation.org
Subject: [merged] fs-pipec-add-statfs-callback-for-pipefs.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:42 -0700
Message-ID: <201111012112.pA1LCgJC005936@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1KAVMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, gorcunov@openvz.org, serge.hallyn@canonical.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pipe.c: add ->statfs callback for pipefs
has been removed from the -mm tree.  Its filename was
     fs-pipec-add-statfs-callback-for-pipefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: fs/pipe.c: add ->statfs callback for pipefs

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

origin.patch

