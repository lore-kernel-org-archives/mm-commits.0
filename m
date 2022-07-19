Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79CCC43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 22:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiGSW7n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 18:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbiGSW7c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 18:59:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A99D62A5A
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 15:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E70BB81DAF
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 22:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007C2C341C6;
        Tue, 19 Jul 2022 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658271569;
        bh=94THp4gLpEoPmXtExArBAG87nA4ZpDD6Nzn318h/Ckg=;
        h=Date:To:From:Subject:From;
        b=BtYpnzhLfJqepyUWlaHpQ4SQWh4w/tjYc6atMBdxFd8ltA8v9uhGj6TyUS77FCTCI
         TmKXyC3VmV8FhaPWyPM7MX/1WBnkkZW5ayihPC4n3NlV9VUChrVHkAdGXHw2jEswta
         yV17R/g1qO88dP6QQkimACFRq2ETOzO3SwOmIU2c=
Date:   Tue, 19 Jul 2022 15:59:28 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-remove-unneeded-out-label.patch added to mm-unstable branch
Message-Id: <20220719225929.007C2C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: remove unneeded out label
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-remove-unneeded-out-label.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-remove-unneeded-out-label.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mempolicy: remove unneeded out label
Date: Tue, 19 Jul 2022 19:52:33 +0800

We can use unlock label to unlock ptl and return ret directly to remove
the unneeded out label and reduce the size of mempolicy.o.  No functional
change intended.

[Before]
   text	   data	    bss	    dec	    hex	filename
  26702	   3972	   6168	  36842	   8fea	mm/mempolicy.o

[After]
   text	   data	    bss	    dec	    hex	filename
  26662	   3972	   6168	  36802	   8fc2	mm/mempolicy.o

Link: https://lkml.kernel.org/r/20220719115233.6706-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-remove-unneeded-out-label
+++ a/mm/mempolicy.c
@@ -466,9 +466,8 @@ static int queue_pages_pmd(pmd_t *pmd, s
 	}
 	page = pmd_page(*pmd);
 	if (is_huge_zero_page(page)) {
-		spin_unlock(ptl);
 		walk->action = ACTION_CONTINUE;
-		goto out;
+		goto unlock;
 	}
 	if (!queue_pages_required(page, qp))
 		goto unlock;
@@ -485,7 +484,6 @@ static int queue_pages_pmd(pmd_t *pmd, s
 		ret = -EIO;
 unlock:
 	spin_unlock(ptl);
-out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch
mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch
mm-mempolicy-remove-unneeded-out-label.patch

