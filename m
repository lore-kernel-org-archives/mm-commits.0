From: akpm@linux-foundation.org
Subject: [merged] mm-move-debug-code-out-of-page_allocc.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:51 -0700
Message-ID: <543c1803.hGIBaAdjALR2YGhw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaJMSUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move debug code out of page_alloc.c
has been removed from the -mm tree.  Its filename was
     mm-move-debug-code-out-of-page_allocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: move debug code out of page_alloc.c

dump_page() and dump_vma() are not specific to page_alloc.c, move them out
so page_alloc.c won't turn into the unofficial debug repository.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile     |    2 
 mm/debug.c      |  162 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c |  160 ---------------------------------------------
 3 files changed, 163 insertions(+), 161 deletions(-)

diff -puN mm/Makefile~mm-move-debug-code-out-of-page_allocc mm/Makefile
--- a/mm/Makefile~mm-move-debug-code-out-of-page_allocc
+++ a/mm/Makefile
@@ -18,7 +18,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   mm_init.o mmu_context.o percpu.o slab_common.o \
 			   compaction.o balloon_compaction.o vmacache.o \
 			   interval_tree.o list_lru.o workingset.o \
-			   iov_iter.o $(mmu-y)
+			   iov_iter.o debug.o $(mmu-y)
 
 obj-y += init-mm.o
 
diff -puN /dev/null mm/debug.c
--- /dev/null
+++ a/mm/debug.c
@@ -0,0 +1,162 @@
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/ftrace_event.h>
+#include <linux/memcontrol.h>
+
+static const struct trace_print_flags pageflag_names[] = {
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
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	{1UL << PG_compound_lock,	"compound_lock"	},
+#endif
+};
+
+static void dump_flags(unsigned long flags,
+			const struct trace_print_flags *names, int count)
+{
+	const char *delim = "";
+	unsigned long mask;
+	int i;
+
+	printk(KERN_ALERT "flags: %#lx(", flags);
+
+	/* remove zone id */
+	flags &= (1UL << NR_PAGEFLAGS) - 1;
+
+	for (i = 0; i < count && flags; i++) {
+
+		mask = names[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		flags &= ~mask;
+		printk("%s%s", delim, names[i].name);
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
+void dump_page_badflags(struct page *page, const char *reason,
+		unsigned long badflags)
+{
+	printk(KERN_ALERT
+	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
+		page, atomic_read(&page->_count), page_mapcount(page),
+		page->mapping, page->index);
+	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
+	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
+	if (reason)
+		pr_alert("page dumped because: %s\n", reason);
+	if (page->flags & badflags) {
+		pr_alert("bad because of flags:\n");
+		dump_flags(page->flags & badflags,
+				pageflag_names, ARRAY_SIZE(pageflag_names));
+	}
+	mem_cgroup_print_bad_page(page);
+}
+
+void dump_page(struct page *page, const char *reason)
+{
+	dump_page_badflags(page, reason, 0);
+}
+EXPORT_SYMBOL(dump_page);
+
+#ifdef CONFIG_DEBUG_VM
+
+static const struct trace_print_flags vmaflags_names[] = {
+	{VM_READ,			"read"		},
+	{VM_WRITE,			"write"		},
+	{VM_EXEC,			"exec"		},
+	{VM_SHARED,			"shared"	},
+	{VM_MAYREAD,			"mayread"	},
+	{VM_MAYWRITE,			"maywrite"	},
+	{VM_MAYEXEC,			"mayexec"	},
+	{VM_MAYSHARE,			"mayshare"	},
+	{VM_GROWSDOWN,			"growsdown"	},
+	{VM_PFNMAP,			"pfnmap"	},
+	{VM_DENYWRITE,			"denywrite"	},
+	{VM_LOCKED,			"locked"	},
+	{VM_IO,				"io"		},
+	{VM_SEQ_READ,			"seqread"	},
+	{VM_RAND_READ,			"randread"	},
+	{VM_DONTCOPY,			"dontcopy"	},
+	{VM_DONTEXPAND,			"dontexpand"	},
+	{VM_ACCOUNT,			"account"	},
+	{VM_NORESERVE,			"noreserve"	},
+	{VM_HUGETLB,			"hugetlb"	},
+	{VM_NONLINEAR,			"nonlinear"	},
+#if defined(CONFIG_X86)
+	{VM_PAT,			"pat"		},
+#elif defined(CONFIG_PPC)
+	{VM_SAO,			"sao"		},
+#elif defined(CONFIG_PARISC) || defined(CONFIG_METAG) || defined(CONFIG_IA64)
+	{VM_GROWSUP,			"growsup"	},
+#elif !defined(CONFIG_MMU)
+	{VM_MAPPED_COPY,		"mappedcopy"	},
+#else
+	{VM_ARCH_1,			"arch_1"	},
+#endif
+	{VM_DONTDUMP,			"dontdump"	},
+#ifdef CONFIG_MEM_SOFT_DIRTY
+	{VM_SOFTDIRTY,			"softdirty"	},
+#endif
+	{VM_MIXEDMAP,			"mixedmap"	},
+	{VM_HUGEPAGE,			"hugepage"	},
+	{VM_NOHUGEPAGE,			"nohugepage"	},
+	{VM_MERGEABLE,			"mergeable"	},
+};
+
+void dump_vma(const struct vm_area_struct *vma)
+{
+	printk(KERN_ALERT
+		"vma %p start %p end %p\n"
+		"next %p prev %p mm %p\n"
+		"prot %lx anon_vma %p vm_ops %p\n"
+		"pgoff %lx file %p private_data %p\n",
+		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
+		vma->vm_prev, vma->vm_mm,
+		(unsigned long)pgprot_val(vma->vm_page_prot),
+		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
+		vma->vm_file, vma->vm_private_data);
+	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
+}
+EXPORT_SYMBOL(dump_vma);
+
+#endif		/* CONFIG_DEBUG_VM */
diff -puN mm/page_alloc.c~mm-move-debug-code-out-of-page_allocc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-debug-code-out-of-page_allocc
+++ a/mm/page_alloc.c
@@ -53,8 +53,6 @@
 #include <linux/kmemleak.h>
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
-#include <linux/ftrace_event.h>
-#include <linux/memcontrol.h>
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
 #include <linux/migrate.h>
@@ -6550,161 +6548,3 @@ bool is_free_buddy_page(struct page *pag
 	return order < MAX_ORDER;
 }
 #endif
-
-static const struct trace_print_flags pageflag_names[] = {
-	{1UL << PG_locked,		"locked"	},
-	{1UL << PG_error,		"error"		},
-	{1UL << PG_referenced,		"referenced"	},
-	{1UL << PG_uptodate,		"uptodate"	},
-	{1UL << PG_dirty,		"dirty"		},
-	{1UL << PG_lru,			"lru"		},
-	{1UL << PG_active,		"active"	},
-	{1UL << PG_slab,		"slab"		},
-	{1UL << PG_owner_priv_1,	"owner_priv_1"	},
-	{1UL << PG_arch_1,		"arch_1"	},
-	{1UL << PG_reserved,		"reserved"	},
-	{1UL << PG_private,		"private"	},
-	{1UL << PG_private_2,		"private_2"	},
-	{1UL << PG_writeback,		"writeback"	},
-#ifdef CONFIG_PAGEFLAGS_EXTENDED
-	{1UL << PG_head,		"head"		},
-	{1UL << PG_tail,		"tail"		},
-#else
-	{1UL << PG_compound,		"compound"	},
-#endif
-	{1UL << PG_swapcache,		"swapcache"	},
-	{1UL << PG_mappedtodisk,	"mappedtodisk"	},
-	{1UL << PG_reclaim,		"reclaim"	},
-	{1UL << PG_swapbacked,		"swapbacked"	},
-	{1UL << PG_unevictable,		"unevictable"	},
-#ifdef CONFIG_MMU
-	{1UL << PG_mlocked,		"mlocked"	},
-#endif
-#ifdef CONFIG_ARCH_USES_PG_UNCACHED
-	{1UL << PG_uncached,		"uncached"	},
-#endif
-#ifdef CONFIG_MEMORY_FAILURE
-	{1UL << PG_hwpoison,		"hwpoison"	},
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	{1UL << PG_compound_lock,	"compound_lock"	},
-#endif
-};
-
-static void dump_flags(unsigned long flags,
-			const struct trace_print_flags *names, int count)
-{
-	const char *delim = "";
-	unsigned long mask;
-	int i;
-
-	printk(KERN_ALERT "flags: %#lx(", flags);
-
-	/* remove zone id */
-	flags &= (1UL << NR_PAGEFLAGS) - 1;
-
-	for (i = 0; i < count && flags; i++) {
-
-		mask = names[i].mask;
-		if ((flags & mask) != mask)
-			continue;
-
-		flags &= ~mask;
-		printk("%s%s", delim, names[i].name);
-		delim = "|";
-	}
-
-	/* check for left over flags */
-	if (flags)
-		printk("%s%#lx", delim, flags);
-
-	printk(")\n");
-}
-
-void dump_page_badflags(struct page *page, const char *reason,
-		unsigned long badflags)
-{
-	printk(KERN_ALERT
-	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
-		page, atomic_read(&page->_count), page_mapcount(page),
-		page->mapping, page->index);
-	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
-	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
-	if (reason)
-		pr_alert("page dumped because: %s\n", reason);
-	if (page->flags & badflags) {
-		pr_alert("bad because of flags:\n");
-		dump_flags(page->flags & badflags,
-				pageflag_names, ARRAY_SIZE(pageflag_names));
-	}
-	mem_cgroup_print_bad_page(page);
-}
-
-void dump_page(struct page *page, const char *reason)
-{
-	dump_page_badflags(page, reason, 0);
-}
-EXPORT_SYMBOL(dump_page);
-
-#ifdef CONFIG_DEBUG_VM
-
-static const struct trace_print_flags vmaflags_names[] = {
-	{VM_READ,			"read"		},
-	{VM_WRITE,			"write"		},
-	{VM_EXEC,			"exec"		},
-	{VM_SHARED,			"shared"	},
-	{VM_MAYREAD,			"mayread"	},
-	{VM_MAYWRITE,			"maywrite"	},
-	{VM_MAYEXEC,			"mayexec"	},
-	{VM_MAYSHARE,			"mayshare"	},
-	{VM_GROWSDOWN,			"growsdown"	},
-	{VM_PFNMAP,			"pfnmap"	},
-	{VM_DENYWRITE,			"denywrite"	},
-	{VM_LOCKED,			"locked"	},
-	{VM_IO,				"io"		},
-	{VM_SEQ_READ,			"seqread"	},
-	{VM_RAND_READ,			"randread"	},
-	{VM_DONTCOPY,			"dontcopy"	},
-	{VM_DONTEXPAND,			"dontexpand"	},
-	{VM_ACCOUNT,			"account"	},
-	{VM_NORESERVE,			"noreserve"	},
-	{VM_HUGETLB,			"hugetlb"	},
-	{VM_NONLINEAR,			"nonlinear"	},
-#if defined(CONFIG_X86)
-	{VM_PAT,			"pat"		},
-#elif defined(CONFIG_PPC)
-	{VM_SAO,			"sao"		},
-#elif defined(CONFIG_PARISC) || defined(CONFIG_METAG) || defined(CONFIG_IA64)
-	{VM_GROWSUP,			"growsup"	},
-#elif !defined(CONFIG_MMU)
-	{VM_MAPPED_COPY,		"mappedcopy"	},
-#else
-	{VM_ARCH_1,			"arch_1"	},
-#endif
-	{VM_DONTDUMP,			"dontdump"	},
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	{VM_SOFTDIRTY,			"softdirty"	},
-#endif
-	{VM_MIXEDMAP,			"mixedmap"	},
-	{VM_HUGEPAGE,			"hugepage"	},
-	{VM_NOHUGEPAGE,			"nohugepage"	},
-	{VM_MERGEABLE,			"mergeable"	},
-};
-
-void dump_vma(const struct vm_area_struct *vma)
-{
-	printk(KERN_ALERT
-		"vma %p start %p end %p\n"
-		"next %p prev %p mm %p\n"
-		"prot %lx anon_vma %p vm_ops %p\n"
-		"pgoff %lx file %p private_data %p\n",
-		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
-		vma->vm_prev, vma->vm_mm,
-		(unsigned long)pgprot_val(vma->vm_page_prot),
-		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
-		vma->vm_file, vma->vm_private_data);
-	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
-}
-EXPORT_SYMBOL(dump_vma);
