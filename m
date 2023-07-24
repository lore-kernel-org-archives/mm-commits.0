Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6B0C0015E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjGXQjW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjGXQjS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:39:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D6618E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A8B36128E
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70B5C433C8;
        Mon, 24 Jul 2023 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690216755;
        bh=hF8nA2YyU66t3NDIf3671NZr7U+Cmv0Tb3G+tdwANJw=;
        h=Date:To:From:Subject:From;
        b=vmH+UdnTpROSuWfmcjpRplDUs7w9rzlLddw+mnurAy7xljc3SU53CGzy6mcD3Tdxq
         k/CQ/c0Pta20W+MxuUSfOiDgMRAK3RRtgAeasmyDnPScFiwS0/RM58fibOMxOqmW2R
         unNNurXatZSKYS3j2A77vg1CBEEMLRMzo3nTf+/0=
Date:   Mon, 24 Jul 2023 09:39:15 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-soft-dirty-tests-on-arm64.patch added to mm-unstable branch
Message-Id: <20230724163915.B70B5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: skip soft-dirty tests on arm64
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-soft-dirty-tests-on-arm64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-soft-dirty-tests-on-arm64.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: skip soft-dirty tests on arm64
Date: Mon, 24 Jul 2023 09:25:16 +0100

arm64 does not support the soft-dirty PTE bit.  However, the `soft-dirty`
test suite is currently run unconditionally and therefore generates
spurious test failures on arm64.  There are also some tests in
`madv_populate` which assume it is supported.

For `soft-dirty` lets disable the whole suite for arm64; it is no longer
built and run_vmtests.sh will skip it if its not present.

For `madv_populate`, we need a runtime mechanism so that the remaining
tests continue to be run.  Unfortunately, the only way to determine if the
soft-dirty dirty bit is supported is to write to a page, then see if the
bit is set in /proc/self/pagemap.  But the tests that we want to
conditionally execute are testing precicesly this.  So if we introduced
this feature check, we could accedentally turn a real failure (on a system
that claims to support soft-dirty) into a skip.  So instead, do the check
based on architecture; for arm64, we report that soft-dirty is not
supported.

Link: https://lkml.kernel.org/r/20230724082522.1202616-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile        |    5 ++-
 tools/testing/selftests/mm/madv_populate.c |   26 +++++++++++++++++--
 tools/testing/selftests/mm/run_vmtests.sh  |    5 ++-
 3 files changed, 32 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-skip-soft-dirty-tests-on-arm64
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -264,14 +264,35 @@ static void test_softdirty(void)
 	munmap(addr, SIZE);
 }
 
+static int system_has_softdirty(void)
+{
+	/*
+	 * There is no way to check if the kernel supports soft-dirty, other
+	 * than by writing to a page and seeing if the bit was set. But the
+	 * tests are intended to check that the bit gets set when it should, so
+	 * doing that check would turn a potentially legitimate fail into a
+	 * skip. Fortunately, we know for sure that arm64 does not support
+	 * soft-dirty. So for now, let's just use the arch as a corse guide.
+	 */
+#if defined(__aarch64__)
+	return 0;
+#else
+	return 1;
+#endif
+}
+
 int main(int argc, char **argv)
 {
+	int nr_tests = 16;
 	int err;
 
 	pagesize = getpagesize();
 
+	if (system_has_softdirty())
+		nr_tests += 5;
+
 	ksft_print_header();
-	ksft_set_plan(21);
+	ksft_set_plan(nr_tests);
 
 	sense_support();
 	test_prot_read();
@@ -279,7 +300,8 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	test_softdirty();
+	if (system_has_softdirty())
+		test_softdirty();
 
 	err = ksft_get_fail_cnt();
 	if (err)
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-skip-soft-dirty-tests-on-arm64
+++ a/tools/testing/selftests/mm/Makefile
@@ -64,12 +64,15 @@ TEST_GEN_PROGS += thuge-gen
 TEST_GEN_PROGS += transhuge-stress
 TEST_GEN_PROGS += uffd-stress
 TEST_GEN_PROGS += uffd-unit-tests
-TEST_GEN_PROGS += soft-dirty
 TEST_GEN_PROGS += split_huge_page_test
 TEST_GEN_PROGS += ksm_tests
 TEST_GEN_PROGS += ksm_functional_tests
 TEST_GEN_PROGS += mdwe_test
 
+ifneq ($(ARCH),arm64)
+TEST_GEN_PROGS += soft-dirty
+endif
+
 ifeq ($(ARCH),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-skip-soft-dirty-tests-on-arm64
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -322,7 +322,10 @@ then
 	CATEGORY="pkey" run_test ./protection_keys_64
 fi
 
-CATEGORY="soft_dirty" run_test ./soft-dirty
+if [ -x ./soft-dirty ]
+then
+	CATEGORY="soft_dirty" run_test ./soft-dirty
+fi
 
 # COW tests
 CATEGORY="cow" run_test ./cow
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-implement-folio_remove_rmap_range.patch
mm-batch-zap-large-anonymous-folio-pte-mappings.patch
selftests-line-buffer-test-programs-stdout.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch

