From: akpm@linux-foundation.org
Subject: + mm-pgtable-genericc-fix-config_swap=n-build.patch added to -mm tree
Date: Mon, 24 Jan 2011 22:34:02 -0800
Message-ID: <201101250634.p0P6Y2Wu002365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab1AYGek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 01:34:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, sam@ravnborg.org, sshtylyov@mvista.com, yuasa@linux-mips.org


The patch titled
     mm/pgtable-generic.c: fix CONFIG_SWAP=n build
has been added to the -mm tree.  Its filename is
     mm-pgtable-genericc-fix-config_swap=n-build.patch

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
Subject: mm/pgtable-generic.c: fix CONFIG_SWAP=n build
From: Andrew Morton <akpm@linux-foundation.org>

mips:

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
Cc: Sam Ravnborg <sam@ravnborg.org>
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

mm-pgtable-genericc-fix-config_swap=n-build.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
change-acquire-release_console_sem-to-console_lock-unlock-checkpatch-fixes.patch
change-acquire-release_console_sem-to-console_lock-unlock-fix-2.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
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

