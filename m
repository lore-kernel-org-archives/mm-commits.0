Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7BD26056C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744886; cv=none; b=kKR281V3vuTTDQavFIyned6lOcY95vW6C57GtC9hJioYFu1hVW+JDRAJ9ZbgGXMEKWPn4l5uPFTEnY3XrJ/t6O7F8zJ8Se+mRIf/5Mm1OXkZHYe5VdmbylASAFaBym/JS/v73CFtmK4QjjiAKyJNPbcnANauVVP67/UW8tRwTLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744886; c=relaxed/simple;
	bh=LmP0sgaSbKUoEF0KVikbxIOGLXifcA8rPN7xaDmqjA4=;
	h=Date:To:From:Subject:Message-Id; b=XWRm+FgwuHvOQkop3bm2YneTAXyNNH8vKNqJLS2l1TwPBTsLLFY72euyafj+LJGFnTnCf0/5eP1UqWjL6JXikuqOg76K0bEWz+ZHEQfL1gq/lEHRXuh+ZyV+H+FL5YZEqpjNA73+Dwv4GZwsR4q8DSPWT8UyNjxu8cM5i+hHLbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sJw1rTvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sJw1rTvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0B5C4CEF7;
	Sun, 29 Mar 2026 00:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744885;
	bh=LmP0sgaSbKUoEF0KVikbxIOGLXifcA8rPN7xaDmqjA4=;
	h=Date:To:From:Subject:From;
	b=sJw1rTvdg2fUP73Y0HyUI3T7vk0E45EUYsTgQUGLGWM2Q38Ia4nhVmOxOSKZIu0Y2
	 OOWc38q0y7TKHsMVmsd1EidpsJVlQIeaLhh1WHHgoi7mQtoSIkAEoG52ZcdWkGfw+V
	 xwnoDq8Bjw05YPxt4dpZ9eE9LmJ8a+byOy+mqV60=
Date: Sat, 28 Mar 2026 17:41:25 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-memcg-skip-memcg_sock-test-if-address-family-not-supported.patch removed from -mm tree
Message-Id: <20260329004125.DB0B5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest: memcg: skip memcg_sock test if address family not supported
has been removed from the -mm tree.  Its filename was
     selftest-memcg-skip-memcg_sock-test-if-address-family-not-supported.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: selftest: memcg: skip memcg_sock test if address family not supported
Date: Wed, 11 Mar 2026 16:05:26 -0400

The test_memcg_sock test in memcontrol.c sets up an IPv6 socket and send
data over it to consume memory and verify that memory.stat.sock and
memory.current values are close.

On systems where IPv6 isn't enabled or not configured to support
SOCK_STREAM, the test_memcg_sock test always fails.  When the socket()
call fails, there is no way we can test the memory consumption and verify
the above claim.  I believe it is better to just skip the test in this
case instead of reporting a test failure hinting that there may be
something wrong with the memcg code.

Link: https://lkml.kernel.org/r/20260311200526.885899-1-longman@redhat.com
Fixes: 5f8f019380b8 ("selftests: cgroup/memcontrol: add basic test for socket accounting")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/test_memcontrol.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/test_memcontrol.c~selftest-memcg-skip-memcg_sock-test-if-address-family-not-supported
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


