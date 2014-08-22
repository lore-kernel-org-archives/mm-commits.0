From: akpm@linux-foundation.org
Subject: + flush_icache_range-export-symbol-to-fix-build-errors.patch
 added to -mm tree
Date: Fri, 22 Aug 2014 15:24:46 -0700
Message-ID: <53f7c32e.LvjwYhjV/3KXihvU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:61534 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaHVWYr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Aug 2014 18:24:47 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so2268557oif.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2014 15:24:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, chris@zankel.net, cmetcalf@tilera.com, geert@linux-m68k.org, jcmvbkbc@gmail.com, masami.hiramatsu.pt@hitachi.com, noamc@ezchip.com, rkuo@codeaurora.org, tkhai@yandex.ru, vgupta@synopsys.com, zlu@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: flush_icache_range: export symbol to fix build errors
has been added to the -mm tree.  Its filename is
     flush_icache_range-export-symbol-to-fix-build-errors.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/flush_icache_range-export-symbol-to-fix-build-errors.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/flush_icache_range-export-symbol-to-fix-build-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: flush_icache_range: export symbol to fix build errors

Fix building errors occuring due to a missing export of
flush_icache_range() in

kisskb.ellerman.id.au/kisskb/buildresult/11677809/

ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Vineet Gupta <vgupta@synopsys.com>	[arc]
Acked-by: Richard Kuo <rkuo@codeaurora.org>	[hexagon]
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>	[xtensa]
Cc: Noam Camus <noamc@ezchip.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Zhigang Lu <zlu@tilera.com>		[tile]
Cc: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/cache_arc700.c |    1 +
 arch/hexagon/mm/cache.c    |    1 +
 arch/sh/mm/cache.c         |    1 +
 arch/tile/kernel/smp.c     |    1 +
 arch/xtensa/kernel/smp.c   |    1 +
 5 files changed, 5 insertions(+)

diff -puN arch/arc/mm/cache_arc700.c~flush_icache_range-export-symbol-to-fix-build-errors arch/arc/mm/cache_arc700.c
--- a/arch/arc/mm/cache_arc700.c~flush_icache_range-export-symbol-to-fix-build-errors
+++ a/arch/arc/mm/cache_arc700.c
@@ -581,6 +581,7 @@ void flush_icache_range(unsigned long ks
 		tot_sz -= sz;
 	}
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 /*
  * General purpose helper to make I and D cache lines consistent.
diff -puN arch/hexagon/mm/cache.c~flush_icache_range-export-symbol-to-fix-build-errors arch/hexagon/mm/cache.c
--- a/arch/hexagon/mm/cache.c~flush_icache_range-export-symbol-to-fix-build-errors
+++ a/arch/hexagon/mm/cache.c
@@ -68,6 +68,7 @@ void flush_icache_range(unsigned long st
 	);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 void hexagon_clean_dcache_range(unsigned long start, unsigned long end)
 {
diff -puN arch/sh/mm/cache.c~flush_icache_range-export-symbol-to-fix-build-errors arch/sh/mm/cache.c
--- a/arch/sh/mm/cache.c~flush_icache_range-export-symbol-to-fix-build-errors
+++ a/arch/sh/mm/cache.c
@@ -229,6 +229,7 @@ void flush_icache_range(unsigned long st
 
 	cacheop_on_each_cpu(local_flush_icache_range, (void *)&data, 1);
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
diff -puN arch/tile/kernel/smp.c~flush_icache_range-export-symbol-to-fix-build-errors arch/tile/kernel/smp.c
--- a/arch/tile/kernel/smp.c~flush_icache_range-export-symbol-to-fix-build-errors
+++ a/arch/tile/kernel/smp.c
@@ -183,6 +183,7 @@ void flush_icache_range(unsigned long st
 		preempt_enable();
 	}
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 
 /* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
diff -puN arch/xtensa/kernel/smp.c~flush_icache_range-export-symbol-to-fix-build-errors arch/xtensa/kernel/smp.c
--- a/arch/xtensa/kernel/smp.c~flush_icache_range-export-symbol-to-fix-build-errors
+++ a/arch/xtensa/kernel/smp.c
@@ -571,6 +571,7 @@ void flush_icache_range(unsigned long st
 	};
 	on_each_cpu(ipi_flush_icache_range, &fd, 1);
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 /* ------------------------------------------------------------------------- */
 
_

Patches currently in -mm which might be from bobby.prani@gmail.com are

flush_icache_range-export-symbol-to-fix-build-errors.patch
linux-next.patch

