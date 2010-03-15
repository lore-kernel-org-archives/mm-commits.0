From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-dump_page-and-print-symbolic-flag-names.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:58 -0400
Message-ID: <201003150653.o2F6rV3R016001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759712Ab0COGyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, achiang@hp.com, andi@firstfloor.org, cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@linux.vnet.ibm.com, mingo@elte.hu, riel@redhat.com, mm-commit


The patch titled
     mm: introduce dump_page() and print symbolic flag names
has been removed from the -mm tree.  Its filename was
     mm-introduce-dump_page-and-print-symbolic-flag-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce dump_page() and print symbolic flag names
From: Wu Fengguang <fengguang.wu@intel.com>

- introduce dump_page() to print the page info for debugging some error
  condition.

- convert three mm users: bad_page(), print_bad_pte() and memory offline
  failure.

- print an extra field: the symbolic names of page->flags

Example dump_page() output:

[  157.521694] page:ffffea0000a7cba8 count:2 mapcount:1 mapping:ffff88001c901791 index:0x147
[  157.525570] page flags: 0x100000000100068(uptodate|lru|active|swapbacked)

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alex Chiang <achiang@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mel Gorman <mel@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    2 +
 mm/memory.c         |    8 +---
 mm/memory_hotplug.c |    6 +--
 mm/page_alloc.c     |   83 +++++++++++++++++++++++++++++++++++++++---
 4 files changed, 86 insertions(+), 13 deletions(-)

diff -puN include/linux/mm.h~mm-introduce-dump_page-and-print-symbolic-flag-names include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-dump_page-and-print-symbolic-flag-names
+++ a/include/linux/mm.h
@@ -1465,5 +1465,7 @@ extern void shake_page(struct page *p, i
 extern atomic_long_t mce_bad_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
+extern void dump_page(struct page *page);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/memory.c~mm-introduce-dump_page-and-print-symbolic-flag-names mm/memory.c
--- a/mm/memory.c~mm-introduce-dump_page-and-print-symbolic-flag-names
+++ a/mm/memory.c
@@ -509,12 +509,8 @@ static void print_bad_pte(struct vm_area
 		"BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
 		current->comm,
 		(long long)pte_val(pte), (long long)pmd_val(*pmd));
-	if (page) {
-		printk(KERN_ALERT
-		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
-		page, (void *)page->flags, page_count(page),
-		page_mapcount(page), page->mapping, page->index);
-	}
+	if (page)
+		dump_page(page);
 	printk(KERN_ALERT
 		"addr:%p vm_flags:%08lx anon_vma:%p mapping:%p index:%lx\n",
 		(void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
diff -puN mm/memory_hotplug.c~mm-introduce-dump_page-and-print-symbolic-flag-names mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-introduce-dump_page-and-print-symbolic-flag-names
+++ a/mm/memory_hotplug.c
@@ -688,9 +688,9 @@ do_migrate_range(unsigned long start_pfn
 			if (page_count(page))
 				not_managed++;
 #ifdef CONFIG_DEBUG_VM
-			printk(KERN_INFO "removing from LRU failed"
-					 " %lx/%d/%lx\n",
-				pfn, page_count(page), page->flags);
+			printk(KERN_ALERT "removing pfn %lx from LRU failed\n",
+			       pfn);
+			dump_page(page);
 #endif
 		}
 	}
diff -puN mm/page_alloc.c~mm-introduce-dump_page-and-print-symbolic-flag-names mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-dump_page-and-print-symbolic-flag-names
+++ a/mm/page_alloc.c
@@ -50,6 +50,7 @@
 #include <linux/kmemleak.h>
 #include <linux/memory.h>
 #include <trace/events/kmem.h>
+#include <linux/ftrace_event.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -288,10 +289,7 @@ static void bad_page(struct page *page)
 
 	printk(KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
-	printk(KERN_ALERT
-		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
-		page, (void *)page->flags, page_count(page),
-		page_mapcount(page), page->mapping, page->index);
+	dump_page(page);
 
 	dump_stack();
 out:
@@ -5183,3 +5181,80 @@ bool is_free_buddy_page(struct page *pag
 	return order < MAX_ORDER;
 }
 #endif
+
+static struct trace_print_flags pageflag_names[] = {
+	{1UL << PG_locked,		"locked"	},
+	{1UL << PG_error,		"error"		},
+	{1UL << PG_referenced,		"referenced"	},
+	{1UL << PG_uptodate,		"uptodate"	},
+	{1UL << PG_dirty,		"dirty"		},
+	{1UL << PG_lru,			"lru"		},
+	{1UL << PG_active,		"active"	},
+	{1UL << PG_slab,		"slab"		},
+	{1UL << PG_owner_priv_1,	"owner_priv_1"	},
+	{1UL << PG_arch_1,		"arch_1"	},
+	{1UL << PG_reserved,		"reserved"	},
+	{1UL << PG_private,		"private"	},
+	{1UL << PG_private_2,		"private_2"	},
+	{1UL << PG_writeback,		"writeback"	},
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+	{1UL << PG_head,		"head"		},
+	{1UL << PG_tail,		"tail"		},
+#else
+	{1UL << PG_compound,		"compound"	},
+#endif
+	{1UL << PG_swapcache,		"swapcache"	},
+	{1UL << PG_mappedtodisk,	"mappedtodisk"	},
+	{1UL << PG_reclaim,		"reclaim"	},
+	{1UL << PG_buddy,		"buddy"		},
+	{1UL << PG_swapbacked,		"swapbacked"	},
+	{1UL << PG_unevictable,		"unevictable"	},
+#ifdef CONFIG_MMU
+	{1UL << PG_mlocked,		"mlocked"	},
+#endif
+#ifdef CONFIG_ARCH_USES_PG_UNCACHED
+	{1UL << PG_uncached,		"uncached"	},
+#endif
+#ifdef CONFIG_MEMORY_FAILURE
+	{1UL << PG_hwpoison,		"hwpoison"	},
+#endif
+	{-1UL,				NULL		},
+};
+
+static void dump_page_flags(unsigned long flags)
+{
+	const char *delim = "";
+	unsigned long mask;
+	int i;
+
+	printk(KERN_ALERT "page flags: %#lx(", flags);
+
+	/* remove zone id */
+	flags &= (1UL << NR_PAGEFLAGS) - 1;
+
+	for (i = 0; pageflag_names[i].name && flags; i++) {
+
+		mask = pageflag_names[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		flags &= ~mask;
+		printk("%s%s", delim, pageflag_names[i].name);
+		delim = "|";
+	}
+
+	/* check for left over flags */
+	if (flags)
+		printk("%s%#lx", delim, flags);
+
+	printk(")\n");
+}
+
+void dump_page(struct page *page)
+{
+	printk(KERN_ALERT
+	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
+		page, page_count(page), page_mapcount(page),
+		page->mapping, page->index);
+	dump_page_flags(page->flags);
+}
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-add-super-operation-writeback_inodes.patch

