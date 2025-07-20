Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8A315CD74
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977375; cv=none; b=vCG8LGYEGW0uP51+lpfNH1mj+k7MYOSmia1q9g2IFyVRMYDqdfsK9TZrI6apuHa9uqMy2BdIYjbvypLeArNrxES5vBQPLSzi4bZCFNo3aFwqjX2hw6HxnXevaUtWOmwDUklNvBbq9ysTw3aa6p0KK9u7FQeGJ74Wv0mmhrJ9VVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977375; c=relaxed/simple;
	bh=ojAuS7okg7ePoeTTS6MAIUzW4HJA3nhX648kcdRF5Vo=;
	h=Date:To:From:Subject:Message-Id; b=mSqYMbXawSlMzEJFPBgKmrMRGgPvVdg33QMj3FdLKCKkBYKuOgNvWLyfDxxFYRq7krSFHMzhSS2aSIVTbhf3nTeCK/np8qi5z7DKdx/CBxgL+C3h0Qlp4UUdaz0E48rJaunEyYgIVdgmb7h8+T01yc1QSuxgJLcieQxh5eM2Ago=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1IA74AM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1IA74AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEFAC4CEE3;
	Sun, 20 Jul 2025 02:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977375;
	bh=ojAuS7okg7ePoeTTS6MAIUzW4HJA3nhX648kcdRF5Vo=;
	h=Date:To:From:Subject:From;
	b=Z1IA74AMDx4R2V2q58bh1UeQjZg9GdbtLhcXuItPy8Ts6aFHdMS1BOsId9XmrNcEe
	 y2abKxFvlLqrNwCyAvz1uY0guRHy3lUaI+hUmAlngojrPI6CqOgzCayXopqzWJPz4r
	 cNgmP+VqOFzLWpmgxoekn63EkH2zeDDeCjaQNfv8=
Date: Sat, 19 Jul 2025 19:09:35 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch removed from -mm tree
Message-Id: <20250720020935.7FEFAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: optimize gcd() performance on RISC-V without Zbb extension
has been removed from the -mm tree.  Its filename was
     riscv-optimize-gcd-performance-on-risc-v-without-zbb-extension.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


