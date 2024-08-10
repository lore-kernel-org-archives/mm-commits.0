Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF37F624;
	Sat, 10 Aug 2024 00:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723248070; cv=none; b=Gf3hzXsovjcwK5bw75umKVBr8M4hBnuRn79ejEN+CWy2Ui7CbgRkA469aHH4Nk9OJGJkD7UC19h5iNuXw+w2fn/HasKOWqG7c8eThjytl7l9z9nidLs1Ta6VDOqxzywSgwm0zuyI989qkv81ssyrZDhkBCaT3D5z1aexJ48US/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723248070; c=relaxed/simple;
	bh=fAI7peasJQc/h6eHNzGL7P1IDtuUxKo7DhaL8g70pew=;
	h=Date:To:From:Subject:Message-Id; b=AS9/iq9fSEke3mVXO3B1f/ZNFykecWQf0Cbko6ii1MC+Sqcc608AdFefI4KlF1/pbqq2hiBKvonEOp8SxBpaFrVDku89b1l8LZobhHAngxgLwFGJJ3a0sanDcKaRSOtvCpZr+PgqcdcIbB+u+y2ALH2AlUdlq4Mkd/9zW1Wxs8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CM6k6IDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CM6k6IDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6672CC32782;
	Sat, 10 Aug 2024 00:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723248069;
	bh=fAI7peasJQc/h6eHNzGL7P1IDtuUxKo7DhaL8g70pew=;
	h=Date:To:From:Subject:From;
	b=CM6k6IDk2GpTw4nPE+Y3jRR3pVuKd2dGTLSY0HqY0DDcyL25khpR/dKgjAtefpqRa
	 hXo3KQ6gDYNRiVj/T4sbQs0NZIdAwdmkMtkKF0qGW+TjgncPoGArKcSDwe+FUBbl4Z
	 x20X0A88UmjcZjXWFjggITYI2rXOS6v0cu8qe7NE=
Date: Fri, 09 Aug 2024 17:01:08 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,dyoung@redhat.com,chenjiahao16@huawei.com,catalin.marinas@arm.com,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] crash-fix-riscv64-crash-memory-reserve-dead-loop.patch removed from -mm tree
Message-Id: <20240810000109.6672CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: Fix riscv64 crash memory reserve dead loop
has been removed from the -mm tree.  Its filename was
     crash-fix-riscv64-crash-memory-reserve-dead-loop.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: crash: Fix riscv64 crash memory reserve dead loop
Date: Fri, 2 Aug 2024 17:01:05 +0800

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

Before refactor in commit 9c08a2a139fe ("x86: kdump: use generic interface
to simplify crashkernel reservation code"), x86 do not try to reserve
crash memory at low if it fails to alloc above high 4G.  However before
refator in commit fdc268232dbba ("arm64: kdump: use generic interface to
simplify crashkernel reservation"), arm64 try to reserve crash memory at
low if it fails above high 4G.  For 64-bit systems, this attempt is less
beneficial than the opposite, remove it to fix this bug and align with
native x86 implementation.

After this patch, it print:
	cannot allocate crashkernel (size:0x1f400000)

Link: https://lkml.kernel.org/r/20240802090105.3871929-1-ruanjinjie@huawei.com
Fixes: 39365395046f ("riscv: kdump: use generic interface to simplify crashkernel reservation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/kernel/crash_reserve.c~crash-fix-riscv64-crash-memory-reserve-dead-loop
+++ a/kernel/crash_reserve.c
@@ -416,15 +416,6 @@ retry:
 			goto retry;
 		}
 
-		/*
-		 * For crashkernel=size[KMG],high, if the first attempt was
-		 * for high memory, fall back to low memory.
-		 */
-		if (high && search_end == CRASH_ADDR_HIGH_MAX) {
-			search_end = CRASH_ADDR_LOW_MAX;
-			search_base = 0;
-			goto retry;
-		}
 		pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
 			crash_size);
 		return;
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
crash-fix-x86_32-crash-memory-reserve-dead-loop.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

