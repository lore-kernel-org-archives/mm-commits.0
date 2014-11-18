From: akpm@linux-foundation.org
Subject: + syscallsx86-implement-execveat-system-call-v8.patch added to
 -mm tree
Date: Mon, 17 Nov 2014 16:12:57 -0800
Message-ID: <546a8f09.OcRgPL8VYK82q5cY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaKRAM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 19:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drysdale@google.com, arnd@arndb.de, dalias@aerifal.cx, ebiederm@xmission.com, hch@infradead.org, hpa@zytor.com, keescook@chromium.org, luto@amacapital.net, meredydd@senatehouse.org, mingo@redhat.com, mtk.manpages@gmail.com, shuah.kh@samsung.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls,x86: implement execveat() system call
has been added to the -mm tree.  Its filename is
     syscallsx86-implement-execveat-system-call-v8.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/syscallsx86-implement-execveat-system-call-v8.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/syscallsx86-implement-execveat-system-call-v8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Drysdale <drysdale@google.com>
Subject: syscalls,x86: implement execveat() system call

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

 fs/exec.c                |    9 ++++++---
 include/linux/syscalls.h |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~syscallsx86-implement-execveat-system-call-v8 fs/exec.c
--- a/fs/exec.c~syscallsx86-implement-execveat-system-call-v8
+++ a/fs/exec.c
@@ -1501,10 +1501,12 @@ static int do_execveat_common(int fd, st
 			retval = -ENOMEM;
 			goto out_unmark;
 		}
-		/* Record that a name derived from an O_CLOEXEC fd will be
+		/*
+		 * Record that a name derived from an O_CLOEXEC fd will be
 		 * inaccessible after exec. Relies on having exclusive access to
-		 * current->files (due to unshare_files above). */
-		if (close_on_exec(fd, current->files->fdt))
+		 * current->files (due to unshare_files above).
+		 */
+		if (close_on_exec(fd, rcu_dereference_raw(current->files->fdt)))
 			bprm->interp_flags |= BINPRM_FLAGS_PATH_INACCESSIBLE;
 		bprm->filename = pathbuf;
 	}
@@ -1549,6 +1551,7 @@ static int do_execveat_common(int fd, st
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
+	kfree(pathbuf);
 	putname(filename);
 	if (displaced)
 		put_files_struct(displaced);
diff -puN include/linux/syscalls.h~syscallsx86-implement-execveat-system-call-v8 include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscallsx86-implement-execveat-system-call-v8
+++ a/include/linux/syscalls.h
@@ -877,6 +877,7 @@ asmlinkage long sys_seccomp(unsigned int
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
 			      unsigned int flags);
 asmlinkage long sys_bpf(int cmd, union bpf_attr *attr, unsigned int size);
+
 asmlinkage long sys_execveat(int dfd, const char __user *filename,
 			const char __user *const __user *argv,
 			const char __user *const __user *envp, int flags);
_

Patches currently in -mm which might be from drysdale@google.com are

syscallsx86-implement-execveat-system-call.patch
syscallsx86-implement-execveat-system-call-v8.patch
syscallsx86-add-selftest-for-execveat2.patch
sparc-hook-up-execveat-system-call.patch

