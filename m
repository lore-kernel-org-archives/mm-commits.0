From: akpm@linux-foundation.org
Subject: [merged] procfs-fix-tid-fdinfo.patch removed from -mm tree
Date: Wed, 28 Apr 2010 11:03:02 -0400
Message-ID: <201004281804.o3SI4aYp010971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756109Ab0D1SEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 14:04:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, adobriyan@gmail.com, mszeredi@suse.cz, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     procfs: fix tid fdinfo
has been removed from the -mm tree.  Its filename was
     procfs-fix-tid-fdinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: fix tid fdinfo
From: Jerome Marchand <jmarchan@redhat.com>

Correct the file_operations struct in fdinfo entry of tid_base_stuff[].

Presently /proc/*/task/*/fdinfo contains symlinks to opened files like
/proc/*/fd/.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~procfs-fix-tid-fdinfo fs/proc/base.c
--- a/fs/proc/base.c~procfs-fix-tid-fdinfo
+++ a/fs/proc/base.c
@@ -2909,7 +2909,7 @@ out_no_task:
  */
 static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
+	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
_

Patches currently in -mm which might be from jmarchan@redhat.com are

origin.patch

