Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128EDEB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 19:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjGKTIC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 15:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbjGKTH6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 15:07:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749D01705
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 12:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BC0D614CE
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 19:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6524BC433C7;
        Tue, 11 Jul 2023 19:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689102476;
        bh=8hPMgkmXu0kQ9w+s2/pgxWSuu72TfbPrMbwyeT44ChQ=;
        h=Date:To:From:Subject:From;
        b=MsjpcREddMVfntszcSguRifQtRlJghMQYg5JjNC6HlVMsWfk8BtMlzK4yrPzp4KKN
         1j7+9S00PANhQd4stAE+Yy6aKx3iEsRqqwTfcuhfUF3asZ12+y0iJgJOQmD3GcZ/yv
         O8E2OQvZ78XkFPGQUzETFIMt3xwBYsSSZ99tQtIQ=
Date:   Tue, 11 Jul 2023 12:07:55 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch added to mm-unstable branch
Message-Id: <20230711190756.6524BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: fix race window when trying to get hugetlb folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch

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
Subject: mm: memory-failure: fix race window when trying to get hugetlb folio
Date: Tue, 11 Jul 2023 13:50:16 +0800

page_folio() is fetched before calling get_hwpoison_hugetlb_folio()
without hugetlb_lock being held.  So hugetlb page could be demoted before
get_hwpoison_hugetlb_folio() holding hugetlb_lock but after page_folio()
is fetched.  So get_hwpoison_hugetlb_folio() will hold unexpected extra
refcnt of hugetlb folio while leaving demoted page un-refcnted.

Link: https://lkml.kernel.org/r/20230711055016.2286677-9-linmiaohe@huawei.com
Fixes: 25182f05ffed ("mm,hwpoison: fix race with hugetlb page allocation")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio
+++ a/mm/memory-failure.c
@@ -1383,8 +1383,15 @@ static int __get_hwpoison_page(struct pa
 	bool hugetlb = false;
 
 	ret = get_hwpoison_hugetlb_folio(folio, &hugetlb, false);
-	if (hugetlb)
-		return ret;
+	if (hugetlb) {
+		/* Make sure hugetlb demotion did not happen from under us. */
+		if (folio == page_folio(page))
+			return ret;
+		if (ret > 0) {
+			folio_put(folio);
+			folio = page_folio(page);
+		}
+	}
 
 	/*
 	 * This check prevents from calling folio_try_get() for any
@@ -1473,8 +1480,13 @@ static int __get_unpoison_page(struct pa
 	bool hugetlb = false;
 
 	ret = get_hwpoison_hugetlb_folio(folio, &hugetlb, true);
-	if (hugetlb)
-		return ret;
+	if (hugetlb) {
+		/* Make sure hugetlb demotion did not happen from under us. */
+		if (folio == page_folio(page))
+			return ret;
+		if (ret > 0)
+			folio_put(folio);
+	}
 
 	/*
 	 * PageHWPoisonTakenOff pages are not only marked as PG_hwpoison,
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

