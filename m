From: akpm@linux-foundation.org
Subject: + utimensat-non-conformances-and-fixes.patch added to -mm tree
Date: Tue, 15 Apr 2008 20:48:39 -0700
Message-ID: <200804160348.m3G3mdUo030682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760797AbYDPDtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 23:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, drepper@redhat.com, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     utimensat() non-conformances and fixes
has been added to the -mm tree.  Its filename is
     utimensat-non-conformances-and-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: utimensat() non-conformances and fixes
From: Michael Kerrisk <mtk.manpages@googlemail.com>

While writing a man page for utimensat(2) and futimens(3), I think I've found
a few bugs in the utimensat() system call (i.e., non-conformances with either
the specification in the draft POSIX.1-200x revision or traditional Linux
behavior).

       int utimensat(int dirfd, const char *pathname,
                     const struct timespec times[2], int flags);

1.  The draft POSIX.1-200x specification for utimensat() says that if a
   times[n].tv_nsec field is UTIME_OMIT or UTIME_NOW, then the value in the
   corresponding tv_sec field is ignored.  However the current Linux
   implementation requires the tv_sec value to be zero (or the EINVAL error
   results).  This requirement should be removed.

2.  The POSIX.1 draft says that to do anything other than setting both
   timestamps to a time other than the current time (i.e., times is not NULL,
   and both tv_nsec fields are not UTIME_NOW and both tv_nsec fields are not
   UTIME_OMIT -- see lines 32400 to 32403 of draft 5 of the spec), either: the
   caller's effective user ID must match the owner of the file; or the caller
   must have appropriate privileges.  If this condition is violated, then the
   error EPERM results.  However, the current implementation does not generate
   EPERM if one tv_nsec field is UTIME_NOW while the other is UTIME_OMIT -- it
   should give this error for that case.

3.  Traditionally, utime()/utimes() gives the error EACCES for the case
   where the timestamp pointer argument is NULL (i.e., set both timestamps to
   the current time), and the file is owned by a user other than the effective
   UID of the caller, and the file is not writable by the effective UID of the
   program.  utimensat() also gives this error in the same case.  However, in
   the same circumstances, when utimensat() is given a 'times' array in which
   both tv_nsec fields are UTIME_NOW, which provides equivalent functionality
   to specifying 'times' as NULL, the call succeeds.  I think that it should
   fail with the error EACCES in this case.

4.  A further bug relates to traditional Linux behavior.  Traditionally
   (i.e., utime(2) and utimes(2)), the EPERM error could also occur if the
   'times' argument was non-NULL (i.e., we are setting the timestamps to a
   value other than the current time) and the file is marked as immutable or
   append-only.  The current implementation also returns this error if 'times'
   is non-NULL and the tv_nsec fields are both UTIME_NOW.  For consistency,
   the

   (times == NULL && times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec ==
   UTIME_NOW)

   case should be treated like the traditional utimes() case where 'times'
   is NULL.  That is, the call should succeed for a file marked append-only
   and should give the error EACCES if the file is marked as immutable.

The first part of the patch below addresses bugs 2, 3, and 4 and the second
part of the patch addresses bug 1.

Below is a command-line-driven test program that can be used to test the
current implementation, and my patch.  Some test cases below demonstrate the 4
cases described above, showing how a vanilla 2.6.25-rcN kernel behaves, and
how it behaves with my patch applied.

Finally, with my patch applied, I believe that the following lines could be
removed from the sys_utimensat() routine (I've done some light testing to
verify this, but more testing would be in order):

                /* Nothing to do, we must not even check the path.  */
                if (tstimes[0].tv_nsec == UTIME_OMIT &&
                    tstimes[1].tv_nsec == UTIME_OMIT)
                        return 0;


Test cases
==========

All test cases run as user 'mtk'

Bug 1
-----

Behavior with vanilla 2.6.25-rcN kernel:

$ ls -l u
-r-------- 1 mtk users 0 Apr  7 21:39 u
$ ./t_utimensat u 1 n 1 n
dirfd is -100
pathname is u
tsp is 0xbfb41408; struct  = { 1, 1073741823 } { 1, 1073741823 }
flags is 0
utimensat: Invalid argument

Behavior with my patch applied:

$ ls -l u
-r-------- 1 mtk users 0 Apr  7 21:39 u
$ ./t_utimensat u 1 n 1 n
dirfd is -100
pathname is u
tsp is 0xbfab7378; struct  = { 1, 1073741823 } { 1, 1073741823 }
flags is 0
utimensat() succeeded
Last file access:         Mon Apr  7 21:39:36 2008
Last file modification:   Mon Apr  7 21:39:36 2008
Last status change:       Mon Apr  7 21:39:36 2008

Bug 2
-----

Behavior with vanilla 2.6.25-rcN kernel:

$ ls -l p
-rw-r--r-- 1 root root 0 Apr  7 10:34 p
$ ./t_utimensat p 0 n 0 o
dirfd is -100
pathname is p
tsp is 0xbfb7ac38; struct  = { 0, 1073741823 } { 0, 1073741822 }
flags is 0
utimensat() succeeded
Last file access:         Mon Apr  7 22:00:51 2008
Last file modification:   Mon Apr  7 10:34:00 2008
Last status change:       Mon Apr  7 22:00:51 2008

Behavior with my patch applied:

$ ls -l p
-rw-r--r-- 1 root root 0 Apr  7 10:34 p
$ ./t_utimensat p 0 n 0 o
dirfd is -100
pathname is p
tsp is 0xbfc40d08; struct  = { 1, 1073741823 } { 1, 1073741822 }
flags is 0
utimensat failed with EPERM

Bug 3
-----

Behavior with vanilla 2.6.25-rcN kernel:

$ ls -l p
-rw-r--r-- 1 root root 0 Apr  7 22:03 p
$ ./t_utimensat p 0 n 0 n
dirfd is -100
pathname is p
tsp is 0xbfd99658; struct  = { 0, 1073741823 } { 0, 1073741823 }
flags is 0
utimensat() succeeded
Last file access:         Mon Apr  7 22:03:31 2008
Last file modification:   Mon Apr  7 22:03:31 2008
Last status change:       Mon Apr  7 22:03:31 2008
$ ./t_utimensat p
dirfd is -100
pathname is p
tsp is (nil)
flags is 0
utimensat failed with EACCES

Behavior with my patch applied:

$ ls -l p
-rw-r--r-- 1 root root 0 Apr  7 10:34 p
$ ./t_utimensat p 0 n 0 n
dirfd is -100
pathname is p
tsp is 0xbfa98358; struct  = { 0, 1073741823 } { 0, 1073741823 }
flags is 0
utimensat failed with EACCES
$ ./t_utimensat p
dirfd is -100
pathname is p
tsp is (nil)
flags is 0
utimensat failed with EACCES

Bug 4
-----

Behavior with vanilla 2.6.25-rcN kernel:

$ ls -l fa fi
-rw-r--r-- 1 mtk users 0 Apr  7 21:43 fa
-rw-r--r-- 1 mtk users 0 Apr  7 09:11 fi
$ lsattr -l fa fi
fa                           Append_Only
fi                           Immutable
$ ./t_utimensat fa 0 n 0 n
dirfd is -100
pathname is fa
tsp is 0xbfc43508; struct  = { 0, 1073741823 } { 0, 1073741823 }
flags is 0
utimensat failed with EPERM
$ ./t_utimensat fi 0 n 0 n
dirfd is -100
pathname is fi
tsp is 0xbfb54c18; struct  = { 0, 1073741823 } { 0, 1073741823 }
flags is 0
utimensat failed with EPERM

Behavior with my patch applied:

$ ls -l fa fi
-rw-r--r-- 1 mtk users 0 Apr  7 18:24 fa
-rw-r--r-- 1 mtk users 0 Apr  7 09:11 fi
$ lsattr -l fa fi
fa                           Append_Only
fi                           Immutable
$ ./t_utimensat fa 0 n 0 n
dirfd is -100
pathname is fa
tsp is 0xbfa7e338; struct  = { 0, 1073741823 } { 0, 1073741823 }
flags is 0
utimensat() succeeded
Last file access:         Mon Apr  7 21:43:23 2008
Last file modification:   Mon Apr  7 21:43:23 2008
Last status change:       Mon Apr  7 21:43:23 2008
$ ./t_utimensat fi 0 n 0 n
dirfd is -100
pathname is fi
tsp is 0xbfe8d748; struct  = { 0, 1073741823 } { 0, 1073741823 }
flags is 0
utimensat failed with EACCES

==================================================

/* t_utimensat.c

   Copyright (C) 2008, Michael Kerrisk <mtk.manpages@gmail.com>

   Licensed under the GPLv2 or later.

   A command-line interface for testing the utimensat() system
   call.

   17 Mar 2008  Initial creation
*/
#define _GNU_SOURCE
#define _ATFILE_SOURCE
#include <stdio.h>
#include <time.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)


#define __NR_utimensat          320     /* x86 syscall number */

# define UTIME_NOW      ((1l << 30) - 1l)
# define UTIME_OMIT     ((1l << 30) - 2l)

static inline int
utimensat(int dirfd, const char *pathname,
          const struct timespec times[2], int flags)
{
    return syscall(__NR_utimensat, dirfd, pathname, times, flags);
}

static void
usageError(char *progName)
{
    fprintf(stderr, "Usage: %s pathname [atime-sec "
            "atime-nsec mtime-sec mtime-nsec]\n\n", progName);
    fprintf(stderr, "Permitted options are:\n");
    fprintf(stderr, "    [-d path] "
            "open a directory file descriptor"
            " (instead of using AT_FDCWD)\n");
    fprintf(stderr, "    -w        Open directory file "
            "descriptor with O_RDWR (instead of O_RDONLY)\n");
    fprintf(stderr, "    -n        Use AT_SYMLINK_NOFOLLOW\n");
    fprintf(stderr, "\n");

    fprintf(stderr, "pathname can be \"NULL\" to use NULL "
            "argument in call\n");
    fprintf(stderr, "\n");

    fprintf(stderr, "Either nsec field can be\n");
    fprintf(stderr, "    'n' for UTIME_NOW\n");
    fprintf(stderr, "    'o' for UTIME_OMIT\n");
    fprintf(stderr, "\n");

    fprintf(stderr, "If the time fields are omitted, "
            "then a NULL 'times' argument is used\n");
    fprintf(stderr, "\n");

    exit(EXIT_FAILURE);
}

int
main(int argc, char *argv[])
{
    int flags, dirfd, opt, oflag;
    struct timespec ts[2];
    struct timespec *tsp;
    char *pathname, *dirfdPath;
    struct stat sb;

    flags = 0;
    dirfd = AT_FDCWD;
    dirfdPath = NULL;
    oflag = O_RDONLY;

    while ((opt = getopt(argc, argv, "d:nw")) != -1) {
        switch (opt) {
        case 'd':
            dirfdPath = optarg;
            break;

        case 'n':
            flags |= AT_SYMLINK_NOFOLLOW;
            printf("Not following symbolic links\n");
            break;

        case 'w':
            oflag = O_RDWR;
            break;

        default:
            usageError(argv[0]);
        }
    }

    if ((optind + 5 != argc) && (optind + 1 != argc))
        usageError(argv[0]);

    if (dirfdPath != NULL) {
        dirfd = open(dirfdPath, oflag);
        if (dirfd == -1) errExit("open");

        printf("Opened dirfd");
        printf(" O_RDWR");
        printf(": %s\n", dirfdPath);
    }

    pathname = (strcmp(argv[optind], "NULL") == 0) ?
                        NULL : argv[optind];

    if (argc == optind + 1) {
        tsp = NULL;

    } else {
        ts[0].tv_sec = atoi(argv[optind + 1]);
        if (argv[optind + 2][0] == 'n') {
            ts[0].tv_nsec = UTIME_NOW;
        } else if (argv[optind + 2][0] == 'o') {
            ts[0].tv_nsec = UTIME_OMIT;
        } else {
            ts[0].tv_nsec = atoi(argv[optind + 2]);
        }

        ts[1].tv_sec = atoi(argv[optind + 3]);
        if (argv[optind + 4][0] == 'n') {
            ts[1].tv_nsec = UTIME_NOW;
        } else if (argv[optind + 4][0] == 'o') {
            ts[1].tv_nsec = UTIME_OMIT;
        } else {
            ts[1].tv_nsec = atoi(argv[optind + 4]);
        }

        tsp = ts;
    }

    /* For testing purposes, it may have been useful to run this
       program as set-user-ID-root so that a directory file
       descriptor could be opened as root.  Now we reset to the
       real UID before making the utimensat() call, so that the
       permission checking is performed under that UID. */

    if (geteuid() == 0) {
        uid_t u;

        u = getuid();

        printf("Resettng UIDs to %ld\n", (long) u);

        if (setresuid(u, u, u) == -1)
            errExit("setresuid");
    }

    printf("dirfd is %d\n", dirfd);
    printf("pathname is %s\n", pathname);
    printf("tsp is %p", tsp);
    if (tsp != NULL) {
        printf("; struct  = { %ld, %ld } { %ld, %ld }",
                (long) tsp[0].tv_sec, (long) tsp[0].tv_nsec,
                (long) tsp[1].tv_sec, (long) tsp[1].tv_nsec);
    }
    printf("\n");
    printf("flags is %d\n", flags);

    if (utimensat(dirfd, pathname, tsp, flags) == -1) {
        if (errno == EPERM)
            printf("utimensat failed with EPERM\n");
        else if (errno == EACCES)
            printf("utimensat failed with EACCES\n");
        else
            perror("utimensat");
        exit(EXIT_FAILURE);
    }

    printf("utimensat() succeeded\n");

    if (stat(pathname, &sb) == -1) errExit("stat");
    printf("Last file access:         %s", ctime(&sb.st_atime));
    printf("Last file modification:   %s", ctime(&sb.st_mtime));
    printf("Last status change:       %s", ctime(&sb.st_ctime));

    exit(EXIT_SUCCESS);
}

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN fs/utimes.c~utimensat-non-conformances-and-fixes fs/utimes.c
--- a/fs/utimes.c~utimensat-non-conformances-and-fixes
+++ a/fs/utimes.c
@@ -99,27 +99,37 @@ long do_utimes(int dfd, char __user *fil
 
 	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
-	if (times) {
+	if (times && ! ((times[0].tv_nsec == UTIME_NOW &&
+			 times[1].tv_nsec == UTIME_NOW) ||
+			(times[0].tv_nsec == UTIME_OMIT &&
+			 times[1].tv_nsec == UTIME_OMIT))) {
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto mnt_drop_write_and_out;
+                        goto mnt_drop_write_and_out;
 
-		if (times[0].tv_nsec == UTIME_OMIT)
-			newattrs.ia_valid &= ~ATTR_ATIME;
-		else if (times[0].tv_nsec != UTIME_NOW) {
+		if (times[0].tv_nsec == UTIME_OMIT) {
+			newattrs.ia_atime = inode->i_atime;
+			newattrs.ia_valid |= ATTR_ATIME_SET;
+		} else if (times[0].tv_nsec != UTIME_NOW) {
 			newattrs.ia_atime.tv_sec = times[0].tv_sec;
 			newattrs.ia_atime.tv_nsec = times[0].tv_nsec;
 			newattrs.ia_valid |= ATTR_ATIME_SET;
 		}
 
-		if (times[1].tv_nsec == UTIME_OMIT)
-			newattrs.ia_valid &= ~ATTR_MTIME;
-		else if (times[1].tv_nsec != UTIME_NOW) {
+		if (times[1].tv_nsec == UTIME_OMIT) {
+			newattrs.ia_mtime = inode->i_mtime;
+			newattrs.ia_valid |= ATTR_MTIME_SET;
+		} else if (times[1].tv_nsec != UTIME_NOW) {
 			newattrs.ia_mtime.tv_sec = times[1].tv_sec;
 			newattrs.ia_mtime.tv_nsec = times[1].tv_nsec;
 			newattrs.ia_valid |= ATTR_MTIME_SET;
 		}
+
+	} else if (unlikely(times && times[0].tv_nsec == UTIME_OMIT &&
+			times[1].tv_nsec == UTIME_OMIT)) {
+		newattrs.ia_valid &= ~(ATTR_ATIME | ATTR_MTIME | ATTR_CTIME);
 	} else {
+		/* times is NULL, or both tv_nsec fields are UTIME_NOW */
 		error = -EACCES;
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
@@ -156,14 +166,6 @@ asmlinkage long sys_utimensat(int dfd, c
 	if (utimes) {
 		if (copy_from_user(&tstimes, utimes, sizeof(tstimes)))
 			return -EFAULT;
-		if ((tstimes[0].tv_nsec == UTIME_OMIT ||
-		     tstimes[0].tv_nsec == UTIME_NOW) &&
-		    tstimes[0].tv_sec != 0)
-			return -EINVAL;
-		if ((tstimes[1].tv_nsec == UTIME_OMIT ||
-		     tstimes[1].tv_nsec == UTIME_NOW) &&
-		    tstimes[1].tv_sec != 0)
-			return -EINVAL;
 
 		/* Nothing to do, we must not even check the path.  */
 		if (tstimes[0].tv_nsec == UTIME_OMIT &&
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

x86-ptrace-pebs-support.patch
add-rusage_thread.patch
utimensat-non-conformances-and-fixes.patch

