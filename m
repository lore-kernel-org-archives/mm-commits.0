Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467F413A244
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729286044; cv=none; b=V3aeFdRd+e6TB2iJVHSQrrpphMGrfsrZrCD8X1oqjbaK6ULbkrD4rRDynA2GesyoJxuDxbRVFEuPgyqeu1FlVnCH9iqKTGf334ri3NWwl9/LCyfxPXPExU7G9MBVT+lsHguW3y5CvVUsif6E64zwRkW72sf3Df8u9GLDp+OMnJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729286044; c=relaxed/simple;
	bh=AFBOGUnMUtYghBq55TcrZJ+F3ue+qTM6Hsuol4iqZE8=;
	h=Date:To:From:Subject:Message-Id; b=g3MEj88m719PrdP1I5JaMvfU1novhf2EPTx0sYKBG9twPTBJT/S/g6SDHP014ZR8P4lOhi34Ike2S8BDmRsnTIhKUV5FnS3ZGt/eDgQXd/WBhDvHLjBirBzKSaru2Dr/cWAW+aTjR6+7DTQ1RKC69Guky3slDm6k0YINpJmQ20A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dHWz3ccx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dHWz3ccx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6C3C4CEC3;
	Fri, 18 Oct 2024 21:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729286043;
	bh=AFBOGUnMUtYghBq55TcrZJ+F3ue+qTM6Hsuol4iqZE8=;
	h=Date:To:From:Subject:From;
	b=dHWz3ccxmMKw4cRS6WgTJlYnfF7OfsCV8MrnsA/dbufONbr8kPbJhMgO95d4Nn4Wb
	 WtqjB11YX42IPUu/T6HPgPmNc1xDglZ/mExCGTm1r2q87oNmZDDiXE0JI3agwiFZXm
	 94egYjmgpNboTY3ylDncx1vMNA4VS52RWqXDHK8Q=
Date: Fri, 18 Oct 2024 14:14:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch added to mm-hotfixes-unstable branch
Message-Id: <20241018211403.CB6C3C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix deadlock for fork after pthread_create with atomic_bool
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch

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

revert-selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch
revert-selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch
selftests-mm-fix-deadlock-for-fork-after-pthread_create-with-atomic_bool.patch

