Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42929C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiKIB2H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKIB17 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:27:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A25657D7
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:27:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E651161808
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4617BC433D6;
        Wed,  9 Nov 2022 01:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957270;
        bh=6e6eVRFtMhQvzTFJ3iyP3N4jxjbD3JSCliEs0ajb+HI=;
        h=Date:To:From:Subject:From;
        b=UVvRr31LeeMzFIwh8wWdfo3J2dbA8W2SqCEXD7zinMYXSUWbSFoIixLxqXwce9rfJ
         Z4ZzYA1IFfyOQoyAjvGeB/HWiEy+UGBjwr4f6irrGsl7uFRV8A5JyeKhGQ/P6xOxgV
         EGh/mBNRYfojrqcQfucZM64wmYP4Sm9Ty60WOUTk=
Date:   Tue, 08 Nov 2022 17:27:49 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch removed from -mm tree
Message-Id: <20221109012750.4617BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix
has been removed from the -mm tree.  Its filename was
     selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch

This patch was dropped because it was folded into selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix
Date: Tue, 25 Oct 2022 09:07:49 +0200

s/size_t/ssize_t/ on `cur', `total', `transferred';

Link: https://lkml.kernel.org/r/51302b9e-dc69-d709-3214-f23868028555@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/anon_cow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/anon_cow.c~selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix
+++ a/tools/testing/selftests/vm/anon_cow.c
@@ -76,7 +76,7 @@ static int child_vmsplice_memcmp_fn(char
 		.iov_base = mem,
 		.iov_len = size,
 	};
-	size_t cur, total, transferred;
+	ssize_t cur, total, transferred;
 	char *old, *new;
 	int fds[2];
 	char buf;
@@ -172,7 +172,7 @@ static void do_test_vmsplice_in_parent(c
 		.iov_base = mem,
 		.iov_len = size,
 	};
-	size_t cur, total, transferred;
+	ssize_t cur, total, transferred;
 	struct comm_pipes comm_pipes;
 	char *old, *new;
 	int ret, fds[2];
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
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

