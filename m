Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D40C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240433AbiGHVFi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240421AbiGHVFR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:05:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8CB2BB2F
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B4B462918
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B7FC341C0;
        Fri,  8 Jul 2022 21:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314314;
        bh=JK8qpXjZ3s0wYuhaiOn89yrs29l4a434qp+C0gAk5gs=;
        h=Date:To:From:Subject:From;
        b=DC49uobSCUQKFHIa80qhE5lZ11/kNeEhe6OO8MfrS0iIJyd16TZesonVPEWeb1fgo
         X0qh+8KTz4BISDz7y90B5rE8qov9jKCU5P8DnlGUqyVoBcWEwUs6WV4B64ThAb9N91
         ddZNQlQBzbde9CAWAjdy69ssIds6GUHKWUWLCBKk=
Date:   Fri, 08 Jul 2022 14:05:14 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-modularize-collapse-selftests.patch added to mm-unstable branch
Message-Id: <20220708210514.95B7FC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: modularize collapse selftests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-modularize-collapse-selftests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-modularize-collapse-selftests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: modularize collapse selftests
Date: Wed, 6 Jul 2022 16:59:32 -0700

Modularize the collapse action of khugepaged collapse selftests by
introducing a struct collapse_context which specifies how to collapse a
given memory range and the expected semantics of the collapse.  This can
be reused later to test other collapse contexts.

Additionally, all tests have logic that checks if a collapse occurred via
reading /proc/self/smaps, and report if this is different than expected. 
Move this logic into the per-context ->collapse() hook instead of
repeating it in every test.

Link: https://lkml.kernel.org/r/20220706235936.2197195-15-zokeefe@google.com
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |  247 +++++++++-------------
 1 file changed, 108 insertions(+), 139 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-modularize-collapse-selftests
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -23,6 +23,11 @@ static int hpage_pmd_nr;
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
 #define PID_SMAPS "/proc/self/smaps"
 
+struct collapse_context {
+	void (*collapse)(const char *msg, char *p, bool expect);
+	bool enforce_pte_scan_limits;
+};
+
 enum thp_enabled {
 	THP_ALWAYS,
 	THP_MADVISE,
@@ -501,6 +506,21 @@ static bool wait_for_scan(const char *ms
 	return timeout == -1;
 }
 
+static void khugepaged_collapse(const char *msg, char *p, bool expect)
+{
+	if (wait_for_scan(msg, p)) {
+		if (expect)
+			fail("Timeout");
+		else
+			success("OK");
+		return;
+	} else if (check_huge(p) == expect) {
+		success("OK");
+	} else {
+		fail("Fail");
+	}
+}
+
 static void alloc_at_fault(void)
 {
 	struct settings settings = default_settings;
@@ -528,53 +548,39 @@ static void alloc_at_fault(void)
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_full(void)
+static void collapse_full(struct collapse_context *c)
 {
 	void *p;
 
 	p = alloc_mapping();
 	fill_memory(p, 0, hpage_pmd_size);
-	if (wait_for_scan("Collapse fully populated PTE table", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
+	c->collapse("Collapse fully populated PTE table", p, true);
 	validate_memory(p, 0, hpage_pmd_size);
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_empty(void)
+static void collapse_empty(struct collapse_context *c)
 {
 	void *p;
 
 	p = alloc_mapping();
-	if (wait_for_scan("Do not collapse empty PTE table", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		fail("Fail");
-	else
-		success("OK");
+	c->collapse("Do not collapse empty PTE table", p, false);
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_single_pte_entry(void)
+static void collapse_single_pte_entry(struct collapse_context *c)
 {
 	void *p;
 
 	p = alloc_mapping();
 	fill_memory(p, 0, page_size);
-	if (wait_for_scan("Collapse PTE table with single PTE entry present", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
+	c->collapse("Collapse PTE table with single PTE entry present", p,
+		    true);
 	validate_memory(p, 0, page_size);
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_max_ptes_none(void)
+static void collapse_max_ptes_none(struct collapse_context *c)
 {
 	int max_ptes_none = hpage_pmd_nr / 2;
 	struct settings settings = default_settings;
@@ -586,28 +592,22 @@ static void collapse_max_ptes_none(void)
 	p = alloc_mapping();
 
 	fill_memory(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
-	if (wait_for_scan("Do not collapse with max_ptes_none exceeded", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		fail("Fail");
-	else
-		success("OK");
+	c->collapse("Maybe collapse with max_ptes_none exceeded", p,
+		    !c->enforce_pte_scan_limits);
 	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
 
-	fill_memory(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
-	if (wait_for_scan("Collapse with max_ptes_none PTEs empty", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
-	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
+	if (c->enforce_pte_scan_limits) {
+		fill_memory(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
+		c->collapse("Collapse with max_ptes_none PTEs empty", p, true);
+		validate_memory(p, 0,
+				(hpage_pmd_nr - max_ptes_none) * page_size);
+	}
 
 	munmap(p, hpage_pmd_size);
 	write_settings(&default_settings);
 }
 
-static void collapse_swapin_single_pte(void)
+static void collapse_swapin_single_pte(struct collapse_context *c)
 {
 	void *p;
 	p = alloc_mapping();
@@ -625,18 +625,13 @@ static void collapse_swapin_single_pte(v
 		goto out;
 	}
 
-	if (wait_for_scan("Collapse with swapping in single PTE entry", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
+	c->collapse("Collapse with swapping in single PTE entry", p, true);
 	validate_memory(p, 0, hpage_pmd_size);
 out:
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_max_ptes_swap(void)
+static void collapse_max_ptes_swap(struct collapse_context *c)
 {
 	int max_ptes_swap = read_num("khugepaged/max_ptes_swap");
 	void *p;
@@ -656,39 +651,34 @@ static void collapse_max_ptes_swap(void)
 		goto out;
 	}
 
-	if (wait_for_scan("Do not collapse with max_ptes_swap exceeded", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		fail("Fail");
-	else
-		success("OK");
+	c->collapse("Maybe collapse with max_ptes_swap exceeded", p,
+		    !c->enforce_pte_scan_limits);
 	validate_memory(p, 0, hpage_pmd_size);
 
-	fill_memory(p, 0, hpage_pmd_size);
-	printf("Swapout %d of %d pages...", max_ptes_swap, hpage_pmd_nr);
-	if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT)) {
-		perror("madvise(MADV_PAGEOUT)");
-		exit(EXIT_FAILURE);
-	}
-	if (check_swap(p, max_ptes_swap * page_size)) {
-		success("OK");
-	} else {
-		fail("Fail");
-		goto out;
-	}
+	if (c->enforce_pte_scan_limits) {
+		fill_memory(p, 0, hpage_pmd_size);
+		printf("Swapout %d of %d pages...", max_ptes_swap,
+		       hpage_pmd_nr);
+		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT)) {
+			perror("madvise(MADV_PAGEOUT)");
+			exit(EXIT_FAILURE);
+		}
+		if (check_swap(p, max_ptes_swap * page_size)) {
+			success("OK");
+		} else {
+			fail("Fail");
+			goto out;
+		}
 
-	if (wait_for_scan("Collapse with max_ptes_swap pages swapped out", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
-	validate_memory(p, 0, hpage_pmd_size);
+		c->collapse("Collapse with max_ptes_swap pages swapped out", p,
+			    true);
+		validate_memory(p, 0, hpage_pmd_size);
+	}
 out:
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_single_pte_entry_compound(void)
+static void collapse_single_pte_entry_compound(struct collapse_context *c)
 {
 	void *p;
 
@@ -710,17 +700,13 @@ static void collapse_single_pte_entry_co
 	else
 		fail("Fail");
 
-	if (wait_for_scan("Collapse PTE table with single PTE mapping compound page", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
+	c->collapse("Collapse PTE table with single PTE mapping compound page",
+		    p, true);
 	validate_memory(p, 0, page_size);
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_full_of_compound(void)
+static void collapse_full_of_compound(struct collapse_context *c)
 {
 	void *p;
 
@@ -742,17 +728,12 @@ static void collapse_full_of_compound(vo
 	else
 		fail("Fail");
 
-	if (wait_for_scan("Collapse PTE table full of compound pages", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
+	c->collapse("Collapse PTE table full of compound pages", p, true);
 	validate_memory(p, 0, hpage_pmd_size);
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_compound_extreme(void)
+static void collapse_compound_extreme(struct collapse_context *c)
 {
 	void *p;
 	int i;
@@ -798,18 +779,14 @@ static void collapse_compound_extreme(vo
 	else
 		fail("Fail");
 
-	if (wait_for_scan("Collapse PTE table full of different compound pages", p))
-		fail("Timeout");
-	else if (check_huge(p))
-		success("OK");
-	else
-		fail("Fail");
+	c->collapse("Collapse PTE table full of different compound pages", p,
+		    true);
 
 	validate_memory(p, 0, hpage_pmd_size);
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_fork(void)
+static void collapse_fork(struct collapse_context *c)
 {
 	int wstatus;
 	void *p;
@@ -835,13 +812,8 @@ static void collapse_fork(void)
 			fail("Fail");
 
 		fill_memory(p, page_size, 2 * page_size);
-
-		if (wait_for_scan("Collapse PTE table with single page shared with parent process", p))
-			fail("Timeout");
-		else if (check_huge(p))
-			success("OK");
-		else
-			fail("Fail");
+		c->collapse("Collapse PTE table with single page shared with parent process",
+			    p, true);
 
 		validate_memory(p, 0, page_size);
 		munmap(p, hpage_pmd_size);
@@ -860,7 +832,7 @@ static void collapse_fork(void)
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_fork_compound(void)
+static void collapse_fork_compound(struct collapse_context *c)
 {
 	int wstatus;
 	void *p;
@@ -896,14 +868,10 @@ static void collapse_fork_compound(void)
 		fill_memory(p, 0, page_size);
 
 		write_num("khugepaged/max_ptes_shared", hpage_pmd_nr - 1);
-		if (wait_for_scan("Collapse PTE table full of compound pages in child", p))
-			fail("Timeout");
-		else if (check_huge(p))
-			success("OK");
-		else
-			fail("Fail");
+		c->collapse("Collapse PTE table full of compound pages in child",
+			    p, true);
 		write_num("khugepaged/max_ptes_shared",
-				default_settings.khugepaged.max_ptes_shared);
+			  default_settings.khugepaged.max_ptes_shared);
 
 		validate_memory(p, 0, hpage_pmd_size);
 		munmap(p, hpage_pmd_size);
@@ -922,7 +890,7 @@ static void collapse_fork_compound(void)
 	munmap(p, hpage_pmd_size);
 }
 
-static void collapse_max_ptes_shared()
+static void collapse_max_ptes_shared(struct collapse_context *c)
 {
 	int max_ptes_shared = read_num("khugepaged/max_ptes_shared");
 	int wstatus;
@@ -957,28 +925,22 @@ static void collapse_max_ptes_shared()
 		else
 			fail("Fail");
 
-		if (wait_for_scan("Do not collapse with max_ptes_shared exceeded", p))
-			fail("Timeout");
-		else if (!check_huge(p))
-			success("OK");
-		else
-			fail("Fail");
-
-		printf("Trigger CoW on page %d of %d...",
-				hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
-		fill_memory(p, 0, (hpage_pmd_nr - max_ptes_shared) * page_size);
-		if (!check_huge(p))
-			success("OK");
-		else
-			fail("Fail");
+		c->collapse("Maybe collapse with max_ptes_shared exceeded", p,
+			    !c->enforce_pte_scan_limits);
 
+		if (c->enforce_pte_scan_limits) {
+			printf("Trigger CoW on page %d of %d...",
+			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
+			fill_memory(p, 0, (hpage_pmd_nr - max_ptes_shared) *
+				    page_size);
+			if (!check_huge(p))
+				success("OK");
+			else
+				fail("Fail");
 
-		if (wait_for_scan("Collapse with max_ptes_shared PTEs shared", p))
-			fail("Timeout");
-		else if (check_huge(p))
-			success("OK");
-		else
-			fail("Fail");
+			c->collapse("Collapse with max_ptes_shared PTEs shared",
+				    p, true);
+		}
 
 		validate_memory(p, 0, hpage_pmd_size);
 		munmap(p, hpage_pmd_size);
@@ -999,6 +961,8 @@ static void collapse_max_ptes_shared()
 
 int main(void)
 {
+	struct collapse_context c;
+
 	setbuf(stdout, NULL);
 
 	page_size = getpagesize();
@@ -1014,18 +978,23 @@ int main(void)
 	adjust_settings();
 
 	alloc_at_fault();
-	collapse_full();
-	collapse_empty();
-	collapse_single_pte_entry();
-	collapse_max_ptes_none();
-	collapse_swapin_single_pte();
-	collapse_max_ptes_swap();
-	collapse_single_pte_entry_compound();
-	collapse_full_of_compound();
-	collapse_compound_extreme();
-	collapse_fork();
-	collapse_fork_compound();
-	collapse_max_ptes_shared();
+
+	printf("\n*** Testing context: khugepaged ***\n");
+	c.collapse = &khugepaged_collapse;
+	c.enforce_pte_scan_limits = true;
+
+	collapse_full(&c);
+	collapse_empty(&c);
+	collapse_single_pte_entry(&c);
+	collapse_max_ptes_none(&c);
+	collapse_swapin_single_pte(&c);
+	collapse_max_ptes_swap(&c);
+	collapse_single_pte_entry_compound(&c);
+	collapse_full_of_compound(&c);
+	collapse_compound_extreme(&c);
+	collapse_fork(&c);
+	collapse_fork_compound(&c);
+	collapse_max_ptes_shared(&c);
 
 	restore_settings(0);
 }
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
proc-smaps-add-pmdmappable-field-to-smaps.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

