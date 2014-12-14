From: akpm@linux-foundation.org
Subject: [merged] syscalls-implement-execveat-system-call.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:09:18 -0800
Message-ID: <548d0d6e.AFbFi5QDV+Prr+ZB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaLNEJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, arnd@arndb.de, dalias@aerifal.cx, ebiederm@xmission.com, hch@infradead.org, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, meredydd@senatehouse.org, mingo@redhat.com, mtk.manpages@gmail.com, shuah.kh@samsung.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls: implement execveat() system call
has been removed from the -mm tree.  Its filename was
     syscalls-implement-execveat-system-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: syscalls: implement execveat() system call

This patchset adds execveat(2) for x86, and is derived from Meredydd
Luff's patch from Sept 2012 (https://lkml.org/lkml/2012/9/11/528).

The primary aim of adding an execveat syscall is to allow an
implementation of fexecve(3) that does not rely on the /proc filesystem,
at least for executables (rather than scripts).  The current glibc version
of fexecve(3) is implemented via /proc, which causes problems in sandboxed
or otherwise restricted environments.

Given the desire for a /proc-free fexecve() implementation, HPA suggested
(https://lkml.org/lkml/2006/7/11/556) that an execveat(2) syscall would be
an appropriate generalization.

Also, having a new syscall means that it can take a flags argument without
back-compatibility concerns.  The current implementation just defines the
AT_EMPTY_PATH and AT_SYMLINK_NOFOLLOW flags, but other flags could be
added in future -- for example, flags for new namespaces (as suggested at
https://lkml.org/lkml/2006/7/11/474).

Related history:
 - https://lkml.org/lkml/2006/12/27/123 is an example of someone
   realizing that fexecve() is likely to fail in a chroot environment.
 - http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514043 covered
   documenting the /proc requirement of fexecve(3) in its manpage, to
   "prevent other people from wasting their time".
 - https://bugzilla.redhat.com/show_bug.cgi?id=241609 described a
   problem where a process that did setuid() could not fexecve()
   because it no longer had access to /proc/self/fd; this has since
   been fixed.



This patch (of 4):

Add a new execveat(2) system call.  execveat() is to execve() as openat()
is to open(): it takes a file descriptor that refers to a directory, and
resolves the filename relative to that.

In addition, if the filename is empty and AT_EMPTY_PATH is specified,
execveat() executes the file to which the file descriptor refers.  This
replicates the functionality of fexecve(), which is a system call in other
UNIXen, but in Linux glibc it depends on opening "/proc/self/fd/<fd>" (and
so relies on /proc being mounted).

The filename fed to the executed program as argv[0] (or the name of the
script fed to a script interpreter) will be of the form "/dev/fd/<fd>"
(for an empty filename) or "/dev/fd/<fd>/<filename>", effectively
reflecting how the executable was found.  This does however mean that
execution of a script in a /proc-less environment won't work; also, script
execution via an O_CLOEXEC file descriptor fails (as the file will not be
accessible after exec).

Based on patches by Meredydd Luff.

Signed-off-by: David Drysdale <drysdale@google.com>
Cc: Meredydd Luff <meredydd@senatehouse.org>
Cc: Shuah Khan <shuah.kh@samsung.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rich Felker <dalias@aerifal.cx>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c                  |    4 
 fs/binfmt_misc.c                  |    4 
 fs/binfmt_script.c                |   10 ++
 fs/exec.c                         |  113 ++++++++++++++++++++++++----
 fs/namei.c                        |    2 
 include/linux/binfmts.h           |    4 
 include/linux/compat.h            |    3 
 include/linux/fs.h                |    1 
 include/linux/sched.h             |    4 
 include/linux/syscalls.h          |    5 +
 include/uapi/asm-generic/unistd.h |    4 
 kernel/sys_ni.c                   |    3 
 lib/audit.c                       |    3 
 13 files changed, 145 insertions(+), 15 deletions(-)

diff -puN fs/binfmt_em86.c~syscalls-implement-execveat-system-call fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~syscalls-implement-execveat-system-call
+++ a/fs/binfmt_em86.c
@@ -42,6 +42,10 @@ static int load_em86(struct linux_binprm
 			return -ENOEXEC;
 	}
 
+	/* Need to be able to load the file after exec */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN fs/binfmt_misc.c~syscalls-implement-execveat-system-call fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~syscalls-implement-execveat-system-call
+++ a/fs/binfmt_misc.c
@@ -144,6 +144,10 @@ static int load_misc_binary(struct linux
 	if (!fmt)
 		goto ret;
 
+	/* Need to be able to load the file after exec */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
 		retval = remove_arg_zero(bprm);
 		if (retval)
diff -puN fs/binfmt_script.c~syscalls-implement-execveat-system-call fs/binfmt_script.c
--- a/fs/binfmt_script.c~syscalls-implement-execveat-system-call
+++ a/fs/binfmt_script.c
@@ -24,6 +24,16 @@ static int load_script(struct linux_binp
 
 	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!'))
 		return -ENOEXEC;
+
+	/*
+	 * If the script filename will be inaccessible after exec, typically
+	 * because it is a "/dev/fd/<fd>/.." path against an O_CLOEXEC fd, give
+	 * up now (on the assumption that the interpreter will want to load
+	 * this file).
+	 */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
diff -puN fs/exec.c~syscalls-implement-execveat-system-call fs/exec.c
--- a/fs/exec.c~syscalls-implement-execveat-system-call
+++ a/fs/exec.c
@@ -748,18 +748,25 @@ EXPORT_SYMBOL(setup_arg_pages);
 
 #endif /* CONFIG_MMU */
 
-static struct file *do_open_exec(struct filename *name)
+static struct file *do_open_execat(int fd, struct filename *name, int flags)
 {
 	struct file *file;
 	int err;
-	static const struct open_flags open_exec_flags = {
+	struct open_flags open_exec_flags = {
 		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_EXEC | MAY_OPEN,
 		.intent = LOOKUP_OPEN,
 		.lookup_flags = LOOKUP_FOLLOW,
 	};
 
-	file = do_filp_open(AT_FDCWD, name, &open_exec_flags);
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return ERR_PTR(-EINVAL);
+	if (flags & AT_SYMLINK_NOFOLLOW)
+		open_exec_flags.lookup_flags &= ~LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		open_exec_flags.lookup_flags |= LOOKUP_EMPTY;
+
+	file = do_filp_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
 		goto out;
 
@@ -770,12 +777,13 @@ static struct file *do_open_exec(struct
 	if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
 		goto exit;
 
-	fsnotify_open(file);
-
 	err = deny_write_access(file);
 	if (err)
 		goto exit;
 
+	if (name->name[0] != '\0')
+		fsnotify_open(file);
+
 out:
 	return file;
 
@@ -787,7 +795,7 @@ exit:
 struct file *open_exec(const char *name)
 {
 	struct filename tmp = { .name = name };
-	return do_open_exec(&tmp);
+	return do_open_execat(AT_FDCWD, &tmp, 0);
 }
 EXPORT_SYMBOL(open_exec);
 
@@ -1428,10 +1436,12 @@ static int exec_binprm(struct linux_binp
 /*
  * sys_execve() executes a new program.
  */
-static int do_execve_common(struct filename *filename,
-				struct user_arg_ptr argv,
-				struct user_arg_ptr envp)
+static int do_execveat_common(int fd, struct filename *filename,
+			      struct user_arg_ptr argv,
+			      struct user_arg_ptr envp,
+			      int flags)
 {
+	char *pathbuf = NULL;
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
@@ -1472,7 +1482,7 @@ static int do_execve_common(struct filen
 	check_unsafe_exec(bprm);
 	current->in_execve = 1;
 
-	file = do_open_exec(filename);
+	file = do_open_execat(fd, filename, flags);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_unmark;
@@ -1480,7 +1490,28 @@ static int do_execve_common(struct filen
 	sched_exec();
 
 	bprm->file = file;
-	bprm->filename = bprm->interp = filename->name;
+	if (fd == AT_FDCWD || filename->name[0] == '/') {
+		bprm->filename = filename->name;
+	} else {
+		if (filename->name[0] == '\0')
+			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d", fd);
+		else
+			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d/%s",
+					    fd, filename->name);
+		if (!pathbuf) {
+			retval = -ENOMEM;
+			goto out_unmark;
+		}
+		/*
+		 * Record that a name derived from an O_CLOEXEC fd will be
+		 * inaccessible after exec. Relies on having exclusive access to
+		 * current->files (due to unshare_files above).
+		 */
+		if (close_on_exec(fd, rcu_dereference_raw(current->files->fdt)))
+			bprm->interp_flags |= BINPRM_FLAGS_PATH_INACCESSIBLE;
+		bprm->filename = pathbuf;
+	}
+	bprm->interp = bprm->filename;
 
 	retval = bprm_mm_init(bprm);
 	if (retval)
@@ -1521,6 +1552,7 @@ static int do_execve_common(struct filen
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
+	kfree(pathbuf);
 	putname(filename);
 	if (displaced)
 		put_files_struct(displaced);
@@ -1538,6 +1570,7 @@ out_unmark:
 
 out_free:
 	free_bprm(bprm);
+	kfree(pathbuf);
 
 out_files:
 	if (displaced)
@@ -1553,7 +1586,18 @@ int do_execve(struct filename *filename,
 {
 	struct user_arg_ptr argv = { .ptr.native = __argv };
 	struct user_arg_ptr envp = { .ptr.native = __envp };
-	return do_execve_common(filename, argv, envp);
+	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
+}
+
+int do_execveat(int fd, struct filename *filename,
+		const char __user *const __user *__argv,
+		const char __user *const __user *__envp,
+		int flags)
+{
+	struct user_arg_ptr argv = { .ptr.native = __argv };
+	struct user_arg_ptr envp = { .ptr.native = __envp };
+
+	return do_execveat_common(fd, filename, argv, envp, flags);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1569,7 +1613,23 @@ static int compat_do_execve(struct filen
 		.is_compat = true,
 		.ptr.compat = __envp,
 	};
-	return do_execve_common(filename, argv, envp);
+	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
+}
+
+static int compat_do_execveat(int fd, struct filename *filename,
+			      const compat_uptr_t __user *__argv,
+			      const compat_uptr_t __user *__envp,
+			      int flags)
+{
+	struct user_arg_ptr argv = {
+		.is_compat = true,
+		.ptr.compat = __argv,
+	};
+	struct user_arg_ptr envp = {
+		.is_compat = true,
+		.ptr.compat = __envp,
+	};
+	return do_execveat_common(fd, filename, argv, envp, flags);
 }
 #endif
 
@@ -1609,6 +1669,20 @@ SYSCALL_DEFINE3(execve,
 {
 	return do_execve(getname(filename), argv, envp);
 }
+
+SYSCALL_DEFINE5(execveat,
+		int, fd, const char __user *, filename,
+		const char __user *const __user *, argv,
+		const char __user *const __user *, envp,
+		int, flags)
+{
+	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return do_execveat(fd,
+			   getname_flags(filename, lookup_flags, NULL),
+			   argv, envp, flags);
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 	const compat_uptr_t __user *, argv,
@@ -1616,4 +1690,17 @@ COMPAT_SYSCALL_DEFINE3(execve, const cha
 {
 	return compat_do_execve(getname(filename), argv, envp);
 }
+
+COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
+		       const char __user *, filename,
+		       const compat_uptr_t __user *, argv,
+		       const compat_uptr_t __user *, envp,
+		       int,  flags)
+{
+	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return compat_do_execveat(fd,
+				  getname_flags(filename, lookup_flags, NULL),
+				  argv, envp, flags);
+}
 #endif
diff -puN fs/namei.c~syscalls-implement-execveat-system-call fs/namei.c
--- a/fs/namei.c~syscalls-implement-execveat-system-call
+++ a/fs/namei.c
@@ -130,7 +130,7 @@ void final_putname(struct filename *name
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - sizeof(struct filename))
 
-static struct filename *
+struct filename *
 getname_flags(const char __user *filename, int flags, int *empty)
 {
 	struct filename *result, *err;
diff -puN include/linux/binfmts.h~syscalls-implement-execveat-system-call include/linux/binfmts.h
--- a/include/linux/binfmts.h~syscalls-implement-execveat-system-call
+++ a/include/linux/binfmts.h
@@ -53,6 +53,10 @@ struct linux_binprm {
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
+/* filename of the binary will be inaccessible after exec */
+#define BINPRM_FLAGS_PATH_INACCESSIBLE_BIT 2
+#define BINPRM_FLAGS_PATH_INACCESSIBLE (1 << BINPRM_FLAGS_PATH_INACCESSIBLE_BIT)
+
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
 	const siginfo_t *siginfo;
diff -puN include/linux/compat.h~syscalls-implement-execveat-system-call include/linux/compat.h
--- a/include/linux/compat.h~syscalls-implement-execveat-system-call
+++ a/include/linux/compat.h
@@ -357,6 +357,9 @@ asmlinkage long compat_sys_lseek(unsigne
 
 asmlinkage long compat_sys_execve(const char __user *filename, const compat_uptr_t __user *argv,
 		     const compat_uptr_t __user *envp);
+asmlinkage long compat_sys_execveat(int dfd, const char __user *filename,
+		     const compat_uptr_t __user *argv,
+		     const compat_uptr_t __user *envp, int flags);
 
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
diff -puN include/linux/fs.h~syscalls-implement-execveat-system-call include/linux/fs.h
--- a/include/linux/fs.h~syscalls-implement-execveat-system-call
+++ a/include/linux/fs.h
@@ -2096,6 +2096,7 @@ extern int vfs_open(const struct path *,
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 
+extern struct filename *getname_flags(const char __user *, int, int *);
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
 
diff -puN include/linux/sched.h~syscalls-implement-execveat-system-call include/linux/sched.h
--- a/include/linux/sched.h~syscalls-implement-execveat-system-call
+++ a/include/linux/sched.h
@@ -2485,6 +2485,10 @@ extern void do_group_exit(int);
 extern int do_execve(struct filename *,
 		     const char __user * const __user *,
 		     const char __user * const __user *);
+extern int do_execveat(int, struct filename *,
+		       const char __user * const __user *,
+		       const char __user * const __user *,
+		       int);
 extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
diff -puN include/linux/syscalls.h~syscalls-implement-execveat-system-call include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscalls-implement-execveat-system-call
+++ a/include/linux/syscalls.h
@@ -877,4 +877,9 @@ asmlinkage long sys_seccomp(unsigned int
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
 			      unsigned int flags);
 asmlinkage long sys_bpf(int cmd, union bpf_attr *attr, unsigned int size);
+
+asmlinkage long sys_execveat(int dfd, const char __user *filename,
+			const char __user *const __user *argv,
+			const char __user *const __user *envp, int flags);
+
 #endif
diff -puN include/uapi/asm-generic/unistd.h~syscalls-implement-execveat-system-call include/uapi/asm-generic/unistd.h
--- a/include/uapi/asm-generic/unistd.h~syscalls-implement-execveat-system-call
+++ a/include/uapi/asm-generic/unistd.h
@@ -707,9 +707,11 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
 __SYSCALL(__NR_memfd_create, sys_memfd_create)
 #define __NR_bpf 280
 __SYSCALL(__NR_bpf, sys_bpf)
+#define __NR_execveat 281
+__SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
 
 #undef __NR_syscalls
-#define __NR_syscalls 281
+#define __NR_syscalls 282
 
 /*
  * All syscalls below here should go away really,
diff -puN kernel/sys_ni.c~syscalls-implement-execveat-system-call kernel/sys_ni.c
--- a/kernel/sys_ni.c~syscalls-implement-execveat-system-call
+++ a/kernel/sys_ni.c
@@ -226,3 +226,6 @@ cond_syscall(sys_seccomp);
 
 /* access BPF programs and maps */
 cond_syscall(sys_bpf);
+
+/* execveat */
+cond_syscall(sys_execveat);
diff -puN lib/audit.c~syscalls-implement-execveat-system-call lib/audit.c
--- a/lib/audit.c~syscalls-implement-execveat-system-call
+++ a/lib/audit.c
@@ -54,6 +54,9 @@ int audit_classify_syscall(int abi, unsi
 	case __NR_socketcall:
 		return 4;
 #endif
+#ifdef __NR_execveat
+	case __NR_execveat:
+#endif
 	case __NR_execve:
 		return 5;
 	default:
_

Patches currently in -mm which might be from drysdale@google.com are

origin.patch

