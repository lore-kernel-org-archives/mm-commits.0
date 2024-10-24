Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81D2176ABA;
	Thu, 24 Oct 2024 06:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750537; cv=none; b=t+uS+mWfWXysWMtm0qQW+Dg8OEvgoMq0RM3DoX731IQ1e7vh1QHvTO8YZrwwjeChedsnFCxyPHblPgCWnbtFyllf1yPtrV+PxZ5/MgJIuylu+4ZpG6zGUQaCbIrfbWP83bVt0be6ZbXn5rHFKteoBWd34ZbJned55anQMKgLyJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750537; c=relaxed/simple;
	bh=Oj6gZU+WX5fmOrbMmVPoPOkRucRKAOcybHNMK/C8B44=;
	h=Date:To:From:Subject:Message-Id; b=RvVVAUXtUEvZmYZE2SbWbezXimlgZq0/epTW7lYiitiZfB8ptwOxhcmwvG9ui47U3Zd92EpjCaojqWsn1IJCy6rsGoPa8Llbn/z5ZUVmi1HU45iUipZ0PTDmJsZsQzr9KiowBT8Se17kTKXm7VG4TBn/YrZggzhD3LmE+VVnvP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dBn4PTtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dBn4PTtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E261C4CECC;
	Thu, 24 Oct 2024 06:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750537;
	bh=Oj6gZU+WX5fmOrbMmVPoPOkRucRKAOcybHNMK/C8B44=;
	h=Date:To:From:Subject:From;
	b=dBn4PTttLryUqeZZrovV0R8s/bd/ixXsT8DpcAJ7eYyGQGBtCaathqAOvarW5kKDL
	 pbgteYHnv9l7tzeYAfIeej8+woUxynTku92BR/D7eqOCesu0rH0IlGmIsJq8G2TiP9
	 dXqkv7MZ/9PGdQEgmYpuYyJ/rAA0b1014w/sIQns=
Date: Wed, 23 Oct 2024 23:15:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch removed from -mm tree
Message-Id: <20241024061537.7E261C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"
has been removed from the -mm tree.  Its filename was
     revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"
Date: Fri, 18 Oct 2024 17:17:23 +0000

This reverts commit e61ef21e27e8deed8c474e9f47f4aa7bc37e138c.

uffd_poll_thread may be called by other tests that do not initialize the
pthread_barrier, so this approach is not correct.  This will revert to
using atomic_bool instead.

Link: https://lkml.kernel.org/r/20241018171734.2315053-3-edliaw@google.com
Fixes: e61ef21e27e8 ("selftests/mm: replace atomic_bool with pthread_barrier_t")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    5 ++---
 tools/testing/selftests/mm/uffd-common.h     |    3 ++-
 tools/testing/selftests/mm/uffd-unit-tests.c |   14 ++++++--------
 3 files changed, 10 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/uffd-common.c~revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -18,7 +18,7 @@ bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
-pthread_barrier_t ready_for_fork;
+atomic_bool ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -519,8 +519,7 @@ void *uffd_poll_thread(void *arg)
 	pollfd[1].fd = pipefd[cpu*2];
 	pollfd[1].events = POLLIN;
 
-	/* Ready for parent thread to fork */
-	pthread_barrier_wait(&ready_for_fork);
+	ready_for_fork = true;
 
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
--- a/tools/testing/selftests/mm/uffd-common.h~revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -33,6 +33,7 @@
 #include <inttypes.h>
 #include <stdint.h>
 #include <sys/random.h>
+#include <stdatomic.h>
 
 #include "../kselftest.h"
 #include "vm_util.h"
@@ -104,7 +105,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
-extern pthread_barrier_t ready_for_fork;
+extern atomic_bool ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -774,7 +774,7 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	pthread_barrier_init(&ready_for_fork, NULL, 2);
+	ready_for_fork = false;
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
@@ -791,9 +791,8 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	/* Wait for child thread to start before forking */
-	pthread_barrier_wait(&ready_for_fork);
-	pthread_barrier_destroy(&ready_for_fork);
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
 
 	pid = fork();
 	if (pid < 0)
@@ -834,7 +833,7 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
-	pthread_barrier_init(&ready_for_fork, NULL, 2);
+	ready_for_fork = false;
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -845,9 +844,8 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
-	/* Wait for child thread to start before forking */
-	pthread_barrier_wait(&ready_for_fork);
-	pthread_barrier_destroy(&ready_for_fork);
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
 
 	pid = fork();
 	if (pid < 0)
_

Patches currently in -mm which might be from edliaw@google.com are


