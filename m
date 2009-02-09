From: akpm@linux-foundation.org
Subject: [merged] cred-fix-suid-exec-regression.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:09 -0800
Message-ID: <200902092005.n19K5Agu024125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbZBIUGZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dsmith@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     CRED: Fix SUID exec regression
has been removed from the -mm tree.  Its filename was
     cred-fix-suid-exec-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CRED: Fix SUID exec regression
From: David Howells <dhowells@redhat.com>

The patch:

	commit a6f76f23d297f70e2a6b3ec607f7aeeea9e37e8d
	CRED: Make execve() take advantage of copy-on-write credentials

moved the place in which the 'safeness' of a SUID/SGID exec was performed
to before de_thread() was called.  This means that LSM_UNSAFE_SHARE is now
calculated incorrectly.  This flag is set if any of the usage counts for
fs_struct, files_struct and sighand_struct are greater than 1 at the time
the determination is made.  All of which are true for threads created by
the pthread library.

However, since we wish to make the security calculation before irrevocably
damaging the process so that we can return it an error code in the case
where we decide we want to reject the exec request on this basis, we have
to make the determination before calling de_thread().

So, instead, we count up the number of threads (CLONE_THREAD) that are
sharing our fs_struct (CLONE_FS), files_struct (CLONE_FILES) and
sighand_structs (CLONE_SIGHAND/CLONE_THREAD) with us.  These will be
killed by de_thread() and so can be discounted by check_unsafe_exec().

We do have to be careful because CLONE_THREAD does not imply FS or FILES.

We _assume_ that there will be no extra references to these structs held by the
threads we're going to kill.

This can be tested with the attached pair of programs.  Build the two
programs using the Makefile supplied, and run ./test1 as a non-root user. 
If successful, you should see something like:

	[dhowells@andromeda tmp]$ ./test1
	--TEST1--
	uid=4043, euid=4043 suid=4043
	exec ./test2
	--TEST2--
	uid=4043, euid=0 suid=0
	SUCCESS - Correct effective user ID

and if unsuccessful, something like:

	[dhowells@andromeda tmp]$ ./test1
	--TEST1--
	uid=4043, euid=4043 suid=4043
	exec ./test2
	--TEST2--
	uid=4043, euid=4043 suid=4043
	ERROR - Incorrect effective user ID!

The non-root user ID you see will depend on the user you run as.

[test1.c]
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

static void *thread_func(void *arg)
{
	while (1) {}
}

int main(int argc, char **argv)
{
	pthread_t tid;
	uid_t uid, euid, suid;

	printf("--TEST1--\n");
	getresuid(&uid, &euid, &suid);
	printf("uid=%d, euid=%d suid=%d\n", uid, euid, suid);

	if (pthread_create(&tid, NULL, thread_func, NULL) < 0) {
		perror("pthread_create");
		exit(1);
	}

	printf("exec ./test2\n");
	execlp("./test2", "test2", NULL);
	perror("./test2");
	_exit(1);
}

[test2.c]
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	uid_t uid, euid, suid;

	getresuid(&uid, &euid, &suid);
	printf("--TEST2--\n");
	printf("uid=%d, euid=%d suid=%d\n", uid, euid, suid);

	if (euid != 0) {
		fprintf(stderr, "ERROR - Incorrect effective user ID!\n");
		exit(1);
	}
	printf("SUCCESS - Correct effective user ID\n");
	exit(0);
}

[Makefile]
CFLAGS = -D_GNU_SOURCE -Wall -Werror -Wunused
all: test1 test2

test1: test1.c
	gcc $(CFLAGS) -o test1 test1.c -lpthread

test2: test2.c
	gcc $(CFLAGS) -o test2 test2.c
	sudo chown root.root test2
	sudo chmod +s test2

Reported-by: David Smith <dsmith@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: David Smith <dsmith@redhat.com>
Tested-by: David Smith <dsmith@redhat.com>
Cc: James Morris <jmorris@namei.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c   |    2 +-
 fs/exec.c     |   28 ++++++++++++++++++++++------
 fs/internal.h |    2 +-
 3 files changed, 24 insertions(+), 8 deletions(-)

diff -puN fs/compat.c~cred-fix-suid-exec-regression fs/compat.c
--- a/fs/compat.c~cred-fix-suid-exec-regression
+++ a/fs/compat.c
@@ -1407,7 +1407,7 @@ int compat_do_execve(char * filename,
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
 		goto out_unlock;
-	check_unsafe_exec(bprm);
+	check_unsafe_exec(bprm, current->files);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
diff -puN fs/exec.c~cred-fix-suid-exec-regression fs/exec.c
--- a/fs/exec.c~cred-fix-suid-exec-regression
+++ a/fs/exec.c
@@ -1049,16 +1049,32 @@ EXPORT_SYMBOL(install_exec_creds);
  * - the caller must hold current->cred_exec_mutex to protect against
  *   PTRACE_ATTACH
  */
-void check_unsafe_exec(struct linux_binprm *bprm)
+void check_unsafe_exec(struct linux_binprm *bprm, struct files_struct *files)
 {
-	struct task_struct *p = current;
+	struct task_struct *p = current, *t;
+	unsigned long flags;
+	unsigned n_fs, n_files, n_sighand;
 
 	bprm->unsafe = tracehook_unsafe_exec(p);
 
-	if (atomic_read(&p->fs->count) > 1 ||
-	    atomic_read(&p->files->count) > 1 ||
-	    atomic_read(&p->sighand->count) > 1)
+	n_fs = 1;
+	n_files = 1;
+	n_sighand = 1;
+	lock_task_sighand(p, &flags);
+	for (t = next_thread(p); t != p; t = next_thread(t)) {
+		if (t->fs == p->fs)
+			n_fs++;
+		if (t->files == files)
+			n_files++;
+		n_sighand++;
+	}
+
+	if (atomic_read(&p->fs->count) > n_fs ||
+	    atomic_read(&p->files->count) > n_files ||
+	    atomic_read(&p->sighand->count) > n_sighand)
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
+
+	unlock_task_sighand(p, &flags);
 }
 
 /* 
@@ -1273,7 +1289,7 @@ int do_execve(char * filename,
 	bprm->cred = prepare_exec_creds();
 	if (!bprm->cred)
 		goto out_unlock;
-	check_unsafe_exec(bprm);
+	check_unsafe_exec(bprm, displaced);
 
 	file = open_exec(filename);
 	retval = PTR_ERR(file);
diff -puN fs/internal.h~cred-fix-suid-exec-regression fs/internal.h
--- a/fs/internal.h~cred-fix-suid-exec-regression
+++ a/fs/internal.h
@@ -43,7 +43,7 @@ extern void __init chrdev_init(void);
 /*
  * exec.c
  */
-extern void check_unsafe_exec(struct linux_binprm *);
+extern void check_unsafe_exec(struct linux_binprm *, struct files_struct *);
 
 /*
  * namespace.c
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

