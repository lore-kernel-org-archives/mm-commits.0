Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F761C77B72
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 20:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjDLUCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjDLUC3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Apr 2023 16:02:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279634482
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 13:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC8ED6382E
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 20:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E4FC433D2;
        Wed, 12 Apr 2023 20:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681329747;
        bh=sas6AO4In8e/U6rkIUCF4CojAsyq9MdIIXc2/COgj2U=;
        h=Date:To:From:Subject:From;
        b=bcHy0Rs5C3UuHkedoGfsaE0DRtvYOBiiywmW/5qQcxySYiGLVk3WrOndlcp07RJ/X
         XWMStTS29b496WVE5sTXDzHGE712FyW/lG+98S9pjxn/zVtrDI28mtqmRhUxfJSz61
         9LnRG6CQ+JoG7WzvvqI9mizCzyEIRkXlPSQlA/Zc=
Date:   Wed, 12 Apr 2023 13:02:26 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-test_gen_progs-where-proper.patch added to mm-unstable branch
Message-Id: <20230412200227.10E4FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: use TEST_GEN_PROGS where proper
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-test_gen_progs-where-proper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-test_gen_progs-where-proper.patch

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
Subject: selftests/mm: use TEST_GEN_PROGS where proper
Date: Wed, 12 Apr 2023 12:42:18 -0400

TEST_GEN_PROGS and TEST_GEN_FILES are used randomly in the mm/Makefile to
specify programs that need to build.  Logically all these binaries should
all fall into TEST_GEN_PROGS.

Replace those TEST_GEN_FILES with TEST_GEN_PROGS, so that we can reference
all the tests easily later.

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

 tools/testing/selftests/mm/Makefile |   63 +++++++++++++-------------
 1 file changed, 32 insertions(+), 31 deletions(-)

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
 TEST_GEN_PROGS = madv_populate
-TEST_GEN_FILES += map_fixed_noreplace
-TEST_GEN_FILES += map_hugetlb
-TEST_GEN_FILES += map_populate
-TEST_GEN_FILES += memfd_secret
-TEST_GEN_FILES += migration
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

