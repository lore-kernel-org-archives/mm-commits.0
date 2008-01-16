From: akpm@linux-foundation.org
Subject: + alpha-fix-conversion-from-denormal-float-to-double.patch added to -mm tree
Date: Wed, 16 Jan 2008 01:24:26 -0800
Message-ID: <200801160924.m0G9O6kv030057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102AbYAPJY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 04:24:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, bonzini@gnu.org, rth@twiddle.net


The patch titled
     alpha: fix conversion from denormal float to double
has been added to the -mm tree.  Its filename is
     alpha-fix-conversion-from-denormal-float-to-double.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
alpha-fix-conversion-from-denormal-float-to-double.patch
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
