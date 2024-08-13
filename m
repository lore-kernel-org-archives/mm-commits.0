Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2247543AB0
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 06:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723530502; cv=none; b=UOEl05i0IHwiAayfkx9FnS1FJ71G0eFkVr+I7u4b87OZW1+0tkyAGAdieVMUCp5+i9mR15TC0AITh4Vp8QnPFd6yCizyc0Eu/dKUWu39iXsptozdPCFO+RdkUTSsAd+8GWPbfYR/8BRbapNLhmq/f25U2hDeGmhzS504OO0XUMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723530502; c=relaxed/simple;
	bh=ka60lIgJqx8poGwiVEs4DWeOUKVUdSaQavPUrnZRmkk=;
	h=Date:To:From:Subject:Message-Id; b=jbaRPh9igF9Q1v4HBCvCdLknPn5Wh+1oabojJcNGiVpZkmkeBsRPqxKIVrNGrNV+uwCoNmQuvRji3AFtPJ62byh2/wkW6RXQ3hJUHoWndKEjnVfn/7lNmnk7Lb3wAtq6vud2tHt2+apxvuWhUWUE0V1KiU3M8xAeD2yQqudbFy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRlX758+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRlX758+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DCBC4AF0B;
	Tue, 13 Aug 2024 06:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723530501;
	bh=ka60lIgJqx8poGwiVEs4DWeOUKVUdSaQavPUrnZRmkk=;
	h=Date:To:From:Subject:From;
	b=wRlX758+wpfgJbZJOz2nhn6OrVh9HjD3fi+2Xatjzw8Ms3CaqrA/fG/+P7jWNuitE
	 +l6b9k4QmDCrBa3dZaDZ1X56QGPxTTOaplW11bUOg93CdWjhXFJ5vTkwuCR9ORCEd5
	 t/iUxpTo3mut3RMTWehXBT2CSq/zLFgSxbAT7ysw=
Date: Mon, 12 Aug 2024 23:28:20 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,dyoung@redhat.com,catalin.marinas@arm.com,bhe@redhat.com,aou@eecs.berkeley.edu,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-fix-riscv64-crash-memory-reserve-dead-loop.patch added to mm-hotfixes-unstable branch
Message-Id: <20240813062821.92DCBC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix riscv64 crash memory reserve dead loop
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     crash-fix-riscv64-crash-memory-reserve-dead-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-riscv64-crash-memory-reserve-dead-loop.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

crash-fix-riscv64-crash-memory-reserve-dead-loop.patch
crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

