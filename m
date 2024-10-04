Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835FC1798C
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 23:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728086011; cv=none; b=QJwro4COJ8irKAjOve+rFDyps5d+4LBpM0r4mxnRm9LayXVGlfPkhZwWbR8EcQ9LgTEh68bkyffWkfTT80WRg5D8NoqWie+WM/98xJFtRUzh03v3CQD06Q3ol+1BwJz8ekqQWh/CooXlB50szpqGUrkozl7vPKxCl0bG17nF5Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728086011; c=relaxed/simple;
	bh=P0Ksi6lgDh+M+YEja5etHRBvvtCDj4OFV1Bm5JsUZnU=;
	h=Date:To:From:Subject:Message-Id; b=r53DPhqdZ6eY4EbtSH8KxfCNWEOURylVDlrwQDHdxRQUikCm0t9m8k68Sqf8+RAQGc2VqwZm3/+Bvxbri49MFWrpZ1KvW00LfPUmft1LQvzFAsgWrmb4Y1GgiKBCAsWaqiH83knjyQID43hwxWy/aV5BpZDkLx7qVX4lZALdv7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nMhjQxI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nMhjQxI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCECEC4CEC6;
	Fri,  4 Oct 2024 23:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728086011;
	bh=P0Ksi6lgDh+M+YEja5etHRBvvtCDj4OFV1Bm5JsUZnU=;
	h=Date:To:From:Subject:From;
	b=nMhjQxI3FXZmWROtpxaOLcI24A0zdNIODykGhGpBduVQNy93Asw5zUzBrq/7/AZCj
	 l20dr+vy3ndabm3uQKQB/m9puwRk+SZNkrfbN3fyqnj34TIoOxI6kRyatkBvz/d7bJ
	 Kdbmn0gQo+V7aJI5H7GWXrDSGDGIJUUIfkIIgz4A=
Date: Fri, 04 Oct 2024 16:53:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,lokeshgidra@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch added to mm-hotfixes-unstable branch
Message-Id: <20241004235330.DCECEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix deadlock for fork after pthread_create on ARM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

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

selftests-mm-replace-atomic_bool-with-pthread_barrier_t.patch
selftests-mm-fix-deadlock-for-fork-after-pthread_create-on-arm.patch

