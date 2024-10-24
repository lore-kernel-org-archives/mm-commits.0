Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D045A176ABA
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 06:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729750538; cv=none; b=S006wPeCZTmfZMKuIpCJQCTKETiQbbvE+bD3RQShLzs0qYkNo+1arF0Ml5zrGkmR9A4UM6/AmumW1sBsQ/7F2J+Lpvr62icw+aVNQuHZHwhFqS6HHdD9JniN/M5VfLchWu8xpQSEKq5dO/rsCI5wY4ufUqchZy0V1i0lLAdCzzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729750538; c=relaxed/simple;
	bh=7q3CAADFKcr29d0mUBLXRnVuE55UVnnpd2fPrnPi6J8=;
	h=Date:To:From:Subject:Message-Id; b=daDOGHqk5XChCnoZiAQTK6WdFSVqxJSpx3PGsj4gqIBB+0Pa8dmTApkg5fpnrRldmFQ78DO+f/tqN4j4E9AmFEe9tQ1v4D8yNa4Aqqc1e6H1tuOE7Hs2yxJC2G8LkytDOYC94cYqJCaN+swpdhJG3lfSv3d6gtae/Z7q2omSeGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VWDSxYub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VWDSxYub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBCAC4CEC7;
	Thu, 24 Oct 2024 06:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729750538;
	bh=7q3CAADFKcr29d0mUBLXRnVuE55UVnnpd2fPrnPi6J8=;
	h=Date:To:From:Subject:From;
	b=VWDSxYubPe+O1kxhASceAgn2zVveQAb3MxJNmHhZFjDTzVNkoCiKYaQMi3jlOYWZz
	 OaqrOOgzXSmH0cFypsHfZksuEObkNpfHKSUPM2buJirCDU50soW8EKCK6VBYHvWXkJ
	 mO8g4H4WKHrRTcQUkFzR+sodoN806kQSzpJUknzw=
Date: Wed, 23 Oct 2024 23:15:38 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch removed from -mm tree
Message-Id: <20241024061538.9EBCAC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix deadlock for fork after pthread_create with atomic_bool
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/mm: fix deadlock for fork after pthread_create with atomic_bool
Date: Fri, 18 Oct 2024 17:17:24 +0000

Some additional synchronization is needed on Android ARM64; we see a
deadlock with pthread_create when the parent thread races forward before
the child has a chance to start doing work.

Link: https://lkml.kernel.org/r/20241018171734.2315053-4-edliaw@google.com
Fixes: cff294582798 ("selftests/mm: extend and rename uffd pagemap test")
Signed-off-by: Edward Liaw <edliaw@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -241,6 +241,8 @@ static void *fork_event_consumer(void *d
 	fork_event_args *args = data;
 	struct uffd_msg msg = { 0 };
 
+	ready_for_fork = true;
+
 	/* Read until a full msg received */
 	while (uffd_read_msg(args->parent_uffd, &msg));
 
@@ -308,8 +310,11 @@ static int pagemap_test_fork(int uffd, b
 
 	/* Prepare a thread to resolve EVENT_FORK */
 	if (with_event) {
+		ready_for_fork = false;
 		if (pthread_create(&thread, NULL, fork_event_consumer, &args))
 			err("pthread_create()");
+		while (!ready_for_fork)
+			; /* Wait for the poll_thread to start executing before forking */
 	}
 
 	child = fork();
_

Patches currently in -mm which might be from edliaw@google.com are


