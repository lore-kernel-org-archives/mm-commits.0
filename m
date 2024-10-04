Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FF91798C;
	Fri,  4 Oct 2024 23:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728086008; cv=none; b=spLiowspnYPeGVnoujUg4eKjq8lKsBfypIxrynUIhjFtCiCUeCpHJ+7hw5UMacFGV68Q783xnzKj6FEgo1C6QHW4QLn9xMr02tesj2RFMv//h2yTRuHODhtYzq30WhKQxPUj9DB5A/pUaV+1zASbyZyuYq4bQGvsTPe9xiImX8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728086008; c=relaxed/simple;
	bh=BebjlxX63Ovteg5+08eKIibagH8b/OwE48M4xmNgEiA=;
	h=Date:To:From:Subject:Message-Id; b=sFV+asVz4/X5A5VFACr3ZrHyVG9OjSK4SATdzQN9xpXJBGfHsY7Wiu7Zjn68hYX/8GDxhLONdA9jBvZHlBjaLDyPS/qEkn5p/8Jh8WoiJzjttIMa134N3Q2e7+8Hfj5Yy8v6l/gNFD5+HSDNW07tc0VuJ8Gn5TI7/pB14uo2Fxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ewAf2e6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ewAf2e6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB24C4CEC6;
	Fri,  4 Oct 2024 23:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728086008;
	bh=BebjlxX63Ovteg5+08eKIibagH8b/OwE48M4xmNgEiA=;
	h=Date:To:From:Subject:From;
	b=ewAf2e6NF9/ZP4tQ8UCqBSWrgyXMeAt9+U1UnFEQmf5USWI++YmX+xMN0zAMqdRUd
	 gH2e873miHp13vSVkHpeZzIz8U7ll20HnFAZz87mYuTwLQfeoDJ2VUPBAd3WJtBrkr
	 f/T1hoE4uH1xsQTn1WAGNcWOpYLwBUt1Zk/gaj0U=
Date: Fri, 04 Oct 2024 16:53:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,lokeshgidra@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch added to mm-hotfixes-unstable branch
Message-Id: <20241004235328.1DB24C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: replace atomic_bool with pthread_barrier_t
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch

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
Fixes: 8c864371b2a1 ("selftests/mm: fix ARM related issue with fork after
pthread_create")
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

selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch
selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

