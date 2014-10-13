From: akpm@linux-foundation.org
Subject: [merged] introduce-dump_vma.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:25 -0700
Message-ID: <543c17e9.tWqYYjU+5HmwZ9A6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaJMSU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, hughd@google.com, khlebnikov@openvz.org, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, swarren@nvidia.com, vbabka@suse.cz, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce dump_vma
has been removed from the -mm tree.  Its filename was
     introduce-dump_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: introduce dump_vma

Introduce a helper to dump information about a VMA, this also makes
dump_page_flags more generic and re-uses that so the output looks very
similar to dump_page:

[   61.903437] vma ffff88070f88be00 start 00007fff25970000 end 00007fff25992000
[   61.903437] next ffff88070facd600 prev ffff88070face400 mm ffff88070fade000
[   61.903437] prot 8000000000000025 anon_vma ffff88070fa1e200 vm_ops           (null)
[   61.903437] pgoff 7ffffffdd file           (null) private_data           (null)
[   61.909129] flags: 0x100173(read|write|mayread|maywrite|mayexec|growsdown|account)

[akpm@linux-foundation.org: make dump_vma() require CONFIG_DEBUG_VM]
[swarren@nvidia.com: fix dump_vma() compilation]
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    2 
 mm/page_alloc.c         |   82 +++++++++++++++++++++++++++++++++-----
 2 files changed, 75 insertions(+), 9 deletions(-)

diff -puN include/linux/mmdebug.h~introduce-dump_vma include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~introduce-dump_vma
+++ a/include/linux/mmdebug.h
@@ -4,10 +4,12 @@
 #include <linux/stringify.h>
 
 struct page;
+struct vm_area_struct;
 
 extern void dump_page(struct page *page, const char *reason);
 extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
+void dump_vma(const struct vm_area_struct *vma);
 
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
diff -puN mm/page_alloc.c~introduce-dump_vma mm/page_alloc.c
--- a/mm/page_alloc.c~introduce-dump_vma
+++ a/mm/page_alloc.c
@@ -6626,27 +6626,26 @@ static const struct trace_print_flags pa
 #endif
 };
 
-static void dump_page_flags(unsigned long flags)
+static void dump_flags(unsigned long flags,
+			const struct trace_print_flags *names, int count)
 {
 	const char *delim = "";
 	unsigned long mask;
 	int i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
-
-	printk(KERN_ALERT "page flags: %#lx(", flags);
+	printk(KERN_ALERT "flags: %#lx(", flags);
 
 	/* remove zone id */
 	flags &= (1UL << NR_PAGEFLAGS) - 1;
 
-	for (i = 0; i < ARRAY_SIZE(pageflag_names) && flags; i++) {
+	for (i = 0; i < count && flags; i++) {
 
-		mask = pageflag_names[i].mask;
+		mask = names[i].mask;
 		if ((flags & mask) != mask)
 			continue;
 
 		flags &= ~mask;
-		printk("%s%s", delim, pageflag_names[i].name);
+		printk("%s%s", delim, names[i].name);
 		delim = "|";
 	}
 
@@ -6664,12 +6663,14 @@ void dump_page_badflags(struct page *pag
 	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
 		page, atomic_read(&page->_count), page_mapcount(page),
 		page->mapping, page->index);
-	dump_page_flags(page->flags);
+	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
+	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
 	if (reason)
 		pr_alert("page dumped because: %s\n", reason);
 	if (page->flags & badflags) {
 		pr_alert("bad because of flags:\n");
-		dump_page_flags(page->flags & badflags);
+		dump_flags(page->flags & badflags,
+				pageflag_names, ARRAY_SIZE(pageflag_names));
 	}
 	mem_cgroup_print_bad_page(page);
 }
@@ -6679,3 +6680,66 @@ void dump_page(struct page *page, const
 	dump_page_badflags(page, reason, 0);
 }
 EXPORT_SYMBOL(dump_page);
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
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
kernel-add-support-for-gcc-5.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

