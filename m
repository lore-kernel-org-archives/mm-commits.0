From: akpm@linux-foundation.org
Subject: + m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch added to -mm
 tree
Date: Thu, 09 Jun 2016 15:16:14 -0700
Message-ID: <5759eaae.HGJH3FjMrNpCIp5h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbcFIWQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2016 18:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sudip.mukherjee@codethink.co.uk, sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r-add-__ucmpdi2-to-fix-build-failure-fix
has been added to the -mm tree.  Its filename is
     m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: m32r-add-__ucmpdi2-to-fix-build-failure-fix

avoid extern declaration in .c file

Cc: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/m32r_ksyms.c |    1 -
 arch/m32r/lib/libgcc.h        |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m32r/kernel/m32r_ksyms.c~m32r-add-__ucmpdi2-to-fix-build-failure-fix arch/m32r/kernel/m32r_ksyms.c
--- a/arch/m32r/kernel/m32r_ksyms.c~m32r-add-__ucmpdi2-to-fix-build-failure-fix
+++ a/arch/m32r/kernel/m32r_ksyms.c
@@ -41,7 +41,6 @@ EXPORT_SYMBOL(cpu_data);
 EXPORT_SYMBOL(smp_flush_tlb_page);
 #endif
 
-extern int __ucmpdi2(unsigned long long a, unsigned long long b);
 EXPORT_SYMBOL(__ucmpdi2);
 
 /* compiler generated symbol */
diff -puN arch/m32r/lib/libgcc.h~m32r-add-__ucmpdi2-to-fix-build-failure-fix arch/m32r/lib/libgcc.h
--- a/arch/m32r/lib/libgcc.h~m32r-add-__ucmpdi2-to-fix-build-failure-fix
+++ a/arch/m32r/lib/libgcc.h
@@ -22,3 +22,4 @@ typedef union {
 
 #endif /* __ASM_LIBGCC_H */
 
+extern int __ucmpdi2(unsigned long long a, unsigned long long b);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-mm-memcontrol-fix-possible-css-ref-leak-on-oom.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
m32r-add-__ucmpdi2-to-fix-build-failure-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix.patch
thp-extract-khugepaged-from-mm-huge_memoryc-fix-2.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix.patch
mm-kasan-switch-slub-to-stackdepot-enable-memory-quarantine-for-slub-fix-fix.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

