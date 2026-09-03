Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0A735CBD7;
	Thu,  3 Sep 2026 03:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405809; cv=none; b=R/ALXKztDveWendAUaE4VRZNOchcVxsR0YBwGwjzbjbGiHUm5rd+Y0gbpWvth5ostSnVscJnvwMUOriDCIgQUobm23zuj24zWR/BY2vN8Q+xorVZehd3xrbB98TfSv8/qNaeNaXYaw8BmdtL/kUsTe3YCkKBGo9MeBfv+gZQxBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405809; c=relaxed/simple;
	bh=R3SMZvoQjaVSyqHO8tbKa8xmDOZ6qCijUpXq4NdXNVw=;
	h=Date:To:From:Subject:Message-Id; b=RVotcXfSLygCdUrhyGs6Y/kW7YyYF4aK2OcIDGmS3UTAhC2A/yFUbj6C7c8wztidTTPykea1q6wswUj2lH7DUA1on6l1m8QLwNMve+HbMDzBloZW595lWOyvQQEEYRLE5NIPjo7ckiIIOH0wIAurSx4MvFX/ZrbFimnKq0mbj7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B6JdD2Vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B6JdD2Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C321F000E9;
	Thu,  3 Sep 2026 03:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788405807;
	bh=SBi+cw6Gk1B61wEU4O5aYdUwidJiomBDkqKB/Yq2AsI=;
	h=Date:To:From:Subject;
	b=B6JdD2VmVBaA7qQlo7Ma4Vd18kQ5mu4milCrGKt3Cq/N6Y6PAjYbS47rZXWHvQhxK
	 Bj3OCNQp4KpHDSiOJySdmrEFMNCKYlbVKpXdwXD58mGiDcORxSSvxqf16yZev3u6xx
	 9Jc40ii8o0snM2ITLTU9Dj7oYQheSq22jtvS1iJs=
Date: Wed, 02 Sep 2026 20:23:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,davem@davemloft.net,christianvanbrauner@gmail.com,mheyne@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-uevent-filtering-dont-shrink-the-socket-buffer.patch added to mm-nonmm-unstable branch
Message-Id: <20260903032327.C5C321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: uevent filtering: don't shrink the socket buffer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-uevent-filtering-dont-shrink-the-socket-buffer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-uevent-filtering-dont-shrink-the-socket-buffer.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Maximilian Heyne <mheyne@amazon.de>
Subject: selftests: uevent filtering: don't shrink the socket buffer
Date: Fri, 19 Jun 2026 11:24:29 +0000

The uevent_filtering test shrinks the uevent socket buffer to 4 KB
although the default socket buffer size is much higher.  This leads to
this test being flaky when too many unrelated uevents are fired on the
machine.  They might fill up the netlink receive buffer leading to ENOBUFS
errors when trying to receive the uevents.  For example, I could trigger
test failures when running triggering a lot of udev events in the
background:

  $ # run multiple of that in the background:
  $ while :; do sudo udevadm trigger --action=change; done &
  $ sudo ./uevent_filtering
    # Starting 1 tests from 1 test cases.
    #  RUN           global.uevent_filtering ...
    add@/devices/virtual/mem/fullACTION=addDEVPATH=/devices/virtual/mem/fullSUBSYSTEM=memSYNTH_UUID=0MAJOR=1MINOR=7DEVNAME=fullDEVMODE=0666SEQNUM=304458
    add@/devices/virtual/mem/fullACTION=addDEVPATH=/devices/virtual/mem/fullSUBSYSTEM=memSYNTH_UUID=0MAJOR=1MINOR=7DEVNAME=fullDEVMODE=0666SEQNUM=304471
    add@/devices/virtual/mem/fullACTION=addDEVPATH=/devices/virtual/mem/fullSUBSYSTEM=memSYNTH_UUID=0MAJOR=1MINOR=7DEVNAME=fullDEVMODE=0666SEQNUM=304481
    add@/devices/virtual/mem/fullACTION=addDEVPATH=/devices/virtual/mem/fullSUBSYSTEM=memSYNTH_UUID=0MAJOR=1MINOR=7DEVNAME=fullDEVMODE=0666SEQNUM=349156
    No buffer space available - Failed to receive uevent
    # uevent_filtering.c:463:uevent_filtering:Expected 0 (0) == ret (-1)
    # uevent_filtering: Test failed
    #          FAIL  global.uevent_filtering
    not ok 1 global.uevent_filtering

The default receive buffer size (SK_RMEM_MAX) is far larger than the
requested 4 KB, so keep this to make the test less flaky.

Link: https://lore.kernel.org/20260619-get-swam-a1cd4cca@mheyne-amazon
Fixes: 9d3df886d17b ("selftests: uevent filtering")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Cc: Christian Brauner <christianvanbrauner@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/uevent/uevent_filtering.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/tools/testing/selftests/uevent/uevent_filtering.c~selftests-uevent-filtering-dont-shrink-the-socket-buffer
+++ a/tools/testing/selftests/uevent/uevent_filtering.c
@@ -78,7 +78,6 @@ static int uevent_listener(unsigned long
 {
 	int sk_fd, ret;
 	socklen_t sk_addr_len;
-	int rcv_buf_sz = __UEVENT_BUFFER_SIZE;
 	uint64_t sync_add = 1;
 	struct sockaddr_nl sk_addr = { 0 }, rcv_addr = { 0 };
 	char buf[__UEVENT_BUFFER_SIZE] = { 0 };
@@ -96,13 +95,6 @@ static int uevent_listener(unsigned long
 		return -1;
 	}
 
-	ret = setsockopt(sk_fd, SOL_SOCKET, SO_RCVBUF, &rcv_buf_sz,
-			 sizeof(rcv_buf_sz));
-	if (ret < 0) {
-		fprintf(stderr, "%s - Failed to set socket options\n", strerror(errno));
-		goto on_error;
-	}
-
 	sk_addr.nl_family = AF_NETLINK;
 	sk_addr.nl_groups = __UEVENT_LISTEN_ALL;
 
_

Patches currently in -mm which might be from mheyne@amazon.de are

selftests-uevent-filtering-dont-shrink-the-socket-buffer.patch

