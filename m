Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEBEC43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 18:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbiGMSfQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiGMSfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 14:35:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9F92ED40
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 11:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE47B82123
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 18:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FD4C34114;
        Wed, 13 Jul 2022 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657737311;
        bh=Zc9jMBcDPpuK7d0g9tK3iRokuo2RqEaEwcavwWzh56M=;
        h=Date:To:From:Subject:From;
        b=PJc3DbvodLaoSRuvSa5e+HnKHB6tOWADnacrVG7XSLCcZBQSalxilxfcRHvj3BT8A
         vKBQ/oR/t27S3yiVJYb7w+2BSNcoDBozLm5mMx8dy4G0MkyidZkyooBI8QAgGcC1Tg
         f17LA1JcRnh3wQAE9xnMRwNNupNsCbpjSIy6D3ok=
Date:   Wed, 13 Jul 2022 11:35:10 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        dan.carpenter@oracle.com, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch added to mm-unstable branch
Message-Id: <20220713183511.A9FD4C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: add missing kfree() to madvise_collapse()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: add missing kfree() to madvise_collapse()
Date: Wed, 13 Jul 2022 09:18:51 -0700

smatch warnings:
mm/khugepaged.c:2409 madvise_collapse() warn: possible memory leak of
'cc'

Link: https://lore.kernel.org/linux-mm/202207100715.TBIYQ4fc-lkp@intel.com/
Link: https://lore.kernel.org/linux-mm/20220713024109.62810-1-jrdr.linux@gmail.com/
Link: https://lkml.kernel.org/r/20220713161851.1879439-1-zokeefe@google.com
Fixes: 3f7416127072 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2
+++ a/mm/khugepaged.c
@@ -2468,6 +2468,7 @@ out_maybelock:
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);
+	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
 			: madvise_collapse_errno(last_fail);
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
proc-smaps-add-pmdmappable-field-to-smaps.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

