Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D59C17A30F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977374; cv=none; b=dgALkN22RgUP3YQqyq3RnmeU2HpVRyom9Gvrytc5C41NZ2WCD2NuN5sivsobFrPC3z5mMgQhl0W5N0xbBJx1kkXZN0UEugGipE9IPDb4U3mRjQdz5+MHCJsNO1h0QL54UOJBEvP7jviWKw7LYWbfHJRDxohIUrV6MtgISo/em58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977374; c=relaxed/simple;
	bh=ubFtTFHk7nDtVdiWFz2vexpUJDRcSngtnbPsX9wxxgs=;
	h=Date:To:From:Subject:Message-Id; b=q157Ahrc/WiyTUd5nTGaao9HP8snPVna4zfpLFZQIks+tXdMVQqYoh1AvnvyXRelxpEqcvNs5YKB4j2Hp+xmy/qdiUelqbdDX9y9ueHvQWra/o7S9J3iS6lb2ZFG/CYuqD9Jz+0CFS71zObHOibb7+k3XBURHfebihOcF/4zLA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y30RoSX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y30RoSX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB54C4CEE3;
	Sun, 20 Jul 2025 02:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977374;
	bh=ubFtTFHk7nDtVdiWFz2vexpUJDRcSngtnbPsX9wxxgs=;
	h=Date:To:From:Subject:From;
	b=Y30RoSX0Ng5u+61zxDOqorAgMnELcMXr4hLza9fWjMEVuBlsJbfLLF2ZjYJsJd5GJ
	 Q1Cjpf26gRV34K5TDb7as97+ViPVALwpJA8uRCoXFz39ognnad45I1OviXfMREyEFn
	 iNIyDuEdHfAoVjDM5sEH1LjWN3QZ8XRFrhkI2iZg=
Date: Sat, 19 Jul 2025 19:09:33 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,jserv@ccns.ncku.edu.tw,eleanor15x@gmail.com,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch removed from -mm tree
Message-Id: <20250720020934.0FB54C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: optimize gcd() code size when CONFIG_RISCV_ISA_ZBB is disabled
has been removed from the -mm tree.  Its filename was
     riscv-optimize-gcd-code-size-when-config_riscv_isa_zbb-is-disabled.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -97,6 +97,7 @@ config RISCV
 	select CLINT_TIMER if RISCV_M_MODE
 	select CLONE_BACKWARDS
 	select COMMON_CLK
+	select CPU_NO_EFFICIENT_FFS if !RISCV_ISA_ZBB
 	select CPU_PM if CPU_IDLE || HIBERNATION || SUSPEND
 	select EDAC_SUPPORT
 	select FRAME_POINTER if PERF_EVENTS || (FUNCTION_TRACER && !DYNAMIC_FTRACE)
_

Patches currently in -mm which might be from visitorckw@gmail.com are


