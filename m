From: akpm@linux-foundation.org
Subject: [merged] mm-pgtable-genericc-fix-config_swap=n-build.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:20 -0800
Message-ID: <201101262032.p0QKWKrV003157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999Ab1AZUcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, sam@ravnborg.org, sshtylyov@mvista.com, yuasa@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mm/pgtable-generic.c: fix CONFIG_SWAP=n build
has been removed from the -mm tree.  Its filename was
     mm-pgtable-genericc-fix-config_swap=n-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/pgtable-generic.c: fix CONFIG_SWAP=n build
From: Andrew Morton <akpm@linux-foundation.org>

mips (and sparc32):

In file included from arch/mips/include/asm/tlb.h:21,
                 from mm/pgtable-generic.c:9:
include/asm-generic/tlb.h: In function `tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function `release_pages'
include/asm-generic/tlb.h: In function `tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function `page_cache_release'

free_pages_and_swap_cache() and free_page_and_swap_cache() are macros
which call release_pages() and page_cache_release().  The obvious fix is
to include pagemap.h in swap.h, where those macros are defined.  But that
breaks sparc for weird reasons.

So fix it within mm/pgtable-generic.c instead.

Reported-by: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/pgtable-generic.c~mm-pgtable-genericc-fix-config_swap=n-build mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-pgtable-genericc-fix-config_swap=n-build
+++ a/mm/pgtable-generic.c
@@ -6,6 +6,7 @@
  *  Copyright (C) 2010  Linus Torvalds
  */
 
+#include <linux/pagemap.h>
 #include <asm/tlb.h>
 #include <asm-generic/pgtable.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

