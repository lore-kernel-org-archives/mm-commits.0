Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B13BC6FA82
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIGWUZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiIGWUX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E962A951
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8A7461A74
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E87EC433C1;
        Wed,  7 Sep 2022 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662589213;
        bh=dxFJsz/PolyU2PZ4KbV5mGosG5pVuScZyowtvINlOl4=;
        h=Date:To:From:Subject:From;
        b=jGj5N9NdlE0f6UvhFE/XOE9jNV9RXu0WF7QTEGU6aisKyw5hc9CLowTnfRVSk0+v2
         an2ik/CEpDUDrCOMZUhHCZP9M0ZSLA8S2AdQ+UoGmjGvjLcHMUPcJ1N554CXMRpibO
         yKf6Q8DrDB5gztGqfY9TumOdLQjdH6IMZdOC53zM=
Date:   Wed, 07 Sep 2022 15:20:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-thp-collapse-shmem-testing.patch added to mm-unstable branch
Message-Id: <20220907222013.0E87EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add thp collapse shmem testing
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-thp-collapse-shmem-testing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-thp-collapse-shmem-testing.patch

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
Subject: selftests/vm: add thp collapse shmem testing
Date: Wed, 7 Sep 2022 07:45:19 -0700

Add memory operations for shmem (memfd) memory, and reuse existing tests
with the new memory operations.

Shmem tests can be called with "shmem" mem_type, and shmem tests are ran
with "all" mem_type as well.

Link: https://lkml.kernel.org/r/20220907144521.3115321-9-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |   57 +++++++++++++++++++++-
 1 file changed, 55 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-add-thp-collapse-shmem-testing
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -58,6 +58,7 @@ struct mem_ops {
 
 static struct mem_ops *file_ops;
 static struct mem_ops *anon_ops;
+static struct mem_ops *shmem_ops;
 
 struct collapse_context {
 	void (*collapse)(const char *msg, char *p, int nr_hpages,
@@ -708,6 +709,40 @@ static bool file_check_huge(void *addr,
 	}
 }
 
+static void *shmem_setup_area(int nr_hpages)
+{
+	void *p;
+	unsigned long size = nr_hpages * hpage_pmd_size;
+
+	finfo.fd = memfd_create("khugepaged-selftest-collapse-shmem", 0);
+	if (finfo.fd < 0)  {
+		perror("memfd_create()");
+		exit(EXIT_FAILURE);
+	}
+	if (ftruncate(finfo.fd, size)) {
+		perror("ftruncate()");
+		exit(EXIT_FAILURE);
+	}
+	p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE, MAP_SHARED, finfo.fd,
+		 0);
+	if (p != BASE_ADDR) {
+		perror("mmap()");
+		exit(EXIT_FAILURE);
+	}
+	return p;
+}
+
+static void shmem_cleanup_area(void *p, unsigned long size)
+{
+	munmap(p, size);
+	close(finfo.fd);
+}
+
+static bool shmem_check_huge(void *addr, int nr_hpages)
+{
+	return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
+}
+
 static struct mem_ops __anon_ops = {
 	.setup_area = &anon_setup_area,
 	.cleanup_area = &anon_cleanup_area,
@@ -724,6 +759,14 @@ static struct mem_ops __file_ops = {
 	.name = "file",
 };
 
+static struct mem_ops __shmem_ops = {
+	.setup_area = &shmem_setup_area,
+	.cleanup_area = &shmem_cleanup_area,
+	.fault = &anon_fault,
+	.check_huge = &shmem_check_huge,
+	.name = "shmem",
+};
+
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 			       struct mem_ops *ops, bool expect)
 {
@@ -1285,7 +1328,7 @@ static void usage(void)
 	fprintf(stderr, "\nUsage: ./khugepaged <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
-	fprintf(stderr, "\t<mem_type>\t: [all|anon|file]\n");
+	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
 	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
@@ -1327,10 +1370,13 @@ static void parse_test_type(int argc, co
 	if (!strcmp(buf, "all")) {
 		file_ops =  &__file_ops;
 		anon_ops = &__anon_ops;
+		shmem_ops = &__shmem_ops;
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		file_ops =  &__file_ops;
+	} else if (!strcmp(buf, "shmem")) {
+		shmem_ops = &__shmem_ops;
 	} else {
 		usage();
 	}
@@ -1347,7 +1393,7 @@ int main(int argc, const char **argv)
 	struct settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
-		.shmem_enabled = SHMEM_NEVER,
+		.shmem_enabled = SHMEM_ADVISE,
 		.use_zero_page = 0,
 		.khugepaged = {
 			.defrag = 1,
@@ -1394,16 +1440,20 @@ int main(int argc, const char **argv)
 
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, file_ops);
+	TEST(collapse_full, khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, file_ops);
+	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, file_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry, madvise_context, file_ops);
+	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
 
 	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_none, khugepaged_context, file_ops);
@@ -1417,8 +1467,10 @@ int main(int argc, const char **argv)
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
 	TEST(collapse_full_of_compound, madvise_context, file_ops);
+	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
 	TEST(collapse_compound_extreme, madvise_context, anon_ops);
@@ -1440,6 +1492,7 @@ int main(int argc, const char **argv)
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
 	restore_settings(0);
 }
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-add-struct-collapse_control-fix-fix-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch
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

