From: akpm@linux-foundation.org
Subject: [merged] fix-compat_sys_utimensat.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:23 -0700
Message-ID: <200909231953.n8NJrNFR031069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbZIWTyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@in.ibm.com, drepper@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix compat_sys_utimensat()
has been removed from the -mm tree.  Its filename was
     fix-compat_sys_utimensat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix compat_sys_utimensat()
From: Suzuki Poulose <suzuki@in.ibm.com>

Compat utimensat() returns EINVAL when the tv_nsec is one of UTIME_OMIT or
UTIME_NOW and the tv_sec is set to non-zero.  As per man pages, the tv_sec
field should be ignored.

sys_utimensat() works fine in this case.


Test case:

#define _GNU_SOURCE
#define _ATFILE_SOURCE
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdlib.h>

main(int argc, char *argv[])
{
	struct timespec ts[2];
	struct timespec *tsp;
	
	if (argc < 2) {
		fprintf(stderr, "Usage : %s filename\n", argv[0]);
		exit (-1);
	}
	
	ts[0].tv_nsec = ts[1].tv_nsec = UTIME_NOW;
	ts[0].tv_sec = ts[1].tv_sec = 1;

	tsp = ts;
	
	if (utimensat(AT_FDCWD, argv[1],tsp,0) == -1)
		perror("utimensat");
	else
		fprintf(stdout, "utimensat success\n");
	return 0;
}
mjs22lp5:~ # cc -m64 utimensat-test.c -o utimensat_test64
mjs22lp5:~ # cc -m32 utimensat-test.c -o utimensat_test32
mjs22lp5:~ # ./utimensat_test32 /tmp/utimensat_test
utimensat: Invalid argument
mjs22lp5:~ # ./utimensat_test64 /tmp/utimensat_test
utimensat success
mjs22lp5:~ # uname -r
2.6.31-rc8

With the patch :

mjs22lp5:~ # ./utimensat_test64 /tmp/utimensat_test
utimensat success
mjs22lp5:~ # ./utimensat_test32 /tmp/utimensat_test
utimensat success
mjs22lp5:~ # uname -r
2.6.31-rc8utimensat

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/compat.c~fix-compat_sys_utimensat fs/compat.c
--- a/fs/compat.c~fix-compat_sys_utimensat
+++ a/fs/compat.c
@@ -100,13 +100,6 @@ asmlinkage long compat_sys_utimensat(uns
 		    get_compat_timespec(&tv[1], &t[1]))
 			return -EFAULT;
 
-		if ((tv[0].tv_nsec == UTIME_OMIT || tv[0].tv_nsec == UTIME_NOW)
-		    && tv[0].tv_sec != 0)
-			return -EINVAL;
-		if ((tv[1].tv_nsec == UTIME_OMIT || tv[1].tv_nsec == UTIME_NOW)
-		    && tv[1].tv_sec != 0)
-			return -EINVAL;
