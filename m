Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDFCCA0FFB
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 16:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjIEQfN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242911AbjIEQLD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 12:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F8049FA
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 09:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7969660A50
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCBAC433C7;
        Tue,  5 Sep 2023 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929774;
        bh=cGsibz7lEjhc5ffsV4wz5X7YCYIQyrpF7tlkxjNqNTI=;
        h=Date:To:From:Subject:From;
        b=bZ4SIZ8OlqwuU4mLa7MrRsWgEiCe0RtAc+9zLOYgHJbvyj7ng5emItGex9CFJGmOt
         SNSXYkslAeOVXiEeclwRKdpjDfqVVlb2HsjuOqFY9fp/ObW8MvurgulKsslMTv0XZX
         sMu9yKAh9zNs9ttreq5uS1I7+j6AFtWIktDz3uxs=
Date:   Tue, 05 Sep 2023 09:02:54 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, shuah@kernel.org,
        paulmck@kernel.org, mhocko@suse.com, lstoakes@gmail.com,
        lokeshgidra@google.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, kaleshsingh@google.com,
        joel@joelfernandes.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-test-for-remapping-within-a-range.patch added to mm-unstable branch
Message-Id: <20230905160254.CBCBAC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: mm: add a test for remapping within a range
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-a-test-for-remapping-within-a-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-test-for-remapping-within-a-range.patch

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
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: selftests: mm: add a test for remapping within a range
Date: Sun, 3 Sep 2023 15:13:27 +0000

Move a block of memory within a memory range.  Any alignment optimization
on the source address may cause corruption.  Verify using kselftest that
it works.  I have also verified with tracing that such optimization does
not happen due to this check in can_align_down():

if (!for_stack && vma->vm_start != addr_to_align)
	return false;

Link: https://lkml.kernel.org/r/20230903151328.2981432-7-joel@joelfernandes.org
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_test.c |   79 ++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-add-a-test-for-remapping-within-a-range
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -23,6 +23,7 @@
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
+#define SIZE_MB(m) ((size_t)m * (1024 * 1024))
 
 struct config {
 	unsigned long long src_alignment;
@@ -227,6 +228,79 @@ out:
 }
 
 /*
+ * Verify that an mremap within a range does not cause corruption
+ * of unrelated part of range.
+ *
+ * Consider the following range which is 2MB aligned and is
+ * a part of a larger 20MB range which is not shown. Each
+ * character is 256KB below making the source and destination
+ * 2MB each. The lower case letters are moved (s to d) and the
+ * upper case letters are not moved. The below test verifies
+ * that the upper case S letters are not corrupted by the
+ * adjacent mremap.
+ *
+ * |DDDDddddSSSSssss|
+ */
+static void mremap_move_within_range(char pattern_seed)
+{
+	char *test_name = "mremap mremap move within range";
+	void *src, *dest;
+	int i, success = 1;
+
+	size_t size = SIZE_MB(20);
+	void *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (ptr == MAP_FAILED) {
+		perror("mmap");
+		success = 0;
+		goto out;
+	}
+	memset(ptr, 0, size);
+
+	src = ptr + SIZE_MB(6);
+	src = (void *)((unsigned long)src & ~(SIZE_MB(2) - 1));
+
+	/* Set byte pattern for source block. */
+	srand(pattern_seed);
+	for (i = 0; i < SIZE_MB(2); i++) {
+		((char *)src)[i] = (char) rand();
+	}
+
+	dest = src - SIZE_MB(2);
+
+	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
+						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
+	if (new_ptr == MAP_FAILED) {
+		perror("mremap");
+		success = 0;
+		goto out;
+	}
+
+	/* Verify byte pattern after remapping */
+	srand(pattern_seed);
+	for (i = 0; i < SIZE_MB(1); i++) {
+		char c = (char) rand();
+
+		if (((char *)src)[i] != c) {
+			ksft_print_msg("Data at src at %d got corrupted due to unrelated mremap\n",
+				       i);
+			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
+					((char *) src)[i] & 0xff);
+			success = 0;
+		}
+	}
+
+out:
+	if (munmap(ptr, size) == -1)
+		perror("munmap");
+
+	if (success)
+		ksft_test_result_pass("%s\n", test_name);
+	else
+		ksft_test_result_fail("%s\n", test_name);
+}
+
+/*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
  */
@@ -491,6 +565,7 @@ int main(int argc, char **argv)
 	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
 	unsigned int pattern_seed;
 	int num_expand_tests = 2;
+	int num_misc_tests = 1;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -572,7 +647,7 @@ int main(int argc, char **argv)
 				(threshold_mb * _1MB >= _1GB);
 
 	ksft_set_plan(ARRAY_SIZE(test_cases) + (run_perf_tests ?
-		      ARRAY_SIZE(perf_test_cases) : 0) + num_expand_tests);
+		      ARRAY_SIZE(perf_test_cases) : 0) + num_expand_tests + num_misc_tests);
 
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
 		run_mremap_test_case(test_cases[i], &failures, threshold_mb,
@@ -590,6 +665,8 @@ int main(int argc, char **argv)
 
 	fclose(maps_fp);
 
+	mremap_move_within_range(pattern_seed);
+
 	if (run_perf_tests) {
 		ksft_print_msg("\n%s\n",
 		 "mremap HAVE_MOVE_PMD/PUD optimization time comparison for 1GB region:");
_

Patches currently in -mm which might be from joel@joelfernandes.org are

mm-vmalloc-add-a-safer-version-of-find_vm_area-for-debug.patch
mm-mremap-optimize-the-start-addresses-in-move_page_tables.patch
mm-mremap-allow-moves-within-the-same-vma-for-stack-moves.patch
selftests-mm-fix-failure-case-when-new-remap-region-was-not-found.patch
selftests-mm-add-a-test-for-mutually-aligned-moves-pmd-size.patch
selftests-mm-add-a-test-for-remapping-to-area-immediately-after-existing-mapping.patch
selftests-mm-add-a-test-for-remapping-within-a-range.patch
selftests-mm-add-a-test-for-moving-from-an-offset-from-start-of-mapping.patch

