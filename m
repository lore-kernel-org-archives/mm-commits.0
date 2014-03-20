From: akpm@linux-foundation.org
Subject: [merged] mips-fpu-fix-conflict-of-register-usage.patch removed
 from -mm tree
Date: Thu, 20 Mar 2014 12:42:36 -0700
Message-ID: <532b44ac.NGxH5JVcYxl+zu/v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729AbaCTTmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Mar 2014 15:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, pebolle@tiscali.nl, paul.burton@imgtec.com, linux@roeck-us.net, aba@ayous.org, aaro.koskinen@iki.fi, chenhc@lemote.com

Subject: [merged] mips-fpu-fix-conflict-of-register-usage.patch removed from -mm tree
To: chenhc@lemote.com,aaro.koskinen@iki.fi,aba@ayous.org,linux@roeck-us.net,paul.burton@imgtec.com,pebolle@tiscali.nl,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 20 Mar 2014 12:42:36 -0700


The patch titled
     Subject: mips: fpu: fix conflict of register usage
has been removed from the -mm tree.  Its filename was
     mips-fpu-fix-conflict-of-register-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huacai Chen <chenhc@lemote.com>
Subject: mips: fpu: fix conflict of register usage

In _restore_fp_context/_restore_fp_context32, t0 is used for both
CP0_Status and CP1_FCSR.  This is a mistake and cause FP exeception on
boot, so fix it.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Andreas Barth <aba@ayous.org>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/r4k_fpu.S |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/mips/kernel/r4k_fpu.S~mips-fpu-fix-conflict-of-register-usage arch/mips/kernel/r4k_fpu.S
--- a/arch/mips/kernel/r4k_fpu.S~mips-fpu-fix-conflict-of-register-usage
+++ a/arch/mips/kernel/r4k_fpu.S
@@ -146,7 +146,7 @@ LEAF(_save_fp_context32)
  *  - cp1 status/control register
  */
 LEAF(_restore_fp_context)
-	EX	lw t0, SC_FPC_CSR(a0)
+	EX	lw t1, SC_FPC_CSR(a0)
 
 #if defined(CONFIG_64BIT) || defined(CONFIG_CPU_MIPS32_R2)
 	.set	push
@@ -191,7 +191,7 @@ LEAF(_restore_fp_context)
 	EX	ldc1 $f26, SC_FPREGS+208(a0)
 	EX	ldc1 $f28, SC_FPREGS+224(a0)
 	EX	ldc1 $f30, SC_FPREGS+240(a0)
-	ctc1	t0, fcr31
+	ctc1	t1, fcr31
 	jr	ra
 	 li	v0, 0					# success
 	END(_restore_fp_context)
@@ -199,7 +199,7 @@ LEAF(_restore_fp_context)
 #ifdef CONFIG_MIPS32_COMPAT
 LEAF(_restore_fp_context32)
 	/* Restore an o32 sigcontext.  */
-	EX	lw t0, SC32_FPC_CSR(a0)
+	EX	lw t1, SC32_FPC_CSR(a0)
 
 	mfc0	t0, CP0_STATUS
 	sll	t0, t0, 5
@@ -239,7 +239,7 @@ LEAF(_restore_fp_context32)
 	EX	ldc1 $f26, SC32_FPREGS+208(a0)
 	EX	ldc1 $f28, SC32_FPREGS+224(a0)
 	EX	ldc1 $f30, SC32_FPREGS+240(a0)
-	ctc1	t0, fcr31
+	ctc1	t1, fcr31
 	jr	ra
 	 li	v0, 0					# success
 	END(_restore_fp_context32)
_

Patches currently in -mm which might be from chenhc@lemote.com are

origin.patch
linux-next.patch

