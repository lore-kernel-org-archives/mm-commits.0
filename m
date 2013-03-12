From: akpm@linux-foundation.org
Subject: + mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch added to -mm tree
Date: Tue, 12 Mar 2013 14:43:30 -0700
Message-ID: <20130312214330.6B65531C230@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:48705 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab3CLVnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 17:43:33 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so40355ggn.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 14:43:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liuj97@gmail.com, agraf@suse.de, amwang@redhat.com, arnd@arndb.de, attilio.rao@citrix.com, benh@kernel.crashing.org, davem@davemloft.net, david.daney@cavium.com, dhowells@redhat.com, geert@linux-m68k.org, hpa@zytor.com, james.hogan@imgtec.com, jdike@addtoit.com, jiang.liu@huawei.com, khlebnikov@openvz.org, konrad.wilk@oracle.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mingo@redhat.com, monstr@monstr.eu, paulus@samba.org, penberg@kernel.org, ralf@linux-mips.org, richard@nod.at, riel@redhat.com, sam@ravnborg.org, sboyd@codeaurora.org, suzuki@in.ibm.com, tglx@linutronix.de, walken@google.com, yinghai@kernel.org


The patch titled
     Subject: mm: introduce free_highmem_page() helper to free highmem pages into buddy system
has been added to the -mm tree.  Its filename is
     mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1301,6 +1301,13 @@ extern void free_initmem(void);
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
@@ -5140,6 +5140,15 @@ unsigned long free_reserved_area(unsigne
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

mm-introduce-common-help-functions-to-deal-with-reserved-managed-pages.patch
mm-alpha-use-common-help-functions-to-free-reserved-pages.patch
mm-arm-use-common-help-functions-to-free-reserved-pages.patch
mm-avr32-use-common-help-functions-to-free-reserved-pages.patch
mm-blackfin-use-common-help-functions-to-free-reserved-pages.patch
mm-c6x-use-common-help-functions-to-free-reserved-pages.patch
mm-cris-use-common-help-functions-to-free-reserved-pages.patch
mm-frv-use-common-help-functions-to-free-reserved-pages.patch
mm-h8300-use-common-help-functions-to-free-reserved-pages.patch
mm-ia64-use-common-help-functions-to-free-reserved-pages.patch
mm-m32r-use-common-help-functions-to-free-reserved-pages.patch
mm-m68k-use-common-help-functions-to-free-reserved-pages.patch
mm-microblaze-use-common-help-functions-to-free-reserved-pages.patch
mm-mips-use-common-help-functions-to-free-reserved-pages.patch
mm-mn10300-use-common-help-functions-to-free-reserved-pages.patch
mm-openrisc-use-common-help-functions-to-free-reserved-pages.patch
mm-parisc-use-common-help-functions-to-free-reserved-pages.patch
mm-ppc-use-common-help-functions-to-free-reserved-pages.patch
mm-s390-use-common-help-functions-to-free-reserved-pages.patch
mm-score-use-common-help-functions-to-free-reserved-pages.patch
mm-sh-use-common-help-functions-to-free-reserved-pages.patch
mm-sparc-use-common-help-functions-to-free-reserved-pages.patch
mm-um-use-common-help-functions-to-free-reserved-pages.patch
mm-unicore32-use-common-help-functions-to-free-reserved-pages.patch
mm-x86-use-common-help-functions-to-free-reserved-pages.patch
mm-xtensa-use-common-help-functions-to-free-reserved-pages.patch
mm-arc-use-common-help-functions-to-free-reserved-pages.patch
mm-metag-use-common-help-functions-to-free-reserved-pages.patch
mmkexec-use-common-help-functions-to-free-reserved-pages.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-frv-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-metag-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-microblaze-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-mips-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-ppc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-sparc-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-um-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
mm-x86-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch

