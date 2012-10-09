From: akpm@linux-foundation.org
Subject: + mm-show-migration-types-in-show_mem.patch added to -mm tree
Date: Tue, 09 Oct 2012 14:08:52 -0700
Message-ID: <20121009210853.601035C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:55527 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JIVIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 17:08:55 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so61556eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 14:08:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rabin.vincent@stericsson.com, mel@csn.ul.ie


The patch titled
     Subject: mm: show migration types in show_mem
has been added to the -mm tree.  Its filename is
     mm-show-migration-types-in-show_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rabin Vincent <rabin.vincent@stericsson.com>
Subject: mm: show migration types in show_mem

This is useful to diagnose the reason for page allocation failure for
cases where there appear to be several free pages.

Example, with this alloc_pages(GFP_ATOMIC) failure:

 swapper/0: page allocation failure: order:0, mode:0x0
 ...
 Mem-info:
 Normal per-cpu:
 CPU    0: hi:   90, btch:  15 usd:  48
 CPU    1: hi:   90, btch:  15 usd:  21
 active_anon:0 inactive_anon:0 isolated_anon:0
  active_file:0 inactive_file:84 isolated_file:0
  unevictable:0 dirty:0 writeback:0 unstable:0
  free:4026 slab_reclaimable:75 slab_unreclaimable:484
  mapped:0 shmem:0 pagetables:0 bounce:0
 Normal free:16104kB min:2296kB low:2868kB high:3444kB active_anon:0kB
 inactive_anon:0kB active_file:0kB inactive_file:336kB unevictable:0kB
 isolated(anon):0kB isolated(file):0kB present:331776kB mlocked:0kB
 dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:300kB
 slab_unreclaimable:1936kB kernel_stack:328kB pagetables:0kB unstable:0kB
 bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
 lowmem_reserve[]: 0 0

Before the patch, it's hard (for me, at least) to say why all these free
chunks weren't considered for allocation:

 Normal: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 1*256kB 1*512kB
 1*1024kB 1*2048kB 3*4096kB = 16128kB

After the patch, it's obvious that the reason is that all of these are
in the MIGRATE_CMA (C) freelist:

 Normal: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 1*256kB (C) 1*512kB
 (C) 1*1024kB (C) 1*2048kB (C) 3*4096kB (C) = 16128kB

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-show-migration-types-in-show_mem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show-migration-types-in-show_mem
+++ a/mm/page_alloc.c
@@ -2875,6 +2875,31 @@ out:
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
 
+static void show_migration_types(unsigned char type)
+{
+	static const char types[MIGRATE_TYPES] = {
+		[MIGRATE_UNMOVABLE]	= 'U',
+		[MIGRATE_RECLAIMABLE]	= 'E',
+		[MIGRATE_MOVABLE]	= 'M',
+		[MIGRATE_RESERVE]	= 'R',
+#ifdef CONFIG_CMA
+		[MIGRATE_CMA]		= 'C',
+#endif
+		[MIGRATE_ISOLATE]	= 'I',
+	};
+	char tmp[MIGRATE_TYPES + 1];
+	char *p = tmp;
+	int i;
+
+	for (i = 0; i < MIGRATE_TYPES; i++) {
+		if (type & (1 << i))
+			*p++ = types[i];
+	}
+
+	*p = '\0';
+	printk("(%s) ", tmp);
+}
+
 /*
  * Show free area list (used inside shift_scroll-lock stuff)
  * We also calculate the percentage fragmentation. We do this by counting the
@@ -3003,6 +3028,7 @@ void show_free_areas(unsigned int filter
 
 	for_each_populated_zone(zone) {
  		unsigned long nr[MAX_ORDER], flags, order, total = 0;
+		unsigned char types[MAX_ORDER];
 
 		if (skip_free_areas_node(filter, zone_to_nid(zone)))
 			continue;
@@ -3011,12 +3037,24 @@ void show_free_areas(unsigned int filter
 
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < MAX_ORDER; order++) {
-			nr[order] = zone->free_area[order].nr_free;
+			struct free_area *area = &zone->free_area[order];
+			int type;
+
+			nr[order] = area->nr_free;
 			total += nr[order] << order;
+
+			types[order] = 0;
+			for (type = 0; type < MIGRATE_TYPES; type++) {
+				if (!list_empty(&area->free_list[type]))
+					types[order] |= 1 << type;
+			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
-		for (order = 0; order < MAX_ORDER; order++)
+		for (order = 0; order < MAX_ORDER; order++) {
 			printk("%lu*%lukB ", nr[order], K(1UL) << order);
+			if (nr[order])
+				show_migration_types(types[order]);
+		}
 		printk("= %lukB\n", K(total));
 	}
 
_

Patches currently in -mm which might be from rabin.vincent@stericsson.com are

origin.patch
mm-show-migration-types-in-show_mem.patch

