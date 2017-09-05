From: akpm@linux-foundation.org
Subject: + toolsselftest-kcmp-add-kcmp_epoll_tfd-testing.patch added to
 -mm tree
Date: Tue, 05 Sep 2017 16:45:09 -0700
Message-ID: <59af3705.rNfR8JWky2qmbhWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43032 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbdIEXpK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2017 19:45:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, avagin@openvz.org, gorcunov@openvz.org, mtk.manpages@gmail.com, shuah@kernel.org, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/kcmp/kcmp_test.c: add KCMP_EPOLL_TFD testing
has been added to the -mm tree.  Its filename is
     toolsselftest-kcmp-add-kcmp_epoll_tfd-testing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/toolsselftest-kcmp-add-kcmp_epoll_tfd-testing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/toolsselftest-kcmp-add-kcmp_epoll_tfd-testing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: tools/testing/selftests/kcmp/kcmp_test.c: add KCMP_EPOLL_TFD testing

KCMP's KCMP_EPOLL_TFD mode merged in commit 0791e3644e5ef2 ("kcmp: add
KCMP_EPOLL_TFD mode to compare epoll target files") we've had no selftest
for it yet (except in criu development list).  Thus add it.

Link: http://lkml.kernel.org/r/20170901151620.GK1898@uranus.lan
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/kcmp_test.c |   60 ++++++++++++++++++++-
 1 file changed, 58 insertions(+), 2 deletions(-)

diff -puN tools/testing/selftests/kcmp/kcmp_test.c~toolsselftest-kcmp-add-kcmp_epoll_tfd-testing tools/testing/selftests/kcmp/kcmp_test.c
--- a/tools/testing/selftests/kcmp/kcmp_test.c~toolsselftest-kcmp-add-kcmp_epoll_tfd-testing
+++ a/tools/testing/selftests/kcmp/kcmp_test.c
@@ -8,7 +8,6 @@
 #include <errno.h>
 #include <string.h>
 #include <fcntl.h>
-
 #include <linux/unistd.h>
 #include <linux/kcmp.h>
 
@@ -16,20 +15,28 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <sys/epoll.h>
 
 #include "../kselftest.h"
 
-static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
+static long sys_kcmp(int pid1, int pid2, int type, unsigned long fd1, unsigned long fd2)
 {
 	return syscall(__NR_kcmp, pid1, pid2, type, fd1, fd2);
 }
 
+static const unsigned int duped_num = 64;
+
 int main(int argc, char **argv)
 {
 	const char kpath[] = "kcmp-test-file";
+	struct kcmp_epoll_slot epoll_slot;
+	struct epoll_event ev;
 	int pid1, pid2;
+	int pipefd[2];
 	int fd1, fd2;
+	int epollfd;
 	int status;
+	int fddup;
 
 	fd1 = open(kpath, O_RDWR | O_CREAT | O_TRUNC, 0644);
 	pid1 = getpid();
@@ -39,6 +46,37 @@ int main(int argc, char **argv)
 		ksft_exit_fail();
 	}
 
+	if (pipe(pipefd)) {
+		perror("Can't create pipe");
+		ksft_exit_fail();
+	}
+
+	epollfd = epoll_create1(0);
+	if (epollfd < 0) {
+		perror("epoll_create1 failed");
+		ksft_exit_fail();
+	}
+
+	memset(&ev, 0xff, sizeof(ev));
+	ev.events = EPOLLIN | EPOLLOUT;
+
+	if (epoll_ctl(epollfd, EPOLL_CTL_ADD, pipefd[0], &ev)) {
+		perror("epoll_ctl failed");
+		ksft_exit_fail();
+	}
+
+	fddup = dup2(pipefd[1], duped_num);
+	if (fddup < 0) {
+		perror("dup2 failed");
+		ksft_exit_fail();
+	}
+
+	if (epoll_ctl(epollfd, EPOLL_CTL_ADD, fddup, &ev)) {
+		perror("epoll_ctl failed");
+		ksft_exit_fail();
+	}
+	close(fddup);
+
 	pid2 = fork();
 	if (pid2 < 0) {
 		perror("fork failed");
@@ -88,6 +126,24 @@ int main(int argc, char **argv)
 		if (ret) {
 			printf("FAIL: 0 expected but %d returned (%s)\n",
 				ret, strerror(errno));
+			ksft_inc_fail_cnt();
+			ret = -1;
+		} else {
+			printf("PASS: 0 returned as expected\n");
+			ksft_inc_pass_cnt();
+		}
+
+		/* Compare epoll target */
+		epoll_slot = (struct kcmp_epoll_slot) {
+			.efd	= epollfd,
+			.tfd	= duped_num,
+			.toff	= 0,
+		};
+		ret = sys_kcmp(pid1, pid1, KCMP_EPOLL_TFD, pipefd[1],
+			       (unsigned long)(void *)&epoll_slot);
+		if (ret) {
+			printf("FAIL: 0 expected but %d returned (%s)\n",
+				ret, strerror(errno));
 			ksft_inc_fail_cnt();
 			ret = -1;
 		} else {
_

Patches currently in -mm which might be from gorcunov@gmail.com are

toolsselftest-kcmp-add-kcmp_epoll_tfd-testing.patch

