Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC21213A244;
	Fri, 18 Oct 2024 21:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729286042; cv=none; b=KzrpD3VSXavmYWYdZrtGdcqUcgNyj47y/oLdJCJt7woivSvdTRED+nthi3/wSNgKgUpkarvKrYedFxo8isc4MDxVxjbOHyztg47sKBYK4C2gBd85E+MMRnk3eFwUTKWPtwTtNJkD/TV2vPCeFCcyyr1vhrbK62CID5trtaw63Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729286042; c=relaxed/simple;
	bh=IYnPDUnk+qNTrxolcfnIVuM4O7wrsLiAcIhotmiAfSs=;
	h=Date:To:From:Subject:Message-Id; b=LMi99iBQ9/s+9LPfOyWHk8eIizwTYUvuTG5W8Q+U6M/RZqSwuhuz/s5jJYEd2eIdf8AMVFosWB6b+ZfW5Qpe+bP2JvWOhrMHbtqY+NGNX7leGXbBILTHX9Qw9Y2gE0Pwc5FzpxMRCOTI8VLw/PEpCTa+vtJ6HgQ69F7Z7h2eTGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NjCq2MUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NjCq2MUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABAAC4CEC3;
	Fri, 18 Oct 2024 21:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729286042;
	bh=IYnPDUnk+qNTrxolcfnIVuM4O7wrsLiAcIhotmiAfSs=;
	h=Date:To:From:Subject:From;
	b=NjCq2MUT0Teg15CpgxSs283L762FbcE0Db+6nls4xh4kEy1eSotGBQfRV1aml+Awl
	 VKQMicVEwsLuvUj/pyahGB7lbe7+F2svWWqa6/tKUPjVxuQ5EYGpYsPJXtwE5gdKbx
	 75Fr8eHl1FpQ8lZ+aYS/Xcz/lHbotquFaRWwErAQ=
Date: Fri, 18 Oct 2024 14:14:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch added to mm-hotfixes-unstable branch
Message-Id: <20241018211402.3ABAAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch
revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch
selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch

