Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3861D4E1DB;
	Mon, 25 Mar 2024 20:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711397072; cv=none; b=RA5LdNMFEd8qwr708JdpELovYv1gBzxo7omcYa7s2RVt1AaU/p5MkNT5s9XLtRIZbPEitsYjZh7awbOp7+3mz0Y+5SNTTcx6mF837g7samE4p69j0gk1r3lCzDkmTJnadsz3Zj8WyA3YppvzkVvhE85BGG+SNtKF9pfAXFJR9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711397072; c=relaxed/simple;
	bh=eWSjoT3CGwTEhwKScYkBxtxF+DOY0q9/MwaCKjag3pQ=;
	h=Date:To:From:Subject:Message-Id; b=TvkX9hFIoylLwFBnuSrSNXRb3vRAKnpjEHnvR3T9+wJtxb6q/VrId2gqYWsZgrv90CNl+ZI4DiUt4Moh8itDXjEBuNvw0WHt5ZVLkvXTZKI0lYZaNEPw5AR70EDnUF8Tqg6X+yfB4MTzSPLTghv/FDiLVvVkBWbONA5HmFbWrI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S0YeFUn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S0YeFUn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D747C433A6;
	Mon, 25 Mar 2024 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711397070;
	bh=eWSjoT3CGwTEhwKScYkBxtxF+DOY0q9/MwaCKjag3pQ=;
	h=Date:To:From:Subject:From;
	b=S0YeFUn3i4/ImA8Mai3wLD8f9pevQ8SQjBtfd2bxBaEGTn/9jAZP30MZtHLxqSeWG
	 HfXdy7S+2KezJkezXkGhB8op9EWWrPDWyTYbzmLecUkh0XmgIk+lZ/isHBmPJse/Ff
	 tJRrg3+KjLTJ1BNb1V2pQs9VkA+rHXxV47Pa42c8=
Date: Mon, 25 Mar 2024 13:04:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterx@redhat.com,lokeshgidra@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-arm-related-issue-with-fork-after-pthread_create.patch added to mm-hotfixes-unstable branch
Message-Id: <20240325200430.9D747C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix ARM related issue with fork after pthread_create
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-arm-related-issue-with-fork-after-pthread_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-arm-related-issue-with-fork-after-pthread_create.patch

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
Subject: selftests/mm: fix ARM related issue with fork after pthread_create
Date: Mon, 25 Mar 2024 19:40:52 +0000

Following issue was observed while running the uffd-unit-tests selftest
on ARM devices. On x86_64 no issues were detected:

pthread_create followed by fork caused deadlock in certain cases wherein
fork required some work to be completed by the created thread.  Used
synchronization to ensure that created thread's start function has started
before invoking fork.

[edliaw@google.com: refactored to use atomic_bool]
Link: https://lkml.kernel.org/r/20240325194100.775052-1-edliaw@google.com
Fixes: 760aee0b71e3 ("selftests/mm: add tests for RO pinning vs fork()")
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c     |    3 +++
 tools/testing/selftests/mm/uffd-common.h     |    2 ++
 tools/testing/selftests/mm/uffd-unit-tests.c |   10 ++++++++++
 3 files changed, 15 insertions(+)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-fix-arm-related-issue-with-fork-after-pthread_create
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -18,6 +18,7 @@ bool test_uffdio_wp = true;
 unsigned long long *count_verify;
 uffd_test_ops_t *uffd_test_ops;
 uffd_test_case_ops_t *uffd_test_case_ops;
+atomic_bool ready_for_fork;
 
 static int uffd_mem_fd_create(off_t mem_size, bool hugetlb)
 {
@@ -518,6 +519,8 @@ void *uffd_poll_thread(void *arg)
 	pollfd[1].fd = pipefd[cpu*2];
 	pollfd[1].events = POLLIN;
 
+	ready_for_fork = true;
+
 	for (;;) {
 		ret = poll(pollfd, 2, -1);
 		if (ret <= 0) {
--- a/tools/testing/selftests/mm/uffd-common.h~selftests-mm-fix-arm-related-issue-with-fork-after-pthread_create
+++ a/tools/testing/selftests/mm/uffd-common.h
@@ -32,6 +32,7 @@
 #include <inttypes.h>
 #include <stdint.h>
 #include <sys/random.h>
+#include <stdatomic.h>
 
 #include "../kselftest.h"
 #include "vm_util.h"
@@ -103,6 +104,7 @@ extern bool map_shared;
 extern bool test_uffdio_wp;
 extern unsigned long long *count_verify;
 extern volatile bool test_uffdio_copy_eexist;
+extern atomic_bool ready_for_fork;
 
 extern uffd_test_ops_t anon_uffd_test_ops;
 extern uffd_test_ops_t shmem_uffd_test_ops;
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-arm-related-issue-with-fork-after-pthread_create
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -775,6 +775,8 @@ static void uffd_sigbus_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
+	ready_for_fork = false;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
@@ -790,6 +792,9 @@ static void uffd_sigbus_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
+
 	pid = fork();
 	if (pid < 0)
 		err("fork");
@@ -829,6 +834,8 @@ static void uffd_events_test_common(bool
 	char c;
 	struct uffd_args args = { 0 };
 
+	ready_for_fork = false;
+
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 	if (uffd_register(uffd, area_dst, nr_pages * page_size,
 			  true, wp, false))
@@ -838,6 +845,9 @@ static void uffd_events_test_common(bool
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
 		err("uffd_poll_thread create");
 
+	while (!ready_for_fork)
+		; /* Wait for the poll_thread to start executing before forking */
+
 	pid = fork();
 	if (pid < 0)
 		err("fork");
_

Patches currently in -mm which might be from edliaw@google.com are

selftests-mm-sigbus-wp-test-requires-uffd_feature_wp_hugetlbfs_shmem.patch
selftests-mm-fix-arm-related-issue-with-fork-after-pthread_create.patch

