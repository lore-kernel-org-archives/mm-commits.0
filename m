From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch removed from -mm tree
Date: Thu, 07 Jan 2016 15:49:56 -0800
Message-ID: <568ef9a4.x5OOQwF6WR+k/lkl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbcAGXt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:49:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: fix wrongly filtered flags in dump_vma()
has been removed from the -mm tree.  Its filename was
     mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, debug: fix wrongly filtered flags in dump_vma()

This is the second version of patchset which originally aimed to improve the
page_owner functionality.

For page_owner, the main changes are

o Use static key to further reduce overhead when compiled in but not enabled.
o Improve output wrt. page and pageblock migratetypes
o Transfer the info on page migrations and track last migration reason.
o Dump the info as part of dump_page() to hopefully help debugging.

For the last point, Kirill requested a human readable printing of gfp_mask
and migratetype after v1.  At that point it probably makes a lot of sense
to do the same for page alloc failure and OOM warnings.  The flags have
been undergoing revisions recently, and we might be getting reports from
various kernel versions that differ.  The ./scripts/gfp-translate tool
needs to be pointed at the corresponding sources to be accurate.  The
downside is potentially breaking scripts that grep these warnings, but
it's not a first change done there over the years.

Note I'm not entirely happy about the dump_gfpflag_names() implementation,
due to usage of pr_cont() unreliable on SMP (and I've seen spurious
newlines in dmesg output, while being correct on serial console or
/var/log/messages).  It also doesn't allow plugging the gfp_mask
translation into /sys/kernel/debug/page_owner where it also could make
sense.  Maybe a new *printf formatting flag?  Too specialized maybe?  Or
just prepare the string in a buffer on stack with strscpy?


This patch (of 9):

The dump_vma() function uses dump_flags() for printing the flags as
symbolic names.  That function however does a page-flags specific
filtering of bits higher than NR_PAGEFLAGS in order to remove the zone id
part.  For dump_vma() this results in removing several VM_* flags from the
symbolic translation.

Fix this by refactoring dump_flags() to dump_flag_names(), which only
prints the symbolic names in parentheses.  Printing the raw flag value
with a prefix, and any filtering is left to the caller.  In addition to
fixing the bug, this allows better flexibility, which will be useful to
print gfp_flags by a later patch.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN mm/debug.c~mm-debug-fix-wrongly-filtered-flags-in-dump_vma mm/debug.c
--- a/mm/debug.c~mm-debug-fix-wrongly-filtered-flags-in-dump_vma
+++ a/mm/debug.c
@@ -46,17 +46,14 @@ static const struct trace_print_flags pa
 #endif
 };
 
-static void dump_flags(unsigned long flags,
+static void dump_flag_names(unsigned long flags,
 			const struct trace_print_flags *names, int count)
 {
 	const char *delim = "";
 	unsigned long mask;
 	int i;
 
-	pr_emerg("flags: %#lx(", flags);
-
-	/* remove zone id */
-	flags &= (1UL << NR_PAGEFLAGS) - 1;
+	pr_cont("(");
 
 	for (i = 0; i < count && flags; i++) {
 
@@ -79,6 +76,8 @@ static void dump_flags(unsigned long fla
 void dump_page_badflags(struct page *page, const char *reason,
 		unsigned long badflags)
 {
+	unsigned long printflags = page->flags;
+
 	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
 		  page, atomic_read(&page->_count), page_mapcount(page),
 		  page->mapping, page->index);
@@ -86,13 +85,19 @@ void dump_page_badflags(struct page *pag
 		pr_cont(" compound_mapcount: %d", compound_mapcount(page));
 	pr_cont("\n");
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS);
-	dump_flags(page->flags, pageflag_names, ARRAY_SIZE(pageflag_names));
+
+	pr_emerg("flags: %#lx", printflags);
+	/* remove zone id */
+	printflags &= (1UL << NR_PAGEFLAGS) - 1;
+	dump_flag_names(printflags, pageflag_names, ARRAY_SIZE(pageflag_names));
+
 	if (reason)
 		pr_alert("page dumped because: %s\n", reason);
 	if (page->flags & badflags) {
-		pr_alert("bad because of flags:\n");
-		dump_flags(page->flags & badflags,
-				pageflag_names, ARRAY_SIZE(pageflag_names));
+		printflags = page->flags & badflags;
+		pr_alert("bad because of flags: %#lx:", printflags);
+		dump_flag_names(printflags, pageflag_names,
+						ARRAY_SIZE(pageflag_names));
 	}
 #ifdef CONFIG_MEMCG
 	if (page->mem_cgroup)
@@ -162,7 +167,9 @@ void dump_vma(const struct vm_area_struc
 		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data);
-	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
+	pr_emerg("flags: %#lx", vma->vm_flags);
+	dump_flag_names(vma->vm_flags, vmaflags_names,
+						ARRAY_SIZE(vmaflags_names));
 }
 EXPORT_SYMBOL(dump_vma);
 
@@ -233,8 +240,9 @@ void dump_mm(const struct mm_struct *mm)
 		""		/* This is here to not have a comma! */
 		);
 
-		dump_flags(mm->def_flags, vmaflags_names,
-				ARRAY_SIZE(vmaflags_names));
+	pr_emerg("def_flags: %#lx", mm->def_flags);
+	dump_flag_names(mm->def_flags, vmaflags_names,
+					ARRAY_SIZE(vmaflags_names));
 }
 
 #endif		/* CONFIG_DEBUG_VM */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

