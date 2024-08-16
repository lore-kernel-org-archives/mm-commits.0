Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D248383A5
	for <mm-commits@vger.kernel.org>; Fri, 16 Aug 2024 05:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785426; cv=none; b=N5aWd+wnsKrqMzh6mRJhUuDgSEMegl8ThYd2Wc6QWVY1tUDXjru5oarh7CEMhbfQH8Jt+XKT2NpxiKh8bY1ZctOX2ib+mzZ/l6kTWKUddWT5aqWMnjm6+jCldNQE0WiDxq5AHtWb4AXlSLew1Rws6oqGgD2hYRan1oIiWLUNMfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785426; c=relaxed/simple;
	bh=GaUbMgQk9MkvELBH6JGPE9XPIKKqDXOZF2iTPkVEmEQ=;
	h=Date:To:From:Subject:Message-Id; b=JbTEk+ewREPVUC9fGDSJseWRQQHX4EcLHvfqVYVz+QUNvKd8TOwOW6WHw8YDlR7ofiCnULexP7b8uLNKKGx4fGBV/v2l+vQuMnQhr9lBSFgZfjVogrb4hfl32BqRmpK99nTR1MXAHbIeavSvS4L0qMqzzAr947owy+GEXJEE2LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dNcDVq8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dNcDVq8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32895C4AF0B;
	Fri, 16 Aug 2024 05:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785426;
	bh=GaUbMgQk9MkvELBH6JGPE9XPIKKqDXOZF2iTPkVEmEQ=;
	h=Date:To:From:Subject:From;
	b=dNcDVq8EbIZZjyCupv7cndzJHQKL8fXTgNGlHNeCU1bUGg+gw7L7lVf63Ftj2uyW2
	 qQiTgFqPu+iopKi5i/kEhCnebHMjj96VPnVRowSNlJ6UjwXM12XXgEwt3USG6pFR3Q
	 /8LZ6yusyhMC0Uk2FVnxnpKrURRNpIUXS21vPU0Q=
Date: Thu, 15 Aug 2024 22:17:05 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,dyoung@redhat.com,catalin.marinas@arm.com,bhe@redhat.com,aou@eecs.berkeley.edu,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] crash-fix-riscv64-crash-memory-reserve-dead-loop.patch removed from -mm tree
Message-Id: <20240816051706.32895C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: fix riscv64 crash memory reserve dead loop
has been removed from the -mm tree.  Its filename was
     crash-fix-riscv64-crash-memory-reserve-dead-loop.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: crash: fix riscv64 crash memory reserve dead loop
Date: Mon, 12 Aug 2024 14:20:17 +0800

On RISCV64 Qemu machine with 512MB memory, cmdline "crashkernel=500M,high"
will cause system stall as below:

	 Zone ranges:
	   DMA32    [mem 0x0000000080000000-0x000000009fffffff]
	   Normal   empty
	 Movable zone start for each node
	 Early memory node ranges
	   node   0: [mem 0x0000000080000000-0x000000008005ffff]
	   node   0: [mem 0x0000000080060000-0x000000009fffffff]
	 Initmem setup node 0 [mem 0x0000000080000000-0x000000009fffffff]
	(stall here)

commit 5d99cadf1568 ("crash: fix x86_32 crash memory reserve dead loop
bug") fix this on 32-bit architecture.  However, the problem is not
completely solved.  If `CRASH_ADDR_LOW_MAX = CRASH_ADDR_HIGH_MAX` on
64-bit architecture, for example, when system memory is equal to
CRASH_ADDR_LOW_MAX on RISCV64, the following infinite loop will also
occur:

	-> reserve_crashkernel_generic() and high is true
	   -> alloc at [CRASH_ADDR_LOW_MAX, CRASH_ADDR_HIGH_MAX] fail
	      -> alloc at [0, CRASH_ADDR_LOW_MAX] fail and repeatedly
	         (because CRASH_ADDR_LOW_MAX = CRASH_ADDR_HIGH_MAX).

As Catalin suggested, do not remove the ",high" reservation fallback to
",low" logic which will change arm64's kdump behavior, but fix it by
skipping the above situation similar to commit d2f32f23190b ("crash: fix
x86_32 crash memory reserve dead loop").

After this patch, it print:
	cannot allocate crashkernel (size:0x1f400000)

Link: https://lkml.kernel.org/r/20240812062017.2674441-1-ruanjinjie@huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Dave Young <dyoung@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/crash_reserve.c~crash-fix-riscv64-crash-memory-reserve-dead-loop
+++ a/kernel/crash_reserve.c
@@ -423,7 +423,8 @@ retry:
 		if (high && search_end == CRASH_ADDR_HIGH_MAX) {
 			search_end = CRASH_ADDR_LOW_MAX;
 			search_base = 0;
-			goto retry;
+			if (search_end != CRASH_ADDR_HIGH_MAX)
+				goto retry;
 		}
 		pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
 			crash_size);
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

