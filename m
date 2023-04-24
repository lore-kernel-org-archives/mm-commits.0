Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022C8C77B61
	for <mm-commits@archiver.kernel.org>; Mon, 24 Apr 2023 22:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjDXWem (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Apr 2023 18:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjDXWeb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Apr 2023 18:34:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062AA7AA3
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 15:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EE5B629D0
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 22:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B54C433EF;
        Mon, 24 Apr 2023 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682375666;
        bh=Q3T/LCCHSviK1u3xRO6vojHY3WIRxY4q+/GBmJom36k=;
        h=Date:To:From:Subject:From;
        b=UUB/l5t4yOJlEX8TvnbNQKEbYByK8qbo4QieGFra3aEa9iArykjzDL+W24bpRwMlW
         esDeDV0TANMevglCf9CQPEmKDRmzPSZefSt2xtGFc6gbCIsnMxfptiEa3xj9MUu5hS
         p6f7TaXEy+s88tR/HoZiv91mtuCAT1XQ/AYeuItA=
Date:   Mon, 24 Apr 2023 15:34:26 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, shuah@kernel.org,
        shr@devkernel.io, riel@surriel.com, mhocko@suse.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test.patch added to mm-unstable branch
Message-Id: <20230424223426.D2B54C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/ksm: ksm_functional_tests: add prctl unmerge test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test.patch

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
Subject: selftests/ksm: ksm_functional_tests: add prctl unmerge test
Date: Sat, 22 Apr 2023 22:54:19 +0200

Let's test whether setting PR_SET_MEMORY_MERGE to 0 after setting it to 1
will unmerge pages, similar to how setting MADV_UNMERGEABLE after setting
MADV_MERGEABLE would.

Link: https://lkml.kernel.org/r/20230422205420.30372-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Stefan Roesch <shr@devkernel.io>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_functional_tests.c |   46 ++++++++++--
 1 file changed, 40 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/ksm_functional_tests.c~selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test
+++ a/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -91,9 +91,10 @@ static int ksm_merge(void)
 	return 0;
 }
 
-static char *mmap_and_merge_range(char val, unsigned long size)
+static char *mmap_and_merge_range(char val, unsigned long size, bool use_prctl)
 {
 	char *map;
+	int ret;
 
 	map = mmap(NULL, size, PROT_READ|PROT_WRITE,
 		   MAP_PRIVATE|MAP_ANON, -1, 0);
@@ -110,7 +111,17 @@ static char *mmap_and_merge_range(char v
 
 	/* Make sure each page contains the same values to merge them. */
 	memset(map, val, size);
-	if (madvise(map, size, MADV_MERGEABLE)) {
+
+	if (use_prctl) {
+		ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
+		if (ret < 0 && errno == EINVAL) {
+			ksft_test_result_skip("PR_SET_MEMORY_MERGE not supported\n");
+			goto unmap;
+		} else if (ret) {
+			ksft_test_result_fail("PR_SET_MEMORY_MERGE=1 failed\n");
+			goto unmap;
+		}
+	} else if (madvise(map, size, MADV_MERGEABLE)) {
 		ksft_test_result_fail("MADV_MERGEABLE failed\n");
 		goto unmap;
 	}
@@ -133,7 +144,7 @@ static void test_unmerge(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	map = mmap_and_merge_range(0xcf, size);
+	map = mmap_and_merge_range(0xcf, size, false);
 	if (map == MAP_FAILED)
 		return;
 
@@ -155,7 +166,7 @@ static void test_unmerge_discarded(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	map = mmap_and_merge_range(0xcf, size);
+	map = mmap_and_merge_range(0xcf, size, false);
 	if (map == MAP_FAILED)
 		return;
 
@@ -187,7 +198,7 @@ static void test_unmerge_uffd_wp(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	map = mmap_and_merge_range(0xcf, size);
+	map = mmap_and_merge_range(0xcf, size, false);
 	if (map == MAP_FAILED)
 		return;
 
@@ -323,9 +334,31 @@ static void test_prctl_fork(void)
 	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
 }
 
+static void test_prctl_unmerge(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	map = mmap_and_merge_range(0xcf, size, true);
+	if (map == MAP_FAILED)
+		return;
+
+	if (prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0)) {
+		ksft_test_result_fail("PR_SET_MEMORY_MERGE=0 failed\n");
+		goto unmap;
+	}
+
+	ksft_test_result(!range_maps_duplicates(map, size),
+			 "Pages were unmerged\n");
+unmap:
+	munmap(map, size);
+}
+
 int main(int argc, char **argv)
 {
-	unsigned int tests = 4;
+	unsigned int tests = 5;
 	int err;
 
 #ifdef __NR_userfaultfd
@@ -355,6 +388,7 @@ int main(int argc, char **argv)
 
 	test_prctl();
 	test_prctl_fork();
+	test_prctl_unmerge();
 
 	err = ksft_get_fail_cnt();
 	if (err)
_

Patches currently in -mm which might be from david@redhat.com are

mm-ksm-unmerge-and-clear-vm_mergeable-when-setting-pr_set_memory_merge=0.patch
selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test.patch
mm-ksm-move-disabling-ksm-from-s390-gmap-code-to-ksm-code.patch

