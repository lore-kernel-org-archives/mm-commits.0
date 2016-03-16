From: akpm@linux-foundation.org
Subject: [merged]
 mm-debug-replace-dump_flags-with-the-new-printk-formats.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:55:50 -0700
Message-ID: <56e9ba46.Ou1DTcjqS+65AfPY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbcCPTzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, acme@kernel.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, linux@rasmusvillemoes.dk, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, rostedt@goodmis.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: replace dump_flags() with the new printk formats
has been removed from the -mm tree.  Its filename was
     mm-debug-replace-dump_flags-with-the-new-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, debug: replace dump_flags() with the new printk formats

With the new printk format strings for flags, we can get rid of
dump_flags() in mm/debug.c.

This also fixes dump_vma() which used dump_flags() for printing vma flags.
However dump_flags() did a page-flags specific filtering of bits higher
than NR_PAGEFLAGS in order to remove the zone id part.  For dump_vma()
this resulted in removing several VM_* flags from the symbolic
translation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   60 +++++++++++----------------------------------------
 1 file changed, 14 insertions(+), 46 deletions(-)

diff -puN mm/debug.c~mm-debug-replace-dump_flags-with-the-new-printk-formats mm/debug.c
--- a/mm/debug.c~mm-debug-replace-dump_flags-with-the-new-printk-formats
+++ a/mm/debug.c
@@ -28,36 +28,6 @@ const struct trace_print_flags vmaflag_n
 	{0, NULL}
 };
 
-static void dump_flags(unsigned long flags,
-			const struct trace_print_flags *names, int count)
-{
-	const char *delim = "";
-	unsigned long mask;
-	int i;
-
-	pr_emerg("flags: %#lx(", flags);
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
-		pr_cont("%s%s", delim, names[i].name);
-		delim = "|";
-	}
-
-	/* check for left over flags */
-	if (flags)
-		pr_cont("%s%#lx", delim, flags);
-
-	pr_cont(")\n");
-}
-
 void dump_page_badflags(struct page *page, const char *reason,
 		unsigned long badflags)
 {
@@ -68,15 +38,15 @@ void dump_page_badflags(struct page *pag
 		pr_cont(" compound_mapcount: %d", compound_mapcount(page));
 	pr_cont("\n");
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
-	dump_flags(page->flags, pageflag_names,
-					ARRAY_SIZE(pageflag_names) - 1);
+	pr_emerg("flags: %#lx(%pGp)\n", page->flags, &page->flags);
+
 	if (reason)
 		pr_alert("page dumped because: %s\n", reason);
-	if (page->flags & badflags) {
-		pr_alert("bad because of flags:\n");
-		dump_flags(page->flags & badflags, pageflag_names,
-					ARRAY_SIZE(pageflag_names) - 1);
-	}
+
+	badflags &= page->flags;
+	if (badflags)
+		pr_alert("bad because of flags: %#lx(%pGp)\n", badflags,
+								&badflags);
 #ifdef CONFIG_MEMCG
 	if (page->mem_cgroup)
 		pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
@@ -96,13 +66,14 @@ void dump_vma(const struct vm_area_struc
 	pr_emerg("vma %p start %p end %p\n"
 		"next %p prev %p mm %p\n"
 		"prot %lx anon_vma %p vm_ops %p\n"
-		"pgoff %lx file %p private_data %p\n",
+		"pgoff %lx file %p private_data %p\n"
+		"flags: %#lx(%pGv)\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
 		vma->vm_prev, vma->vm_mm,
 		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
-		vma->vm_file, vma->vm_private_data);
-	dump_flags(vma->vm_flags, vmaflag_names, ARRAY_SIZE(vmaflag_names) - 1);
+		vma->vm_file, vma->vm_private_data,
+		vma->vm_flags, &vma->vm_flags);
 }
 EXPORT_SYMBOL(dump_vma);
 
@@ -136,7 +107,7 @@ void dump_mm(const struct mm_struct *mm)
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 		"tlb_flush_pending %d\n"
 #endif
-		"%s",	/* This is here to hold the comma */
+		"def_flags: %#lx(%pGv)\n",
 
 		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
 #ifdef CONFIG_MMU
@@ -170,11 +141,8 @@ void dump_mm(const struct mm_struct *mm)
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 		mm->tlb_flush_pending,
 #endif
-		""		/* This is here to not have a comma! */
-		);
