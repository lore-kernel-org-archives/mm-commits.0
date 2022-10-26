Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1FCC38A2D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 03:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiJZDHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 23:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiJZDHZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 23:07:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05653237E5
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 20:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB4E0B81FDF
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 03:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F8FC433C1;
        Wed, 26 Oct 2022 03:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666753641;
        bh=JjpSsv1dmXlvJJtRop+qaswzxdajL4VbYexPLHXRFIw=;
        h=Date:To:From:Subject:From;
        b=PUAojwthQOh2R9/q8yWtbsup3DuXWQ8yxc7+vVkjOHfZIHVIDafmEqhR9qVqYiOE/
         J4ECjcO0MdKfUtSOFJrZofatpMd++ZtM3Mo8PB5xWaQOMuYC8xEExhTlIffRDYI6T5
         TmuvgHB3BheuGJOGGPFKqFvunwYyoFer8yfnKNPU=
Date:   Tue, 25 Oct 2022 20:07:19 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shuah@kernel.org,
        rppt@kernel.org, peterx@redhat.com, namit@vmware.com,
        jhubbard@nvidia.com, jgg@nvidia.com, ddutile@redhat.com,
        crecklin@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-anon_cow-add-liburing-test-cases-fix.patch added to mm-unstable branch
Message-Id: <20221026030721.28F8FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-vm-anon_cow-add-liburing-test-cases-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-anon_cow-add-liburing-test-cases-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-anon_cow-add-liburing-test-cases-fix.patch

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
selftests-vm-anon_cow-add-liburing-test-cases-fix.patch
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

