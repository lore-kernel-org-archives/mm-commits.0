Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28542367B5
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078117; cv=none; b=IaFAW0IkwEoex0RXeiD7f0CLXtLlXIBngendzmtsG53eJ+YbYrhEMf/ihxnGsw/V20WPcB8dFHGZZ47sXtT0WVS9YyPZ1ri4AByZz4mqC+3okU7F9q7YBk7pBeg6S+iWHh83szRDoFhu4m/+4MIfFb6JOSFYGdTe9prK/sAZ8kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078117; c=relaxed/simple;
	bh=gwH5ssWhShHK5kMz3oMErzJY8/KMzwwk7wloZrPXZn4=;
	h=Date:To:From:Subject:Message-Id; b=gxoQHk7XP4q/xPL4ML/rxJAvk+VFsr3mH4zXxj0QfJjshIZnwA6kRETuTFpVe9L6sFffzTx8bUe7cBlqpIYnQOLa1PgBNmUu+bQVHYHiU5aAuum2NqAEnQK56sveEdA0hN66ShV1OfdstCznuQ+2bWB0lvr+jQWfGssYDYWjtPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eBQnTsRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eBQnTsRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44356C4CEF7;
	Mon,  9 Mar 2026 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773078117;
	bh=gwH5ssWhShHK5kMz3oMErzJY8/KMzwwk7wloZrPXZn4=;
	h=Date:To:From:Subject:From;
	b=eBQnTsRU86i5Rz2tk1Du0FMpxmbwTlvAKOyk2Vo4mpDOCVOseTxwV93QoAhoU3cne
	 cG1B5dRrMqITCxyonosJtgaCBDsNBYw7etiTV2IOiRxSbah202LHEyyg/pbQbBPs43
	 QK6QbJ7KaT9sRpcJkl+fCFIcsexaE/tyLYgn7+N4=
Date: Mon, 09 Mar 2026 10:41:56 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-memcg-skp-memcg_sock-test-if-address-family-not-supported.patch added to mm-new branch
Message-Id: <20260309174157.44356C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest: memcg: skip memcg_sock test if address family not supported
has been added to the -mm mm-new branch.  Its filename is
     selftest-memcg-skp-memcg_sock-test-if-address-family-not-supported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-memcg-skp-memcg_sock-test-if-address-family-not-supported.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: selftest: memcg: skip memcg_sock test if address family not supported
Date: Mon, 9 Mar 2026 12:02:05 -0400

On systems where IPv6 isn't enabled or not configured to support
SOCK_STREAM, the test_memcg_sock test always fails.  The purpose of the
test_memcg_sock test is to verify that memory.stat.sock and memory.current
values are close.  If the socket() call fails, there is no way we can test
that.  I believe it is better to just skip the test in this case instead
of reporting a test failure hinting that there may be something wrong with
the memcg code.

Link: https://lkml.kernel.org/r/20260309160205.651754-1-longman@redhat.com
Fixes: 5f8f019380b8 ("selftests: cgroup/memcontrol: add basic test for socket accounting")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftest-memcg-skp-memcg_sock-test-if-address-family-not-supported
+++ a/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1280,8 +1280,11 @@ static int tcp_server(const char *cgroup
 	saddr.sin6_port = htons(srv_args->port);
 
 	sk = socket(AF_INET6, SOCK_STREAM, 0);
-	if (sk < 0)
+	if (sk < 0) {
+		/* Pass back errno to the ctl_fd */
+		write(ctl_fd, &errno, sizeof(errno));
 		return ret;
+	}
 
 	if (setsockopt(sk, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) < 0)
 		goto cleanup;
@@ -1414,6 +1417,9 @@ static int test_memcg_sock(const char *r
 
 		if (!err)
 			break;
+		if (err == EAFNOSUPPORT)
+			/* Skip if address family not supported by protocol */
+			goto skip;
 		if (err != EADDRINUSE)
 			goto cleanup;
 
@@ -1460,6 +1466,9 @@ cleanup:
 	free(memcg);
 
 	return ret;
+skip:
+	ret = KSFT_SKIP;
+	goto cleanup;
 }
 
 /*
_

Patches currently in -mm which might be from longman@redhat.com are

selftest-memcg-skp-memcg_sock-test-if-address-family-not-supported.patch

