From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-printk-introduce-new-format-string-for-flags.patch removed from -mm tree
Date: Wed, 02 Dec 2015 14:14:51 -0800
Message-ID: <565f6d5b.RqL6N8vvYQnHWfD+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbbLBWOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, printk: introduce new format string for flags
has been removed from the -mm tree.  Its filename was
     mm-printk-introduce-new-format-string-for-flags.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, printk: introduce new format string for flags

In mm we use several kinds of flags bitfields that are sometimes printed for
debugging purposes, or exported to userspace via sysfs. To make them easier to
interpret independently on kernel version and config, we want to dump also the
symbolic flag names. So far this has been done with repeated calls to
pr_cont(), which is unreliable on SMP, and not usable for e.g. sysfs export.

To get a more reliable and universal solution, this patch extends printk()
format string for pointers to handle the page flags (%pgp), gfp_flags (%pgg)
and vma flags (%pgv). Existing users of dump_flag_names() are converted and
simplified.

It would be possible to pass flags by value instead of pointer, but the %p
format string for pointers already has extensions for various kernel
structures, so it's a good fit, and the extra indirection in a non-critical
path is negligible.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   14 ++
 include/linux/mmdebug.h          |    5 
 lib/vsprintf.c                   |   31 +++++
 mm/debug.c                       |  150 ++++++++++++++++-------------
 mm/oom_kill.c                    |    5 
 mm/page_alloc.c                  |    5 
 mm/page_owner.c                  |    5 
 7 files changed, 140 insertions(+), 75 deletions(-)

diff -puN Documentation/printk-formats.txt~mm-printk-introduce-new-format-string-for-flags Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~mm-printk-introduce-new-format-string-for-flags
+++ a/Documentation/printk-formats.txt
@@ -292,6 +292,20 @@ bitmap and its derivatives such as cpuma
 
 	Passed by reference.
 
+Flags bitfields such as page flags, gfp_flags:
+
+	%pgp	0x1fffff8000086c(referenced|uptodate|lru|active|private)
+	%pgg	0x24202c4(GFP_USER|GFP_DMA32|GFP_NOWARN)
+	%pgv	0x875(read|exec|mayread|maywrite|mayexec|denywrite)
+
+	For printing raw values of flags bitfields together with symbolic
+	strings that would construct the value. The type of flags is given by
+	the third character. Currently supported are [p]age flags, [g]fp_flags
+	and [v]ma_flags. The flag names and print order depends on the
+	particular type.
+
+	Passed by reference.
+
 Network device features:
 
 	%pNF	0x000000000000c000
diff -puN include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-printk-introduce-new-format-string-for-flags
+++ a/include/linux/mmdebug.h
@@ -2,6 +2,7 @@
 #define LINUX_MM_DEBUG_H 1
 
 #include <linux/stringify.h>
+#include <linux/types.h>
 
 struct page;
 struct vm_area_struct;
@@ -10,7 +11,9 @@ struct mm_struct;
 extern void dump_page(struct page *page, const char *reason);
 extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
-extern void dump_gfpflag_names(unsigned long gfp_flags);
+extern char *format_page_flags(unsigned long flags, char *buf, char *end);
+extern char *format_vma_flags(unsigned long flags, char *buf, char *end);
+extern char *format_gfp_flags(gfp_t gfp_flags, char *buf, char*end);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 
diff -puN lib/vsprintf.c~mm-printk-introduce-new-format-string-for-flags lib/vsprintf.c
--- a/lib/vsprintf.c~mm-printk-introduce-new-format-string-for-flags
+++ a/lib/vsprintf.c
@@ -31,6 +31,7 @@
 #include <linux/dcache.h>
 #include <linux/cred.h>
 #include <net/addrconf.h>
+#include <linux/mmdebug.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
@@ -1361,6 +1362,29 @@ char *clock(char *buf, char *end, struct
 	}
 }
 
+static noinline_for_stack
+char *flags_string(char *buf, char *end, void *flags_ptr,
+			struct printf_spec spec, const char *fmt)
+{
+	unsigned long flags;
+	gfp_t gfp_flags;
+
+	switch (fmt[1]) {
+	case 'p':
+		flags = *(unsigned long *)flags_ptr;
+		return format_page_flags(flags, buf, end);
+	case 'v':
+		flags = *(unsigned long *)flags_ptr;
+		return format_vma_flags(flags, buf, end);
+	case 'g':
+		gfp_flags = *(gfp_t *)flags_ptr;
+		return format_gfp_flags(gfp_flags, buf, end);
+	default:
+		WARN_ONCE(1, "Unsupported flags modifier: %c\n", fmt[1]);
+		return 0;
+	}
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1448,6 +1472,11 @@ int kptr_restrict __read_mostly;
  * - 'Cn' For a clock, it prints the name (Common Clock Framework) or address
  *        (legacy clock framework) of the clock
  * - 'Cr' For a clock, it prints the current rate of the clock
+ * - 'g' For flags to be printed as a collection of symbolic strings that would
+ *       construct the specific value. Supported flags given by option:
+ *       p page flags (see struct page) given as pointer to unsigned long
+ *       g gfp flags (GFP_* and __GFP_*) given as pointer to gfp_t
+ *       v vma flags (VM_*) given as pointer to unsigned long
  *
  * ** Please update also Documentation/printk-formats.txt when making changes **
  *
@@ -1600,6 +1629,8 @@ char *pointer(const char *fmt, char *buf
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'g':
+		return flags_string(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
diff -puN mm/debug.c~mm-printk-introduce-new-format-string-for-flags mm/debug.c
--- a/mm/debug.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/debug.c
@@ -59,40 +59,109 @@ static const struct trace_print_flags pa
 #endif
 };
 
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
+	{VM_LOCKONFAULT,		"lockonfault"	},
+	{VM_LOCKED,			"locked"	},
+	{VM_IO,				"io"		},
+	{VM_SEQ_READ,			"seqread"	},
+	{VM_RAND_READ,			"randread"	},
+	{VM_DONTCOPY,			"dontcopy"	},
+	{VM_DONTEXPAND,			"dontexpand"	},
+	{VM_ACCOUNT,			"account"	},
+	{VM_NORESERVE,			"noreserve"	},
+	{VM_HUGETLB,			"hugetlb"	},
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
 static const struct trace_print_flags gfpflag_names[] = {
 	__def_gfpflag_names
 };
 
-static void dump_flag_names(unsigned long flags,
-			const struct trace_print_flags *names, int count)
+static char *format_flag_names(unsigned long flags, unsigned long mask_out,
+		const struct trace_print_flags *names, int count,
+		char *buf, char *end)
 {
 	const char *delim = "";
 	unsigned long mask;
 	int i;
 
-	pr_cont("(");
+	buf += snprintf(buf, end - buf, "%#lx(", flags);
+
+	flags &= ~mask_out;
 
 	for (i = 0; i < count && flags; i++) {
+		if (buf >= end)
+			break;
 
 		mask = names[i].mask;
 		if ((flags & mask) != mask)
 			continue;
 
 		flags &= ~mask;
-		pr_cont("%s%s", delim, names[i].name);
+		buf += snprintf(buf, end - buf, "%s%s", delim, names[i].name);
 		delim = "|";
 	}
 
 	/* check for left over flags */
-	if (flags)
-		pr_cont("%s%#lx", delim, flags);
+	if (flags && (buf < end))
+		buf += snprintf(buf, end - buf, "%s%#lx", delim, flags);
+
+	if (buf < end) {
+		*buf = ')';
+		buf++;
+	}
 
-	pr_cont(")\n");
+	return buf;
 }
 
-void dump_gfpflag_names(unsigned long gfp_flags)
+char *format_page_flags(unsigned long flags, char *buf, char *end)
 {
-	dump_flag_names(gfp_flags, gfpflag_names, ARRAY_SIZE(gfpflag_names));
+	/* remove zone id */
+	unsigned long mask = (1UL << NR_PAGEFLAGS) - 1;
+
+	return format_flag_names(flags, ~mask, pageflag_names,
+					ARRAY_SIZE(pageflag_names), buf, end);
+}
+
+char *format_vma_flags(unsigned long flags, char *buf, char *end)
+{
+	return format_flag_names(flags, 0, vmaflags_names,
+					ARRAY_SIZE(vmaflags_names), buf, end);
+}
+
+char *format_gfp_flags(gfp_t gfp_flags, char *buf, char *end)
+{
+	return format_flag_names(gfp_flags, 0, gfpflag_names,
+					ARRAY_SIZE(gfpflag_names), buf, end);
 }
 
 void dump_page_badflags(struct page *page, const char *reason,
@@ -108,18 +177,15 @@ void dump_page_badflags(struct page *pag
 	pr_cont("\n");
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
 
-	pr_emerg("flags: %#lx", printflags);
+	pr_emerg("flags: %pgp\n", &printflags);
 	/* remove zone id */
 	printflags &= (1UL << NR_PAGEFLAGS) - 1;
-	dump_flag_names(printflags, pageflag_names, ARRAY_SIZE(pageflag_names));
 
 	if (reason)
 		pr_alert("page dumped because: %s\n", reason);
 	if (page->flags & badflags) {
 		printflags = page->flags & badflags;
-		pr_alert("bad because of flags: %#lx:", printflags);
-		dump_flag_names(printflags, pageflag_names,
-						ARRAY_SIZE(pageflag_names));
+		pr_alert("bad because of flags: %pgp\n", &printflags);
 	}
 #ifdef CONFIG_MEMCG
 	if (page->mem_cgroup)
@@ -136,63 +202,19 @@ EXPORT_SYMBOL(dump_page);
 
 #ifdef CONFIG_DEBUG_VM
 
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
-	{VM_LOCKONFAULT,		"lockonfault"	},
-	{VM_LOCKED,			"locked"	},
-	{VM_IO,				"io"		},
-	{VM_SEQ_READ,			"seqread"	},
-	{VM_RAND_READ,			"randread"	},
-	{VM_DONTCOPY,			"dontcopy"	},
-	{VM_DONTEXPAND,			"dontexpand"	},
-	{VM_ACCOUNT,			"account"	},
-	{VM_NORESERVE,			"noreserve"	},
-	{VM_HUGETLB,			"hugetlb"	},
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
 void dump_vma(const struct vm_area_struct *vma)
 {
 	pr_emerg("vma %p start %p end %p\n"
 		"next %p prev %p mm %p\n"
 		"prot %lx anon_vma %p vm_ops %p\n"
-		"pgoff %lx file %p private_data %p\n",
+		"pgoff %lx file %p private_data %p\n"
+		"flags: %pgv\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
 		vma->vm_prev, vma->vm_mm,
 		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
-		vma->vm_file, vma->vm_private_data);
-	pr_emerg("flags: %#lx", vma->vm_flags);
-	dump_flag_names(vma->vm_flags, vmaflags_names,
-						ARRAY_SIZE(vmaflags_names));
+		vma->vm_file, vma->vm_private_data,
+		&vma->vm_flags);
 }
 EXPORT_SYMBOL(dump_vma);
 
@@ -263,9 +285,7 @@ void dump_mm(const struct mm_struct *mm)
 		""		/* This is here to not have a comma! */
 		);
 
-	pr_emerg("def_flags: %#lx", mm->def_flags);
-	dump_flag_names(mm->def_flags, vmaflags_names,
-					ARRAY_SIZE(vmaflags_names));
+	pr_emerg("def_flags: %pgv\n", &mm->def_flags);
 }
 
 #endif		/* CONFIG_DEBUG_VM */
diff -puN mm/oom_kill.c~mm-printk-introduce-new-format-string-for-flags mm/oom_kill.c
--- a/mm/oom_kill.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/oom_kill.c
@@ -387,10 +387,9 @@ static void dump_header(struct oom_contr
 			struct mem_cgroup *memcg)
 {
 	pr_warning("%s invoked oom-killer: order=%d, oom_score_adj=%hd, "
-			"gfp_mask=0x%x",
+			"gfp_mask=%pgg\n",
 		current->comm, oc->order, current->signal->oom_score_adj,
-		oc->gfp_mask);
-	dump_gfpflag_names(oc->gfp_mask);
+		&oc->gfp_mask);
 
 	cpuset_print_current_mems_allowed();
 	dump_stack();
diff -puN mm/page_alloc.c~mm-printk-introduce-new-format-string-for-flags mm/page_alloc.c
--- a/mm/page_alloc.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/page_alloc.c
@@ -2704,9 +2704,8 @@ void warn_alloc_failed(gfp_t gfp_mask, u
 		va_end(args);
 	}
 
-	pr_warn("%s: page allocation failure: order:%u, mode:0x%x",
-		current->comm, order, gfp_mask);
-	dump_gfpflag_names(gfp_mask);
+	pr_warn("%s: page allocation failure: order:%u, mode:%pgg\n",
+		current->comm, order, &gfp_mask);
 	dump_stack();
 	if (!should_suppress_show_mem())
 		show_mem(filter);
diff -puN mm/page_owner.c~mm-printk-introduce-new-format-string-for-flags mm/page_owner.c
--- a/mm/page_owner.c~mm-printk-introduce-new-format-string-for-flags
+++ a/mm/page_owner.c
@@ -208,9 +208,8 @@ void __dump_page_owner(struct page *page
 		return;
 	}
 
-	pr_alert("page allocated via order %u, migratetype %s, gfp_mask 0x%x",
-			page_ext->order, migratetype_names[mt], gfp_mask);
-	dump_gfpflag_names(gfp_mask);
+	pr_alert("page allocated via order %u, migratetype %s, gfp_mask %pgg\n",
+			page_ext->order, migratetype_names[mt], &gfp_mask);
 	print_stack_trace(&trace, 0);
 
 	if (page_ext->last_migrate_reason != -1)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-track-and-print-last-migrate-reason-fix.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch

