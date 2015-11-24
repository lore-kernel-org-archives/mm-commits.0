From: akpm@linux-foundation.org
Subject: +
 mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch added to -mm tree
Date: Tue, 24 Nov 2015 14:45:26 -0800
Message-ID: <5654e886.ntg/3U+vDlxZkHpZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbKXWp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: introduce dump_gfpflag_names() for symbolic printing of gfp_flags
has been added to the -mm tree.  Its filename is
     mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, debug: introduce dump_gfpflag_names() for symbolic printing of gfp_flags

It would be useful to convert gfp_flags into string representation when
printing them in case of allocation failure, OOM etc.  There's a script
./scripts/gfp-translate to make this simpler, but it needs the matching
version of the sources to be accurate, and the flags have been undergoing
some changes recently.

The ftrace framework already has this translation in the form of
show_gfp_flags() defined in include/trace/events/gfpflags.h which defines
the translation table internally.  Allow reusing the table outside ftrace
by putting it behind __def_gfpflag_names definition and introduce
dump_gfpflag_names() to handle the printing.

While at it, also fill in the names for the flags and flag combinations
that have been missing in the table.  GFP_NOWAIT no longer equals to "no
flags", so change the output for no flags to "none".

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h         |    1 +
 include/trace/events/gfpflags.h |   14 +++++++++++---
 mm/debug.c                      |   10 ++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff -puN include/linux/mmdebug.h~mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags
+++ a/include/linux/mmdebug.h
@@ -10,6 +10,7 @@ struct mm_struct;
 extern void dump_page(struct page *page, const char *reason);
 extern void dump_page_badflags(struct page *page, const char *reason,
 			       unsigned long badflags);
+extern void dump_gfpflag_names(unsigned long gfp_flags);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 
diff -puN include/trace/events/gfpflags.h~mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags
+++ a/include/trace/events/gfpflags.h
@@ -8,8 +8,8 @@
  *
  * Thus most bits set go first.
  */
-#define show_gfp_flags(flags)						\
-	(flags) ? __print_flags(flags, "|",				\
+
+#define __def_gfpflag_names						\
 	{(unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
 	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
 	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
@@ -19,9 +19,13 @@
 	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
 	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
 	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
+	{(unsigned long)GFP_NOWAIT,		"GFP_NOWAIT"},		\
+	{(unsigned long)__GFP_DMA,		"GFP_DMA"},		\
+	{(unsigned long)__GFP_DMA32,		"GFP_DMA32"},		\
 	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
 	{(unsigned long)__GFP_ATOMIC,		"GFP_ATOMIC"},		\
 	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
+	{(unsigned long)__GFP_FS,		"GFP_FS"},		\
 	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
 	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
 	{(unsigned long)__GFP_REPEAT,		"GFP_REPEAT"},		\
@@ -36,8 +40,12 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
+	{(unsigned long)__GFP_WRITE,		"GFP_WRITE"},		\
 	{(unsigned long)__GFP_DIRECT_RECLAIM,	"GFP_DIRECT_RECLAIM"},	\
 	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"GFP_KSWAPD_RECLAIM"},	\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
-	) : "GFP_NOWAIT"
 
+#define show_gfp_flags(flags)						\
+	(flags) ? __print_flags(flags, "|",				\
+	__def_gfpflag_names						\
+	) : "none"
diff -puN mm/debug.c~mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags mm/debug.c
--- a/mm/debug.c~mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags
+++ a/mm/debug.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/trace_events.h>
 #include <linux/memcontrol.h>
+#include <trace/events/gfpflags.h>
 
 static const struct trace_print_flags pageflag_names[] = {
 	{1UL << PG_locked,		"locked"	},
@@ -46,6 +47,10 @@ static const struct trace_print_flags pa
 #endif
 };
 
+static const struct trace_print_flags gfpflag_names[] = {
+	__def_gfpflag_names
+};
+
 static void dump_flag_names(unsigned long flags,
 			const struct trace_print_flags *names, int count)
 {
@@ -73,6 +78,11 @@ static void dump_flag_names(unsigned lon
 	pr_cont(")\n");
 }
 
+void dump_gfpflag_names(unsigned long gfp_flags)
+{
+	dump_flag_names(gfp_flags, gfpflag_names, ARRAY_SIZE(gfpflag_names));
+}
+
 void dump_page_badflags(struct page *page, const char *reason,
 		unsigned long badflags)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

