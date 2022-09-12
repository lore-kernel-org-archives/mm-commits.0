Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC92ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiILD2l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiILD2W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDE726135
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1EFB61169
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DE1C433D6;
        Mon, 12 Sep 2022 03:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953296;
        bh=A6IdlJO33tKt525T4p1NYYOK28mjlTcEJrnszDg+l5A=;
        h=Date:To:From:Subject:From;
        b=gIeNd4qjcSftgLPsAVutkW+qFiT8hCIEDJVMKGYkZITBOIe3CxbGEAY9G4vfuTlpD
         d5Ksh4YRtKPhlWE1Fd2eedNYAZX0rhIWcFBF1yTm4BAzLvC2ck56DndyZvcJzx/se7
         rqt89E5/c9hh0O+/YP0ienNVP0rWZEKlXLY/M9eY=
Date:   Sun, 11 Sep 2022 20:28:15 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jrdr.linux@gmail.com, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hughd@google.com, deller@gmx.de, david@redhat.com,
        dan.carpenter@oracle.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch removed from -mm tree
Message-Id: <20220912032816.20DE1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: add MADV_COLLAPSE collapse context to selftests
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: add MADV_COLLAPSE collapse context to selftests
Date: Wed, 6 Jul 2022 16:59:34 -0700

Add madvise collapse context to hugepage collapse selftests.  This context
is tested with /sys/kernel/mm/transparent_hugepage/enabled set to "never"
in order to avoid unwanted interaction with khugepaged during testing.

Also, refactor updates to sysfs THP settings using a stack so that the THP
settings from nested callers can be restored.

Link: https://lkml.kernel.org/r/20220706235936.2197195-17-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |  171 ++++++++++++++++------
 1 file changed, 125 insertions(+), 46 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-add-madv_collapse-collapse-context-to-selftests
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -14,6 +14,9 @@
 #ifndef MADV_PAGEOUT
 #define MADV_PAGEOUT 21
 #endif
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
 
 #define BASE_ADDR ((void *)(1UL << 30))
 static unsigned long hpage_pmd_size;
@@ -95,18 +98,6 @@ struct settings {
 	struct khugepaged_settings khugepaged;
 };
 
-static struct settings default_settings = {
-	.thp_enabled = THP_MADVISE,
-	.thp_defrag = THP_DEFRAG_ALWAYS,
-	.shmem_enabled = SHMEM_NEVER,
-	.use_zero_page = 0,
-	.khugepaged = {
-		.defrag = 1,
-		.alloc_sleep_millisecs = 10,
-		.scan_sleep_millisecs = 10,
-	},
-};
-
 static struct settings saved_settings;
 static bool skip_settings_restore;
 
@@ -284,6 +275,39 @@ static void write_settings(struct settin
 	write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
 }
 
+#define MAX_SETTINGS_DEPTH 4
+static struct settings settings_stack[MAX_SETTINGS_DEPTH];
+static int settings_index;
+
+static struct settings *current_settings(void)
+{
+	if (!settings_index) {
+		printf("Fail: No settings set");
+		exit(EXIT_FAILURE);
+	}
+	return settings_stack + settings_index - 1;
+}
+
+static void push_settings(struct settings *settings)
+{
+	if (settings_index >= MAX_SETTINGS_DEPTH) {
+		printf("Fail: Settings stack exceeded");
+		exit(EXIT_FAILURE);
+	}
+	settings_stack[settings_index++] = *settings;
+	write_settings(current_settings());
+}
+
+static void pop_settings(void)
+{
+	if (settings_index <= 0) {
+		printf("Fail: Settings stack empty");
+		exit(EXIT_FAILURE);
+	}
+	--settings_index;
+	write_settings(current_settings());
+}
+
 static void restore_settings(int sig)
 {
 	if (skip_settings_restore)
@@ -327,14 +351,6 @@ static void save_settings(void)
 	signal(SIGQUIT, restore_settings);
 }
 
-static void adjust_settings(void)
-{
-
-	printf("Adjust settings...");
-	write_settings(&default_settings);
-	success("OK");
-}
-
 #define MAX_LINE_LENGTH 500
 
 static bool check_for_pattern(FILE *fp, char *pattern, char *buf)
@@ -493,6 +509,38 @@ static void validate_memory(int *p, unsi
 	}
 }
 
+static void madvise_collapse(const char *msg, char *p, bool expect)
+{
+	int ret;
+	struct settings settings = *current_settings();
+
+	printf("%s...", msg);
+	/* Sanity check */
+	if (check_huge(p)) {
+		printf("Unexpected huge page\n");
+		exit(EXIT_FAILURE);
+	}
+
+	/*
+	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
+	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
+	 */
+	settings.thp_enabled = THP_NEVER;
+	push_settings(&settings);
+
+	/* Clear VM_NOHUGEPAGE */
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	ret = madvise(p, hpage_pmd_size, MADV_COLLAPSE);
+	if (((bool)ret) == expect)
+		fail("Fail: Bad return value");
+	else if (check_huge(p) != expect)
+		fail("Fail: check_huge()");
+	else
+		success("OK");
+
+	pop_settings();
+}
+
 #define TICK 500000
 static bool wait_for_scan(const char *msg, char *p)
 {
@@ -542,11 +590,11 @@ static void khugepaged_collapse(const ch
 
 static void alloc_at_fault(void)
 {
-	struct settings settings = default_settings;
+	struct settings settings = *current_settings();
 	char *p;
 
 	settings.thp_enabled = THP_ALWAYS;
-	write_settings(&settings);
+	push_settings(&settings);
 
 	p = alloc_mapping();
 	*p = 1;
@@ -556,7 +604,7 @@ static void alloc_at_fault(void)
 	else
 		fail("Fail");
 
-	write_settings(&default_settings);
+	pop_settings();
 
 	madvise(p, page_size, MADV_DONTNEED);
 	printf("Split huge PMD on MADV_DONTNEED...");
@@ -602,11 +650,11 @@ static void collapse_single_pte_entry(st
 static void collapse_max_ptes_none(struct collapse_context *c)
 {
 	int max_ptes_none = hpage_pmd_nr / 2;
-	struct settings settings = default_settings;
+	struct settings settings = *current_settings();
 	void *p;
 
 	settings.khugepaged.max_ptes_none = max_ptes_none;
-	write_settings(&settings);
+	push_settings(&settings);
 
 	p = alloc_mapping();
 
@@ -623,7 +671,7 @@ static void collapse_max_ptes_none(struc
 	}
 
 	munmap(p, hpage_pmd_size);
-	write_settings(&default_settings);
+	pop_settings();
 }
 
 static void collapse_swapin_single_pte(struct collapse_context *c)
@@ -703,7 +751,6 @@ static void collapse_single_pte_entry_co
 
 	p = alloc_hpage();
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-
 	printf("Split huge page leaving single PTE mapping compound page...");
 	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
 	if (!check_huge(p))
@@ -864,7 +911,7 @@ static void collapse_fork_compound(struc
 		c->collapse("Collapse PTE table full of compound pages in child",
 			    p, true);
 		write_num("khugepaged/max_ptes_shared",
-			  default_settings.khugepaged.max_ptes_shared);
+			  current_settings()->khugepaged.max_ptes_shared);
 
 		validate_memory(p, 0, hpage_pmd_size);
 		munmap(p, hpage_pmd_size);
@@ -943,9 +990,21 @@ static void collapse_max_ptes_shared(str
 	munmap(p, hpage_pmd_size);
 }
 
-int main(void)
+int main(int argc, const char **argv)
 {
 	struct collapse_context c;
+	struct settings default_settings = {
+		.thp_enabled = THP_MADVISE,
+		.thp_defrag = THP_DEFRAG_ALWAYS,
+		.shmem_enabled = SHMEM_NEVER,
+		.use_zero_page = 0,
+		.khugepaged = {
+			.defrag = 1,
+			.alloc_sleep_millisecs = 10,
+			.scan_sleep_millisecs = 10,
+		},
+	};
+	const char *tests = argc == 1 ? "all" : argv[1];
 
 	setbuf(stdout, NULL);
 
@@ -959,26 +1018,46 @@ int main(void)
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
 
 	save_settings();
-	adjust_settings();
+	push_settings(&default_settings);
 
 	alloc_at_fault();
 
-	printf("\n*** Testing context: khugepaged ***\n");
-	c.collapse = &khugepaged_collapse;
-	c.enforce_pte_scan_limits = true;
-
-	collapse_full(&c);
-	collapse_empty(&c);
-	collapse_single_pte_entry(&c);
-	collapse_max_ptes_none(&c);
-	collapse_swapin_single_pte(&c);
-	collapse_max_ptes_swap(&c);
-	collapse_single_pte_entry_compound(&c);
-	collapse_full_of_compound(&c);
-	collapse_compound_extreme(&c);
-	collapse_fork(&c);
-	collapse_fork_compound(&c);
-	collapse_max_ptes_shared(&c);
+	if (!strcmp(tests, "khugepaged") || !strcmp(tests, "all")) {
+		printf("\n*** Testing context: khugepaged ***\n");
+		c.collapse = &khugepaged_collapse;
+		c.enforce_pte_scan_limits = true;
+
+		collapse_full(&c);
+		collapse_empty(&c);
+		collapse_single_pte_entry(&c);
+		collapse_max_ptes_none(&c);
+		collapse_swapin_single_pte(&c);
+		collapse_max_ptes_swap(&c);
+		collapse_single_pte_entry_compound(&c);
+		collapse_full_of_compound(&c);
+		collapse_compound_extreme(&c);
+		collapse_fork(&c);
+		collapse_fork_compound(&c);
+		collapse_max_ptes_shared(&c);
+	}
+	if (!strcmp(tests, "madvise") || !strcmp(tests, "all")) {
+		printf("\n*** Testing context: madvise ***\n");
+		c.collapse = &madvise_collapse;
+		c.enforce_pte_scan_limits = false;
+
+		collapse_full(&c);
+		collapse_empty(&c);
+		collapse_single_pte_entry(&c);
+		collapse_max_ptes_none(&c);
+		collapse_swapin_single_pte(&c);
+		collapse_max_ptes_swap(&c);
+		collapse_single_pte_entry_compound(&c);
+		collapse_full_of_compound(&c);
+		collapse_compound_extreme(&c);
+		collapse_fork(&c);
+		collapse_fork_compound(&c);
+		collapse_max_ptes_shared(&c);
+	}
 
 	restore_settings(0);
 }
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

