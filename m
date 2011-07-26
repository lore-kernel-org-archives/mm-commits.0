From: akpm@linux-foundation.org
Subject: [to-be-updated] proc-pid-fdinfo-add-cloexec-information.patch removed from -mm tree
Date: Tue, 26 Jul 2011 14:20:19 -0700
Message-ID: <201107262120.p6QLKJPk009696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112Ab1GZVU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 17:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drepper@gmail.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, rientjes@google.com, viro@zeniv.linux.org.uk, wilsons@start.ca, mm-commits@vger.kernel.org


The patch titled
     /proc/pid/fdinfo: add cloexec information
has been removed from the -mm tree.  Its filename was
     proc-pid-fdinfo-add-cloexec-information.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/pid/fdinfo: add cloexec information
From: Ulrich Drepper <drepper@gmail.com>

There is one piece of information about a file descriptor which is
currently not visible from the outside: the close-on-exec flag.  The
/proc/PID/fdinfo/* files have the mode information but this is missing. 

This is needed so that Linux can re-implement the Solaris pfiles program.

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
@@ -1923,12 +1923,23 @@ static int proc_fd_info(struct inode *in
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
proc-pid-fdinfo-add-cloexec-information-fix.patch

