From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:46:19 -0700
Message-ID: <20130430184620.195B231C2C5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33917 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab3D3SqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:46:23 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so84752vbf.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:46:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, agraf@suse.de, amwang@redhat.com, arnd@arndb.de, attilio.rao@citrix.com, benh@kernel.crashing.org, davem@davemloft.net, david.daney@cavium.com, dhowells@redhat.com, geert@linux-m68k.org, hpa@zytor.com, james.hogan@imgtec.com, jdike@addtoit.com, jiang.liu@huawei.com, khlebnikov@openvz.org, konrad.wilk@oracle.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, monstr@monstr.eu, paulus@samba.org, penberg@kernel.org, ralf@linux-mips.org, richard@nod.at, riel@redhat.com, sam@ravnborg.org, sboyd@codeaurora.org, suzuki@in.ibm.com, tglx@linutronix.de, walken@google.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce free_highmem_page() helper to free highmem pages into buddy system
has been removed from the -mm tree.  Its filename was
     mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: introduce free_highmem_page() helper to free highmem pages into buddy system

The original goal of this patchset is to fix the bug reported by
https://bugzilla.kernel.org/show_bug.cgi?id=53501
Now it has also been expanded to reduce common code used by memory
initializion.

This is the second part, which applies to the previous part at:
http://marc.info/?l=linux-mm&m=136289696323825&w=2

It introduces a helper function free_highmem_page() to free highmem
pages into the buddy system when initializing mm subsystem.
Introduction of free_highmem_page() is one step forward to clean up
accesses and modificaitons of totalhigh_pages, totalram_pages and
zone->managed_pages etc. I hope we could remove all references to
totalhigh_pages from the arch/ subdirectory.

We have only tested these patchset on x86 platforms, and have done basic
compliation tests using cross-compilers from ftp.kernel.org. That means
some code may not pass compilation on some architectures. So any help
to test this patchset are welcomed!

There are several other parts still under development:
Part3: refine code to manage totalram_pages, totalhigh_pages and
	zone->managed_pages
Part4: introduce helper functions to simplify mem_init() and remove the
	global variable num_physpages.


This patch:

Introduce helper function free_highmem_page(), which will be used by
architectures with HIGHMEM enabled to free highmem pages into the buddy
system.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: Alexander Graf <agraf@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Attilio Rao <attilio.rao@citrix.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: David Daney <david.daney@cavium.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++++++
 mm/page_alloc.c    |    9 +++++++++
 2 files changed, 16 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system
+++ a/include/linux/mm.h
@@ -1303,6 +1303,13 @@ extern void free_initmem(void);
  */
 extern unsigned long free_reserved_area(unsigned long start, unsigned long end,
 					int poison, char *s);
+#ifdef	CONFIG_HIGHMEM
+/*
+ * Free a highmem page into the buddy system, adjusting totalhigh_pages
+ * and totalram_pages.
+ */
+extern void free_highmem_page(struct page *page);
+#endif
 
 static inline void adjust_managed_page_count(struct page *page, long count)
 {
diff -puN mm/page_alloc.c~mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system
+++ a/mm/page_alloc.c
@@ -5141,6 +5141,15 @@ unsigned long free_reserved_area(unsigne
 	return pages;
 }
 
+#ifdef	CONFIG_HIGHMEM
+void free_highmem_page(struct page *page)
+{
+	__free_reserved_page(page);
+	totalram_pages++;
+	totalhigh_pages++;
+}
+#endif
+
 /**
  * set_dma_reserve - set the specified number of pages reserved in the first zone
  * @new_dma_reserve: The number of pages to mark reserved
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch

