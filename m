Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C28D21766A
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 23:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752103195; cv=none; b=MI6UbhfgWyPLolmtcpw/s8deXnocmNzUMNy1oPHkRGMhJXbzoa/BMSlsGX0WAKSvE9uuPZWVvQ/bDuKv6sUaZSx7WHGuxibjUYQecqjRo2mbpQsijjiiDZmOY4mWLemN6E1J8xe7NNgrz1y/XqMgZ/aWzvL0dw7E4o8pm2+BGJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752103195; c=relaxed/simple;
	bh=nwLdVRpSG2bcZNQRnpUy4tPgnSWnUrVMoG4bunJmoe4=;
	h=Date:To:From:Subject:Message-Id; b=lz9RH1oOTyOe5BbBUS/V9o7PiQMnqfYkH2rAoLWeQHH5Dry5Eqixwy+cFfSjtVZwZOxRNeJA9TA6rsqoLRJNYKVO6RnBUbxKo90QsagID1hFt72uS8/iQrmmDaptsxnDNJGjPZEAPhgaMGg3cawee8ax6pjNB6cZc7r3iiGw1Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xxd7+tBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xxd7+tBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E98C4CEEF;
	Wed,  9 Jul 2025 23:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752103194;
	bh=nwLdVRpSG2bcZNQRnpUy4tPgnSWnUrVMoG4bunJmoe4=;
	h=Date:To:From:Subject:From;
	b=Xxd7+tBv8Bs5jm2jAxU1q5IQzmkL/IiK1j/M8vHrGBDLsv3nsW7Pf6gTBtXSpVsqL
	 6tlcNx6Zgsj+A4ynFOzsXzzzIhx9yAOdV/U1Z3MJVVwH7ZpLQ0bnIAmG5mykFO5qh5
	 Eesgg3ImIQahIF1gqdE2N/CZCn0DH5U8i9XLbx44=
Date: Wed, 09 Jul 2025 16:19:53 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch added to mm-nonmm-unstable branch
Message-Id: <20250709231954.92E98C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: Optimize gcd() performance on RISC-V without Zbb extension
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

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
Subject: riscv: Optimize gcd() performance on RISC-V without Zbb extension
Date: Fri, 6 Jun 2025 21:47:58 +0800

The binary GCD implementation uses FFS (find first set), which benefits
from hardware support for the ctz instruction, provided by the Zbb
extension on RISC-V.  Without Zbb, this results in slower
software-emulated behavior.

Previously, RISC-V always used the binary GCD, regardless of actual
hardware support.  This patch improves runtime efficiency by disabling the
efficient_ffs_key static branch when Zbb is either not enabled in the
kernel (config) or not supported on the executing CPU.  This selects the
odd-even GCD implementation, which is faster in the absence of efficient
FFS.

This change ensures the most suitable GCD algorithm is chosen dynamically
based on actual hardware capabilities.

Link: https://lkml.kernel.org/r/20250606134758.1308400-4-visitorckw@gmail.com
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

 arch/riscv/kernel/setup.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/riscv/kernel/setup.c~riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension
+++ a/arch/riscv/kernel/setup.c
@@ -21,6 +21,8 @@
 #include <linux/efi.h>
 #include <linux/crash_dump.h>
 #include <linux/panic_notifier.h>
+#include <linux/jump_label.h>
+#include <linux/gcd.h>
 
 #include <asm/acpi.h>
 #include <asm/alternative.h>
@@ -362,6 +364,9 @@ void __init setup_arch(char **cmdline_p)
 
 	riscv_user_isa_enable();
 	riscv_spinlock_init();
+
+	if (!IS_ENABLED(CONFIG_RISCV_ISA_ZBB) || !riscv_isa_extension_available(NULL, ZBB))
+		static_branch_disable(&efficient_ffs_key);
 }
 
 bool arch_cpu_is_hotpluggable(int cpu)
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-math-gcd-use-static-key-to-select-implementation-at-runtime.patch
riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch
riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

