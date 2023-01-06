Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136FBC53210
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 01:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAFB4q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 20:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAFB4q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 20:56:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B916FD2
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 17:56:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36F3FB81C3C
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 01:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2497C433EF;
        Fri,  6 Jan 2023 01:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672970192;
        bh=Q1r0QU2p76WL35+wLlErvbI8sPVMeZFTfELmbQjit8I=;
        h=Date:To:From:Subject:From;
        b=a/+GwPROxdu6SUdWRrD0byuSvxO7KqwBgM1gUR3Q/wbJCKt8cXOi2lzS4GwmacmHA
         O9PVznrMxLALHgW8kUFTxPvLdDwKpxkS5xrygY9Rl3jfSqVhSYIQdZWwctTcy/Sw7f
         CesJ6thEg/k2eANtRDBVBkw9GYCC+VflILyZ4zds=
Date:   Thu, 05 Jan 2023 17:56:31 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, nadav.amit@gmail.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch added to mm-unstable branch
Message-Id: <20230106015632.B2497C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: cow: add COW tests for collapsing of PTE-mapped anon THP
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch

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
Subject: selftests/vm: cow: add COW tests for collapsing of PTE-mapped anon THP
Date: Wed, 4 Jan 2023 15:49:05 +0100

Currently, anonymous PTE-mapped THPs cannot be collapsed in-place:
collapsing (e.g., via MADV_COLLAPSE) implies allocating a fresh THP and
mapping that new THP via a PMD: as it's a fresh anon THP, it will get the
exclusive flag set on the head page and everybody is happy.

However, if the kernel would ever support in-place collapse of anonymous
THPs (replacing a page table mapping each sub-page of a THP via PTEs with
a single PMD mapping the complete THP), exclusivity information stored for
each sub-page would have to be collapsed accordingly:

(1) All PTEs map !exclusive anon sub-pages: the in-place collapsed THP
    must not not have the exclusive flag set on the head page mapped by
    the PMD. This is the easiest case to handle ("simply don't set any
    exclusive flags").

(2) All PTEs map exclusive anon sub-pages: when collapsing, we have to
    clear the exclusive flag from all tail pages and only leave the
    exclusive flag set for the head page. Otherwise, fork() after
    collapse would not clear the exclusive flags from the tail pages
    and we'd be in trouble once PTE-mapping the shared THP when writing
    to shared tail pages that still have the exclusive flag set. This
    would effectively revert what the PTE-mapping code does when
    propagating the exclusive flag to all sub-pages.

(3) PTEs map a mixture of exclusive and !exclusive anon sub-pages (can
    happen e.g., due to MADV_DONTFORK before fork()). We must not
    collapse the THP in-place, otherwise bad things may happen:
    the exclusive flags of sub-pages would get ignored and the
    exclusive flag of the head page would get used instead.

Now that we have MADV_COLLAPSE in place to trigger collapsing a THP, let's
add some test cases that would bail out early, if we'd
voluntarily/accidantially unlock in-place collapse for anon THPs and
forget about taking proper care of exclusive flags.

Running the test on a kernel with MADV_COLLAPSE support:
  # [INFO] Anonymous THP tests
  # [RUN] Basic COW after fork() when collapsing before fork()
  ok 169 No leak from parent into child
  # [RUN] Basic COW after fork() when collapsing after fork() (fully shared)
  ok 170 # SKIP MADV_COLLAPSE failed: Invalid argument
  # [RUN] Basic COW after fork() when collapsing after fork() (lower shared)
  ok 171 No leak from parent into child
  # [RUN] Basic COW after fork() when collapsing after fork() (upper shared)
  ok 172 No leak from parent into child

For now, MADV_COLLAPSE always seems to fail if all PTEs map shared
sub-pages.

Link: https://lkml.kernel.org/r/20230104144905.460075-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/cow.c |  228 +++++++++++++++++++++++++++++
 1 file changed, 228 insertions(+)

--- a/tools/testing/selftests/vm/cow.c~selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp
+++ a/tools/testing/selftests/vm/cow.c
@@ -30,6 +30,10 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
+
 static size_t pagesize;
 static int pagemap_fd;
 static size_t thpsize;
@@ -1178,6 +1182,228 @@ static int tests_per_anon_test_case(void
 	return tests;
 }
 
+enum anon_thp_collapse_test {
+	ANON_THP_COLLAPSE_UNSHARED,
+	ANON_THP_COLLAPSE_FULLY_SHARED,
+	ANON_THP_COLLAPSE_LOWER_SHARED,
+	ANON_THP_COLLAPSE_UPPER_SHARED,
+};
+
+static void do_test_anon_thp_collapse(char *mem, size_t size,
+				      enum anon_thp_collapse_test test)
+{
+	struct comm_pipes comm_pipes;
+	char buf;
+	int ret;
+
+	ret = setup_comm_pipes(&comm_pipes);
+	if (ret) {
+		ksft_test_result_fail("pipe() failed\n");
+		return;
+	}
+
+	/*
+	 * Trigger PTE-mapping the THP by temporarily mapping a single subpage
+	 * R/O, such that we can try collapsing it later.
+	 */
+	ret = mprotect(mem + pagesize, pagesize, PROT_READ);
+	if (ret) {
+		ksft_test_result_fail("mprotect() failed\n");
+		goto close_comm_pipes;
+	}
+	ret = mprotect(mem + pagesize, pagesize, PROT_READ | PROT_WRITE);
+	if (ret) {
+		ksft_test_result_fail("mprotect() failed\n");
+		goto close_comm_pipes;
+	}
+
+	switch (test) {
+	case ANON_THP_COLLAPSE_UNSHARED:
+		/* Collapse before actually COW-sharing the page. */
+		ret = madvise(mem, size, MADV_COLLAPSE);
+		if (ret) {
+			ksft_test_result_skip("MADV_COLLAPSE failed: %s\n",
+					      strerror(errno));
+			goto close_comm_pipes;
+		}
+		break;
+	case ANON_THP_COLLAPSE_FULLY_SHARED:
+		/* COW-share the full PTE-mapped THP. */
+		break;
+	case ANON_THP_COLLAPSE_LOWER_SHARED:
+		/* Don't COW-share the upper part of the THP. */
+		ret = madvise(mem + size / 2, size / 2, MADV_DONTFORK);
+		if (ret) {
+			ksft_test_result_fail("MADV_DONTFORK failed\n");
+			goto close_comm_pipes;
+		}
+		break;
+	case ANON_THP_COLLAPSE_UPPER_SHARED:
+		/* Don't COW-share the lower part of the THP. */
+		ret = madvise(mem, size / 2, MADV_DONTFORK);
+		if (ret) {
+			ksft_test_result_fail("MADV_DONTFORK failed\n");
+			goto close_comm_pipes;
+		}
+		break;
+	default:
+		assert(false);
+	}
+
+	ret = fork();
+	if (ret < 0) {
+		ksft_test_result_fail("fork() failed\n");
+		goto close_comm_pipes;
+	} else if (!ret) {
+		switch (test) {
+		case ANON_THP_COLLAPSE_UNSHARED:
+		case ANON_THP_COLLAPSE_FULLY_SHARED:
+			exit(child_memcmp_fn(mem, size, &comm_pipes));
+			break;
+		case ANON_THP_COLLAPSE_LOWER_SHARED:
+			exit(child_memcmp_fn(mem, size / 2, &comm_pipes));
+			break;
+		case ANON_THP_COLLAPSE_UPPER_SHARED:
+			exit(child_memcmp_fn(mem + size / 2, size / 2,
+					     &comm_pipes));
+			break;
+		default:
+			assert(false);
+		}
+	}
+
+	while (read(comm_pipes.child_ready[0], &buf, 1) != 1)
+		;
+
+	switch (test) {
+	case ANON_THP_COLLAPSE_UNSHARED:
+		break;
+	case ANON_THP_COLLAPSE_UPPER_SHARED:
+	case ANON_THP_COLLAPSE_LOWER_SHARED:
+		/*
+		 * Revert MADV_DONTFORK such that we merge the VMAs and are
+		 * able to actually collapse.
+		 */
+		ret = madvise(mem, size, MADV_DOFORK);
+		if (ret) {
+			ksft_test_result_fail("MADV_DOFORK failed\n");
+			write(comm_pipes.parent_ready[1], "0", 1);
+			wait(&ret);
+			goto close_comm_pipes;
+		}
+		/* FALLTHROUGH */
+	case ANON_THP_COLLAPSE_FULLY_SHARED:
+		/* Collapse before anyone modified the COW-shared page. */
+		ret = madvise(mem, size, MADV_COLLAPSE);
+		if (ret) {
+			ksft_test_result_skip("MADV_COLLAPSE failed: %s\n",
+					      strerror(errno));
+			write(comm_pipes.parent_ready[1], "0", 1);
+			wait(&ret);
+			goto close_comm_pipes;
+		}
+		break;
+	default:
+		assert(false);
+	}
+
+	/* Modify the page. */
+	memset(mem, 0xff, size);
+	write(comm_pipes.parent_ready[1], "0", 1);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+
+	ksft_test_result(!ret, "No leak from parent into child\n");
+close_comm_pipes:
+	close_comm_pipes(&comm_pipes);
+}
+
+static void test_anon_thp_collapse_unshared(char *mem, size_t size)
+{
+	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_UNSHARED);
+}
+
+static void test_anon_thp_collapse_fully_shared(char *mem, size_t size)
+{
+	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_FULLY_SHARED);
+}
+
+static void test_anon_thp_collapse_lower_shared(char *mem, size_t size)
+{
+	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_LOWER_SHARED);
+}
+
+static void test_anon_thp_collapse_upper_shared(char *mem, size_t size)
+{
+	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_UPPER_SHARED);
+}
+
+/*
+ * Test cases that are specific to anonymous THP: pages in private mappings
+ * that may get shared via COW during fork().
+ */
+static const struct test_case anon_thp_test_cases[] = {
+	/*
+	 * Basic COW test for fork() without any GUP when collapsing a THP
+	 * before fork().
+	 *
+	 * Re-mapping a PTE-mapped anon THP using a single PMD ("in-place
+	 * collapse") might easily get COW handling wrong when not collapsing
+	 * exclusivity information properly.
+	 */
+	{
+		"Basic COW after fork() when collapsing before fork()",
+		test_anon_thp_collapse_unshared,
+	},
+	/* Basic COW test, but collapse after COW-sharing a full THP. */
+	{
+		"Basic COW after fork() when collapsing after fork() (fully shared)",
+		test_anon_thp_collapse_fully_shared,
+	},
+	/*
+	 * Basic COW test, but collapse after COW-sharing the lower half of a
+	 * THP.
+	 */
+	{
+		"Basic COW after fork() when collapsing after fork() (lower shared)",
+		test_anon_thp_collapse_lower_shared,
+	},
+	/*
+	 * Basic COW test, but collapse after COW-sharing the upper half of a
+	 * THP.
+	 */
+	{
+		"Basic COW after fork() when collapsing after fork() (upper shared)",
+		test_anon_thp_collapse_upper_shared,
+	},
+};
+
+static void run_anon_thp_test_cases(void)
+{
+	int i;
+
+	if (!thpsize)
+		return;
+
+	ksft_print_msg("[INFO] Anonymous THP tests\n");
+
+	for (i = 0; i < ARRAY_SIZE(anon_thp_test_cases); i++) {
+		struct test_case const *test_case = &anon_thp_test_cases[i];
+
+		ksft_print_msg("[RUN] %s\n", test_case->desc);
+		do_run_with_thp(test_case->fn, THP_RUN_PMD);
+	}
+}
+
+static int tests_per_anon_thp_test_case(void)
+{
+	return thpsize ? 1 : 0;
+}
+
 typedef void (*non_anon_test_fn)(char *mem, const char *smem, size_t size);
 
 static void test_cow(char *mem, const char *smem, size_t size)
@@ -1518,6 +1744,7 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
+		      ARRAY_SIZE(anon_thp_test_cases) * tests_per_anon_thp_test_case() +
 		      ARRAY_SIZE(non_anon_test_cases) * tests_per_non_anon_test_case());
 
 	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
@@ -1526,6 +1753,7 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("opening pagemap failed\n");
 
 	run_anon_test_cases();
+	run_anon_thp_test_cases();
 	run_non_anon_test_cases();
 
 	err = ksft_get_fail_cnt();
_

Patches currently in -mm which might be from david@redhat.com are

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch

