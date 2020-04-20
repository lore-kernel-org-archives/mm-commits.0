From: akpm@linux-foundation.org
Subject: + proc-use-human-readable-values-for-hidepid.patch added
 to -mm tree
Date: Mon, 20 Apr 2020 15:24:17 -0700
Message-ID: <20200420222417.iyNHKf-wD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTWYT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akinobu.mita@gmail.com, bfields@fieldses.org, corbet@lwn.net, danielmicay@gmail.com, dhowells@redhat.com, ebiederm@xmission.com, gladkov.alexey@gmail.com, gregkh@linuxfoundation.org, jlayton@poochiereds.net, keescook@chromium.org, ldv@altlinux.org, luto@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com, tixxdz@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: proc: use human-readable values for hidepid
has been added to the -mm tree.  Its filename is
     proc-use-human-readable-values-for-hidepid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-use-human-readable-values=
-for-hidepid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-use-human-readable-values=
-for-hidepid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: proc: use human-readable values for hidepid

The hidepid parameter values are becoming more and more and it becomes
difficult to remember what each new magic number means.

Backward compatibility is preserved since it is possible to specify
numerical value for the hidepid parameter.  This does not break the
fsconfig since it is not possible to specify a numerical value through it.
All numeric values are converted to a string.  The type
FSCONFIG_SET_BINARY cannot be used to indicate a numerical value.

Selftest has been added to verify this behavior.

Link: http://lkml.kernel.org/r/20200419141057.621356-7-gladkov.alexey@gmail=
.com
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
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

 Documentation/filesystems/proc.rst                   |   48 ++++-----
 fs/proc/inode.c                                      |   15 ++-
 fs/proc/root.c                                       |   38 ++++++-
 tools/testing/selftests/proc/.gitignore              |    1=20
 tools/testing/selftests/proc/Makefile                |    1=20
 tools/testing/selftests/proc/proc-fsconfig-hidepid.c |   50 ++++++++++
 6 files changed, 124 insertions(+), 29 deletions(-)

--- a/Documentation/filesystems/proc.rst~proc-use-human-readable-values-for=
-hidepid
+++ a/Documentation/filesystems/proc.rst
@@ -2147,28 +2147,28 @@ The following mount options are supporte
 	subset=3D		Show only the specified subset of procfs.
 	=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-hidepid=3D0 means classic mode - everybody may access all /proc/<pid>/ dir=
ectories
-(default).
+hidepid=3Doff or hidepid=3D0 means classic mode - everybody may access all
+/proc/<pid>/ directories (default).
=20
-hidepid=3D1 means users may not access any /proc/<pid>/ directories but th=
eir
-own.  Sensitive files like cmdline, sched*, status are now protected again=
st
-other users.  This makes it impossible to learn whether any user runs
-specific program (given the program doesn't reveal itself by its behaviour=
).
-As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other u=
sers,
-poorly written programs passing sensitive information via program argument=
s are
-now protected against local eavesdroppers.
-
-hidepid=3D2 means hidepid=3D1 plus all /proc/<pid>/ will be fully invisibl=
e to other
-users.  It doesn't mean that it hides a fact whether a process with a spec=
ific
-pid value exists (it can be learned by other means, e.g. by "kill -0 $PID"=
),
-but it hides process' uid and gid, which may be learned by stat()'ing
-/proc/<pid>/ otherwise.  It greatly complicates an intruder's task of gath=
ering
-information about running processes, whether some daemon runs with elevated
-privileges, whether other user runs some sensitive program, whether other =
users
-run any program at all, etc.
+hidepid=3Dnoaccess or hidepid=3D1 means users may not access any /proc/<pi=
d>/
+directories but their own.  Sensitive files like cmdline, sched*, status a=
re now
+protected against other users.  This makes it impossible to learn whether =
any
+user runs specific program (given the program doesn't reveal itself by its
+behaviour).  As an additional bonus, as /proc/<pid>/cmdline is unaccessibl=
e for
+other users, poorly written programs passing sensitive information via pro=
gram
+arguments are now protected against local eavesdroppers.
+
+hidepid=3Dinvisible or hidepid=3D2 means hidepid=3D1 plus all /proc/<pid>/=
 will be
+fully invisible to other users.  It doesn't mean that it hides a fact whet=
her a
+process with a specific pid value exists (it can be learned by other means=
, e.g.
+by "kill -0 $PID"), but it hides process' uid and gid, which may be learne=
d by
+stat()'ing /proc/<pid>/ otherwise.  It greatly complicates an intruder's t=
ask of
+gathering information about running processes, whether some daemon runs wi=
th
+elevated privileges, whether other user runs some sensitive program, wheth=
er
+other users run any program at all, etc.
=20
-hidepid=3D4 means that procfs should only contain /proc/<pid>/ directories
-that the caller can ptrace.
+hidepid=3Dptraceable or hidepid=3D4 means that procfs should only contain
+/proc/<pid>/ directories that the caller can ptrace.
=20
 gid=3D defines a group authorized to learn processes information otherwise
 prohibited by hidepid=3D.  If you use some daemon like identd which needs =
to learn
@@ -2216,8 +2216,8 @@ creates a new procfs instance. Mount opt
 It means that it became possible to have several procfs instances
 displaying tasks with different filtering options in one pid namespace.
=20
-# mount -o hidepid=3D2 -t proc proc /proc
-# mount -o hidepid=3D1 -t proc proc /tmp/proc
+# mount -o hidepid=3Dinvisible -t proc proc /proc
+# mount -o hidepid=3Dnoaccess -t proc proc /tmp/proc
 # grep ^proc /proc/mounts
-proc /proc proc rw,relatime,hidepid=3D2 0 0
-proc /tmp/proc proc rw,relatime,hidepid=3D1 0 0
+proc /proc proc rw,relatime,hidepid=3Dinvisible 0 0
+proc /tmp/proc proc rw,relatime,hidepid=3Dnoaccess 0 0
--- a/fs/proc/inode.c~proc-use-human-readable-values-for-hidepid
+++ a/fs/proc/inode.c
@@ -24,6 +24,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/mount.h>
+#include <linux/bug.h>
=20
 #include <linux/uaccess.h>
=20
@@ -165,6 +166,18 @@ void proc_invalidate_siblings_dcache(str
 		deactivate_super(old_sb);
 }
=20
+static inline const char *hidepid2str(int v)
+{
+	switch (v) {
+		case HIDEPID_OFF: return "off";
+		case HIDEPID_NO_ACCESS: return "noaccess";
+		case HIDEPID_INVISIBLE: return "invisible";
+		case HIDEPID_NOT_PTRACEABLE: return "ptraceable";
+	}
+	WARN_ONCE(1, "bad hide_pid value: %d\n", v);
+	return "unknown";
+}
+
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct proc_fs_info *fs_info =3D proc_sb_info(root->d_sb);
@@ -172,7 +185,7 @@ static int proc_show_options(struct seq_
 	if (!gid_eq(fs_info->pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=3D%u", from_kgid_munged(&init_user_ns, fs_info->pi=
d_gid));
 	if (fs_info->hide_pid !=3D HIDEPID_OFF)
-		seq_printf(seq, ",hidepid=3D%u", fs_info->hide_pid);
+		seq_printf(seq, ",hidepid=3D%s", hidepid2str(fs_info->hide_pid));
 	if (fs_info->pidonly !=3D PROC_PIDONLY_OFF)
 		seq_printf(seq, ",subset=3Dpid");
=20
--- a/fs/proc/root.c~proc-use-human-readable-values-for-hidepid
+++ a/fs/proc/root.c
@@ -45,7 +45,7 @@ enum proc_param {
=20
 static const struct fs_parameter_spec proc_fs_parameters[] =3D {
 	fsparam_u32("gid",	Opt_gid),
-	fsparam_u32("hidepid",	Opt_hidepid),
+	fsparam_string("hidepid",	Opt_hidepid),
 	fsparam_string("subset",	Opt_subset),
 	{}
 };
@@ -58,6 +58,37 @@ static inline int valid_hidepid(unsigned
 		value =3D=3D HIDEPID_NOT_PTRACEABLE);
 }
=20
+static int proc_parse_hidepid_param(struct fs_context *fc, struct fs_param=
eter *param)
+{
+	struct proc_fs_context *ctx =3D fc->fs_private;
+	struct fs_parameter_spec hidepid_u32_spec =3D fsparam_u32("hidepid", Opt_=
hidepid);
+	struct fs_parse_result result;
+	int base =3D (unsigned long)hidepid_u32_spec.data;
+
+	if (param->type !=3D fs_value_is_string)
+		return invalf(fc, "proc: unexpected type of hidepid value\n");
+
+	if (!kstrtouint(param->string, base, &result.uint_32)) {
+		if (!valid_hidepid(result.uint_32))
+			return invalf(fc, "proc: unknown value of hidepid - %s\n", param->strin=
g);
+		ctx->hidepid =3D result.uint_32;
+		return 0;
+	}
+
+	if (!strcmp(param->string, "off"))
+		ctx->hidepid =3D HIDEPID_OFF;
+	else if (!strcmp(param->string, "noaccess"))
+		ctx->hidepid =3D HIDEPID_NO_ACCESS;
+	else if (!strcmp(param->string, "invisible"))
+		ctx->hidepid =3D HIDEPID_INVISIBLE;
+	else if (!strcmp(param->string, "ptraceable"))
+		ctx->hidepid =3D HIDEPID_NOT_PTRACEABLE;
+	else
+		return invalf(fc, "proc: unknown value of hidepid - %s\n", param->string=
);
+
+	return 0;
+}
+
 static int proc_parse_subset_param(struct fs_context *fc, char *value)
 {
 	struct proc_fs_context *ctx =3D fc->fs_private;
@@ -97,9 +128,8 @@ static int proc_parse_param(struct fs_co
 		break;
=20
 	case Opt_hidepid:
-		if (!valid_hidepid(result.uint_32))
-			return invalf(fc, "proc: unknown value of hidepid.\n");
-		ctx->hidepid =3D result.uint_32;
+		if (proc_parse_hidepid_param(fc, param))
+			return -EINVAL;
 		break;
=20
 	case Opt_subset:
--- a/tools/testing/selftests/proc/.gitignore~proc-use-human-readable-value=
s-for-hidepid
+++ a/tools/testing/selftests/proc/.gitignore
@@ -2,6 +2,7 @@
 /fd-001-lookup
 /fd-002-posix-eq
 /fd-003-kthread
+/proc-fsconfig-hidepid
 /proc-loadavg-001
 /proc-multiple-procfs
 /proc-pid-vm
--- a/tools/testing/selftests/proc/Makefile~proc-use-human-readable-values-=
for-hidepid
+++ a/tools/testing/selftests/proc/Makefile
@@ -20,5 +20,6 @@ TEST_GEN_PROGS +=3D setns-dcache
 TEST_GEN_PROGS +=3D setns-sysvipc
 TEST_GEN_PROGS +=3D thread-self
 TEST_GEN_PROGS +=3D proc-multiple-procfs
+TEST_GEN_PROGS +=3D proc-fsconfig-hidepid
=20
 include ../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/proc/proc-fsconfig-hidepid.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright =C2=A9 2020 Alexey Gladkov <gladkov.alexey@gmail.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <assert.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <linux/mount.h>
+#include <linux/unistd.h>
+
+static inline int fsopen(const char *fsname, unsigned int flags)
+{
+	return syscall(__NR_fsopen, fsname, flags);
+}
+
+static inline int fsconfig(int fd, unsigned int cmd, const char *key, cons=
t void *val, int aux)
+{
+	return syscall(__NR_fsconfig, fd, cmd, key, val, aux);
+}
+
+int main(void)
+{
+	int fsfd, ret;
+	int hidepid =3D 2;
+
+	assert((fsfd =3D fsopen("proc", 0)) !=3D -1);
+
+	ret =3D fsconfig(fsfd, FSCONFIG_SET_BINARY, "hidepid", &hidepid, 0);
+	assert(ret =3D=3D -1);
+	assert(errno =3D=3D EINVAL);
+
+	assert(!fsconfig(fsfd, FSCONFIG_SET_STRING, "hidepid", "2", 0));
+	assert(!fsconfig(fsfd, FSCONFIG_SET_STRING, "hidepid", "invisible", 0));
+
+	assert(!close(fsfd));
+
+	return 0;
+}
_

Patches currently in -mm which might be from gladkov.alexey@gmail.com are

proc-rename-struct-proc_fs_info-to-proc_fs_opts.patch
proc-allow-to-mount-many-instances-of-proc-in-one-pid-namespace.patch
proc-instantiate-only-pids-that-we-can-ptrace-on-hidepid=3D4-mount-option.p=
atch
proc-add-option-to-mount-only-a-pids-subset.patch
docs-proc-add-documentation-for-hidepid=3D4-and-subset=3Dpid-options-and-ne=
w-mount-behavior.patch
proc-use-human-readable-values-for-hidepid.patch
proc-use-named-enums-for-better-readability.patch
