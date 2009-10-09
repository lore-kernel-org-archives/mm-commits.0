From: akpm@linux-foundation.org
Subject: [merged] page-types-introduce-checked_open.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:08 -0700
Message-ID: <200910092205.n99M58dP020764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934571AbZJIWFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     page-types: introduce checked_open()
has been removed from the -mm tree.  Its filename was
     page-types-introduce-checked_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: introduce checked_open()
From: Wu Fengguang <fengguang.wu@intel.com>

This helps merge duplicate code (now and future) and outstand the main
logic.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-introduce-checked_open Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-introduce-checked_open
+++ a/Documentation/vm/page-types.c
@@ -214,6 +214,18 @@ static void fatal(const char *x, ...)
 	exit(EXIT_FAILURE);
 }
 
+int checked_open(const char *pathname, int flags)
+{
+	int fd = open(pathname, flags);
+
+	if (fd < 0) {
+		perror(pathname);
+		exit(EXIT_FAILURE);
+	}
+
+	return fd;
+}
+
 
 /*
  * page flag names
@@ -534,11 +546,7 @@ static void walk_addr_ranges(void)
 {
 	int i;
 
-	kpageflags_fd = open(PROC_KPAGEFLAGS, O_RDONLY);
-	if (kpageflags_fd < 0) {
-		perror(PROC_KPAGEFLAGS);
-		exit(EXIT_FAILURE);
-	}
+	kpageflags_fd = checked_open(PROC_KPAGEFLAGS, O_RDONLY);
 
 	if (!nr_addr_ranges)
 		add_addr_range(0, ULONG_MAX);
@@ -631,11 +639,7 @@ static void parse_pid(const char *str)
 	opt_pid = parse_number(str);
 
 	sprintf(buf, "/proc/%d/pagemap", opt_pid);
-	pagemap_fd = open(buf, O_RDONLY);
-	if (pagemap_fd < 0) {
-		perror(buf);
-		exit(EXIT_FAILURE);
-	}
+	pagemap_fd = checked_open(buf, O_RDONLY);
 
 	sprintf(buf, "/proc/%d/maps", opt_pid);
 	file = fopen(buf, "r");
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
dev-mem-remove-redundant-test-on-len.patch
dev-mem-introduce-size_inside_page.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
dev-mem-make-size_inside_page-logic-straight.patch
dev-mem-remove-the-written-variable-in-write_kmem.patch
dev-mem-remove-the-written-variable-in-write_kmem-fix.patch
dev-mem-remove-redundant-parameter-from-do_write_kmem.patch

