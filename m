Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793416362;
	b=ZkEiz6dKPBAHT57YioJ79Z7DNDGedqZ9DSInFu74R9OhOQq2cebssbsuPVuxiG25ae9d
	 0e6mt7cTji9UZhTQA5/CabtVcy/x5mSNCFdjRfAsbeQ//+bTZs2qmFvDb2WEYI84pkKKq
	 EXWXvHuFFhHg//DQn5v/qZz1uuoHrTh+E9uXymDLOMO+sEGr72SqxTowQmIhUBicUb9aO
	 JIrsmuIsqVZePlqjAwTRg25PLcfKdECY01pYqprxX3m28zAi1TcUchuJY04IWXbdNdOGB
	 GzQR4YRlP+gaZWIV/pYBKPQkPwVEL1oa1SqffJ7G+nguM6kb7Rh8xf6jzbQ0kDiCUCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793416362;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hTVoXFWzDYEiAz3CxSiTnB2JAHr+fsrBQxBRXecdM3A=;
	b=xn85ZwAKChGt0RolTbansUB1iYMp7J6zHXRDpZsMmYKqZxKKVfSlBuXRHdBdiWf9jVW2
	 Z5llEcVY06i5L/DNHDXcvJeCaN3k+Z63XNaKKsXCBqoAzUo98eGrRTvuyN/2f4uc4xB1x
	 0Xv2YeA3slgjy27mZ4eL6dXKfsyAk2R2ESLnfy0t4P5Di02qCChM1W6RChEiTHxtMhkyy
	 Jnqe11iEU06H7K2k5oh22rDfoSpSqUufc3RlBdwERTyJporOLuloAnhuosiJiFEt5hm5R
	 7TTBhviqPazXTTN1ppzRWp79km83xTM2+WmtUxthixjKgFMJQGOK2lTcrF+LszCVh+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d7WSbJXi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8BF606A31D
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 03:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=d7WSbJXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452651F000C1;
	Sat, 31 Oct 2026 03:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793416361;
	bh=hTVoXFWzDYEiAz3CxSiTnB2JAHr+fsrBQxBRXecdM3A=;
	h=Date:To:From:Subject;
	b=d7WSbJXigP/9+trKyTt3QP2JIQHCTFmMccxUZM01+Yc/Okx4I8fcRB9gUo+it5eoq
	 YtvxiPCVegeOHIV0HJQ1FY4/nD2eyVfTTlUSkF9RBY0UZYSv/hCl6EDe0oXA3EiFv8
	 tUny4Ge6KTR3k27akSHndrNzYM7pgmQFnJBw47RA=
Date: Fri, 30 Oct 2026 20:12:40 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,richard.weiyang@gmail.com,
	reddybalavignesh9979@gmail.com,christian.gellermann@codasip.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-uevent-gracefully-handle-receive-buffer-overrun.patch added to mm-nonmm-unstable branch
Message-Id: <20261031031241.452651F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/uevent: Gracefully handle receive buffer overrun
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-uevent-gracefully-handle-receive-buffer-overrun.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-uevent-gracefully-handle-receive-buffer-overrun.patch

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
From: Chris Gellermann <christian.gellermann@codasip.com>
Subject: selftests/uevent: Gracefully handle receive buffer overrun
Date: Wed,  2 Sep 2026 10:50:30 +0200

Due to udevd rebroadcasting uevents, the receiver's socket buffer may
overrun and the kernel has to drop messages.  Instead of failing on the
overrun, continue listening for the remaining copies if we expect a uevent
until killed by the timeout.

For each subtest do_test() of the uevent_filtering test case, the sender
triggers uevents that a receiver should listen for.  These uevents may
also be received and rebroadcasted by udevd.  This can happen with some
delay, so uevents from an earlier do_test() subtest may generate
rebroadcasted uevents for a subsequent subtest.  Both, uevents triggered
by the sender and rebroadcasted ones are queued by the kernel to the
receiver socket buffer.  The buffer may overrun forcing the kernel to drop
uevents.  This causes the recvmsg() call by the receiver to fail with
ENOBUFS.  To fix this, do not treat ENOBUFS as a fatal receive error and,
if we expect a uevent, keep listening for one of the ten triggered by the
sender.  If the receiver is in a namespace where it should not receive any
uevents, a dropped package may be the one it should never reach.  So we
defensively fail in this case.  The wait is bounded by the sender that
kills the receiver after a timeout.

The rebroadcast can be observed in the udev logs:
udevd[115]:  seq 6774 queued, 'add' 'mem'
udevd[2436]: seq 6774 running
udevd[2436]: handling device node '/dev/full', devnum=c1:7
udevd[2436]: passed 200 byte device to netlink monitor
udevd[2436]: seq 6774 processed

Link: https://lore.kernel.org/20260902085030.1378789-1-christian.gellermann@codasip.com
Fixes: 9d3df886d17b ("selftests: uevent filtering")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
---

 tools/testing/selftests/uevent/uevent_filtering.c |   24 ++++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/testing/selftests/uevent/uevent_filtering.c~selftests-uevent-gracefully-handle-receive-buffer-overrun
+++ a/tools/testing/selftests/uevent/uevent_filtering.c
@@ -158,6 +158,30 @@ static int uevent_listener(unsigned long
 		ssize_t r;
 
 		r = recvmsg(sk_fd, &hdr, 0);
+		if (r < 0 && errno == ENOBUFS) {
+			/*
+			 * The socket receive buffer overran and the kernel
+			 * dropped uevents. This may happen due to udev
+			 * rebroadcasting kernel uevents that end up in the
+			 * receive buffer as we are subscribed to all groups.
+			 *
+			 * When a uevent is expected, we trigger it multiple
+			 * times to tolerate drops, so keep listening for one
+			 * of the remaining copies. The parent bounds this
+			 * wait by killing us on a timeout.
+			 *
+			 * When no uevent is expected, our socket sits in a
+			 * namespace that should not receive any, so a drop
+			 * means traffic reached it, or that we can no longer
+			 * prove it did not. Rather fail.
+			 */
+			if (!expect_uevent) {
+				fprintf(stderr, "Unexpected buffer overrun\n");
+				ret = -1;
+				break;
+			}
+			continue;
+		}
 		if (r <= 0) {
 			fprintf(stderr, "%s - Failed to receive uevent\n", strerror(errno));
 			ret = -1;
_

Patches currently in -mm which might be from christian.gellermann@codasip.com are

selftests-uevent-gracefully-handle-receive-buffer-overrun.patch

