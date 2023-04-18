Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E95AC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjDRXhk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjDRXgH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1F4A5F5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 349416387C
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B030C433D2;
        Tue, 18 Apr 2023 23:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860912;
        bh=WeollxszucsNj6OXf0P3YPRzCeiJO3xJzH9TTyhibuw=;
        h=Date:To:From:Subject:From;
        b=AsQiXzNSpivS2AJLM+YHHK5pAcL7nyQUakZCVO+GxZkaJ1RoBJGJVRd6N6wrTx0V8
         D3KW27SIGkRJ5EFDECLBczXP/HJOG+Q5HKlC3DQD2mLdFGcMmi17EhmImhNCtOI164
         vA75e87QL7bJXKDr1G5ydEnrQuRVN3sg9cg0kcXo=
Date:   Tue, 18 Apr 2023 16:35:11 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-test_gen_progs-where-proper.patch removed from -mm tree
Message-Id: <20230418233512.8B030C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: use TEST_GEN_PROGS where proper
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-test_gen_progs-where-proper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: use TEST_GEN_PROGS where proper
Date: Wed, 12 Apr 2023 12:42:18 -0400

TEST_GEN_PROGS and TEST_GEN_FILES are used randomly in the mm/Makefile to
specify programs that need to build.  Logically all these binaries should
all fall into TEST_GEN_PROGS.

Replace those TEST_GEN_FILES with TEST_GEN_PROGS, so that we can reference
all the tests easily later.

[peterx@redhat.com: tools/testing/selftests/mm/Makefile: don't wipe out TEST_GEN_PROGS]
  Link: https://lkml.kernel.org/r/ZDxrvZh/cw357D8P@x1n
Link: https://lkml.kernel.org/r/20230412164218.328104-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |   65 +++++++++++++-------------
 1 file changed, 33 insertions(+), 32 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-use-test_gen_progs-where-proper
+++ a/tools/testing/selftests/mm/Makefile
@@ -31,35 +31,36 @@ MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 LDLIBS = -lrt -lpthread
-TEST_GEN_FILES = cow
-TEST_GEN_FILES += compaction_test
-TEST_GEN_FILES += gup_test
-TEST_GEN_FILES += hmm-tests
-TEST_GEN_FILES += hugetlb-madvise
-TEST_GEN_FILES += hugepage-mmap
-TEST_GEN_FILES += hugepage-mremap
-TEST_GEN_FILES += hugepage-shm
-TEST_GEN_FILES += hugepage-vmemmap
-TEST_GEN_FILES += khugepaged
-TEST_GEN_PROGS = madv_populate
-TEST_GEN_FILES += map_fixed_noreplace
-TEST_GEN_FILES += map_hugetlb
-TEST_GEN_FILES += map_populate
-TEST_GEN_FILES += memfd_secret
-TEST_GEN_FILES += migration
+
+TEST_GEN_PROGS = cow
+TEST_GEN_PROGS += compaction_test
+TEST_GEN_PROGS += gup_test
+TEST_GEN_PROGS += hmm-tests
+TEST_GEN_PROGS += hugetlb-madvise
+TEST_GEN_PROGS += hugepage-mmap
+TEST_GEN_PROGS += hugepage-mremap
+TEST_GEN_PROGS += hugepage-shm
+TEST_GEN_PROGS += hugepage-vmemmap
+TEST_GEN_PROGS += khugepaged
+TEST_GEN_PROGS += madv_populate
+TEST_GEN_PROGS += map_fixed_noreplace
+TEST_GEN_PROGS += map_hugetlb
+TEST_GEN_PROGS += map_populate
+TEST_GEN_PROGS += memfd_secret
+TEST_GEN_PROGS += migration
 TEST_GEN_PROGS += mkdirty
-TEST_GEN_FILES += mlock-random-test
-TEST_GEN_FILES += mlock2-tests
-TEST_GEN_FILES += mrelease_test
-TEST_GEN_FILES += mremap_dontunmap
-TEST_GEN_FILES += mremap_test
-TEST_GEN_FILES += on-fault-limit
-TEST_GEN_FILES += thuge-gen
-TEST_GEN_FILES += transhuge-stress
-TEST_GEN_FILES += userfaultfd
+TEST_GEN_PROGS += mlock-random-test
+TEST_GEN_PROGS += mlock2-tests
+TEST_GEN_PROGS += mrelease_test
+TEST_GEN_PROGS += mremap_dontunmap
+TEST_GEN_PROGS += mremap_test
+TEST_GEN_PROGS += on-fault-limit
+TEST_GEN_PROGS += thuge-gen
+TEST_GEN_PROGS += transhuge-stress
+TEST_GEN_PROGS += userfaultfd
 TEST_GEN_PROGS += soft-dirty
 TEST_GEN_PROGS += split_huge_page_test
-TEST_GEN_FILES += ksm_tests
+TEST_GEN_PROGS += ksm_tests
 TEST_GEN_PROGS += ksm_functional_tests
 TEST_GEN_PROGS += mdwe_test
 
@@ -77,24 +78,24 @@ CFLAGS += -no-pie
 endif
 
 ifeq ($(CAN_BUILD_I386),1)
-TEST_GEN_FILES += $(BINARIES_32)
+TEST_GEN_PROGS += $(BINARIES_32)
 endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
-TEST_GEN_FILES += $(BINARIES_64)
+TEST_GEN_PROGS += $(BINARIES_64)
 endif
 else
 
 ifneq (,$(findstring $(MACHINE),ppc64))
-TEST_GEN_FILES += protection_keys
+TEST_GEN_PROGS += protection_keys
 endif
 
 endif
 
 ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 riscv64 s390x sh64 sparc64 x86_64))
-TEST_GEN_FILES += va_128TBswitch
-TEST_GEN_FILES += virtual_address_range
-TEST_GEN_FILES += write_to_hugetlbfs
+TEST_GEN_PROGS += va_128TBswitch
+TEST_GEN_PROGS += virtual_address_range
+TEST_GEN_PROGS += write_to_hugetlbfs
 endif
 
 TEST_PROGS := run_vmtests.sh
_

Patches currently in -mm which might be from peterx@redhat.com are

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
mm-hugetlb-fix-uffd-wp-during-fork.patch
mm-hugetlb-fix-uffd-wp-bit-lost-when-unsharing-happens.patch
selftests-mm-add-a-few-options-for-uffd-unit-test.patch
selftests-mm-extend-and-rename-uffd-pagemap-test.patch
selftests-mm-rename-cow_extra_libs-to-iouring_extra_libs.patch
selftests-mm-add-tests-for-ro-pinning-vs-fork.patch

