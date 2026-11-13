Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794534442;
	b=IMlrIZEM3V7/ZvSkZsaP1JKBJptFeOdpD51nZnF0FpMecNf7r0b69VdS8pfkuZLvTEhw
	 Z02gJhR0AA7MoC23SEzihNS3rBlrDo3K5ROfRBfuSvAJPQXllOtiun669Wu9IcWdomMc+
	 BNFleygLuPq0UE9oAae1Wx74+3k1drH1gytgiY58PVMqQJ0zTz+joeU1qIAKayZVH4aim
	 8VGex2mWSggz/JjnfGuUI0hW0Dspjdq+u+0M7WJ8ayGEdhMkH0rCakinyFZbdtpZnCCTM
	 Uhs9JgicU8iDT/3ZGlfTIXWx3YgLeyH3bO8YcgWJq2aVD41zFkWpX4Yyu+k7VK/4RsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794534442;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+6ELNXd483VAxie0iseebsng3T+J5R6tTq9KxvHzEYE=;
	b=ZG8UYrXF1VrZvMnfIkJxACB7rcyB9H3x7WnapJJZi0TsEVzi8cIbVcVvrFntOWVrboSk
	 VJPJEK7wZShkNtHQVDd/vT222mKYipaDIRYBxFekIQLY4e+aMLA/oCUyMcDe1/v7MZuSK
	 Zu8ydbyu9eJ7CirVDxjy6t/kqZpljWODMZ9FGRQWoXljUbj053NjdYCn9aPFsDbWFbTw6
	 K6ctIm8pRLAsJ0MptGGKKmZACDA2U06FcnG+Xd0nhqA/uo+A0ySICBEU6V/OijItEl7h8
	 55kQkpV1UIcI5kCq5aLuQ+mhn6X9TVbqCrwMp34KHudSypLrygOINqiDgb/IF9v6wWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0LZehtJP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAD7606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 01:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0LZehtJP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5D81F000C4;
	Fri, 13 Nov 2026 01:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794534442;
	bh=+6ELNXd483VAxie0iseebsng3T+J5R6tTq9KxvHzEYE=;
	h=Date:To:From:Subject;
	b=0LZehtJPKtXe1tpzJnQIXHyQaUMCLQ8GuAmZIQbh7qdSKveFvhxRTUd3UvRzz3sTi
	 rNYg0euBooFlQR2SHcQrbI43FtJHS6JOjMAjwgq+9uW2RbZVtEQQ0HfuKAok0mTGAd
	 btCcbCnMa9kOPONU2LXAs09v/aL8CgGo5yV7hc+I=
Date: Thu, 12 Nov 2026 17:47:21 -0800
To: mm-commits@vger.kernel.org,vlad.wing@gmail.com,harry@kernel.org,
	catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-drop-kmemleak_lock-in-scan_block-when-it-is-contended.patch added to mm-new branch
Message-Id: <20261113014722.3B5D81F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: kmemleak: drop kmemleak_lock in scan_block() when it is contended
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-drop-kmemleak_lock-in-scan_block-when-it-is-contended.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-drop-kmemleak_lock-in-scan_block-when-it-is-contended.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: drop kmemleak_lock in scan_block() when it is contended
Date: Thu, 12 Nov 2026 03:48:01 -0800

kmemleak_lock is a damn hot lock, used on allocations, free, NET_RX, etc. 
It is also used on the scan, so, while scanning, most of the system is
mostly waiting for the lock.

On meta fleet, this is, by far, the most contented lock.  This is not a
big deal, because very few hosts run with kmemleak enabled, but, I think
we can do better here.

scan_block() takes kmemleak_lock once per block and keeps it, with
interrupts disabled, for up to MAX_SCAN_SIZE bytes: 512 words, each
needing up to two object tree lookups. Every allocation and free in the
system needs the same lock to insert or remove its object, so each of
them can wait for a whole block.

Keep taking the lock once per block, but in auto scan mode, check every
64 words whether anybody is waiting for it and, if so, breathe (aka
release it and take it again so that the waiters go first)

Releasing the lock seems safe because it only keeps the object trees
stable during each lookup, and scan_block() does not use an object found
under it past the word being processed.

Tested in an arm64 KVM guest with 48 vCPUs, KASAN and lockdep, running
stress-ng sock, fork and dentry workers on 8 CPUs during five scans.
The kmemleak_lock wait times of the other CPUs, from the lock_contended
and lock_acquired tracepoints:

                   average     p99     p99.9
  no scan            3.7us    <16us    <32us
  scan, before      15.8us   <256us   <512us
  scan, after       11.7us    <64us   <256us

The cost is a slower scan, as the scanner now queues behind the
waiters: the five scans took 179s instead of 118s.

This patch does not change interactive users (echo scan > kmemleak in
debugfs), given current != scan_thread, and scan_breathe() will not be
called.

Link: https://lore.kernel.org/20261112-kmemleak-scan-lock-break-v1-1-95808108d03c@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vlad Poenaru <vlad.wing@gmail.com>
Cc: Harry Yoo <harry@kernel.org>
---

 mm/kmemleak.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/mm/kmemleak.c~mm-kmemleak-drop-kmemleak_lock-in-scan_block-when-it-is-contended
+++ a/mm/kmemleak.c
@@ -112,6 +112,7 @@
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
+#define SCAN_LOCK_BATCH		64	/* words between lock waiter checks */
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
@@ -1540,6 +1541,18 @@ static int scan_should_stop(void)
 }
 
 /*
+ * Release kmemleak_lock and take it again if anybody is waiting for it, so
+ * that allocations and frees do not have to wait for a whole block.
+ */
+static void scan_breathe(unsigned long *flags)
+{
+	if (raw_spin_is_contended(&kmemleak_lock)) {
+		raw_spin_unlock_irqrestore(&kmemleak_lock, *flags);
+		raw_spin_lock_irqsave(&kmemleak_lock, *flags);
+	}
+}
+
+/*
  * Scan a memory block (exclusive range) for valid pointers and add those
  * found to the gray list. Return non-zero if the scan was interrupted.
  */
@@ -1561,6 +1574,14 @@ static int scan_block(void *_start, void
 			break;
 		}
 
+		/*
+		 * Only the background scan thread breathes, scans requested
+		 * through debugfs keep the lock and finish sooner.
+		 */
+		if (current == scan_thread && ptr != start &&
+		    !((ptr - start) % SCAN_LOCK_BATCH))
+			scan_breathe(&flags);
+
 		kasan_disable_current();
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
 		kasan_enable_current();
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch
tools-mm-add-hwpoison-panic-tool.patch
mm-split-out-memory-failure-declarations-from-internalh.patch
mm-kmemleak-drop-kmemleak_lock-in-scan_block-when-it-is-contended.patch
ratelimit-fix-data-race-on-burst-in-___ratelimit.patch
stackdepot-dont-warn-when-the-depot-runs-out-of-pools.patch

