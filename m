From: akpm@linux-foundation.org
Subject: + arm-fix-config_swap=n-build.patch added to -mm tree
Date: Wed, 23 Feb 2011 17:01:07 -0800
Message-ID: <201102240101.p1O117rh002842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab1BXBBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 20:01:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, rmk@arm.linux.org.uk, stevec@couttsnet.com, yuasa@linux-mips.org


The patch titled
     arm: fix CONFIG_SWAP=n build
has been added to the -mm tree.  Its filename is
     arm-fix-config_swap=n-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: fix CONFIG_SWAP=n build
From: Andrew Morton <akpm@linux-foundation.org>

Thee files apparently need linux/pagemap.h to fix errors of the form

include/asm-generic/tlb.h: In function `tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function `release_pages'
include/asm-generic/tlb.h: In function `tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function `page_cache_release'

Reported-by: Steven Coutts <stevec@couttsnet.com>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    1 +
 arch/arm/mm/mmu.c  |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/arm/mm/init.c~arm-fix-config_swap=n-build arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-fix-config_swap=n-build
+++ a/arch/arm/mm/init.c
@@ -17,6 +17,7 @@
 #include <linux/initrd.h>
 #include <linux/highmem.h>
 #include <linux/gfp.h>
+#include <linux/pagemap.h>
 #include <linux/memblock.h>
 #include <linux/sort.h>
 
diff -puN arch/arm/mm/mmu.c~arm-fix-config_swap=n-build arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c~arm-fix-config_swap=n-build
+++ a/arch/arm/mm/mmu.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/mman.h>
 #include <linux/nodemask.h>
+#include <linux/pagemap.h>
 #include <linux/memblock.h>
 #include <linux/fs.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-fix-config_swap=n-build.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-platform-x86-makefile-drivers-platform-x86-intel_mid_thermalc-doesnt-exist.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
fs-ocfs2-dlm-dlmdomainc-avoid-a-gfp_atomic-allocation.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

