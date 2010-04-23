From: akpm@linux-foundation.org
Subject: + procfs-fix-tid-fdinfo.patch added to -mm tree
Date: Fri, 23 Apr 2010 11:17:00 -0700
Message-ID: <201004231817.o3NIH0wv004190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194Ab0DWSRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Apr 2010 14:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmarchan@redhat.com, adobriyan@gmail.com, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     procfs: fix tid fdinfo
has been added to the -mm tree.  Its filename is
     procfs-fix-tid-fdinfo.patch

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
Subject: procfs: fix tid fdinfo
From: Jerome Marchand <jmarchan@redhat.com>

Correct the file_operations struct in fdinfo entry of tid_base_stuff[].

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
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

procfs-fix-tid-fdinfo.patch

