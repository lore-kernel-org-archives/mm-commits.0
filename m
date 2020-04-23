From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?docs-proc-add-documentation-for-hidepid=3D4-and-subset=3D?=
 =?US-ASCII?Q?pid-options-and-new-mount-behavior.patch?= removed from -mm
 tree
Date: Thu, 23 Apr 2020 12:52:20 -0700
Message-ID: <20200423195220.CxvG8FVNZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTwV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, bfields@fieldses.org, corbet@lwn.net, danielmicay@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, gladkov.alexey@gmail.com, gregkh@linuxfoundation.org, jlayton@poochiereds.net, keescook@chromium.org, ldv@altlinux.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tixxdz@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: docs: proc: add documentation for "hidepid=4" and "subset=pid" options and new mount behavior
has been removed from the -mm tree.  Its filename was
     docs-proc-add-documentation-for-hidepid=4-and-subset=pid-options-and-new-mount-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: docs: proc: add documentation for "hidepid=4" and "subset=pid" options and new mount behavior

Link: http://lkml.kernel.org/r/20200419141057.621356-6-gladkov.alexey@gmail.com
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Djalal Harouni <tixxdz@gmail.com>
Cc: "Dmitry V . Levin" <ldv@altlinux.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   54 +++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/Documentation/filesystems/proc.rst~docs-proc-add-documentation-for-hidepid=4-and-subset=pid-options-and-new-mount-behavior
+++ a/Documentation/filesystems/proc.rst
@@ -51,6 +51,8 @@ fixes/update part 1.1  Stefani Seibold <
   4	Configuring procfs
   4.1	Mount options
 
+  5	Filesystem behavior
+
 Preface
 =======
 
@@ -2142,6 +2144,7 @@ The following mount options are supporte
 	=========	========================================================
 	hidepid=	Set /proc/<pid>/ access mode.
 	gid=		Set the group authorized to learn processes information.
+	subset=		Show only the specified subset of procfs.
 	=========	========================================================
 
 hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
@@ -2164,6 +2167,57 @@ information about running processes, whe
 privileges, whether other user runs some sensitive program, whether other users
 run any program at all, etc.
 
+hidepid=4 means that procfs should only contain /proc/<pid>/ directories
+that the caller can ptrace.
+
 gid= defines a group authorized to learn processes information otherwise
 prohibited by hidepid=.  If you use some daemon like identd which needs to learn
 information about processes information, just add identd to this group.
+
+subset=pid hides all top level files and directories in the procfs that
+are not related to tasks.
+
+5	Filesystem behavior
+----------------------------
+
+Originally, before the advent of pid namepsace, procfs was a global file
+system. It means that there was only one procfs instance in the system.
+
+When pid namespace was added, a separate procfs instance was mounted in
+each pid namespace. So, procfs mount options are global among all
+mountpoints within the same namespace.
+
+::
+
+# grep ^proc /proc/mounts
+proc /proc proc rw,relatime,hidepid=2 0 0
+
+# strace -e mount mount -o hidepid=1 -t proc proc /tmp/proc
+mount("proc", "/tmp/proc", "proc", 0, "hidepid=1") = 0
++++ exited with 0 +++
+
+# grep ^proc /proc/mounts
+proc /proc proc rw,relatime,hidepid=2 0 0
+proc /tmp/proc proc rw,relatime,hidepid=2 0 0
+
+and only after remounting procfs mount options will change at all
+mountpoints.
+
+# mount -o remount,hidepid=1 -t proc proc /tmp/proc
+
+# grep ^proc /proc/mounts
+proc /proc proc rw,relatime,hidepid=1 0 0
+proc /tmp/proc proc rw,relatime,hidepid=1 0 0
+
+This behavior is different from the behavior of other filesystems.
+
+The new procfs behavior is more like other filesystems. Each procfs mount
+creates a new procfs instance. Mount options affect own procfs instance.
+It means that it became possible to have several procfs instances
+displaying tasks with different filtering options in one pid namespace.
+
+# mount -o hidepid=2 -t proc proc /proc
+# mount -o hidepid=1 -t proc proc /tmp/proc
+# grep ^proc /proc/mounts
+proc /proc proc rw,relatime,hidepid=2 0 0
+proc /tmp/proc proc rw,relatime,hidepid=1 0 0
_

Patches currently in -mm which might be from gladkov.alexey@gmail.com are
