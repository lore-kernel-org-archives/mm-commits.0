Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E57C004D4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 19:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbiHXTnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 15:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHXTnt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 15:43:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22975792DF
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 12:43:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5DE5B8261C
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 19:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8854AC433D6;
        Wed, 24 Aug 2022 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661370225;
        bh=ts3ghk6OBnWxlmFfii9Yw0TYTA8Lp5JtaTC2uRMKvnA=;
        h=Date:To:From:Subject:From;
        b=jjiZlroasfGyRByiSbtBjk8kQtvkxHgmDHsRMbm2sLPK+UFjrsbI5slsYCXLjznjM
         lPRX3CC0rmmDtQn7B1+SPpvS28sSwjr9apvfe2S1GH85Q7vduc4tkA4F/L+5RcU156
         SiIPlnr3ql2sFbr+iRO9SS+EUrXWSbozkHLDcJsI=
Date:   Wed, 24 Aug 2022 12:43:44 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-kill-procs-if-unmap-fails-v2.patch added to mm-unstable branch
Message-Id: <20220824194345.8854AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-kill-procs-if-unmap-fails-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-kill-procs-if-unmap-fails-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-kill-procs-if-unmap-fails-v2.patch

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
Subject: mm-hwpoison-kill-procs-if-unmap-fails-v2
Date: Tue, 23 Aug 2022 11:23:45 +0800

If try_to_unmap() fails, the hwpoisoned page still resides in the address
space of some processes. We should kill these processes or the hwpoisoned
page might be consumed later. collect_procs() is always called to collect
relevant processes now so they can be killed later if unmap fails.

Link: https://lkml.kernel.org/r/20220823032346.4260-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-kill-procs-if-unmap-fails-v2
+++ a/mm/memory-failure.c
@@ -1448,9 +1448,6 @@ static bool hwpoison_user_mappings(struc
 	 * First collect all the processes that have the page
 	 * mapped in dirty form.  This has to be done before try_to_unmap,
 	 * because ttu takes the rmap data structures down.
-	 *
-	 * Error handling: We ignore errors here because
-	 * there's nothing that can be done.
 	 */
 	collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch
mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch
mm-hugetlb-fix-warn_onkobj-in-sysfs_create_group.patch
mm-hugetlb-fix-missing-call-to-restore_reserve_on_error.patch
mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch
mm-hugetlb-fix-sysfs-group-leak-in-hugetlb_unregister_node.patch
mm-hugetlb-make-detecting-shared-pte-more-reliable.patch
mm-hwpoison-fix-page-refcnt-leaking-in-try_memory_failure_hugetlb.patch
mm-hwpoison-fix-page-refcnt-leaking-in-unpoison_memory.patch
mm-hwpoison-fix-extra-put_page-in-soft_offline_page.patch
mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch
mm-hwpoison-kill-procs-if-unmap-fails.patch
mm-hwpoison-kill-procs-if-unmap-fails-v2.patch
mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch

