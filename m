From: akpm@linux-foundation.org
Subject: + proc-pid-fdinfo-add-cloexec-information.patch added to -mm tree
Date: Mon, 20 Jun 2011 14:31:43 -0700
Message-ID: <201106202131.p5KLVh6F021960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755386Ab1FTVbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jun 2011 17:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@gmail.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, rientjes@google.com, viro@zeniv.linux.org.uk, wilsons@start.ca


The patch titled
     /proc/pid/fdinfo: add cloexec information
has been added to the -mm tree.  Its filename is
     proc-pid-fdinfo-add-cloexec-information.patch

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
Subject: /proc/pid/fdinfo: add cloexec information
From: Ulrich Drepper <drepper@gmail.com>

There is one piece of information about a file descriptor which is
currently not visible from the outside: the close-on-exec flag.  The
/proc/PID/fdinfo/* files have the mode information but this is missing. 

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-pid-fdinfo-add-cloexec-information fs/proc/base.c
--- a/fs/proc/base.c~proc-pid-fdinfo-add-cloexec-information
+++ a/fs/proc/base.c
@@ -1924,12 +1924,23 @@ static int proc_fd_info(struct inode *in
 				*path = file->f_path;
 				path_get(&file->f_path);
 			}
-			if (info)
+			if (info) {
+				int cloexec;
+				struct fdtable *fdt;
+
+				rcu_read_lock();
+				fdt = files_fdtable(files);
+				cloexec = FD_ISSET(fd, fdt->close_on_exec);
+				rcu_read_unlock();
+
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
+					 "flags:\t0%o\n"
+					 "cloexec: %d\n",
 					 (long long) file->f_pos,
-					 file->f_flags);
+					 file->f_flags,
+					 cloexec);
+			}
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
_

Patches currently in -mm which might be from drepper@gmail.com are

h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch

