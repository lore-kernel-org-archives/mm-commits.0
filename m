Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A68C38A2D
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 03:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiJZDKK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 23:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiJZDKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 23:10:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA76515738
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 20:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FC5161C41
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 03:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D58C433C1;
        Wed, 26 Oct 2022 03:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666753805;
        bh=0L4P1At9RUskmGRguXd+WM0s483w9SxbG5Z/N6si26Y=;
        h=Date:To:From:Subject:From;
        b=uyWlu7avnEJirTQ3tvszJTlq55MIYdYrYejvB0i9thS4PuvQciL3rzvo1UxFQGtxe
         CMASzd1kTdBar3wwPFUGiPCiAw2faW/A7wGPl4g0mLLbHltS7S1YRZjsTnqSqaXu2/
         P90ZI85OPihUA3ng+39qbQmXc8WNMjmBzxNYpFYg=
Date:   Tue, 25 Oct 2022 20:10:04 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch added to mm-unstable branch
Message-Id: <20221026031005.41D58C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch

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
Subject: selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix
Date: Tue, 25 Oct 2022 09:07:49 +0200

s/size_t/ssize_t/ on `cur', `total', `transferred';

Link: https://lkml.kernel.org/r/51302b9e-dc69-d709-3214-f23868028555@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch
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

