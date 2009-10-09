From: akpm@linux-foundation.org
Subject: [merged] page-types-add-hwpoison-unpoison-feature.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:16 -0700
Message-ID: <200910092205.n99M5GFh021021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934671AbZJIWF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     page-types: add hwpoison/unpoison feature
has been removed from the -mm tree.  Its filename was
     page-types-add-hwpoison-unpoison-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-types: add hwpoison/unpoison feature
From: Wu Fengguang <fengguang.wu@intel.com>

For hwpoison stress testing.  The debugfs mount point is assumed to be
/debug/.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/page-types.c~page-types-add-hwpoison-unpoison-feature Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~page-types-add-hwpoison-unpoison-feature
+++ a/Documentation/vm/page-types.c
@@ -170,6 +170,13 @@ static int		page_size;
 static int		pagemap_fd;
 static int		kpageflags_fd;
 
+static int		opt_hwpoison;
+static int		opt_unpoison;
+
+static char		*hwpoison_debug_fs = "/debug/hwpoison";
+static int		hwpoison_inject_fd;
+static int		hwpoison_forget_fd;
+
 #define HASH_SHIFT	13
 #define HASH_SIZE	(1 << HASH_SHIFT)
 #define HASH_MASK	(HASH_SIZE - 1)
@@ -447,6 +454,53 @@ static uint64_t kpageflags_flags(uint64_
 }
 
 /*
+ * page actions
+ */
+
+static void prepare_hwpoison_fd(void)
+{
+	char buf[100];
+
+	if (opt_hwpoison && !hwpoison_inject_fd) {
+		sprintf(buf, "%s/corrupt-pfn", hwpoison_debug_fs);
+		hwpoison_inject_fd = checked_open(buf, O_WRONLY);
+	}
+
+	if (opt_unpoison && !hwpoison_forget_fd) {
+		sprintf(buf, "%s/renew-pfn", hwpoison_debug_fs);
+		hwpoison_forget_fd = checked_open(buf, O_WRONLY);
+	}
+}
+
+static int hwpoison_page(unsigned long offset)
+{
+	char buf[100];
+	int len;
+
+	len = sprintf(buf, "0x%lx\n", offset);
+	len = write(hwpoison_inject_fd, buf, len);
+	if (len < 0) {
+		perror("hwpoison inject");
+		return len;
+	}
+	return 0;
+}
+
+static int unpoison_page(unsigned long offset)
+{
+	char buf[100];
+	int len;
+
+	len = sprintf(buf, "0x%lx\n", offset);
+	len = write(hwpoison_forget_fd, buf, len);
+	if (len < 0) {
+		perror("hwpoison forget");
+		return len;
+	}
+	return 0;
+}
+
+/*
  * page frame walker
  */
 
@@ -485,6 +539,11 @@ static void add_page(unsigned long voffs
 	if (!bit_mask_ok(flags))
 		return;
 
+	if (opt_hwpoison)
+		hwpoison_page(offset);
+	if (opt_unpoison)
+		unpoison_page(offset);
+
 	if (opt_list == 1)
 		show_page_range(voffset, offset, flags);
 	else if (opt_list == 2)
@@ -624,6 +683,8 @@ static void usage(void)
 "            -l|--list                 Show page details in ranges\n"
 "            -L|--list-each            Show page details one by one\n"
 "            -N|--no-summary           Don't show summay info\n"
+"            -X|--hwpoison             hwpoison pages\n"
+"            -x|--unpoison             unpoison pages\n"
 "            -h|--help                 Show this usage message\n"
 "addr-spec:\n"
 "            N                         one page at offset N (unit: pages)\n"
@@ -833,6 +894,8 @@ static struct option opts[] = {
 	{ "list"      , 0, NULL, 'l' },
 	{ "list-each" , 0, NULL, 'L' },
 	{ "no-summary", 0, NULL, 'N' },
+	{ "hwpoison"  , 0, NULL, 'X' },
+	{ "unpoison"  , 0, NULL, 'x' },
 	{ "help"      , 0, NULL, 'h' },
 	{ NULL        , 0, NULL, 0 }
 };
@@ -844,7 +907,7 @@ int main(int argc, char *argv[])
 	page_size = getpagesize();
 
 	while ((c = getopt_long(argc, argv,
-				"rp:f:a:b:lLNh", opts, NULL)) != -1) {
+				"rp:f:a:b:lLNXxh", opts, NULL)) != -1) {
 		switch (c) {
 		case 'r':
 			opt_raw = 1;
@@ -870,6 +933,14 @@ int main(int argc, char *argv[])
 		case 'N':
 			opt_no_summary = 1;
 			break;
+		case 'X':
+			opt_hwpoison = 1;
+			prepare_hwpoison_fd();
+			break;
+		case 'x':
+			opt_unpoison = 1;
+			prepare_hwpoison_fd();
+			break;
 		case 'h':
 			usage();
 			exit(0);
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

