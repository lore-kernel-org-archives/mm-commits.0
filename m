From: akpm@linux-foundation.org
Subject: + proc-show-mnt_id-in-proc-pid-fdinfo.patch added to -mm tree
Date: Thu, 20 Mar 2014 15:32:20 -0700
Message-ID: <532b6c74.IP+ms8rk0Qbr5sSV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165AbaCTWcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 18:32:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, viro@zeniv.linux.org.uk, rob@landley.net, oleg@redhat.com, gorcunov@openvz.org, ebiederm@xmission.com, avagin@openvz.org

Subject: + proc-show-mnt_id-in-proc-pid-fdinfo.patch added to -mm tree
To: avagin@openvz.org,ebiederm@xmission.com,gorcunov@openvz.org,oleg@redhat.com,rob@landley.net,viro@zeniv.linux.org.uk,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 15:32:20 -0700


The patch titled
     Subject: proc: show mnt_id in /proc/pid/fdinfo
has been added to the -mm tree.  Its filename is
     proc-show-mnt_id-in-proc-pid-fdinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-show-mnt_id-in-proc-pid-fdinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-show-mnt_id-in-proc-pid-fdinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: proc: show mnt_id in /proc/pid/fdinfo

Currently we don't have a way how to determing from which mount point file
has been opened.  This information is required for proper dumping and
restoring file descriptos due to presence of mount namespaces.  It's
possible, that two file descriptors are opened using the same paths, but
one fd references mount point from one namespace while the other fd --
from other namespace.

$ ls -l /proc/1/fd/1
lrwx------ 1 root root 64 Mar 19 23:54 /proc/1/fd/1 -> /dev/null

$ cat /proc/1/fdinfo/1
pos:	0
flags:	0100002
mnt_id:	16

$ cat /proc/1/mountinfo | grep ^16
16 32 0:4 / /dev rw,nosuid shared:2 - devtmpfs devtmpfs rw,size=1013356k,nr_inodes=253339,mode=755

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Rob Landley <rob@landley.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   17 ++++++++++++-----
 fs/proc/fd.c                       |    6 ++++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff -puN Documentation/filesystems/proc.txt~proc-show-mnt_id-in-proc-pid-fdinfo Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-show-mnt_id-in-proc-pid-fdinfo
+++ a/Documentation/filesystems/proc.txt
@@ -1648,18 +1648,21 @@ pids, so one need to either stop or free
 if precise results are needed.
 
 
-3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
+3.8	/proc/<pid>/fdinfo/<fd> - Information about opened file
 ---------------------------------------------------------------
 This file provides information associated with an opened file. The regular
-files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
-the current offset of the opened file in decimal form [see lseek(2) for
-details] and 'flags' denotes the octal O_xxx mask the file has been
-created with [see open(2) for details].
+files have at least three fields -- 'pos', 'flags' and mnt_id. The 'pos'
+represents the current offset of the opened file in decimal form [see lseek(2)
+for details], 'flags' denotes the octal O_xxx mask the file has been
+created with [see open(2) for details] and 'mnt_id' represents mount ID of
+the file system containing the opened file [see 3.5 /proc/<pid>/mountinfo
+for details].
 
 A typical output is
 
 	pos:	0
 	flags:	0100002
+	mnt_id:	19
 
 The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
 pair provide additional information particular to the objects they represent.
@@ -1668,6 +1671,7 @@ pair provide additional information part
 	~~~~~~~~~~~~~
 	pos:	0
 	flags:	04002
+	mnt_id:	9
 	eventfd-count:	5a
 
 	where 'eventfd-count' is hex value of a counter.
@@ -1676,6 +1680,7 @@ pair provide additional information part
 	~~~~~~~~~~~~~~
 	pos:	0
 	flags:	04002
+	mnt_id:	9
 	sigmask:	0000000000000200
 
 	where 'sigmask' is hex value of the signal mask associated
@@ -1685,6 +1690,7 @@ pair provide additional information part
 	~~~~~~~~~~~
 	pos:	0
 	flags:	02
+	mnt_id:	9
 	tfd:        5 events:       1d data: ffffffffffffffff
 
 	where 'tfd' is a target file descriptor number in decimal form,
@@ -1718,6 +1724,7 @@ pair provide additional information part
 
 	pos:	0
 	flags:	02
+	mnt_id:	9
 	fanotify flags:10 event-flags:0
 	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
diff -puN fs/proc/fd.c~proc-show-mnt_id-in-proc-pid-fdinfo fs/proc/fd.c
--- a/fs/proc/fd.c~proc-show-mnt_id-in-proc-pid-fdinfo
+++ a/fs/proc/fd.c
@@ -11,6 +11,7 @@
 
 #include <linux/proc_fs.h>
 
+#include "../mount.h"
 #include "internal.h"
 #include "fd.h"
 
@@ -48,8 +49,9 @@ static int seq_show(struct seq_file *m,
 	}
 
 	if (!ret) {
-                seq_printf(m, "pos:\t%lli\nflags:\t0%o\n",
-			   (long long)file->f_pos, f_flags);
+		seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
+			   (long long)file->f_pos, f_flags,
+			   real_mount(file->f_path.mnt)->mnt_id);
 		if (file->f_op->show_fdinfo)
 			ret = file->f_op->show_fdinfo(m, file);
 		fput(file);
_

Patches currently in -mm which might be from avagin@openvz.org are

exit-call-disassociate_ctty-before-exit_task_namespaces.patch
proc-show-mnt_id-in-proc-pid-fdinfo.patch

