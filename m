Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF01C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiKIB23 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiKIB20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:28:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E557DD72
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:28:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DAAB5CE1D3C
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BA7C433C1;
        Wed,  9 Nov 2022 01:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957300;
        bh=KwJS698OUqX5/VHYhAJ0xwelcngi1BIBsAlzAt5S7Rw=;
        h=Date:To:From:Subject:From;
        b=nABVgfG57c6g9YWSQlMbJyTssUebt2LRP5iX1EdFVGFisQ/MKZxKG4kwh+m0YcsS6
         Kb25Gk69kZff5J+OJNRXlvK+W3QHaOUcFdEkkXC4iZVjtnUUbbU2/Vfb9NS4ZOgNpS
         qyLYkw9bqwMXFzaqbnoxUgnBRW9Qnk0jCo1MeHbU=
Date:   Tue, 08 Nov 2022 17:28:19 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-vm-anon_cow-add-liburing-test-cases-fix.patch removed from -mm tree
Message-Id: <20221109012820.08BA7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-vm-anon_cow-add-liburing-test-cases-fix
has been removed from the -mm tree.  Its filename was
     selftests-vm-anon_cow-add-liburing-test-cases-fix.patch

This patch was dropped because it was folded into selftests-vm-anon_cow-add-liburing-test-cases.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests-vm-anon_cow-add-liburing-test-cases-fix
Date: Tue, 25 Oct 2022 09:10:18 +0200

s/size_t/ssize_t/ on `cur', `total'.

Link: https://lkml.kernel.org/r/445fe1ae-9e22-0d1d-4d09-272231d2f84a@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph von Recklinghausen <crecklin@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/anon_cow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/anon_cow.c~selftests-vm-anon_cow-add-liburing-test-cases-fix
+++ a/tools/testing/selftests/vm/anon_cow.c
@@ -346,7 +346,7 @@ static void do_test_iouring(char *mem, s
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	struct io_uring ring;
-	size_t cur, total;
+	ssize_t cur, total;
 	struct iovec iov;
 	char *buf, *tmp;
 	int ret, fd;
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

