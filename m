Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793246699;
	b=UqS0QqWva2/mCTP5W5wP1loS3p5ZHfRwtr1qZ8LJRLDdsThSq3HoWun9sIbegow1r6of
	 QJ209YVkPeGRKtS21Z1xhWKRH+o74ydgDRQXcGy5WZ3ijSnlji5yRwOtZWxMiUJs5xMvd
	 qF08G/MDsdL6fo75uatA4Q8Wrs8inPD57KGwVZJ65g+puuTraKPVpfVLPeaK96TTQe7eb
	 QDneEW/+rhfMsVJe1biAW//fppzBeZwUVK3u8Qv9Ac4CGoiYwch8zOuFROII0FbtssUJ1
	 UVt3KlRC4h6j3ILwAx2pFwanOY2aSzf63qHEGbwDzsJiuKe0ByJCiaNz/QsJGLzuuwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793246699;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=joqwICKBL6wS2+bEKwhEhDo73YfQ8GskCkdNCEnQxRA=;
	b=SERlrzJx1hXRi3DL3KvJZXkKa0uCqUl44iL+QJ3xa/gozb2ZU/g3pIChJxJOc5cQu+Ps
	 3DWtG4mTd8eiRA0u4Etw8KAAjDdIcZW+ls1z9CsWI6v5mBShmzEoRTEoAv+8lLMaubOkk
	 niJRRi0ngLSiR6Cad+sv0uvlu3QKzEl96MwIdrca4kx3xtI8vjm0KBinlLgWn8/QMRpec
	 TsncYvYHYho7OgMpvm5eHvYSWicqRh0Y0FjNdcgkKeRhjBykHfS9NV1eEaT9LLVN08oB7
	 U5MgbIXq8mVIKkH/Tv7FUDepw23E+WG027tgFt4AKP9zaVwKMXA/Pm/eNvvLa+7u+nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RhqtHiOu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE10606A330;
	Thu, 29 Oct 2026 04:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RhqtHiOu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD16C1F01828;
	Thu, 29 Oct 2026 04:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793246698;
	bh=joqwICKBL6wS2+bEKwhEhDo73YfQ8GskCkdNCEnQxRA=;
	h=Date:To:From:Subject;
	b=RhqtHiOuJkRkHmHTvAW+SnPQVs1axpM7SNeWJoLoV05j2fe9XwsZfg7H6UJtA8vX+
	 gFk2LLlMfkScP1Cr+Zh1r1m5Dod5SUCCC+QKVlx2XNIyl4BFcP2w8a+S6AneMOlpZT
	 vSVu3b4rkxpe7uG0DwPFgtutVLGT1NKJXOq8E9bw=
Date: Wed, 28 Oct 2026 21:04:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	manfred@colorfullife.com,david.laight.linux@gmail.com,dave@stgolabs.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-clamp-negative-statistics.patch added to mm-nonmm-unstable branch
Message-Id: <20261029040458.BD16C1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/msg: clamp negative MSG_INFO usage counts
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-clamp-negative-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-clamp-negative-statistics.patch

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
ipc-msg-clamp-negative-statistics.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

