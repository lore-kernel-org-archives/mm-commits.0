Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148858;
	b=OgJcnK7qXhBXeDRMOAxKh7h6G45ZC6vAGdBMALSTw6hJn5E+RUlPgukoCK9tXAER0olN
	 EoBhjduJEOiOAtEj9bpgMgKacCXAyP+CG7DJAkRXYdTMwS6NUhOCGDXRMMTTLiUEbHREP
	 6qoL66Ku6ouq1ON6FsAsHa2lBi8AuGmH93DxmHdu297ItZsLgRoMuGwlhvAJJ50VGDTt+
	 izTOvhpi3s9ctvDIhVQzlISnbilz1eBIM4y30cKh3C9XtO0DAMDs7XvzG4fdY9yKishp3
	 g2UK+EOWNMrZvVRoWMR/E19U9NBd3WO7qrm9CGCwgdezyPT1ihuAiJAn2i9P/k/1tyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148858;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ximWkdMPo3C0HINhB8g5hVC/MrWZQ2RkJfguOHs4lWw=;
	b=LQ+sZPrgA8vUjBTNelhC3ZeHxiP/U+BJvYnI5tR58bGJhntPih6eAJWxPZms8PZN39jt
	 5fURFbl0gznjUQQcH/tzlqGWyQVket9SqbTNgzdZh053KBwGfM4eiDJZL9GK3P+E9sd7/
	 n1oaT6Tc3l9kpyt/a+seY0webKP+Qw6qt76vo/g5jUVO1DdWuPt6cbW8mmKA9SldvGVTF
	 Zpsccn9lCIlUf7wBE8Y4KjSYFI32PPAFUmTGwpvDRvMT5U8Q9W1p1nfCreR6YDjj5PTyF
	 /NoXoieSmz/kH5kXXzZMfj1kIPDS9ZpRzo4fEs3PIoyoPJhwoO1mdFOnffVSK2Q9xfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="H4zGq/xT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6748160A2608
	for <mm-commits@vger.kernel.org>; Fri, 20 Nov 2026 04:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=H4zGq/xT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97621F000C6;
	Fri, 20 Nov 2026 04:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795148857;
	bh=ximWkdMPo3C0HINhB8g5hVC/MrWZQ2RkJfguOHs4lWw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=H4zGq/xTRq5583csIVOUEkoNIS9EKFebW4bQu9k/UepzuvS/yCDSRCWUPXvYDu1r9
	 6NXOu/xpJt9+v247p3kQJjymDRL5NpyP3V336X2VfRhCthzxZqfa80B0LS+o9APNNr
	 zKSKsA4u3c0Nv4ij2rOSW35yUu63HGVIjkG5Tvhc=
Date: Thu, 19 Nov 2026 20:27:37 -0800
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,tamird@kernel.org,
	kees@kernel.org,david@davidgow.net,desobei@outlook.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <PH7PR19MB66581508E6F6733E0C36EF92AF792@PH7PR19MB6658.namprd19.prod.outlook.com>
References: <PH7PR19MB66581508E6F6733E0C36EF92AF792@PH7PR19MB6658.namprd19.prod.outlook.com>
Subject: + lib-prime_numbers-dont-sleep-under-rcu_read_lock-in-with_primes.patch added to mm-nonmm-unstable branch
Message-Id: <20261120042737.C97621F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/prime_numbers: don't sleep under rcu_read_lock() in with_primes()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-prime_numbers-dont-sleep-under-rcu_read_lock-in-with_primes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-prime_numbers-dont-sleep-under-rcu_read_lock-in-with_primes.patch

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
From: Ilyas N <desobei@outlook.com>
Subject: lib/prime_numbers: don't sleep under rcu_read_lock() in with_primes()
Date: Thu, 19 Nov 2026 17:42:36 -0500

The KUnit suite exit hook dumps the primes cache through with_primes(),
which calls its callback inside an RCU read-side critical section.  The
callback, dump_primes(), logs with kunit_info().  With
CONFIG_KUNIT_DEBUGFS=y that also appends to the suite log, which allocates
with GFP_KERNEL and may sleep.  With CONFIG_PREEMPT_RCU=y and
CONFIG_DEBUG_ATOMIC_SLEEP=y, every run of the suite reports:

  BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:322
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  Call Trace:
  __might_resched
  __kmalloc_cache_noprof
  string_stream_vadd
  kunit_log_append
  dump_primes
  with_primes
  kunit_run_tests

All updates of the primes pointer are serialized by the mutex in
prime_numbers.c.  Hold that mutex in with_primes() instead of the RCU read
lock.  The pointer stays valid for the callback, and the callback is
allowed to sleep.  with_primes() is only built for the KUnit test, and the
suite exit hook is its only caller.

Allocating with GFP_KERNEL under the mutex adds no new constraint on the
callers of the library.  The only other place that takes the mutex outside
of module exit is expand_to_next_prime(), which does a GFP_KERNEL
allocation right before taking it.

Found by running the KUnit suites on next-20261117 with KASAN, lockdep and
CONFIG_DEBUG_ATOMIC_SLEEP enabled.  The problem was found and the patch
was written with the help of an AI coding assistant (Claude Opus 5.5 and
Claude Fable 5.2).  Tested in x86_64 QEMU/KVM guests with 1 and 8 vCPUs,
running only this suite.  The splat shows up on every boot before the
patch and is gone with it, lockdep stays quiet, and the dump is still
printed and still lands in the debugfs log of the suite.

Link: https://patch.msgid.link/PH7PR19MB66581508E6F6733E0C36EF92AF792@PH7PR19MB6658.namprd19.prod.outlook.com
Fixes: 313b38a6ecb4 ("lib/prime_numbers: convert self-test to KUnit")
Signed-off-by: Ilyas N <desobei@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tamir Duberstein <tamird@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: David Gow <david@davidgow.net>

 lib/math/prime_numbers.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/lib/math/prime_numbers.c~lib-prime_numbers-dont-sleep-under-rcu_read_lock-in-with_primes
+++ a/lib/math/prime_numbers.c
@@ -59,14 +59,15 @@ static const struct primes __rcu *primes
 
 #if IS_ENABLED(CONFIG_PRIME_NUMBERS_KUNIT_TEST)
 /*
- * Calls the callback under RCU lock. The callback must not retain
- * the primes pointer.
+ * Calls the callback with the lock held, so that the primes cannot be
+ * replaced under it and the callback is allowed to sleep. The callback
+ * must not retain the primes pointer.
  */
 void with_primes(void *ctx, primes_fn fn)
 {
-	rcu_read_lock();
-	fn(ctx, rcu_dereference(primes));
-	rcu_read_unlock();
+	mutex_lock(&lock);
+	fn(ctx, rcu_dereference_protected(primes, lockdep_is_held(&lock)));
+	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL(with_primes);
 
_

Patches currently in -mm which might be from desobei@outlook.com are

lib-prime_numbers-dont-sleep-under-rcu_read_lock-in-with_primes.patch

