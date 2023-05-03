Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795CCC7EE24
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 00:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjECAWU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 20:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjECAWQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 20:22:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BCD30C0
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 17:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7ED9629D6
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 00:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D352C433D2;
        Wed,  3 May 2023 00:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683073334;
        bh=y02F2dDDNDyLLZfHAYBCqlPvJvE5KHRfhl+LLf2Zedo=;
        h=Date:To:From:Subject:From;
        b=BE9LssXzYGWxq+gTnDWrek1CjF5iFEyGVlo2OkxfLwtF2fMb6NiJhhCeW3DVMcqXs
         8cRTesQkIK3hm3QeyMz5Fdi5ODAfQnt8tKcBSElRM7K73FthNqGl6Uv6tbWZcXe42n
         0E/en18qZ0yfvrGe5OY/HNjzL+rephAEVZaW4W/Y=
Date:   Tue, 02 May 2023 17:22:13 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com, shuah@kernel.org,
        shr@devkernel.io, riel@surriel.com, mhocko@suse.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, frankja@linux.ibm.com,
        borntraeger@linux.ibm.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test.patch removed from -mm tree
Message-Id: <20230503002214.1D352C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/ksm: ksm_functional_tests: add prctl unmerge test
has been removed from the -mm tree.  Its filename was
     selftests-ksm-ksm_functional_tests-add-prctl-unmerge-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


