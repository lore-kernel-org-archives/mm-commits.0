Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815237;
	b=XcHR4sqWBo6Ue9RBCEqoAaj1wixJZI0J5y6l6xDBC0MUCXyn1hdehcXtcUhqmVLba+a/
	 Zf4CE8yEQDGTd/1fIy8HEw73ab/qmHhUz2gjMYXuVqE8WAq7e9NgvQeroHbDA5JKHSSq9
	 7MOFgiNnzsKpWCPzLmRUVjK9yHEU9yKisfSDWLHVqKe+jr/fj8oXQAElhYMWuDKQYkLF4
	 NiZ7IIqzj9GS2b9FaeQ3j458i/1ppDTPKRmeYPQwJZtozNOZkR9lyNse91IlR4hredLP5
	 7Ql3g1S4Gn0xKkBtGp/BSXneggbcMyxTglpjnmiy/nFUoZ7YVtE2vSqxa3t5kJoXgHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815237;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KmIZ5vPnOFcgbYW+bSNa1i+qZ1icECTNvKBllwfCKm4=;
	b=vlINb4ra9gLX9ffYL1Lx2roqTiQCxenqxpt1vefJZbfEPyEWnOGzhaLnIZrgMJPYHdTP
	 +XjJJ/cT5BX+aZTCsbdsdBUMidBVRRiAVC3yA6epWGZzxZS40U/e3iJDEskXSo2h/rDgu
	 voytWX6HlZ7GT3Zay2U+emhQLmxIzL65puIkW24IGFn55g4QKZtIO4JCwstJQHuvkgQFo
	 oZ2YmXFoOaLVRK9WTt2CV5h2AJse91WgoOzltQfHMNryi+dxRyMO2OW6kn4v0sO5GycB0
	 cCQ7wso1WuLHLKSkOg3i7tCBCpLeTowPIztXoz2/zAThU6eijf4codSy8O5CDEZpPjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1N1jQEpz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077D4606BDD3
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=1N1jQEpz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6320F1F000C1;
	Wed,  4 Nov 2026 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793815236;
	bh=KmIZ5vPnOFcgbYW+bSNa1i+qZ1icECTNvKBllwfCKm4=;
	h=Date:To:From:Subject;
	b=1N1jQEpzJPtXWD5efdBkDtPW2VckCtPiHcGCLRLv1Qt9oLlEzYSxTTtOhbPRZ2dzB
	 d9/tag9pVOAkNg68wgCWbOd5fQUraJqKJJ1FPjjEFrBvfR84ScAQrHjapKtaeDID9u
	 9QUwm0BOwhvw+sBZT616rUZ3m5PP7UhQxrF5mRuo=
Date: Wed, 04 Nov 2026 10:00:35 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryabinin.a.a@gmail.com,
	pmladek@suse.com,john.ogness@linutronix.de,glider@google.com,
	elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,leitao@debian.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-dont-warn-when-the-depot-runs-out-of-pools.patch added to mm-nonmm-unstable branch
Message-Id: <20261104180036.6320F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: stackdepot: don't WARN when the depot runs out of pools
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     stackdepot-dont-warn-when-the-depot-runs-out-of-pools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-dont-warn-when-the-depot-runs-out-of-pools.patch

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
Subject: stackdepot: don't WARN when the depot runs out of pools
Date: Tue, 03 Nov 2026 03:01:24 -0800

depot_init_pool() emits WARN_ONCE() when the depot runs out of pools.  It
runs with the raw pool_lock held and IRQs disabled, and
stack_depot_save_flags() wraps that section in printk_deferred_enter() so
that it does not print to the consoles with the lock held.

That deferral only applies to legacy consoles.  ON nbcon WARN() puts the
CPU in emergency mode, and in emergency mode printk() flushes all pending
records to the nbcon consoles from the calling context.  With a slow
serial console (pl011 is an nbcon console) and a backlog of messages, that
flush can outlast the hard lockup threshold, all of it with pool_lock held
and IRQs disabled, while every other CPU that needs to save a new stack
trace spins on pool_lock.

This was hit on an arm64 host running a KASAN and kmemleak enabled
linux-next kernel under stress-ng:

   Stack depot reached limit capacity
   WARNING: lib/stackdepot.c:302 at stack_depot_save_flags+0x6b0/0x6b8, CPU#56: stress-ng-dev/3466160
   smp: csd: Detected non-responsive CSD lock (#1) on CPU#66, waiting 5000000030 ns for CPU#19 do_nothing+0x0/0x18(0x0).
   smp: csd: Detected non-responsive CSD lock (#2) on CPU#4, waiting 5000000030 ns for CPU#61 ipi_mb+0x0/0x18(0x0).
   watchdog: CPU53: Watchdog detected hard LOCKUP on cpu 54
   Kernel panic - not syncing: Hard LOCKUP

The rest of the WARN splat never made it to the log: CPU 56 was still
flushing the console backlog from the "WARNING:" line when the hard lockup
detector fired.

Running out of depot space is an expected condition under heavy debug
load, not a kernel bug, so report it with pr_warn_once() instead.

At normal priority the nbcon consoles are printed by the printer threads,
and the legacy consoles honour printk_deferred.

This also keeps a full depot from crashing machines running with
panic_on_warn.

Link: https://lore.kernel.org/20261103-stackdepot-full-warn-v1-1-41f1fc651b64@debian.org
Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 lib/stackdepot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/stackdepot.c~stackdepot-dont-warn-when-the-depot-runs-out-of-pools
+++ a/lib/stackdepot.c
@@ -299,7 +299,7 @@ static bool depot_init_pool(void **preal
 		/* Bail out if we reached the pool limit. */
 		WARN_ON_ONCE(pools_num > stack_max_pools); /* should never happen */
 		WARN_ON_ONCE(!new_pool); /* to avoid unnecessary pre-allocation */
-		WARN_ONCE(1, "Stack depot reached limit capacity");
+		pr_warn_once("Stack depot reached limit capacity\n");
 		return false;
 	}
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-scan-modified-objects-as-soon-as-they-are-grayed.patch
tools-mm-add-hwpoison-panic-tool.patch
mm-split-out-memory-failure-declarations-from-internalh.patch
ratelimit-fix-data-race-on-burst-in-___ratelimit.patch
stackdepot-dont-warn-when-the-depot-runs-out-of-pools.patch

