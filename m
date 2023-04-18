Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3AF7C77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjDRXhj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjDRXgI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018E5A5E2
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E57863A0B
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72D7C4339B;
        Tue, 18 Apr 2023 23:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860914;
        bh=dRMwE8Ld2tfb+gmCkmTR3O/iO/l6C5dP9RYS2X5wbCk=;
        h=Date:To:From:Subject:From;
        b=je1rB8hAUj4da8tbwlFgkDPPEvsOY/JhK4JyZcwYpZmJ9PHCAJTF5xt3rWc+OIo7h
         68jyn2Uo8+q5crU7yXlM6LoKapM2E72ijy++/W4I55FUs9ebjwMMjtbIIg0QFT+30M
         ivFBsumaLEEB4mWFm8207LNo+kW6stQCb7jevNAo=
Date:   Tue, 18 Apr 2023 16:35:13 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-link-vm_utilc-always.patch removed from -mm tree
Message-Id: <20230418233513.E72D7C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: link vm_util.c always
has been removed from the -mm tree.  Its filename was
     selftests-mm-link-vm_utilc-always.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: link vm_util.c always
Date: Wed, 12 Apr 2023 12:42:20 -0400

We do have plenty of files that want to link against vm_util.c.  Just make
it simple by linking it always.

Link: https://lkml.kernel.org/r/20230412164220.328123-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-link-vm_utilc-always
+++ a/tools/testing/selftests/mm/Makefile
@@ -106,18 +106,7 @@ TEST_FILES += va_128TBswitch.sh
 
 include ../lib.mk
 
-$(OUTPUT)/cow: vm_util.c
-$(OUTPUT)/khugepaged: vm_util.c
-$(OUTPUT)/ksm_functional_tests: vm_util.c
-$(OUTPUT)/madv_populate: vm_util.c
-$(OUTPUT)/mkdirty: vm_util.c
-$(OUTPUT)/soft-dirty: vm_util.c
-$(OUTPUT)/split_huge_page_test: vm_util.c
-$(OUTPUT)/userfaultfd: vm_util.c
-$(OUTPUT)/gup_test: vm_util.c
-$(OUTPUT)/mrelease_test: vm_util.c
-$(OUTPUT)/transhuge-stress: vm_util.c
-$(OUTPUT)/ksm_tests: vm_util.c
+$(TEST_GEN_PROGS): vm_util.c
 
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
_

Patches currently in -mm which might be from peterx@redhat.com are

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

