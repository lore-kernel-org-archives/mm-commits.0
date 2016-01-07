From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_owner-track-and-print-last-migrate-reason-fix.patch removed from
 -mm tree
Date: Thu, 07 Jan 2016 15:49:12 -0800
Message-ID: <568ef978.LtKXFae+19JuQVFA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbcAGXtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:49:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: track and print last migrate reason-fix
has been removed from the -mm tree.  Its filename was
     mm-page_owner-track-and-print-last-migrate-reason-fix.patch

This patch was dropped because it was folded into mm-page_owner-track-and-print-last-migrate-reason.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: track and print last migrate reason-fix

Move migrate_reason_names from mm/migrate.c to mm/debug.c so that link doesn't
warn with CONFIG_MIGRATION disabled.

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 +-
 mm/debug.c              |   11 +++++++++++
 mm/migrate.c            |   10 ----------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/migrate.h~mm-page_owner-track-and-print-last-migrate-reason-fix include/linux/migrate.h
--- a/include/linux/migrate.h~mm-page_owner-track-and-print-last-migrate-reason-fix
+++ a/include/linux/migrate.h
@@ -27,7 +27,7 @@ enum migrate_reason {
 	MR_TYPES
 };
 
-/* In mm/migrate.c; also keep sync with include/trace/events/migrate.h */
+/* In mm/debug.c; also keep sync with include/trace/events/migrate.h */
 extern char * migrate_reason_names[MR_TYPES];
 
 #ifdef CONFIG_MIGRATION
diff -puN mm/debug.c~mm-page_owner-track-and-print-last-migrate-reason-fix mm/debug.c
--- a/mm/debug.c~mm-page_owner-track-and-print-last-migrate-reason-fix
+++ a/mm/debug.c
@@ -9,6 +9,17 @@
 #include <linux/mm.h>
 #include <linux/trace_events.h>
 #include <linux/memcontrol.h>
+#include <linux/migrate.h>
+
+char *migrate_reason_names[MR_TYPES] = {
+	"compaction",
+	"memory_failure",
+	"memory_hotplug",
+	"syscall_or_cpuset",
+	"mempolicy_mbind",
+	"numa_misplaced",
+	"cma",
+};
 
 static const struct trace_print_flags pageflag_names[] = {
 	{1UL << PG_locked,		"locked"	},
diff -puN mm/migrate.c~mm-page_owner-track-and-print-last-migrate-reason-fix mm/migrate.c
--- a/mm/migrate.c~mm-page_owner-track-and-print-last-migrate-reason-fix
+++ a/mm/migrate.c
@@ -47,16 +47,6 @@
 
 #include "internal.h"
 
-char *migrate_reason_names[MR_TYPES] = {
-	"compaction",
-	"memory_failure",
-	"memory_hotplug",
-	"syscall_or_cpuset",
-	"mempolicy_mbind",
-	"numa_misplaced",
-	"cma",
-};
-
 /*
  * migrate_prep() needs to be called before we start compiling a list of pages
  * to be migrated using isolate_lru_page(). If scheduling work on other CPUs is
_

Patches currently in -mm which might be from vbabka@suse.cz are

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
mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

