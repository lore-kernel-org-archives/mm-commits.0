Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CFFC00528
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjGXQjx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjGXQjd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:39:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E783E1B8
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:39:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8445D6127D
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC00FC433C8;
        Mon, 24 Jul 2023 16:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690216768;
        bh=PdWsrAMlVFncapKL8gDzwjsFI4+oOk7m28cMXyG5A3Q=;
        h=Date:To:From:Subject:From;
        b=HaeisvyMmZG8UQpQ5bPJ632s4fHn9h5zjm1ZU/GoBWyet+j7Kks1XZlRKJbCyJHaS
         99utBbQYwei5QvDzXpYBA3ltv+IZoAVk0bjoTpV0GoFnKRTCN+/dW3HLywv2xQs9fB
         pE5+nsOZhdLlRElBaCubRgZ/9hRRI6aHlxV2TfJ4=
Date:   Mon, 24 Jul 2023 09:39:27 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, revest@chromium.org,
        peterx@redhat.com, jhubbard@nvidia.com, jglisse@redhat.com,
        david@redhat.com, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run-all-tests-from-run_vmtestssh.patch added to mm-unstable branch
Message-Id: <20230724163927.DC00FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: run all tests from run_vmtests.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-run-all-tests-from-run_vmtestssh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run-all-tests-from-run_vmtestssh.patch

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
Subject: selftests/mm: run all tests from run_vmtests.sh
Date: Mon, 24 Jul 2023 09:25:22 +0100

It is very unclear to me how one is supposed to run all the mm selftests
consistently and get clear results.

Most of the test programs are launched by both run_vmtests.sh and
run_kselftest.sh:

  hugepage-mmap
  hugepage-shm
  map_hugetlb
  hugepage-mremap
  hugepage-vmemmap
  hugetlb-madvise
  map_fixed_noreplace
  gup_test
  gup_longterm
  uffd-unit-tests
  uffd-stress
  compaction_test
  on-fault-limit
  map_populate
  mlock-random-test
  mlock2-tests
  mrelease_test
  mremap_test
  thuge-gen
  virtual_address_range
  va_high_addr_switch
  mremap_dontunmap
  hmm-tests
  madv_populate
  memfd_secret
  ksm_tests
  ksm_functional_tests
  soft-dirty
  cow

However, of this set, when launched by run_vmtests.sh, some of the
programs are invoked multiple times with different arguments. When
invoked by run_kselftest.sh, they are invoked without arguments (and as
a consequence, some fail immediately).

Some test programs are only launched by run_vmtests.sh:

  test_vmalloc.sh

And some test programs and only launched by run_kselftest.sh:

  khugepaged
  migration
  mkdirty
  transhuge-stress
  split_huge_page_test
  mdwe_test
  write_to_hugetlbfs

Furthermore, run_vmtests.sh is invoked by run_kselftest.sh, so in this
case all the test programs invoked by both scripts are run twice!

Needless to say, this is a bit of a mess. In the absence of fully
understanding the history here, it looks to me like the best solution is
to launch ALL test programs from run_vmtests.sh, and ONLY invoke
run_vmtests.sh from run_kselftest.sh. This way, we get full control over
the parameters, each program is only invoked the intended number of
times, and regardless of which script is used, the same tests get run in
the same way.

The only drawback is that if using run_kselftest.sh, it's top-level tap
result reporting reports only a single test and it fails if any of the
contained tests fail. I don't see this as a big deal though since we
still see all the nested reporting from multiple layers. The other issue
with this is that all of run_vmtests.sh must execute within a single
kselftest timeout period, so let's increase that to something more
suitable.

In the Makefile, TEST_GEN_PROGS will compile and install the tests and
will add them to the list of tests that run_kselftest.sh will run.
TEST_GEN_FILES will compile and install the tests but will not add them
to the test list. So let's move all the programs from TEST_GEN_PROGS to
TEST_GEN_FILES so that they are built but not executed by
run_kselftest.sh. Note that run_vmtests.sh is added to TEST_PROGS, which
means it ends up in the test list. (the lack of "_GEN" means it won't be
compiled, but simply copied).

Link: https://lkml.kernel.org/r/20230724082522.1202616-9-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile       |   79 ++++++++++----------
 tools/testing/selftests/mm/run_vmtests.sh |   23 +++++
 tools/testing/selftests/mm/settings       |    2 
 3 files changed, 64 insertions(+), 40 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-run-all-tests-from-run_vmtestssh
+++ a/tools/testing/selftests/mm/Makefile
@@ -35,39 +35,39 @@ MAKEFLAGS += --no-builtin-rules
 CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 LDLIBS = -lrt -lpthread
 
-TEST_GEN_PROGS = cow
-TEST_GEN_PROGS += compaction_test
-TEST_GEN_PROGS += gup_longterm
-TEST_GEN_PROGS += gup_test
-TEST_GEN_PROGS += hmm-tests
-TEST_GEN_PROGS += hugetlb-madvise
-TEST_GEN_PROGS += hugetlb-read-hwpoison
-TEST_GEN_PROGS += hugepage-mmap
-TEST_GEN_PROGS += hugepage-mremap
-TEST_GEN_PROGS += hugepage-shm
-TEST_GEN_PROGS += hugepage-vmemmap
-TEST_GEN_PROGS += khugepaged
-TEST_GEN_PROGS += madv_populate
-TEST_GEN_PROGS += map_fixed_noreplace
-TEST_GEN_PROGS += map_hugetlb
-TEST_GEN_PROGS += map_populate
-TEST_GEN_PROGS += memfd_secret
-TEST_GEN_PROGS += migration
-TEST_GEN_PROGS += mkdirty
-TEST_GEN_PROGS += mlock-random-test
-TEST_GEN_PROGS += mlock2-tests
-TEST_GEN_PROGS += mrelease_test
-TEST_GEN_PROGS += mremap_dontunmap
-TEST_GEN_PROGS += mremap_test
-TEST_GEN_PROGS += on-fault-limit
-TEST_GEN_PROGS += thuge-gen
-TEST_GEN_PROGS += transhuge-stress
-TEST_GEN_PROGS += uffd-stress
-TEST_GEN_PROGS += uffd-unit-tests
-TEST_GEN_PROGS += split_huge_page_test
-TEST_GEN_PROGS += ksm_tests
-TEST_GEN_PROGS += ksm_functional_tests
-TEST_GEN_PROGS += mdwe_test
+TEST_GEN_FILES = cow
+TEST_GEN_FILES += compaction_test
+TEST_GEN_FILES += gup_longterm
+TEST_GEN_FILES += gup_test
+TEST_GEN_FILES += hmm-tests
+TEST_GEN_FILES += hugetlb-madvise
+TEST_GEN_FILES += hugetlb-read-hwpoison
+TEST_GEN_FILES += hugepage-mmap
+TEST_GEN_FILES += hugepage-mremap
+TEST_GEN_FILES += hugepage-shm
+TEST_GEN_FILES += hugepage-vmemmap
+TEST_GEN_FILES += khugepaged
+TEST_GEN_FILES += madv_populate
+TEST_GEN_FILES += map_fixed_noreplace
+TEST_GEN_FILES += map_hugetlb
+TEST_GEN_FILES += map_populate
+TEST_GEN_FILES += memfd_secret
+TEST_GEN_FILES += migration
+TEST_GEN_FILES += mkdirty
+TEST_GEN_FILES += mlock-random-test
+TEST_GEN_FILES += mlock2-tests
+TEST_GEN_FILES += mrelease_test
+TEST_GEN_FILES += mremap_dontunmap
+TEST_GEN_FILES += mremap_test
+TEST_GEN_FILES += on-fault-limit
+TEST_GEN_FILES += thuge-gen
+TEST_GEN_FILES += transhuge-stress
+TEST_GEN_FILES += uffd-stress
+TEST_GEN_FILES += uffd-unit-tests
+TEST_GEN_FILES += split_huge_page_test
+TEST_GEN_FILES += ksm_tests
+TEST_GEN_FILES += ksm_functional_tests
+TEST_GEN_FILES += mdwe_test
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_PROGS += soft-dirty
@@ -87,24 +87,24 @@ CFLAGS += -no-pie
 endif
 
 ifeq ($(CAN_BUILD_I386),1)
-TEST_GEN_PROGS += $(BINARIES_32)
+TEST_GEN_FILES += $(BINARIES_32)
 endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
-TEST_GEN_PROGS += $(BINARIES_64)
+TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
 
 ifneq (,$(findstring $(ARCH),ppc64))
-TEST_GEN_PROGS += protection_keys
+TEST_GEN_FILES += protection_keys
 endif
 
 endif
 
 ifneq (,$(filter $(ARCH),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sparc64 x86_64))
-TEST_GEN_PROGS += va_high_addr_switch
-TEST_GEN_PROGS += virtual_address_range
-TEST_GEN_PROGS += write_to_hugetlbfs
+TEST_GEN_FILES += va_high_addr_switch
+TEST_GEN_FILES += virtual_address_range
+TEST_GEN_FILES += write_to_hugetlbfs
 endif
 
 TEST_PROGS := run_vmtests.sh
@@ -116,6 +116,7 @@ TEST_FILES += va_high_addr_switch.sh
 include ../lib.mk
 
 $(TEST_GEN_PROGS): vm_util.c
+$(TEST_GEN_FILES): vm_util.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run-all-tests-from-run_vmtestssh
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -58,6 +58,17 @@ separated by spaces:
 	test soft dirty page bit semantics
 - cow
 	test copy-on-write semantics
+- thp
+	test transparent huge pages
+- migration
+	invoke move_pages(2) to exercise the migration entry code
+	paths in the kernel
+- mkdirty
+	test handling of code that might set PTE/PMD dirty in
+	read-only VMAs
+- mdwe
+	test prctl(PR_SET_MDWE, ...)
+
 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
 	exit 0
@@ -330,6 +341,18 @@ fi
 # COW tests
 CATEGORY="cow" run_test ./cow
 
+CATEGORY="thp" run_test ./khugepaged
+
+CATEGORY="thp" run_test ./transhuge-stress -d 20
+
+CATEGORY="thp" run_test ./split_huge_page_test
+
+CATEGORY="migration" run_test ./migration
+
+CATEGORY="mkdirty" run_test ./mkdirty
+
+CATEGORY="mdwe" run_test ./mdwe_test
+
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}"
 
 exit $exitcode
--- a/tools/testing/selftests/mm/settings~selftests-mm-run-all-tests-from-run_vmtestssh
+++ a/tools/testing/selftests/mm/settings
@@ -1 +1 @@
-timeout=90
+timeout=180
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

