Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304CDC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  4 Nov 2022 22:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiKDWqy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiKDWqW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Nov 2022 18:46:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF289121245
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 15:41:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D866B83016
        for <mm-commits@vger.kernel.org>; Fri,  4 Nov 2022 22:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18C4C433C1;
        Fri,  4 Nov 2022 22:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667601664;
        bh=rneBAy3Saa3bJXZ+5BdBu+beRxQxfufV42CQHxfj03E=;
        h=Date:To:From:Subject:From;
        b=PqWKGxzccQ1AEaaIN8WYBJFB7fkSR5sPOr+4Jz/Y7nRnNqMQE3cYGzWoYkgCrAsHH
         ycBfYiyvLp4w8v2tPzNIV8LeT5PjuZqUkdu8k/A7WJw0t8dmJrWKPT9CqDgOLv8FSu
         NZ2MloNLpwQKfiEWuFp8IPkbBCvRGR3XFanpg2EM=
Date:   Fri, 04 Nov 2022 15:41:03 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com,
        oliver.sang@intel.com, david@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-update-hugetlb-madvise.patch added to mm-unstable branch
Message-Id: <20221104224104.C18C4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: update hugetlb madvise
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-update-hugetlb-madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-update-hugetlb-madvise.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: selftests/vm: update hugetlb madvise
Date: Thu, 3 Nov 2022 18:16:32 -0700

Commit 8ebe0a5eaaeb ("mm,madvise,hugetlb: fix unexpected data loss with
MADV_DONTNEED on hugetlbfs") changed how the passed length was interpreted
for hugetlb mappings.  It was changed from align up to align down.  The
hugetlb-madvise test explicitly tests this behavior.  Change test to
expect new behavior.

Link: https://lkml.kernel.org/r/20221104011632.357049-1-mike.kravetz@oracle.com
Link: https://lore.kernel.org/oe-lkp/202211040619.2ec447d7-oliver.sang@intel.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/hugetlb-madvise.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/hugetlb-madvise.c~selftests-vm-update-hugetlb-madvise
+++ a/tools/testing/selftests/vm/hugetlb-madvise.c
@@ -195,7 +195,7 @@ int main(int argc, char **argv)
 			exit(1);
 	}
 
-	/* addr + length should be aligned up to huge page size */
+	/* addr + length should be aligned down to huge page size */
 	if (madvise(addr,
 			((NR_HUGE_PAGES - 1) * huge_page_size) + base_page_size,
 			MADV_DONTNEED)) {
@@ -203,10 +203,11 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	/* should free all pages in mapping */
-	validate_free_pages(free_hugepages);
+	/* should free all but last page in mapping */
+	validate_free_pages(free_hugepages - 1);
 
 	(void)munmap(addr, NR_HUGE_PAGES * huge_page_size);
+	validate_free_pages(free_hugepages);
 
 	/*
 	 * Test MADV_DONTNEED on anonymous private mapping
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch
selftests-vm-update-hugetlb-madvise.patch

