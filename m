From: akpm@linux-foundation.org
Subject: + mqueue-fix-mq_open-file-descriptor-leak-on-user-space-processes.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:02:34 -0800
Message-ID: <201002242202.o1OM2YNh022902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758254Ab0BXWDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:03:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     mqueue: fix mq_open() file descriptor leak on user-space processes
has been added to the -mm tree.  Its filename is
     mqueue-fix-mq_open-file-descriptor-leak-on-user-space-processes.pa=
tch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mqueue: fix mq_open() file descriptor leak on user-space proce=
sses
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

It can be triggered by the following test program:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mqueue.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/resource.h>

int main(int argc, char *argv[])
{
	struct rlimit limit;
	char queue_name[] =3D "/mq_open/bug";
	char tmp_name[]   =3D "/tmp/tmp";
	int fd, i =3D 1;

	if (getrlimit(RLIMIT_NOFILE, &limit) !=3D 0) {
		printf("%s\n", "Failed to get RLIMIT_NOFILE");
		return EXIT_FAILURE;
	}
	printf("Max number of open files is: %d\n", limit.rlim_cur);

	while (i <=3D limit.rlim_cur) {
		mqd_t queue;

		errno =3D 0;
		queue =3D mq_open(queue_name, O_CREAT |O_RDWR, S_IRUSR | S_IWUSR
		    , NULL);
		if (queue !=3D (mqd_t)-1) {
			/* Success opening mqueue, no leak will happen */
			printf("Successfully opened an mqueue[%d]\n", queue);
			printf("mq_close(%d) =3D %d\n", queue, mq_close(queue));
			return EXIT_SUCCESS;
		}
		/* Failed to open mqueue, maybe a leak is happening... */
		if (errno =3D=3D EMFILE)
		{
			printf("\nRun out of file descriptors");
			break;
		}
		printf("\rLeaking [%d] files?!?!", i++);
		fflush(stdout);
		usleep(500);
	}
	/* Double check that no file descriptor is available anymore indeed */
	putchar('\n');
	errno =3D 0;
	fd =3D open(tmp_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
	if (fd =3D=3D -1) {
		printf("open() failed: %s\n", strerror(errno));
		if (errno =3D=3D EMFILE) {
			printf("%s\n", "Cannot open new files, fds exhausted");
			return EXIT_FAILURE;
		}
	} else
		printf("close(%d) =3D %d\n", fd, close(fd));
	printf("%s\n", "Expected output: kernel is not leaking any fds!");

	return EXIT_SUCCESS;
}

## Preparing for testing

$ touch /tmp/tmp
$ gcc -g main_mq_open_fd_leak.c -lrt

## Linux kernel with the fix applied:

$ ./a.out
Max number of open files is: 1024
Leaking [1024] files?!?!
close(3) =3D 0
Expected output: kernel is not leaking any fds!

## Linux kernel without the fix:

## Shell execution:

$ ./a.out
Max number of open files is: 1024
Leaking [1019] files?!?!
Run out of file descriptors
Segmentation fault

## Valgrind execution:

$ valgrind --track-fds=3Dyes ./a.out
=3D=3D2895=3D=3D Memcheck, a memory error detector
=3D=3D2895=3D=3D Copyright (C) 2002-2009, and GNU GPL'd, by Julian Sewa=
rd et al.
=3D=3D2895=3D=3D Using Valgrind-3.6.0.SVN and LibVEX; rerun with -h for=
 copyright info
=3D=3D2895=3D=3D Command: ./a.out
=3D=3D2895=3D=3D
Max number of open files is: 1024
Leaking [1024] files?!?!
open() failed: Too many open files
Cannot open new files, fds exhausted
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D FILE DESCRIPTORS: 5 open at exit.
=3D=3D2895=3D=3D Open file descriptor 13:
=3D=3D2895=3D=3D    <inherited from parent>
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D Open file descriptor 12:
=3D=3D2895=3D=3D    <inherited from parent>
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D Open file descriptor 2: /dev/pts/1
=3D=3D2895=3D=3D    <inherited from parent>
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D Open file descriptor 1: /dev/pts/1
=3D=3D2895=3D=3D    <inherited from parent>
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D Open file descriptor 0: /dev/pts/1
=3D=3D2895=3D=3D    <inherited from parent>
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D HEAP SUMMARY:
=3D=3D2895=3D=3D     in use at exit: 0 bytes in 0 blocks
=3D=3D2895=3D=3D   total heap usage: 0 allocs, 0 frees, 0 bytes allocat=
ed
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D All heap blocks were freed -- no leaks are possible
=3D=3D2895=3D=3D
=3D=3D2895=3D=3D For counts of detected and suppressed errors, rerun wi=
th: -v
=3D=3D2895=3D=3D ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 2=
 from 2)

When not running valgrind, user-space program segfaults trying to execu=
te
strerror(errno). With valgrind, it executes successfully and prints the
5 open files: stdin, stdout, stderr, pipe[0] and pipe[1].

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/mqueue.c~mqueue-fix-mq_open-file-descriptor-leak-on-user-=
space-processes ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-fix-mq_open-file-descriptor-leak-on-user-spac=
e-processes
+++ a/ipc/mqueue.c
@@ -705,7 +705,7 @@ SYSCALL_DEFINE4(mq_open, const char __us
 	dentry =3D lookup_one_len(name, ipc_ns->mq_mnt->mnt_root, strlen(name=
));
 	if (IS_ERR(dentry)) {
 		error =3D PTR_ERR(dentry);
-		goto out_err;
+		goto out_putfd;
 	}
 	mntget(ipc_ns->mq_mnt);
=20
@@ -742,7 +742,6 @@ out:
 	mntput(ipc_ns->mq_mnt);
 out_putfd:
 	put_unused_fd(fd);
-out_err:
 	fd =3D error;
 out_upsem:
 	mutex_unlock(&ipc_ns->mq_mnt->mnt_root->d_inode->i_mutex);
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

linux-next.patch
mqueue-fix-mq_open-file-descriptor-leak-on-user-space-processes.patch
mqueue-remove-unneeded-info-messages-initialization.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation.patch
mqueue-simplify-do_open-error-handling.patch
mqueue-only-set-error-codes-if-they-are-really-necessary.patch
mqueue-fix-typo-failues-failures.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
