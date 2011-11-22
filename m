From: akpm@linux-foundation.org
Subject: [folded] procfs-add-documentation-for-procfs-mount-options.patch removed from -mm tree
Date: Mon, 21 Nov 2011 16:34:41 -0800
Message-ID: <201111220034.pAM0YfT6016938@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:63866 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1KVAeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2011 19:34:46 -0500
Received: by fabs1 with SMTP id s1so87864fab.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2011 16:34:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, hpa@zytor.com, jmorris@namei.org, oleg@redhat.com, rdunlap@xenotime.net, seooon@openwall.com, tytso@MIT.EDU, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add documentation for procfs mount options
has been removed from the -mm tree.  Its filename was
     procfs-add-documentation-for-procfs-mount-options.patch

This patch was dropped because it was folded into procfs-add-hidepid=-and-gid=-mount-options.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasiliy Kulikov <segooon@gmail.com>
Subject: procfs: add documentation for procfs mount options

Signed-off-by: Vasiliy Kulikov <seooon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Theodore Tso <tytso@MIT.EDU>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   39 +++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff -puN Documentation/filesystems/proc.txt~procfs-add-documentation-for-procfs-mount-options Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-add-documentation-for-procfs-mount-options
+++ a/Documentation/filesystems/proc.txt
@@ -41,6 +41,8 @@ Table of Contents
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
 
+  4	Configuring procfs
+  4.1	Mount options
 
 ------------------------------------------------------------------------------
 Preface
@@ -1542,3 +1544,40 @@ a task to set its own or one of its thre
 is limited in size compared to the cmdline value, so writing anything longer
 then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
 comm value.
+
+
+------------------------------------------------------------------------------
+Configuring procfs
+------------------------------------------------------------------------------
+
+4.1	Mount options
+---------------------
+
+The following mount options are supported:
+
+	hidepid=	Set /proc/<pid>/ access mode.
+	gid=		Set the group authorized to learn processes information.
+
+hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
+(default).
+
+hidepid=1 means users may not access any /proc/<pid>/ directories but their
+own.  Sensitive files like cmdline, sched*, status are now protected against
+other users.  This makes it impossible to learn whether any user runs
+specific program (given the program doesn't reveal itself by its behaviour).
+As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
+poorly written programs passing sensitive information via program arguments are
+now protected against local eavesdroppers.
+
+hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be fully invisible to other
+users.  It doesn't mean that it hides a fact whether a process with a specific
+pid value exists (it can be learned by other means, e.g. by "kill -0 $PID"),
+but it hides process' uid and gid, which may be learned by stat()'ing
+/proc/<pid>/ otherwise.  It greatly complicates an intruder's task of gathering
+information about running processes, whether some daemon runs with elevated
+privileges, whether other user runs some sensitive program, whether other users
+run any program at all, etc.
+
+gid= defines a group authorized to learn processes information otherwise
+prohibited by hidepid=.  If you use some daemon like identd which needs to learn
+information about processes information, just add identd to this group.
_

Patches currently in -mm which might be from segooon@gmail.com are

procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options.patch

