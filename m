Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD64C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbjHKXBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbjHKXA2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59D03C03
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EAFE67B71
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D623EC4339A;
        Fri, 11 Aug 2023 23:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794806;
        bh=s70CvCGDezAAlyG75oFeOYfsHkuKcWoPZgN/igtdG8I=;
        h=Date:To:From:Subject:From;
        b=HIRB6DCjKKCQU45jzEmv+j8DZzZQrWROxuopKAG/LDPQXsTrCpzS/i29R5MHKBIr+
         djqUBf0T36ZfMWZQjQsjBkM2Dme0hq1hdaTHdnU2IehvB9aSs4YCGdPA08uDfa2xUJ
         fc2wlzit06Kq5G1FtEvWBm981Xz0QrbQxrm/pRtk=
Date:   Fri, 11 Aug 2023 16:00:06 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch removed from -mm tree
Message-Id: <20230811230006.D623EC4339A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: ensure moving HWPoison flag to the raw error pages
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-ensure-moving-hwpoison-flag-to-the-raw-error-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1908,6 +1908,8 @@ void folio_clear_hugetlb_hwpoison(struct
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

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

