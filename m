Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C79C7EE2A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 02:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbjFBCbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbjFBCbo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 22:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998D1193
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 19:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3227E64BBB
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 02:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3A2C433EF;
        Fri,  2 Jun 2023 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685673101;
        bh=n9YCvHpNHcf7obPo3ZGqeZSfdIvPLMgh4ooaS00Wj5Y=;
        h=Date:To:From:Subject:From;
        b=1wCSNarCbQW+Xj3C2zDWIFtF9sHONmwclENAl6tunHaKPbaZ3fC8GLEoHohQ4IKXW
         p9XHiZQkTXPVFZ/sQNfqut6HOa00GTjdNzPK8XVy4nTy31g/Oipw8lK3Vl4p09oq4P
         peK+m+9wETrr4qCk1bO8A2Ws8/RMn94GwnzDSe0Y=
Date:   Thu, 01 Jun 2023 19:31:40 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, hannes@cmpxchg.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch added to mm-unstable branch
Message-Id: <20230602023141.8C3A2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: fix unused variable warning in hugetlb-madvise.c
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: fix unused variable warning in hugetlb-madvise.c
Date: Thu, 1 Jun 2023 18:33:48 -0700

The dummy variable is required in order to make this work, so declare it
as volatile in order to avoid the clang compiler warning.

Link: https://lkml.kernel.org/r/20230602013358.900637-3-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb-madvise.c~selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec
+++ a/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -65,7 +65,7 @@ void write_fault_pages(void *addr, unsig
 
 void read_fault_pages(void *addr, unsigned long nr_pages)
 {
-	unsigned long dummy = 0;
+	volatile unsigned long dummy = 0;
 	unsigned long i;
 
 	for (i = 0; i < nr_pages; i++)
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-fix-uffd-stress-unused-function-warning.patch
selftests-mm-fix-unused-variable-warning-in-hugetlb-madvisec.patch
selftests-mm-fix-unused-variable-warning-in-migrationc.patch
selftests-mm-fix-a-char-assignment-in-mlock2-testsc.patch
selftests-mm-fix-invocation-of-tests-that-are-run-via-shell-scripts.patch
selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch
selftests-mm-set-wno-format-security-to-avoid-uffd-build-warnings.patch
selftests-mm-fix-a-possibly-uninitialized-warning-in-pkey-x86h.patch
selftests-mm-move-psize-pshift-into-vm_utilsc.patch
selftests-mm-move-uffd-routines-from-vm_utilc-to-uffd-commonc.patch
selftests-mm-fix-missing-uffdio_continue_mode_wp-and-similar-build-failures.patch
selftests-mm-fix-uffd-unit-testsc-build-failure-due-to-missing-madv_collapse.patch

