From: akpm@linux-foundation.org
Subject: - lib-generic-show_mem.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:25 -0700
Message-ID: <200807262117.m6QLHPYY019925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757943AbYGZVUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, benh@kernel.crashing.org, chris@zankel.net, cooloney@kernel.org, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, heiko.carstens@d


The patch titled
     lib: generic show_mem()
has been removed from the -mm tree.  Its filename was
     lib-generic-show_mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: generic show_mem()
From: Johannes Weiner <hannes@saeurebad.de>

This implements a platform-independent version of show_mem().

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile   |    2 -
 lib/show_mem.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff -puN lib/Makefile~lib-generic-show_mem lib/Makefile
--- a/lib/Makefile~lib-generic-show_mem
+++ a/lib/Makefile
@@ -11,7 +11,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o
+	 proportions.o prio_heap.o ratelimit.o show_mem.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff -puN /dev/null lib/show_mem.c
--- /dev/null
+++ a/lib/show_mem.c
@@ -0,0 +1,63 @@
+/*
+ * Generic show_mem() implementation
+ *
+ * Copyright (C) 2008 Johannes Weiner <hannes@saeurebad.de>
+ * All code subject to the GPL version 2.
+ */
+
+#include <linux/mm.h>
+#include <linux/nmi.h>
+#include <linux/quicklist.h>
+
+void show_mem(void)
+{
+	pg_data_t *pgdat;
+	unsigned long total = 0, reserved = 0, shared = 0,
+		nonshared = 0, highmem = 0;
+
+	printk(KERN_INFO "Mem-Info:\n");
+	show_free_areas();
+
+	for_each_online_pgdat(pgdat) {
+		unsigned long i, flags;
+
+		pgdat_resize_lock(pgdat, &flags);
+		for (i = 0; i < pgdat->node_spanned_pages; i++) {
+			struct page *page;
+			unsigned long pfn = pgdat->node_start_pfn + i;
+
+			if (unlikely(!(i % MAX_ORDER_NR_PAGES)))
+				touch_nmi_watchdog();
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+
+			if (PageHighMem(page))
+				highmem++;
+
+			if (PageReserved(page))
+				reserved++;
+			else if (page_count(page) == 1)
+				nonshared++;
+			else if (page_count(page) > 1)
+				shared += page_count(page) - 1;
+
+			total++;
+		}
+		pgdat_resize_unlock(pgdat, &flags);
+	}
+
+	printk(KERN_INFO "%lu pages RAM\n", total);
+#ifdef CONFIG_HIGHMEM
+	printk(KERN_INFO "%lu pages HighMem\n", highmem);
+#endif
+	printk(KERN_INFO "%lu pages reserved\n", reserved);
+	printk(KERN_INFO "%lu pages shared\n", shared);
+	printk(KERN_INFO "%lu pages non-shared\n", nonshared);
+#ifdef CONFIG_QUICKLIST
+	printk(KERN_INFO "%lu pages in pagetable cache\n",
+		quicklist_total_size());
+#endif
+}
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch

