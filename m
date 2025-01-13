Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74662AF09
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736741690; cv=none; b=MI/hFWnNaEOvqC+Kb4HQ8nHwvlou3by0py2+K3zHDZytcThfcW0W0KppDSeHcl6AvYYmmh5lHpusLkHpHjRhyHsmv5HWcMlVHPc1i6zKZzjaEhY1xoNIRJB2nmVOmqDIkSzLAIIV6gdabeQJlNE0vIG4ohffVjxDKU3UrrsWUHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736741690; c=relaxed/simple;
	bh=pM7RVtvUJwnIhM6Vfm89Gx2pNZNCydiv0RgXyM37dPA=;
	h=Date:To:From:Subject:Message-Id; b=sy4TWBx7RWyiIhCAZssDfxoEApG0KuLjDxHVudGWyXRiE3cbOlPPxp4xEdh9ZVnDbAh1rVFN6RLoKYt1LdwYUihfHHO8yeqcb6h19rul40HGi+4RK0sb122gmn82EXj7fNkj8/co/p7+Z5GPrVyOspBiQyrWQ0fShFZMtQGP+sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cgty4jNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cgty4jNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F694C4CED6;
	Mon, 13 Jan 2025 04:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736741689;
	bh=pM7RVtvUJwnIhM6Vfm89Gx2pNZNCydiv0RgXyM37dPA=;
	h=Date:To:From:Subject:From;
	b=cgty4jNqzgKoF+rUW0/DkjZcblp8kPNDzMc1+MXM3OT51VWmEgiclN5mQxizb+Axl
	 m4LeSiDX/kh6n7OvLWKqygWsun5xBemiz6CSJ+YhQ6mQAEvRwUN6MkoMQN+RJCXy6s
	 8Dx38hM2XDHjPBz4uaAx8M7WdO0PdRBCCfKfuuSw=
Date: Sun, 12 Jan 2025 20:14:48 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,mhiramat@kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch removed from -mm tree
Message-Id: <20250113041449.4F694C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix
has been removed from the -mm tree.  Its filename was
     fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

This patch was dropped because it was folded into fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed.patch

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

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed.patch
hung_task-add-task-flags-blocked-by-coredump-to-log-fix.patch

