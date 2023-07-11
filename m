Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85266EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjGKTHx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjGKTHv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:07:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286B51710
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B38A3615A5
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C33C433C8;
        Tue, 11 Jul 2023 19:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102466;
        bh=iRkkX1j5a+8xqS5TlWKtodM8FZ50mTSzVxoy4gdDOGY=;
        h=Date:To:From:Subject:From;
        b=vxqTn8A+7UQRy94A/9Wf4luQipODZAvhKlWkE2dpOZye1AKv8Kfpo/kHzSlBXeieY
         r2ZAOmY7y3cwqkETLe3s3gei9CkvY9q6AGSYfdVWW7qaMMsBfhD7ngikOAICw0P/C8
         ZCcKzIg5tBtkNoJ897tmakUxNkqvfEJdGMWuehr4=
Date:   Tue, 11 Jul 2023 12:07:45 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch added to mm-unstable branch
Message-Id: <20230711190746.14C33C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: ensure moving HWPoison flag to the raw error pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch

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
Subject: mm: memory-failure: ensure moving HWPoison flag to the raw error pages
Date: Tue, 11 Jul 2023 13:50:10 +0800

If hugetlb_vmemmap_optimized is enabled, folio_clear_hugetlb_hwpoison()
called from try_memory_failure_hugetlb() won't transfer HWPoison flag to
subpages while folio's HWPoison flag is cleared.  So when trying to free
this hugetlb page into buddy, folio_clear_hugetlb_hwpoison() is not called
to move HWPoison flag from head page to the raw error pages even if now
hugetlb_vmemmap_optimized is cleared.  This will results in HWPoisoned
page being used again and raw_hwp_page leak.

Link: https://lkml.kernel.org/r/20230711055016.2286677-3-linmiaohe@huawei.com
Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages
+++ a/mm/memory-failure.c
@@ -1920,6 +1920,8 @@ void folio_clear_hugetlb_hwpoison(struct
 {
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
+	if (folio_test_hugetlb_vmemmap_optimized(folio))
+		return;
 	folio_clear_hwpoison(folio);
 	folio_free_raw_hwp(folio, true);
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
memory-tier-rename-destroy_memory_type-to-put_memory_type.patch
mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch
mm-memcg-minor-cleanup-for-mem_cgroup_id_max.patch
mm-memory-failure-remove-unneeded-pagehuge-check.patch
mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch
mm-memory-failure-dont-account-hwpoison_filter-filtered-pages.patch
mm-memory-failure-use-local-variable-huge-to-check-hugetlb-page.patch
mm-memory-failure-remove-unneeded-header-files.patch
mm-memory-failure-minor-cleanup-for-comments-and-codestyle.patch
mm-memory-failure-fetch-compound-head-after-extra-page-refcnt-is-held.patch
mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch

