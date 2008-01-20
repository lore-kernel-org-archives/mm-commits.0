From: akpm@linux-foundation.org
Subject: - alpha-fix-conversion-from-denormal-float-to-double.patch removed from -mm tree
Date: Sat, 19 Jan 2008 23:04:51 -0800
Message-ID: <200801200704.m0K74V7j007811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbYATHFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 02:05:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, bonzini@gnu.org, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix conversion from denormal float to double
has been removed from the -mm tree.  Its filename was
     alpha-fix-conversion-from-denormal-float-to-double.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix conversion from denormal float to double
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

The trap handler does properly update the fraction,
but not the exponent...

Thanks to Paolo Bonzini for the bug report and the testcase.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Paolo Bonzini <bonzini@gnu.org>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/math-emu/math.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/math-emu/math.c~alpha-fix-conversion-from-denormal-float-to-double arch/alpha/math-emu/math.c
--- a/arch/alpha/math-emu/math.c~alpha-fix-conversion-from-denormal-float-to-double
+++ a/arch/alpha/math-emu/math.c
@@ -225,7 +225,7 @@ alpha_fp_emul (unsigned long pc)
 				FP_UNPACK_SP(SB, &vb);
 				DR_c = DB_c;
 				DR_s = DB_s;
-				DR_e = DB_e;
+				DR_e = DB_e + (1024 - 128);
 				DR_f = SB_f << (52 - 23);
 				goto pack_d;
 			}
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
arch-alpha-removed-duplicate-includes.patch
alpha-atomic_add_return-should-return-int.patch
alpha-kill-deprecated-virt_to_bus.patch
alpha-doesnt-use-socketcall.patch
agp-alpha-nopage.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
calibrate_delay-must-be-__cpuinit.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
make-sure-nobodys-leaking-resources.patch
