From: akpm@linux-foundation.org
Subject: + proc-use-named-enums-for-better-readability.patch added
 to -mm tree
Date: Mon, 20 Apr 2020 15:24:21 -0700
Message-ID: <20200420222421.k5orUW1gK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTWYX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, bfields@fieldses.org, corbet@lwn.net, danielmicay@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, gladkov.alexey@gmail.com, gregkh@linuxfoundation.org, jlayton@poochiereds.net, keescook@chromium.org, ldv@altlinux.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tixxdz@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: use named enums for better readability
has been added to the -mm tree.  Its filename is
     proc-use-named-enums-for-better-readability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-use-named-enums-for-better-readability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-use-named-enums-for-better-readability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: proc: use named enums for better readability

Link: http://lkml.kernel.org/r/20200419141057.621356-8-gladkov.alexey@gmail.com
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

 fs/proc/base.c          |    2 +-
 fs/proc/inode.c         |    2 +-
 fs/proc/root.c          |    4 ++--
 include/linux/proc_fs.h |    8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/proc/base.c~proc-use-named-enums-for-better-readability
+++ a/fs/proc/base.c
@@ -699,7 +699,7 @@ int proc_setattr(struct dentry *dentry,
  */
 static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
-				 int hide_pid_min)
+				 enum proc_hidepid hide_pid_min)
 {
 	/*
 	 * If 'hidpid' mount option is set force a ptrace check,
--- a/fs/proc/inode.c~proc-use-named-enums-for-better-readability
+++ a/fs/proc/inode.c
@@ -166,7 +166,7 @@ void proc_invalidate_siblings_dcache(str
 		deactivate_super(old_sb);
 }
 
-static inline const char *hidepid2str(int v)
+static inline const char *hidepid2str(enum proc_hidepid v)
 {
 	switch (v) {
 		case HIDEPID_OFF: return "off";
--- a/fs/proc/root.c~proc-use-named-enums-for-better-readability
+++ a/fs/proc/root.c
@@ -32,9 +32,9 @@
 struct proc_fs_context {
 	struct pid_namespace	*pid_ns;
 	unsigned int		mask;
-	int			hidepid;
+	enum proc_hidepid	hidepid;
 	int			gid;
-	int			pidonly;
+	enum proc_pidonly	pidonly;
 };
 
 enum proc_param {
--- a/include/linux/proc_fs.h~proc-use-named-enums-for-better-readability
+++ a/include/linux/proc_fs.h
@@ -43,7 +43,7 @@ struct proc_ops {
 } __randomize_layout;
 
 /* definitions for hide_pid field */
-enum {
+enum proc_hidepid {
 	HIDEPID_OFF	  = 0,
 	HIDEPID_NO_ACCESS = 1,
 	HIDEPID_INVISIBLE = 2,
@@ -51,7 +51,7 @@ enum {
 };
 
 /* definitions for proc mount option pidonly */
-enum {
+enum proc_pidonly {
 	PROC_PIDONLY_OFF = 0,
 	PROC_PIDONLY_ON  = 1,
 };
@@ -61,8 +61,8 @@ struct proc_fs_info {
 	struct dentry *proc_self;        /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self */
 	kgid_t pid_gid;
-	int hide_pid;
-	int pidonly;
+	enum proc_hidepid hide_pid;
+	enum proc_pidonly pidonly;
 };
 
 static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
_

Patches currently in -mm which might be from gladkov.alexey@gmail.com are

proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch
proc-allow-to-mount-many-instances-of-proc-in-one-pid-namespace.patch
proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=4-mount-option.patch
proc-add-option-to-mount-only-a-pids-subset.patch
docs-proc-add-documentation-for-hidepid=4-and-subset=pid-options-and-new-mount-behavior.patch
proc-use-human-readable-values-for-hidepid.patch
proc-use-named-enums-for-better-readability.patch
