From: akpm@linux-foundation.org
Subject: [merged]
 flush_icache_range-export-symbol-to-fix-build-errors.patch removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:55 -0700
Message-ID: <540756a3.18ui+MtabL6FqglA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICR54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, chris@zankel.net, cmetcalf@tilera.com, geert@linux-m68k.org, jcmvbkbc@gmail.com, masami.hiramatsu.pt@hitachi.com, noamc@ezchip.com, rkuo@codeaurora.org, tkhai@yandex.ru, vgupta@synopsys.com, zlu@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: flush_icache_range: export symbol to fix build errors
has been removed from the -mm tree.  Its filename was
     flush_icache_range-export-symbol-to-fix-build-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

