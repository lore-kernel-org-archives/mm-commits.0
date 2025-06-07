Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CD136D
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 22:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749336652; cv=none; b=CCVsIT8/cN3ms544R63wzmUzcQZp+IhUvTz8wEsURPIplMg6n1miQgxuhNs56SpsPjp1IZwuJRnq5M4u5PM8LfSTrjY++PBoaizRIjiu3A+gQj2ZRe/obDLHnVA1XRRo3hyJ+j6Aq5MlOGBqMdDLoXUUPioDTzSa18K0L5nLxbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749336652; c=relaxed/simple;
	bh=dLCQF5bqwVcc7mXLqAFmysafMt3Sp3KX8HLVYmqVcT4=;
	h=Date:To:From:Subject:Message-Id; b=u9JZJCaaK6Y2qWoKEdxnuSsj/fqWERic3LcPHBm36lTxcrdHdk3m8Yw+KKAMG8iIeBGehr96jotAPv8u7JlQkRNRwQtLyMGfHQ7ak0/yy+huweUXFG7ftUEfrkBZYsD6IbR3r/7/AzyFzOCBFVQPZFIaHE6xZEh3VI2i78yS3rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cH06LWFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cH06LWFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82E0C4CEE4;
	Sat,  7 Jun 2025 22:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749336651;
	bh=dLCQF5bqwVcc7mXLqAFmysafMt3Sp3KX8HLVYmqVcT4=;
	h=Date:To:From:Subject:From;
	b=cH06LWFrkc7f92B75FgWzynfjVj/4O+2eHLErH7XRfZKsfEcUKPbpYiKTiKHrrex/
	 HcORsXucC3+N+h9YvhtqLfhDys0Si4sXB8P+tjGIJwhoY+v6dyGfr4sIs/3nSSFHFl
	 g/NHiOBWnlpBORSkLmCDESjgj65TpFwGt/pdvyX0=
Date: Sat, 07 Jun 2025 15:50:51 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alex@ghiti.fr,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch added to mm-nonmm-unstable branch
Message-Id: <20250607225051.C82E0C4CEE4@smtp.kernel.org>
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
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/Kconfig~riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled
+++ a/arch/riscv/Kconfig
@@ -95,6 +95,7 @@ config RISCV
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

