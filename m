Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4F36D
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 22:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749336654; cv=none; b=PMbk3cmNCRc0ZxS4HRMuUSxA4JEFgFe2tcMNHI5gQv0UuePeiWVGd0XRsuVFw3hPUByOjbUgDgdGy4RGMDemq6mlnL1Uw6KQhb2s61NJIeLmpwYP0Lol5/VAmIn3jl7VvQX/Fug67tTNdlxW2+No07IGbYfCnef46q+8QRsLTEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749336654; c=relaxed/simple;
	bh=3wbzrr7ZD0g00EHLh6Ab9M/eRbCCTjeyrAgV9IfLr1w=;
	h=Date:To:From:Subject:Message-Id; b=UTFS6yIQoez/4D98p6igII71Dj82yWCvmA28N16v9cVTQfqMDc4T0hSeQ3Fwrc5GQUsOGniECqnsd+mYfk++P9FKzO7xblMfWsIB84ZUFApRar3O5QFPJMwb4Ver+mmQVxEvUJOsei7x7GzVCInyN8LsHG0HM7rpQ3LhnsNlH10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=elzwoPoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="elzwoPoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46F9C4CEE4;
	Sat,  7 Jun 2025 22:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749336653;
	bh=3wbzrr7ZD0g00EHLh6Ab9M/eRbCCTjeyrAgV9IfLr1w=;
	h=Date:To:From:Subject:From;
	b=elzwoPoCskCqVEm7uqy9bp9EdzNeavhEsyi96u0zoZfpWv8Omxc5pSO/avBGBdp8+
	 L8grYLuyrH3QikI6ciAj07G/1N0iRr8i2yP8sciW0dKutBPD71i/NsvgIxl1o2Mvcs
	 ejy29aKGABaGPSCCI/mAjjjny31Aw85A6UGYzpCg=
Date: Sat, 07 Jun 2025 15:50:53 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alex@ghiti.fr,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch added to mm-nonmm-unstable branch
Message-Id: <20250607225053.A46F9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: optimize gcd() performance on RISC-V without Zbb extension
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
Subject: riscv: optimize gcd() performance on RISC-V without Zbb extension
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
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
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
@@ -361,6 +363,9 @@ void __init setup_arch(char **cmdline_p)
 
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

