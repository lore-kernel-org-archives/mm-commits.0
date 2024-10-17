Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32E11925B2;
	Thu, 17 Oct 2024 07:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150119; cv=none; b=TaWm7z9rPiqZZDnvdLF6W3NftCVeAbUsXj+15JACzY1LtJDO4khyjYfQxpOBlKw0N5svtDuC0ZV/k6+vi/eOQ1Ez16m8qVEAg3f7QUd0XbHVx+lnN624P/Z4rqLfp27W25A/UoskW1UWNudi+UcHDpJCJkFxAvWvTBM//hHc8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150119; c=relaxed/simple;
	bh=1LTRaUlQaCmHMjebxf4riJToDxAIxvyEE1Su5aMn9gc=;
	h=Date:To:From:Subject:Message-Id; b=A+2Q58JKF6F7VxfB1lUZX+4kp9VmJZjhfT8AhaqPatcZojFqRjF0P/8rx+1HMZK79F4GraiVv3rrGE/3DZEDE9c44C0qM7zEqGENdJg3XGFPYQW21SFVlWhWGyQu7puQt8nKz2lTMaH0FvBJLx8cBvckHTlsCmDJAA4668LTN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZUD6RAIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZUD6RAIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85953C4CEC5;
	Thu, 17 Oct 2024 07:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150119;
	bh=1LTRaUlQaCmHMjebxf4riJToDxAIxvyEE1Su5aMn9gc=;
	h=Date:To:From:Subject:From;
	b=ZUD6RAIKf9Wk5g+QB1a2gW9adx/oU1rsvdgrSj/r+LNYgF9nD1i7+5SLHgUDgt1NP
	 AJr/fpXsERGfp6T7ZsWvBuMIGGkn4B/32D4YeTTKAixk87jZ6DLlSEwmcev43DiAsP
	 pumK2hP8q+0//gYwjEqvnXze6zjCeqpADQ8utJ3A=
Date: Thu, 17 Oct 2024 00:28:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,lokeshgidra@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch removed from -mm tree
Message-Id: <20241017072839.85953C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix deadlock for fork after pthread_create on ARM
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: fix deadlock for fork after pthread_create on ARM
Date: Thu, 3 Oct 2024 21:17:11 +0000

On Android with arm, there is some synchronization needed to avoid a
deadlock when forking after pthread_create.

Link: https://lkml.kernel.org/r/20241003211716.371786-3-edliaw@google.com
Fixes: cff294582798 ("selftests/mm: extend and rename uffd pagemap test")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -241,6 +241,9 @@ static void *fork_event_consumer(void *d
 	fork_event_args *args = data;
 	struct uffd_msg msg = { 0 };
 
+	/* Ready for parent thread to fork */
+	pthread_barrier_wait(&ready_for_fork);
+
 	/* Read until a full msg received */
 	while (uffd_read_msg(args->parent_uffd, &msg));
 
@@ -308,8 +311,12 @@ static int pagemap_test_fork(int uffd, b
 
 	/* Prepare a thread to resolve EVENT_FORK */
 	if (with_event) {
+		pthread_barrier_init(&ready_for_fork, NULL, 2);
 		if (pthread_create(&thread, NULL, fork_event_consumer, &args))
 			err("pthread_create()");
+		/* Wait for child thread to start before forking */
+		pthread_barrier_wait(&ready_for_fork);
+		pthread_barrier_destroy(&ready_for_fork);
 	}
 
 	child = fork();
_

Patches currently in -mm which might be from edliaw@google.com are


