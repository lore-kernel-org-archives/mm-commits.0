Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D59392C27
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773162448; cv=none; b=ItH7paDqe/JS3jr+xyfwZFunWymVRpDD09rCR/Exxm+lVHrOHl2R/3FBvRGhzbqwgPM7rjRStJ6e8abecTerEOcXZ3YyFBomHFxbeTSWa8LPlHBDndFjxgymbxQmV5THt59hz3Q9lXcvvywUOXo0n5WnXHxFuEi7g37j3CZqYVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773162448; c=relaxed/simple;
	bh=RY+hWlwOnkGoiW5O2nn5qxHk//gPSsFgp3kB1MosNIQ=;
	h=Date:To:From:Subject:Message-Id; b=BrSG6zqfV/Jgz8jqRvzpj8a4Tf/UKI7ZC0OlArVQs5FGV7NrE20UHprAq3KGlYgy0GvslT9hRD+6IYmGq4nvnf6uCx1crIWkX+IS/jrORAdkJFu+NvdfprB8CxeSYeL9m91+d54ZKU4rm6+bjIxgHEHgRA4oQQAmqtZ+xiQoJKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxkDLR95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxkDLR95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281EBC19423;
	Tue, 10 Mar 2026 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773162448;
	bh=RY+hWlwOnkGoiW5O2nn5qxHk//gPSsFgp3kB1MosNIQ=;
	h=Date:To:From:Subject:From;
	b=fxkDLR953R4jWZf9L8wtUgdoJCH/3wO04/q/uAV/sGrZEleZBY7N6eTKU+luHrOh2
	 NsKx77kmmGb/8FP6Zoqpop4NxPS9Bf+wTHgzb/evxBZ3v5PhUoOpTszDOZIEOZyRCe
	 nm6DrM9RoSqyFvWE1B2oW9b+u0Mxrkl5idJLNPYw=
Date: Tue, 10 Mar 2026 10:07:27 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-memcg-skp-memcg_sock-test-if-address-family-not-supported.patch added to mm-new branch
Message-Id: <20260310170728.281EBC19423@smtp.kernel.org>
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
Date: Tue, 10 Mar 2026 10:39:35 -0400

The test_memcg_sock test in memcontrol.c sets up an IPv6 socket and send
data over it to consume memory and verify that memory.stat.sock and
memory.current values are close.

On systems where IPv6 isn't enabled or not configured to support
SOCK_STREAM, the test_memcg_sock test always fails.  When the socket()
call fails, there is no way we can test the memory consumption and verify
the above claim.  I believe it is better to just skip the test in this
case instead of reporting a test failure hinting that there may be
something wrong with the memcg code.

Link: https://lkml.kernel.org/r/20260310143936.720592-1-longman@redhat.com
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
@@ -1412,6 +1415,12 @@ static int test_memcg_sock(const char *r
 			goto cleanup;
 		close(args.ctl[0]);
 
+		/* Skip if address family not supported by protocol */
+		if (err == EAFNOSUPPORT) {
+			ret = KSFT_SKIP;
+			goto cleanup;
+		}
+
 		if (!err)
 			break;
 		if (err != EADDRINUSE)
_

Patches currently in -mm which might be from longman@redhat.com are

selftest-memcg-skp-memcg_sock-test-if-address-family-not-supported.patch

