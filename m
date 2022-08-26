Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA50ECAAA3
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 01:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbiHZBW2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Aug 2022 21:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244311AbiHZBWY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2022 21:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0503C9936
        for <mm-commits@vger.kernel.org>; Thu, 25 Aug 2022 18:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CAB261DCC
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 01:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F1EC433D7;
        Fri, 26 Aug 2022 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661476938;
        bh=H6RjhLFPYKBf2ZT841dGLdr5smrPYwq1NWh2+axFJnU=;
        h=Date:To:From:Subject:From;
        b=nvZQsD5NaXdkzCmcZM8MPZZHRiN7DmlRCB+F3voCsSI21Z1AgEhAr6q4ewwoxnLBa
         5tWGIeEEBVr7bWQ5h0vTRhnKShoHWhUkbUXyy++B3awpxUyIYgLzAPu6jysNpzvod3
         3dzBgV9tHVw3S/WFIphxF8WtjqbSp45n9IVAOVmg=
Date:   Thu, 25 Aug 2022 18:22:17 -0700
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        naresh.kamboju@linaro.org, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-handle-truncate-racing-with-page-faults-fix.patch added to mm-unstable branch
Message-Id: <20220826012218.A1F1EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix/remove uninitialized variable in remove_inode_hugepages
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-handle-truncate-racing-with-page-faults-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-handle-truncate-racing-with-page-faults-fix.patch

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
Subject: hugetlb: fix/remove uninitialized variable in remove_inode_hugepages

Code introduced for the routine remove_inode_hugepages by patch "hugetlb:
handle truncate racing with page faults", incorrectly uses a variable
m_index.  This is a remnant from a previous version of the code when under
development.  Use the correct variable 'index' and remove 'm_index' from
the routine.

Link: https://lkml.kernel.org/r/Ywepr7C2X20ZvLdn@monkey
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-handle-truncate-racing-with-page-faults-fix
+++ a/fs/hugetlbfs/inode.c
@@ -537,7 +537,7 @@ static void remove_inode_hugepages(struc
 	const pgoff_t start = lstart >> huge_page_shift(h);
 	const pgoff_t end = lend >> huge_page_shift(h);
 	pgoff_t m_end = lm_end >> huge_page_shift(h);
-	pgoff_t m_start, m_index;
+	pgoff_t m_start;
 	struct folio_batch fbatch;
 	struct folio *folio;
 	pgoff_t next, index;
@@ -559,7 +559,7 @@ static void remove_inode_hugepages(struc
 			 * due to a race with fault code.
 			 */
 			freed += fault_lock_inode_indicies(h, inode, mapping,
-						m_start, m_index, truncate_op);
+						m_start, index, truncate_op);
 
 			/*
 			 * Remove folio that was part of folio_batch.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-handle-truncate-racing-with-page-faults.patch
hugetlb-handle-truncate-racing-with-page-faults-fix.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch

