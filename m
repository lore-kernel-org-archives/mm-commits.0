From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=3D?=
 =?US-ASCII?Q?4-mount-option.patch?= added to -mm tree
Date: Mon, 20 Apr 2020 15:24:06 -0700
Message-ID: <20200420222406.dMf74hQ-d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTWYI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, bfields@fieldses.org, corbet@lwn.net, danielmicay@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, gladkov.alexey@gmail.com, gregkh@linuxfoundation.org, jlayton@poochiereds.net, keescook@chromium.org, ldv@altlinux.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tixxdz@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: instantiate only pids that we can ptrace on 'hidepid=4' mount option
has been added to the -mm tree.  Its filename is
     proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=4-mount-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid%3D4-mount-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid%3D4-mount-option.patch

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
Subject: proc: instantiate only pids that we can ptrace on 'hidepid=4' mount option

If "hidepid=4" mount option is set then do not instantiate pids that we
can not ptrace.  "hidepid=4" means that procfs should only contain pids
that the caller can ptrace.

Link: http://lkml.kernel.org/r/20200419141057.621356-4-gladkov.alexey@gmail.com
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Howells <dhowells@redhat.com>
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

 fs/proc/base.c          |   15 +++++++++++++++
 fs/proc/root.c          |   13 ++++++++++---
 include/linux/proc_fs.h |    1 +
 3 files changed, 26 insertions(+), 3 deletions(-)

--- a/fs/proc/base.c~proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=4-mount-option
+++ a/fs/proc/base.c
@@ -701,6 +701,14 @@ static bool has_pid_permissions(struct p
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
+	/*
+	 * If 'hidpid' mount option is set force a ptrace check,
+	 * we indicate that we are using a filesystem syscall
+	 * by passing PTRACE_MODE_READ_FSCREDS
+	 */
+	if (fs_info->hide_pid == HIDEPID_NOT_PTRACEABLE)
+		return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
+
 	if (fs_info->hide_pid < hide_pid_min)
 		return true;
 	if (in_group_p(fs_info->pid_gid))
@@ -3331,7 +3339,14 @@ struct dentry *proc_pid_lookup(struct de
 	if (!task)
 		goto out;
 
+	/* Limit procfs to only ptraceable tasks */
+	if (fs_info->hide_pid == HIDEPID_NOT_PTRACEABLE) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS))
+			goto out_put_task;
+	}
+
 	result = proc_pid_instantiate(dentry, task, NULL);
+out_put_task:
 	put_task_struct(task);
 out:
 	return result;
--- a/fs/proc/root.c~proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=4-mount-option
+++ a/fs/proc/root.c
@@ -47,6 +47,14 @@ static const struct fs_parameter_spec pr
 	{}
 };
 
+static inline int valid_hidepid(unsigned int value)
+{
+	return (value == HIDEPID_OFF ||
+		value == HIDEPID_NO_ACCESS ||
+		value == HIDEPID_INVISIBLE ||
+		value == HIDEPID_NOT_PTRACEABLE);
+}
+
 static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -63,10 +71,9 @@ static int proc_parse_param(struct fs_co
 		break;
 
 	case Opt_hidepid:
+		if (!valid_hidepid(result.uint_32))
+			return invalf(fc, "proc: unknown value of hidepid.\n");
 		ctx->hidepid = result.uint_32;
-		if (ctx->hidepid < HIDEPID_OFF ||
-		    ctx->hidepid > HIDEPID_INVISIBLE)
-			return invalfc(fc, "hidepid value must be between 0 and 2.\n");
 		break;
 
 	default:
--- a/include/linux/proc_fs.h~proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=4-mount-option
+++ a/include/linux/proc_fs.h
@@ -47,6 +47,7 @@ enum {
 	HIDEPID_OFF	  = 0,
 	HIDEPID_NO_ACCESS = 1,
 	HIDEPID_INVISIBLE = 2,
+	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
 };
 
 struct proc_fs_info {
_

Patches currently in -mm which might be from gladkov.alexey@gmail.com are

proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch
proc-allow-to-mount-many-instances-of-proc-in-one-pid-namespace.patch
proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=4-mount-option.patch
proc-add-option-to-mount-only-a-pids-subset.patch
docs-proc-add-documentation-for-hidepid=4-and-subset=pid-options-and-new-mount-behavior.patch
proc-use-human-readable-values-for-hidepid.patch
proc-use-named-enums-for-better-readability.patch
