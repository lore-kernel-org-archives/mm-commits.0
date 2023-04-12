Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EF7C77B6E
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjDLUDA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjDLUCs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D636A4D
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5420D638BE
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA799C433EF;
        Wed, 12 Apr 2023 20:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329764;
        bh=eZQjmM8zJHiaYnkmZ8kmiWlzQ9koOSICgqLLO1mbNmk=;
        h=Date:To:From:Subject:From;
        b=l5KLsYOucwb2GJRSzHdRWt+hdxXfXS5OPlfSSSrtt/QVpULXtA9hDy59pmsxEPBOf
         xJd1xmsiWBDYIHYBWM2KeQs8pdGud+fuit2GqeEYt7VNEQZV08Yw49Ak5wwtvBYOY+
         DH+bDBWGkRFGLvAXokTbbCraPgvC40VS87G51vRo=
Date:   Wed, 12 Apr 2023 13:02:44 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch added to mm-unstable branch
Message-Id: <20230412200244.AA799C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: split uffd tests into uffd-stress and uffd-unit-tests
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: split uffd tests into uffd-stress and uffd-unit-tests
Date: Wed, 12 Apr 2023 12:42:44 -0400

In many ways it's weird and unwanted to keep all the tests in the same
userfaultfd.c at least when still in the current way.

For example, it doesn't make much sense to run the stress test for each
method we can create an userfaultfd handle (either via syscall or /dev/
node).  It's a waste of time running this twice for the whole stress as
the stress paths are the same, only the open path is different.

It's also just weird to need to manually specify different types of memory
to run all unit tests for the userfaultfd interface.  We should be able to
just run a single program and that should go through all functional uffd
tests without running the stress test at all.  The stress test was more
for torturing and finding race conditions.  We don't want to wait for
stress to finish just to regress test a functional test.

When we start to pile up more things on top of the same file and same
functions, things start to go a bit chaos and the code is just harder to
maintain too with tons of global variables.

This patch creates a new test uffd-unit-tests to keep userfaultfd unit
tests in the future, currently empty.

Meanwhile rename the old userfaultfd.c test to uffd-stress.c.

Link: https://lkml.kernel.org/r/20230412164244.328270-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore        |    3 +
 tools/testing/selftests/mm/Makefile          |    8 +++--
 tools/testing/selftests/mm/run_vmtests.sh    |   10 +++---
 tools/testing/selftests/mm/uffd-unit-tests.c |   27 +++++++++++++++++
 4 files changed, 40 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests
+++ a/tools/testing/selftests/mm/.gitignore
@@ -21,7 +21,8 @@ protection_keys
 protection_keys_32
 protection_keys_64
 madv_populate
-userfaultfd
+uffd-stress
+uffd-unit-tests
 mlock-intersect-test
 mlock-random-test
 virtual_address_range
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests
+++ a/tools/testing/selftests/mm/Makefile
@@ -20,7 +20,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed
 # Avoid accidental wrong builds, due to built-in rules working just a little
 # bit too well--but not quite as well as required for our situation here.
 #
-# In other words, "make userfaultfd" is supposed to fail to build at all,
+# In other words, "make $SOME_TEST" is supposed to fail to build at all,
 # because this Makefile only supports either "make" (all), or "make /full/path".
 # However,  the built-in rules, if not suppressed, will pick up CFLAGS and the
 # initial LDLIBS (but not the target-specific LDLIBS, because those are only
@@ -57,7 +57,8 @@ TEST_GEN_PROGS += mremap_test
 TEST_GEN_PROGS += on-fault-limit
 TEST_GEN_PROGS += thuge-gen
 TEST_GEN_PROGS += transhuge-stress
-TEST_GEN_PROGS += userfaultfd
+TEST_GEN_PROGS += uffd-stress
+TEST_GEN_PROGS += uffd-unit-tests
 TEST_GEN_PROGS += soft-dirty
 TEST_GEN_PROGS += split_huge_page_test
 TEST_GEN_PROGS += ksm_tests
@@ -108,7 +109,8 @@ include ../lib.mk
 
 $(TEST_GEN_PROGS): vm_util.c
 
-$(OUTPUT)/userfaultfd: uffd-common.c
+$(OUTPUT)/uffd-stress: uffd-common.c
+$(OUTPUT)/uffd-unit-tests: uffd-common.c
 
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -196,14 +196,16 @@ CATEGORY="gup_test" run_test ./gup_test
 # Dump pages 0, 19, and 4096, using pin_user_pages:
 CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
 
+CATEGORY="userfaultfd" run_test ./uffd-unit-tests
 uffd_mods=("" ":dev")
+uffd_stress_bin=./uffd-stress
 for mod in "${uffd_mods[@]}"; do
-	CATEGORY="userfaultfd" run_test ./userfaultfd anon${mod} 20 16
+	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon${mod} 20 16
 	# Hugetlb tests require source and destination huge pages. Pass in half
 	# the size ($half_ufd_size_MB), which is used for *each*.
-	CATEGORY="userfaultfd" run_test ./userfaultfd hugetlb${mod} "$half_ufd_size_MB" 32
-	CATEGORY="userfaultfd" run_test ./userfaultfd hugetlb_shared${mod} "$half_ufd_size_MB" 32
-	CATEGORY="userfaultfd" run_test ./userfaultfd shmem${mod} 20 16
+	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb${mod} "$half_ufd_size_MB" 32
+	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb_shared${mod} "$half_ufd_size_MB" 32
+	CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem${mod} 20 16
 done
 
 #cleanup
--- /dev/null
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Userfaultfd unit tests.
+ *
+ *  Copyright (C) 2015-2023  Red Hat, Inc.
+ */
+
+#include "uffd-common.h"
+
+#ifdef __NR_userfaultfd
+
+int main(int argc, char *argv[])
+{
+	return KSFT_PASS;
+}
+
+#else /* __NR_userfaultfd */
+
+#warning "missing __NR_userfaultfd definition"
+
+int main(void)
+{
+	printf("Skipping %s (missing __NR_userfaultfd)\n", __file__);
+	return KSFT_SKIP;
+}
+
+#endif /* __NR_userfaultfd */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
revert-userfaultfd-dont-fail-on-unrecognized-features.patch
selftests-mm-update-gitignore-with-two-missing-tests.patch
selftests-mm-dump-a-summary-in-run_vmtestssh.patch
selftests-mm-merge-utilh-into-vm_utilh.patch
selftests-mm-use-test_gen_progs-where-proper.patch
selftests-mm-link-vm_utilc-always.patch
selftests-mm-merge-default_huge_page_size-into-one.patch
selftests-mm-use-pm_-macros-in-vm_utilsh.patch
selftests-mm-reuse-pagemap_get_entry-in-vm_utilh.patch
selftests-mm-test-uffdio_zeropage-only-when-hugetlb.patch
selftests-mm-drop-test_uffdio_zeropage_eexist.patch
selftests-mm-create-uffd-common.patch
selftests-mm-split-uffd-tests-into-uffd-stress-and-uffd-unit-tests.patch
selftests-mm-uffd_register.patch
selftests-mm-uffd_open_devsys.patch
selftests-mm-uffdio_api-test.patch
selftests-mm-drop-global-mem_fd-in-uffd-tests.patch
selftests-mm-drop-global-hpage_size-in-uffd-tests.patch
selftests-mm-rename-uffd_stats-to-uffd_args.patch
selftests-mm-let-uffd_handle_page_fault-take-wp-parameter.patch
selftests-mm-allow-allocate_area-to-fail-properly.patch
selftests-mm-add-framework-for-uffd-unit-test.patch
selftests-mm-move-uffd-pagemap-test-to-unit-test.patch
selftests-mm-move-uffd-minor-test-to-unit-test.patch
selftests-mm-move-uffd-sig-events-tests-into-uffd-unit-tests.patch
selftests-mm-move-zeropage-test-into-uffd-unit-tests.patch
selftests-mm-workaround-no-way-to-detect-uffd-minor-wp.patch
selftests-mm-allow-uffd-test-to-skip-properly-with-no-privilege.patch
selftests-mm-drop-sys-dev-test-in-uffd-stress-test.patch
selftests-mm-add-shmem-private-test-to-uffd-stress.patch
selftests-mm-add-uffdio-register-ioctls-test.patch

