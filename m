Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E25C76196
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 21:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDKVDf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 17:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKVDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 17:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6519B2D77
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 14:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E705862135
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 21:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3740FC433EF;
        Tue, 11 Apr 2023 21:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681247012;
        bh=F1Y3u4YUu3WOwuQI7uaHs/csHG9rJK7ni+pEg7KePPA=;
        h=Date:To:From:Subject:From;
        b=xdEcXQHiXmOWe1UDqesmgt1FO2kDP1xIuws+czWKrEzvt5cwsTMbgsp8i+s7pzPLj
         FJgE4+vhOUOqjJ1FovF2BBHgyloY8yNKleqwQXKKWj+erIa4U6WJlHXGFgaRLJOekh
         LMZUp4itsDhi5BvcwmpBPZCNuGk6CvRST/HLCTiY=
Date:   Tue, 11 Apr 2023 14:03:31 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, shuah@kernel.org,
        sam@ravnborg.org, peterx@redhat.com, hughd@google.com,
        davem@davemloft.net, anshuman.khandual@arm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch added to mm-unstable branch
Message-Id: <20230411210332.3740FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: reuse read_pmd_pagesize() in COW selftest
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: reuse read_pmd_pagesize() in COW selftest
Date: Tue, 11 Apr 2023 16:25:07 +0200

Patch series "mm: (pte|pmd)_mkdirty() should not unconditionally allow for
write access".

This is the follow-up on [1], adding selftests (testing for known issues
we added workarounds for and other issues that haven't been fixed yet),
fixing sparc64, reverting the workarounds, and perform one cleanup.

The patch from [1] was modified slightly (updated/extended patch
description, dropped one unnecessary NOP instruction from the ASM in
__pte_mkhwwrite()).

Retested on x86_64 and sparc64 (sun4u in QEMU).

I scanned most architectures to make sure their (pte|pmd)_mkdirty()
handling is correct.  To be sure, we can run the selftests and find out if
other architectures are still affectes (loongarch was fixed recently as
well).

Based on master for now. I don't expect surprises regarding mm-tress, but
I can rebase if there are any problems.


This patch (of 6):

The COW selftest can deal with THP not being configured.  So move error
handling of read_pmd_pagesize() into the callers such that we can reuse it
in the COW selftest.

Link: https://lkml.kernel.org/r/20230411142512.438404-1-david@redhat.com
Link: https://lkml.kernel.org/r/20221212130213.136267-1-david@redhat.com [1]
Link: https://lkml.kernel.org/r/20230411142512.438404-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c                  |   33 +-----------
 tools/testing/selftests/mm/khugepaged.c           |    4 +
 tools/testing/selftests/mm/soft-dirty.c           |    3 +
 tools/testing/selftests/mm/split_huge_page_test.c |    4 +
 tools/testing/selftests/mm/vm_util.c              |    4 -
 5 files changed, 17 insertions(+), 31 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest
+++ a/tools/testing/selftests/mm/cow.c
@@ -45,34 +45,6 @@ static size_t hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
-static void detect_thpsize(void)
-{
-	int fd = open("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size",
-		      O_RDONLY);
-	size_t size = 0;
-	char buf[15];
-	int ret;
-
-	if (fd < 0)
-		return;
-
-	ret = pread(fd, buf, sizeof(buf), 0);
-	if (ret > 0 && ret < sizeof(buf)) {
-		buf[ret] = 0;
-
-		size = strtoul(buf, NULL, 10);
-		if (size < pagesize)
-			size = 0;
-		if (size > 0) {
-			thpsize = size;
-			ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
-				       thpsize / 1024);
-		}
-	}
-
-	close(fd);
-}
-
 static void detect_huge_zeropage(void)
 {
 	int fd = open("/sys/kernel/mm/transparent_hugepage/use_zero_page",
@@ -1741,7 +1713,10 @@ int main(int argc, char **argv)
 	int err;
 
 	pagesize = getpagesize();
-	detect_thpsize();
+	thpsize = read_pmd_pagesize();
+	if (thpsize)
+		ksft_print_msg("[INFO] detected THP size: %zu KiB\n",
+			       thpsize / 1024);
 	detect_hugetlbsizes();
 	detect_huge_zeropage();
 
--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1476,6 +1476,10 @@ int main(int argc, const char **argv)
 
 	page_size = getpagesize();
 	hpage_pmd_size = read_pmd_pagesize();
+	if (!hpage_pmd_size) {
+		printf("Reading PMD pagesize failed");
+		exit(EXIT_FAILURE);
+	}
 	hpage_pmd_nr = hpage_pmd_size / page_size;
 
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
--- a/tools/testing/selftests/mm/soft-dirty.c~selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest
+++ a/tools/testing/selftests/mm/soft-dirty.c
@@ -80,6 +80,9 @@ static void test_hugepage(int pagemap_fd
 	int i, ret;
 	size_t hpage_len = read_pmd_pagesize();
 
+	if (!hpage_len)
+		ksft_exit_fail_msg("Reading PMD pagesize failed");
+
 	map = memalign(hpage_len, hpage_len);
 	if (!map)
 		ksft_exit_fail_msg("memalign failed\n");
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -490,6 +490,10 @@ int main(int argc, char **argv)
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
 	pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize) {
+		printf("Reading PMD pagesize failed\n");
+		exit(EXIT_FAILURE);
+	}
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_thp();
--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -84,12 +84,12 @@ uint64_t read_pmd_pagesize(void)
 
 	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
 	if (fd == -1)
-		ksft_exit_fail_msg("Open hpage_pmd_size failed\n");
+		return 0;
 
 	num_read = read(fd, buf, 19);
 	if (num_read < 1) {
 		close(fd);
-		ksft_exit_fail_msg("Read hpage_pmd_size failed\n");
+		return 0;
 	}
 	buf[num_read] = '\0';
 	close(fd);
_

Patches currently in -mm which might be from david@redhat.com are

mm-userfaultfd-fix-uffd-wp-handling-for-thp-migration-entries.patch
m68k-mm-use-correct-bit-number-in-_page_swp_exclusive-comment.patch
mm-userfaultfd-dont-consider-uffd-wp-bit-of-writable-migration-entries.patch
selftests-mm-reuse-read_pmd_pagesize-in-cow-selftest.patch
selftests-mm-mkdirty-test-behavior-of-ptepmd_mkdirty-on-vmas-without-write-permissions.patch
sparc-mm-dont-unconditionally-set-hw-writable-bit-when-setting-pte-dirty-on-64bit.patch
mm-migrate-revert-mm-migrate-fix-wrongly-apply-write-bit-after-mkdirty-on-sparc64.patch
mm-huge_memory-revert-partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-huge_memory-conditionally-call-maybe_mkwrite-and-drop-pte_wrprotect-in-__split_huge_pmd_locked.patch

