Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA77C4321E
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiJCVRx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJCVPo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:15:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9DD550BD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B22FFB81122
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECB5C433C1;
        Mon,  3 Oct 2022 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831410;
        bh=hJgfRDa/ngeSscMCHjif097crPBxJ0Z7hOkxMIEkWxQ=;
        h=Date:To:From:Subject:From;
        b=CjzC04Bdz4zv1XCP2ZQnB576Zcu1JO+tXThtmtx2VmTKEYLS/yNZNqoRQVH4C5Edk
         BD/doAyiyemkBO5kW8a8q4HIdCGtUFTbQnDkByoMpsjoT4qI47SxFllKLTwBTglzon
         OYfyE9yKYymg2JAeJ/XeDMOBc2ylfNArgDy3vV4w=
Date:   Mon, 03 Oct 2022 14:10:09 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        songliubraving@fb.com, sj@kernel.org, shy828301@gmail.com,
        rongwei.wang@linux.alibaba.com, rientjes@google.com,
        peterx@redhat.com, pasha.tatashin@soleen.com, minchan@kernel.org,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jthoughton@google.com, hughd@google.com, david@redhat.com,
        ckennelly@google.com, axelrasmussen@google.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-thp-collapse-shmem-testing.patch removed from -mm tree
Message-Id: <20221003211010.4ECB5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/vm: add thp collapse shmem testing
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-thp-collapse-shmem-testing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: add thp collapse shmem testing
Date: Thu, 22 Sep 2022 15:40:44 -0700

Add memory operations for shmem (memfd) memory, and reuse existing tests
with the new memory operations.

Shmem tests can be called with "shmem" mem_type, and shmem tests are ran
with "all" mem_type as well.

Link: https://lkml.kernel.org/r/20220907144521.3115321-9-zokeefe@google.com
Link: https://lkml.kernel.org/r/20220922224046.1143204-9-zokeefe@google.com
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
@@ -59,6 +59,7 @@ struct mem_ops {
 
 static struct mem_ops *file_ops;
 static struct mem_ops *anon_ops;
+static struct mem_ops *shmem_ops;
 
 struct collapse_context {
 	void (*collapse)(const char *msg, char *p, int nr_hpages,
@@ -739,6 +740,40 @@ static bool file_check_huge(void *addr,
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
@@ -755,6 +790,14 @@ static struct mem_ops __file_ops = {
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
@@ -1315,7 +1358,7 @@ static void usage(void)
 	fprintf(stderr, "\nUsage: ./khugepaged <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
-	fprintf(stderr, "\t<mem_type>\t: [all|anon|file]\n");
+	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
 	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
@@ -1357,10 +1400,13 @@ static void parse_test_type(int argc, co
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
@@ -1377,7 +1423,7 @@ int main(int argc, const char **argv)
 	struct settings default_settings = {
 		.thp_enabled = THP_MADVISE,
 		.thp_defrag = THP_DEFRAG_ALWAYS,
-		.shmem_enabled = SHMEM_NEVER,
+		.shmem_enabled = SHMEM_ADVISE,
 		.use_zero_page = 0,
 		.khugepaged = {
 			.defrag = 1,
@@ -1424,16 +1470,20 @@ int main(int argc, const char **argv)
 
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
@@ -1447,8 +1497,10 @@ int main(int argc, const char **argv)
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
 	TEST(collapse_full_of_compound, madvise_context, file_ops);
+	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
 	TEST(collapse_compound_extreme, madvise_context, anon_ops);
@@ -1470,6 +1522,7 @@ int main(int argc, const char **argv)
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
 	restore_settings(0);
 }
_

Patches currently in -mm which might be from zokeefe@google.com are


