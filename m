Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD7DC04FE1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbjHKXBu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235234AbjHKXAf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6E23A8E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BE576556B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59C8C433C8;
        Fri, 11 Aug 2023 23:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794813;
        bh=Romg20cyq91DDy3p9FpRLC248W+XSzD/jlsNQuXtyuo=;
        h=Date:To:From:Subject:From;
        b=HXN/h2Roef6Edx5uxt2x/TNUic/3gJ1nbCrOBsmCaJ5qMQZglwGq0mVMQoHTL57z+
         vvV0xlMLqq6juM4+GnWSbNewpULiu8z5PUwB7a1QNN8ZDgKO0sZCyF+tIU8FwPmxmN
         B4ZqzLWGXyEzguznlET2c0GKgRVloQWmoRYOxXGA=
Date:   Fri, 11 Aug 2023 16:00:13 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch removed from -mm tree
Message-Id: <20230811230013.B59C8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: fix race window when trying to get hugetlb folio
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-race-window-when-trying-to-get-hugetlb-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

