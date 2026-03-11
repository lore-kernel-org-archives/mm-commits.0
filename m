Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725622DA759
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773261229; cv=none; b=VvRD3bPPHD8JuR0broxYrHXrzThtVMsPGN23ycMpew3cV6kDMTuEOOPESqfWPQPl6fxZ1kXLKvyTR04pyN9hlEjDYgeB99H/74FeC3uEnX8hrKoSQMitOU8BnEUWFE54UQESa1cy2lYPJ57Y3xyoCU/5t9QAcJSBC/VPjrsSxAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773261229; c=relaxed/simple;
	bh=yfcE5w6J80rjkclNgDovcsEQKnBbIbTkG5pXzsBwCDA=;
	h=Date:To:From:Subject:Message-Id; b=aAgJsI1GcfqIkAmfd7pi+rO7FQUIu3t0R7Omq3m1/SkcfztAduSnYwh3dvuvmVshRZowXhXYB79/3LRgujsWuZtmhKzrBTckrchJUZ9L9SJPCpjcm9tOlyyPVpEh035GrZ3PV4LN2zaKaCv3V5Q2c9E/irV8duOqvBY4Yy0+dV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gMSbDav7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gMSbDav7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85851C116C6;
	Wed, 11 Mar 2026 20:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773261228;
	bh=yfcE5w6J80rjkclNgDovcsEQKnBbIbTkG5pXzsBwCDA=;
	h=Date:To:From:Subject:From;
	b=gMSbDav7w0FuCYm/nyZNSpX9qHRCM3qvZB6Bd4+445neTUMB0ywqmWa24xc5wOQqw
	 sOv7PPE9zF7yCB6aK4d7BR9OqcU0luClw8BHOB5Nf1mlPQPO3XFxD/xJ8Zl3KaP6cH
	 mAqwKKWYnMNm0CDr3UwE5txfON+X38+i7LNbE5VI=
Date: Wed, 11 Mar 2026 13:33:48 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shuah@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-memcg-skip-memcg_sock-test-if-address-family-not-supported.patch added to mm-new branch
Message-Id: <20260311203348.85851C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest: memcg: skip memcg_sock test if address family not supported
has been added to the -mm mm-new branch.  Its filename is
     selftest-memcg-skip-memcg_sock-test-if-address-family-not-supported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-memcg-skip-memcg_sock-test-if-address-family-not-supported.patch

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

selftest-memcg-skip-memcg_sock-test-if-address-family-not-supported.patch

