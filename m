From: akpm@linux-foundation.org
Subject: + mm-page_owner-track-and-print-last-migrate-reason-fix.patch
 added to -mm tree
Date: Mon, 30 Nov 2015 15:16:32 -0800
Message-ID: <565cd8d0.kOKuUI/zH7Lln//6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbbK3XQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 18:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: track and print last migrate reason-fix
has been added to the -mm tree.  Its filename is
     mm-page_owner-track-and-print-last-migrate-reason-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-track-and-print-last-migrate-reason-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-track-and-print-last-migrate-reason-fix.patch

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
