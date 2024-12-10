Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0027B1C242C
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 03:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733800508; cv=none; b=b8MADa4nvFf+/YSwMLLTMrLmjqVvVMq9krhLPMR2oKmHoXfjYy7Zje93ZziY3nLeXnB2jRWk3Xp20vC5QTdGpCk9ECif9SX4Smi9vnChUhg1phsBI+Z/tPED3BE5hnEi5WNG3gLQb/f7JJtsok6mza3KHORV88Bg9xIDn0+lKNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733800508; c=relaxed/simple;
	bh=rmbFnL9aL53yOMUCd7mor4tX50VqmBOAQVmMztmZlwg=;
	h=Date:To:From:Subject:Message-Id; b=UryWYMUtlNeyIU+ZnUOlN1InBQArAPyqUpSY4dRf15pz20PCSYWsOUANM2pZqAL3fFHJyX92oYt4Q3af2Mq+oTfcZjG4w+AhpTW1gsTlgUE4CoQ4oTLJr8nrhyZvJAP5YPHyXz6jwGK+ijr0TbdJgZEyrAgNJDewq+Dgalpfh7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e4J6Gw+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e4J6Gw+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0B7C4CED1;
	Tue, 10 Dec 2024 03:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733800507;
	bh=rmbFnL9aL53yOMUCd7mor4tX50VqmBOAQVmMztmZlwg=;
	h=Date:To:From:Subject:From;
	b=e4J6Gw+H8JaTKz2nmh7aWOg5kYWE56s7MLHT/CIwKVfclklQ6zXikh0wcQat7lsMi
	 4IwX1P+42SvQ5oJ1vhriHcd5w1BoekS9NuX2sHz/cAqMRXxgL1PjlacvT8SgcaSoNy
	 fRmM3LjloqV9CYQX2kMXWW/CkAe5YxdDJRuXFF3w=
Date: Mon, 09 Dec 2024 19:15:06 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,mhiramat@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20241210031507.6E0B7C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix
Date: Mon Dec  9 07:12:31 PM PST 2024

tweak and reflow comment

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/fault-inject.c~fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix
+++ a/lib/fault-inject.c
@@ -13,8 +13,8 @@
 #include <linux/fault-inject.h>
 
 /*
- * The should_fail() use prandom instead of the normal Linux RNG since they don't
- * need cryptographically secure random numbers.
+ * The should_fail() functions use prandom instead of the normal Linux RNG
+ * since they don't need cryptographically secure random numbers.
  */
 static DEFINE_PER_CPU(struct rnd_state, fault_rnd_state);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

