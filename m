Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793292222;
	b=lcosGtgI6QLeom8MDMxLPiXPFx2CxJgWbFGWbyydm70mHwf8s404d9deMEO5G1ZGxQfw
	 oRzvOYcrqH6OPhMQ5Hq6kqAWYcX3x9lT7Nrr6crWE/1hGZVuadRVMXwirklaHjwfPIoDq
	 veED2tb1vA5b2awBSR0+Ajtcxh2f1Jbu7FS1magyR+gyrFG5WsTL5i23Be4HWjcgqdkEE
	 +q6Z9crVB+1OBfQFVasrwlPpBMHnerzGYZm1E/om/fOmMIPmWavfBYJBzn3EeFfK/kPMG
	 BlLckIg3raUOPNoWEB6o3ar41cwltKSEXsUmgZoRb4cTDiPABJuLqnrMr8WXFkgImrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793292222;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zIb+pqaaA/YKCk5vRPQd2ADFJ6LQtEkb6CBYfwYZyio=;
	b=p1npZk6EKACv2ZKb6/qL26cM2XshAvxqaxQp4mHl8O5HxWRD6yUU4dFs0oZpzIXBcnqc
	 BI9Eb+MnghE1x2u7ElxjVxGs0M8h6ZReTpBjZTx8tQFozgq+6FHRPGhv6rDWlEJulH9wn
	 XfH8Q2/9790lPQ8GZiPjDBORv8V1L/ORF1Vdsx/c/zyOxELW69Umr8HAiX52tEmNZJ6CG
	 IO8ctUIG1DDFoagZTsr3fSWYSdkkbpqRKNNVSWVsvPE28effCyLaxDwIfyeS0AW9zf2f4
	 Bz3cW76qen1bXia9BgqkD24yiq1/YypnilruNTMSdChMWa1/4pX4X0viuWjrCflJBlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bJs9ec7j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D49606A31A;
	Thu, 29 Oct 2026 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bJs9ec7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521631F01816;
	Thu, 29 Oct 2026 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793292221;
	bh=zIb+pqaaA/YKCk5vRPQd2ADFJ6LQtEkb6CBYfwYZyio=;
	h=Date:To:From:Subject;
	b=bJs9ec7j9+S4AmsXClSRjaOmDoHLTs/sBNXxSvcYqUw2sfGFJcAatkmYvmM1mCRY2
	 b8tz1q0OfuvtYz14c/v3Zyhad+pa+vqfdeiMnCkztahJ7DwApZFLfTPUwVikUNGtXm
	 f+gy+IWM51yohhbewh5smhMghKqiG99JnBLH1I3g=
Date: Thu, 29 Oct 2026 09:43:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	manfred@colorfullife.com,david.laight.linux@gmail.com,dave@stgolabs.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ipc-msg-clamp-negative-statistics.patch removed from -mm tree
Message-Id: <20261029164341.521631F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ipc/msg: clamp negative MSG_INFO usage counts
has been removed from the -mm tree.  Its filename was
     ipc-msg-clamp-negative-statistics.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc/msg: clamp negative MSG_INFO usage counts
Date: Thu, 29 Oct 2026 01:43:24 +0000

MSG_INFO can report negative message and byte counts during ordinary queue
traffic.  For example, ipcs -q -u prints a negative header count and can
convert a negative byte count into an enormous unsigned used-space value.

percpu_counter_sum() does not take an atomic snapshot of all CPUs.  While
a third CPU sums the counters, it can read the sending CPU's local count
before an enqueue and the receiving CPU's local count after the matching
dequeue.  The sampled total is then negative, even if the queue was
initially empty and is empty again.  The sum's lock serializes folding
into the global count, but not ordinary local counter updates.  Queue
locking does not serialize these updates with the statistics reader.

Use percpu_counter_sum_positive() for both usage counters before applying
the upper clamp.  Keep the comparison in s64 so the result is not narrowed
before saturation.

This bounds the reported usage without making the statistics an atomic
snapshot.  Message delivery and queue-limit enforcement are unchanged.

This is a follow-up to David Laight's "ipc/msg: Fix saturation of percpu
counts in msgctl_info()".

Validated with a source-extraction regression harness, including a forced
three-CPU sampling trace and failing old-code controls.  No running-kernel
reproduction or kernel build was performed.

Backporting: kernels such as v6.1 and v6.6 require matching min() operand
types.  Use min_t(s64, ...) instead of min() on those kernels.  For trees
still using min_t(int, ...), also retain the s64 upper clamp; the separate
standalone variant includes both adjustments.

Fixes: 72d1e611082e ("ipc/msg: mitigate the lock contention with percpu counter")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
---

 ipc/msg.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/ipc/msg.c~ipc-msg-clamp-negative-statistics
+++ a/ipc/msg.c
@@ -501,10 +501,12 @@ static int msgctl_info(struct ipc_namesp
 	max_idx = ipc_get_maxidx(&msg_ids(ns));
 	up_read(&msg_ids(ns).rwsem);
 	if (cmd == MSG_INFO) {
-		msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs),
-				     INT_MAX);
-		msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes),
-				     INT_MAX);
+		msginfo->msgmap = min(
+			percpu_counter_sum_positive(&ns->percpu_msg_hdrs),
+			INT_MAX);
+		msginfo->msgtql = min(
+			percpu_counter_sum_positive(&ns->percpu_msg_bytes),
+			INT_MAX);
 	} else {
 		msginfo->msgmap = MSGMAP;
 		msginfo->msgpool = MSGPOOL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

openrisc-export-mulsi3.patch
maintainers-add-ipc-maintainers.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

