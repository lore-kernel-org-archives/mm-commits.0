From: akpm@linux-foundation.org
Subject: [patch 085/142] userfaultfd: non-cooperative: selftest: introduce userfaultfd_open
Date: Wed, 22 Feb 2017 15:44:01 -0800
Message-ID: <58ae2241.FJCljEcbPA7O4sFA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934046AbdBVXoC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: selftest: introduce userfaultfd_open

userfaultfd_open will be needed by the non cooperative selftest.

Link: http://lkml.kernel.org/r/20161216144821.5183-39-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |   41 ++++++++++++---------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-non-cooperative-selftest-introduce-userfaultfd_open
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -81,7 +81,7 @@ static int huge_fd;
 static char *huge_fd_off0;
 #endif
 static unsigned long long *count_verify;
-static int uffd, finished, *pipefd;
+static int uffd, uffd_flags, finished, *pipefd;
 static char *area_src, *area_dst;
 static char *zeropage;
 pthread_attr_t attr;
@@ -512,23 +512,9 @@ static int stress(unsigned long *userfau
 	return 0;
 }
 
-static int userfaultfd_stress(void)
+static int userfaultfd_open(void)
 {
-	void *area;
-	char *tmp_area;
-	unsigned long nr;
-	struct uffdio_register uffdio_register;
 	struct uffdio_api uffdio_api;
-	unsigned long cpu;
-	int uffd_flags, err;
-	unsigned long userfaults[nr_cpus];
-
-	allocate_area((void **)&area_src);
-	if (!area_src)
-		return 1;
-	allocate_area((void **)&area_dst);
-	if (!area_dst)
-		return 1;
 
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
 	if (uffd < 0) {
@@ -549,6 +535,29 @@ static int userfaultfd_stress(void)
 		return 1;
 	}
 
+	return 0;
+}
+
+static int userfaultfd_stress(void)
+{
+	void *area;
+	char *tmp_area;
+	unsigned long nr;
+	struct uffdio_register uffdio_register;
+	unsigned long cpu;
+	int err;
+	unsigned long userfaults[nr_cpus];
+
+	allocate_area((void **)&area_src);
+	if (!area_src)
+		return 1;
+	allocate_area((void **)&area_dst);
+	if (!area_dst)
+		return 1;
+
+	if (userfaultfd_open() < 0)
+		return 1;
+
 	count_verify = malloc(nr_pages * sizeof(unsigned long long));
 	if (!count_verify) {
 		perror("count_verify");
_
