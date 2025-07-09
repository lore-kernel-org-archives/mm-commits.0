Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C75421766A
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 23:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752103194; cv=none; b=mqRn+zsoZZGCXsXFkidtd4C58XWlI4xj6M6snusBsy874BzxHhTj0xYeqRdTdHsMDbw81OryrViZ37VE4SXn3x/1kQoz86hW2QuOo/fJhNAA8ia3XLxArs0PxYWyPpMSch4m51wmSaMYdFb+9Mnl0TrOCwdkr6OfNA9LEYht3q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752103194; c=relaxed/simple;
	bh=nSAeicDa+LJDStL80lfbsnQciljeWHp0w2FHQvZlsRw=;
	h=Date:To:From:Subject:Message-Id; b=OUqQK6KbJIWlbRO+8GXL9xmFKqXNMgLnF5zEjp0FbM9/Pa7OlvNTkChsAXrwML0blbHeCJZ5gDyZKNJe6mtD+WJbKYvQn25nKv/AHzZiHt92o+L1CPj2VZCfg4NoCQSeTPUgoRGZC8fh7+uFNUy8CnwbrlsMnV/89bKW9C7DfV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJpmq6OA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJpmq6OA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CD1C4CEF1;
	Wed,  9 Jul 2025 23:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752103193;
	bh=nSAeicDa+LJDStL80lfbsnQciljeWHp0w2FHQvZlsRw=;
	h=Date:To:From:Subject:From;
	b=cJpmq6OAMzRD8dwFGDCrpANkb0OIHdjddCKHflF/ADA+QtIv+KYnwftPZEzasj3rW
	 x9l44aAi/T3TlUYBA4lcy0riztHqfXsL3edNll2WW0vbIPK3fufeZrpRBPIMCrQM16
	 ngQNgHOrPuMWbpkoPJx9VU998iLyyaShhWV11S5I=
Date: Wed, 09 Jul 2025 16:19:52 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch added to mm-nonmm-unstable branch
Message-Id: <20250709231953.40CD1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: optimize gcd() code size when CONFIG_RISCV_ISA_ZBB is disabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: riscv: optimize gcd() code size when CONFIG_RISCV_ISA_ZBB is disabled
Date: Fri, 6 Jun 2025 21:47:57 +0800

The binary GCD implementation depends on efficient ffs(), which on RISC-V
requires hardware support for the Zbb extension.  When
CONFIG_RISCV_ISA_ZBB is not enabled, the kernel will never use binary GCD,
as runtime logic will always fall back to the odd-even implementation.

To avoid compiling unused code and reduce code size, select
CONFIG_CPU_NO_EFFICIENT_FFS when CONFIG_RISCV_ISA_ZBB is not set.

$ ./scripts/bloat-o-meter ./lib/math/gcd.o.old ./lib/math/gcd.o.new
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-274 (-274)
Function                                     old     new   delta
gcd                                          360      86    -274
Total: Before=384, After=110, chg -71.35%

Link: https://lkml.kernel.org/r/20250606134758.1308400-3-visitorckw@gmail.com
Co-developed-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/Kconfig~riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled
+++ a/arch/riscv/Kconfig
@@ -96,6 +96,7 @@ config RISCV
 	select CLINT_TIMER if RISCV_M_MODE
 	select CLONE_BACKWARDS
 	select COMMON_CLK
+	select CPU_NO_EFFICIENT_FFS if !RISCV_ISA_ZBB
 	select CPU_PM if CPU_IDLE || HIBERNATION || SUSPEND
 	select EDAC_SUPPORT
 	select FRAME_POINTER if PERF_EVENTS || (FUNCTION_TRACER && !DYNAMIC_FTRACE)
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

