Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12871925B2;
	Thu, 17 Oct 2024 07:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150119; cv=none; b=hn9BvJ26YmiN2JvUexcPxqHRUpzfIz9kb7L0t0CELYAbwITb7jvTC3ckX0MInrYlgUP+GGDECa4upTM85LPiblflDJOEyh1+fntVzDXf/tk6kU4NoEGQSMDL+WzB3/ERrXDEWYfauMoPiXP264its5NiA4rA6Ew4kzgzzXZigaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150119; c=relaxed/simple;
	bh=Lmo/r2JU8iT/p1WVabjuLWe1nXO1BLTUmLYTeV4PlC8=;
	h=Date:To:From:Subject:Message-Id; b=jJ/WIfjbXyZSLslvNaGMFYNObElzqV8JIOgpBcINPaWfP6mIX/U5/yC3bFkukBuwMZIeCLaVYJ7DfROsJLQEqjjYc4r7+NvIeVtvLByPJWw8nbMe3BCfQ1AVQ6cpNoK/yy8DgJNggVOKN8hwsNbczZBYJihGFudyQdMvyBDMYjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TBp14FOP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TBp14FOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D04C4CEC3;
	Thu, 17 Oct 2024 07:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150118;
	bh=Lmo/r2JU8iT/p1WVabjuLWe1nXO1BLTUmLYTeV4PlC8=;
	h=Date:To:From:Subject:From;
	b=TBp14FOPuzh4w4/LxMe5JJAVSr3SJX3sTetNdKr5qrbryoo9dAXVQx4qFSK15W3qu
	 YByxyO3P7I90LKW6erYem9D0NSbmm8wOxGKRPaBhe5UAV9q76NRgT+O+sfVjoEKsDD
	 cjr+B54GPKroyFWLJIS4DnEQ2IHSYtcUrrcXx+aI=
Date: Thu, 17 Oct 2024 00:28:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,lokeshgidra@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch removed from -mm tree
Message-Id: <20241017072838.67D04C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: replace atomic_bool with pthread_barrier_t
has been removed from the -mm tree.  Its filename was
     selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: replace atomic_bool with pthread_barrier_t
Date: Thu, 3 Oct 2024 21:17:10 +0000

Patch series "selftests/mm: fix deadlock after pthread_create".

On Android arm, pthread_create followed by a fork caused a deadlock in the
case where the fork required work to be completed by the created thread.

Update the synchronization primitive to use pthread_barrier instead of
atomic_bool.

Apply the same fix to the wp-fork-with-event test.


This patch (of 2):

Swap synchronization primitive with pthread_barrier, so that stdatomic.h
does not need to be included.

The synchronization is needed on Android ARM64; we see a deadlock with
pthread_create when the parent thread races forward before the child has a
chance to start doing work.

Link: https://lkml.kernel.org/r/20241003211716.371786-1-edliaw@google.com
Link: https://lkml.kernel.org/r/20241003211716.371786-2-edliaw@google.com
Fixes: cff294582798 ("selftests/mm: extend and rename uffd pagemap test")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    5 +++--
 tools/testing/selftests/mm/uffd-common.h     |    3 +--
 tools/testing/selftests/mm/uffd-unit-tests.c |   14 ++++++++------
 3 files changed, 12 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-replace-atomic_bool-with-pthread_barrier_t
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -18,7 +18,7 @@ bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
-atomic_bool ready_for_fork;
+pthread_barrier_t ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -519,7 +519,8 @@ void *uffd_poll_thread(void *arg)
 	pollfd[1].fd = pipefd[cpu*2];
 	pollfd[1].events = POLLIN;
 
-	ready_for_fork = true;
+	/* Ready for parent thread to fork */
+	pthread_barrier_wait(&ready_for_fork);
 
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-replace-atomic_bool-with-pthread_barrier_t
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -33,7 +33,6 @@
 #include <inttypes.h>
 #include <stdint.h>
 #include <sys/random.h>
-#include <stdatomic.h>
 
 #include "../kselftest.h"
 #include "vm_util.h"
@@ -105,7 +104,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
-extern atomic_bool ready_for_fork;
+extern pthread_barrier_t ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-replace-atomic_bool-with-pthread_barrier_t
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -774,7 +774,7 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	ready_for_fork = false;
+	pthread_barrier_init(&ready_for_fork, NULL, 2);
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -791,8 +791,9 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	while (!ready_for_fork)
-		; /* Wait for the poll_thread to start executing before forking */
+	/* Wait for child thread to start before forking */
+	pthread_barrier_wait(&ready_for_fork);
+	pthread_barrier_destroy(&ready_for_fork);
 
 	pid = fork();
 	if (pid < 0)
@@ -833,7 +834,7 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	ready_for_fork = false;
+	pthread_barrier_init(&ready_for_fork, NULL, 2);
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -844,8 +845,9 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	while (!ready_for_fork)
-		; /* Wait for the poll_thread to start executing before forking */
+	/* Wait for child thread to start before forking */
+	pthread_barrier_wait(&ready_for_fork);
+	pthread_barrier_destroy(&ready_for_fork);
 
 	pid = fork();
 	if (pid < 0)
_

Patches currently in -mm which might be from edliaw@google.com are


