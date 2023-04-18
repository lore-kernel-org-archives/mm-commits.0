Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD5AC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjDRXTC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjDRXS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:18:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD8893C7
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:18:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F2B0639E8
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DB4C433D2;
        Tue, 18 Apr 2023 23:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859936;
        bh=gBzFxmtozK071vQ4ntrtdY4AE0a1IUFhDuWyzxDS30U=;
        h=Date:To:From:Subject:From;
        b=Q8IrOwP2Iu8KX1O3YKEdZNfYQ1gbH73rDLJ6tZaMS2EwnCESYOCJifv/3iePV/4BZ
         588i5vvLCiTKKq+wv3z9RK69IpwBgNnVLSReYlDmVCcpGhBKFWOl7GGGxVZ1Il4msJ
         7NckXun/qsc675z7CJDgMVdU3PgVUJCbDONHfa3Q=
Date:   Tue, 18 Apr 2023 16:18:56 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com, rppt@kernel.org,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, 0x7f454c46@gmail.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-use-test_gen_progs-where-proper-fix.patch removed from -mm tree
Message-Id: <20230418231856.B0DB4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-mm-use-test_gen_progs-where-proper-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-test_gen_progs-where-proper-fix.patch

This patch was dropped because it was folded into selftests-mm-use-test_gen_progs-where-proper.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests-mm-use-test_gen_progs-where-proper-fix
Date: Sun, 16 Apr 2023 17:35:02 -0400

tools/testing/selftests/mm/Makefile: don't wipe out TEST_GEN_PROGS

Link: https://lkml.kernel.org/r/ZDxrvZh/cw357D8P@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-use-test_gen_progs-where-proper-fix
+++ a/tools/testing/selftests/mm/Makefile
@@ -42,7 +42,7 @@ TEST_GEN_PROGS += hugepage-mremap
 TEST_GEN_PROGS += hugepage-shm
 TEST_GEN_PROGS += hugepage-vmemmap
 TEST_GEN_PROGS += khugepaged
-TEST_GEN_PROGS = madv_populate
+TEST_GEN_PROGS += madv_populate
 TEST_GEN_PROGS += map_fixed_noreplace
 TEST_GEN_PROGS += map_hugetlb
 TEST_GEN_PROGS += map_populate
_

Patches currently in -mm which might be from peterx@redhat.com are

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
selftests-mm-uffd_register-fix.patch
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

