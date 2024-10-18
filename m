Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C80013A244;
	Fri, 18 Oct 2024 21:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729286041; cv=none; b=igS7s6Pvdzm/qEE6btWD1yH6h3gF7vq0jkYpHySduAZwCml7aZH1uZw8MzbEwLa1vZwYmCnunx/n0QYkhYAlubfsK9zk5WgTKUFGWMQwoAT5I0fKqoB/P7IiGP2Zhh74TbzaTazsFLcZYnPY/SIpx0A9sF0+3jka0d9Wu2DuCvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729286041; c=relaxed/simple;
	bh=aWPXU+4d/rnm3/zjnaXecxHLvLD/V6AXMrQS/7+y8io=;
	h=Date:To:From:Subject:Message-Id; b=JW+xEXuzQnnWXyzNrmC7cX1BTKQE6EHsaGwoFeyNWl+gQcPm7pAgc1V8V+Bz1k8dRakz0kGOgCZkNWpysBnbLQfgZPHafCl1Zpx/OoeEp11wceKt8TUI2QMzvrNZoSmigqNZAr+1f/927BODAlCTzdzbA8wFEL1BTfS6HXuoBq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cqMVo8Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cqMVo8Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0DAC4CEC3;
	Fri, 18 Oct 2024 21:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729286041;
	bh=aWPXU+4d/rnm3/zjnaXecxHLvLD/V6AXMrQS/7+y8io=;
	h=Date:To:From:Subject:From;
	b=cqMVo8CrRqwivGkirnhinDyPo5jAMF24tKqRw4SamHlrud4qGb+OJc7FTo3VaKSQF
	 lJfRTPAjMawrfmjewdPeRi0jcTlzXrm6hYf1TP9NSDrWkFXXbD6h/WVDmW/9Bd7RkJ
	 qiTl7jFBRUTb+CV/ITvZVgnKT4DaGlPFTMpKIyvI=
Date: Fri, 18 Oct 2024 14:14:00 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch added to mm-hotfixes-unstable branch
Message-Id: <20241018211400.EC0DAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "selftests/mm: fix deadlock for fork after pthread_create on ARM"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

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
Subject: Revert "selftests/mm: fix deadlock for fork after pthread_create on ARM"
Date: Fri, 18 Oct 2024 17:17:22 +0000

Patch series "selftests/mm: revert pthread_barrier change"

On Android arm, pthread_create followed by a fork caused a deadlock in
the case where the fork required work to be completed by the created
thread.

The previous patches incorrectly assumed that the parent would
always initialize the pthread_barrier for the child thread.  This
reverts the change and replaces the fix for wp-fork-with-event with the
original use of atomic_bool.


This patch (of 3):

This reverts commit e142cc87ac4ec618f2ccf5f68aedcd6e28a59d9d.

fork_event_consumer may be called by other tests that do not initialize
the pthread_barrier, so this approach is not correct.  The subsequent
patch will revert to using atomic_bool instead.

Link: https://lkml.kernel.org/r/20241018171734.2315053-1-edliaw@google.com
Link: https://lkml.kernel.org/r/20241018171734.2315053-2-edliaw@google.com
Fixes: e142cc87ac4e ("fix deadlock for fork after pthread_create on ARM")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -241,9 +241,6 @@ static void *fork_event_consumer(void *d
 	fork_event_args *args = data;
 	struct uffd_msg msg = { 0 };
 
-	/* Ready for parent thread to fork */
-	pthread_barrier_wait(&ready_for_fork);
-
 	/* Read until a full msg received */
 	while (uffd_read_msg(args->parent_uffd, &msg));
 
@@ -311,12 +308,8 @@ static int pagemap_test_fork(int uffd, b
 
 	/* Prepare a thread to resolve EVENT_FORK */
 	if (with_event) {
-		pthread_barrier_init(&ready_for_fork, NULL, 2);
 		if (pthread_create(&thread, NULL, fork_event_consumer, &args))
 			err("pthread_create()");
-		/* Wait for child thread to start before forking */
-		pthread_barrier_wait(&ready_for_fork);
-		pthread_barrier_destroy(&ready_for_fork);
 	}
 
 	child = fork();
_

Patches currently in -mm which might be from edliaw@google.com are

revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch
revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch
selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch

