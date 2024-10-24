Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F92216F287;
	Thu, 24 Oct 2024 06:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750536; cv=none; b=VzmAMp4ysH64Eqch3Q3Az9vV3C+7k6S3Xot1b/aarjKwJim2RFdePH6UVr3ZX2H3uSj+AKCfAic1uo6/coM6ZyW8kcHHUO5nTCUYEq4HR9SibKiI6SPNFdm2giNktTtF4uOvCXwCSfjgRVPn0lK6JDkXUEIsFwMqtu5YIp2zZxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750536; c=relaxed/simple;
	bh=wnhJsEdeEWgXDS0fH/6WKrC766W7WpXnqmY7fpRFI4I=;
	h=Date:To:From:Subject:Message-Id; b=DChTbM/uOz53Mj2O1oSn+KiUKjykasYHQ9rHn8VL4qGEutPyeoGGClFMK/Y4ULTkdGAhnC9p8Jlw7WYMvy0qF0LRbgbnzLtjlivEMWOd7F8ww7zUE8LVteCLuPEEGBpRrscnOOerIgw3Z2nfn5wyJxwQb1lFmIyTN3SbpSTLBes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+4sg5o3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+4sg5o3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7C2C4CEC7;
	Thu, 24 Oct 2024 06:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750536;
	bh=wnhJsEdeEWgXDS0fH/6WKrC766W7WpXnqmY7fpRFI4I=;
	h=Date:To:From:Subject:From;
	b=C+4sg5o3mgC5N4hNyx/nbidxcta2LwPzv2bSIAZXq8XyxxqbbHgM6q7LHzAFznY1O
	 6B3QSRDPUTKM4cIRYnBuSm/SS25i02VdVMKAV7qX/V5edqvabPhEqy+bryCthb8c8i
	 a+NOtlmb8n6YpbUprj3uHyja8+8kjVhdkNfTxs94=
Date: Wed, 23 Oct 2024 23:15:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch removed from -mm tree
Message-Id: <20241024061536.6B7C2C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "selftests/mm: fix deadlock for fork after pthread_create on ARM"
has been removed from the -mm tree.  Its filename was
     revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


