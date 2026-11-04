Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814895;
	b=gYEGu10Ndr/0aN7Su2cQEChlLOaUFCLdECMIE3PHOkTbq7/UqpK329HKxXidd6PNJ4nx
	 C7cJ7tjZvUe39jW6g9OzqU7Df5xGIvqfWe/NxPOex9xANeJY+CYkT06pzTKPDYKde1KV2
	 4bX40JQ2/dvAelACG6Ky/JedNlyWTQkbvpib3iiq7zNIMVt50KsC6kxqUzxUpJlRdpADb
	 tfJzXmmwaqTZRDV/wNvrQVHR5Cpw/V3VM74mOmq05F2zM0JIZv7GMj9VxaTz74dRx4S7R
	 FLqA3zx/20F8A4bBKJfelC3Xt9FXWRZzRvs3sEm5amOmv9GwN4PqqFDuLpYdwjS0Tng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814895;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eWtBQtpXoso6m6iuDHIkfeGyFZBBHVp9Xdx4A1bieXQ=;
	b=a5wHCOjRnHx0XoOzKEnEaMH2Q2trKaj3pJy3d/uQ2VxZFa1rVF+J7OqBkCp6k1kOWqII
	 GQhTJf4q82uV7lYtYA/QramKxOI3DN2+fcQuxDbtslOQY1EL0+nN379EiSjLKD+yb48CB
	 MbElDQoGD6GLnzYWnKmurbM/p6lUDERJjpgxxF1cqJTgMwCFJJ5Pl3BkPi5dkEdSP6XeW
	 sWoRJVHyhS97ftXNWIuqjmidA3fVZ2FGO7wcC/htWLSpQfz4NmNAbELrgr4NM72cTB4r3
	 KCL6NHZz9/gm+RbzkfQrifHRosNgt9eENfZH7IGhbwc6WrAiJ0/BXj1QH6GUuuFWnUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rw3jnBS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8408C606C903
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rw3jnBS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA571F00A02;
	Wed,  4 Nov 2026 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793814895;
	bh=eWtBQtpXoso6m6iuDHIkfeGyFZBBHVp9Xdx4A1bieXQ=;
	h=Date:To:From:Subject;
	b=rw3jnBS4NLguo3Lu9SgSw7TpoQ3m+DSau4jEnWeTLFjVJ+upNQFdX1Nb3nXUA4Knk
	 9K3EhOQZmgLNcoRsnavbBrhBm3o5NTab1bhke/CxSVRWez7L9f+Ic/A6Jf+cntV6QV
	 5YzuDaso9qcsdG+PHaRqEBW0PbTg80PaSKzJRJbI=
Date: Wed, 04 Nov 2026 09:54:54 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,paulmck@kernel.org,
	kuniyu@google.com,akpm@linux-foundation.org,leitao@debian.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ratelimit-fix-data-race-on-burst-in-___ratelimit.patch added to mm-nonmm-unstable branch
Message-Id: <20261104175454.EDA571F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ratelimit: Fix data race on ->burst in ___ratelimit()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ratelimit-fix-data-race-on-burst-in-___ratelimit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ratelimit-fix-data-race-on-burst-in-___ratelimit.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: ratelimit: Fix data race on ->burst in ___ratelimit()
Date: Tue, 03 Nov 2026 04:29:54 -0800

I am seeing the following race on my debug kernels:

  BUG: KCSAN: data-race in ___ratelimit / do_proc_int_conv

  write (marked) to 0xffffffff83084544 of 4 bytes by task 186 on cpu 3:
   do_proc_int_conv+0x94/0xa0
   proc_vec+0x48a/0x8d0
   proc_dointvec+0x16/0x20
   proc_sys_call_handler+0x263/0x3b0
   proc_sys_write+0x13/0x20
   vfs_write+0x559/0x610
   __x64_sys_pwrite64+0xce/0x110

  read to 0xffffffff83084544 of 4 bytes by task 185 on cpu 1:
   ___ratelimit+0x137/0x3b0
   __printk_ratelimit+0x18/0x20

  value changed: 0x00000001 -> 0x00000000

This could be reproduced by flipping kernel.printk_ratelimit_burst
between 0 and 1 while a kthread calls __printk_ratelimit() in a loop
makes KCSAN report:

___ratelimit() reads ->interval and ->burst once, with READ_ONCE(),
because sysctl writes like the one above change them without taking
rs->lock. Commit 6bae8ceb90ba ("ratelimit: Fix data-races in
___ratelimit().") added those snapshots.

Refill rs_n_left from the snapshot instead, which is also the value
the function has already checked to be positive.

Link: https://lore.kernel.org/20261103-ratelimit_race-v1-1-07486c49ec12@debian.org
Fixes: cf8cfa8a9978 ("ratelimit: Reduce ___ratelimit() false-positive rate limiting")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
---

 lib/ratelimit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/ratelimit.c~ratelimit-fix-data-race-on-burst-in-___ratelimit
+++ a/lib/ratelimit.c
@@ -67,7 +67,7 @@ int ___ratelimit(struct ratelimit_state
 	if (!(rs->flags & RATELIMIT_INITIALIZED)) {
 		rs->begin = jiffies;
 		rs->flags |= RATELIMIT_INITIALIZED;
-		atomic_set(&rs->rs_n_left, rs->burst);
+		atomic_set(&rs->rs_n_left, burst);
 	}
 
 	if (time_is_before_jiffies(rs->begin + interval)) {
@@ -77,7 +77,7 @@ int ___ratelimit(struct ratelimit_state
 		 * Reset rs_n_left ASAP to reduce false positives
 		 * in parallel calls, see above.
 		 */
-		atomic_set(&rs->rs_n_left, rs->burst);
+		atomic_set(&rs->rs_n_left, burst);
 		rs->begin = jiffies;
 
 		if (!(rs->flags & RATELIMIT_MSG_ON_RELEASE)) {
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch
tools-mm-add-hwpoison-panic-tool.patch
mm-split-out-memory-failure-declarations-from-internalh.patch
ratelimit-fix-data-race-on-burst-in-___ratelimit.patch

