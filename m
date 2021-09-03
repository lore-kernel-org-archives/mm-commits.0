Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4ADC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663DE6113A
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhICVAx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350205AbhICVAt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FF18610FB;
        Fri,  3 Sep 2021 20:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702789;
        bh=5VVNm60kU0maT/dfR31vWP3HHApPLEeGJPK4DziQ2WE=;
        h=Date:From:To:Subject:From;
        b=KcJDGNl9XiZru6S8PlTQDO2/8rTbb8dqAMKu7pjoHPEnKuoKII73D31KEpUlwJsiR
         uGHTyS9JM3fNv1npZH4GRqaXl6Z5R29NauakaIYLXIGSb6jHn06F9IrpWRv3XXkbH4
         zovcHWiIAWDDOwq9v6Ym3qXXyDZiKzAweXTnF4+Q=
Date:   Fri, 03 Sep 2021 13:59:49 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com
Subject:  [merged]
 mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch removed from
 -mm tree
Message-ID: <20210903205949.DzlMlsPcL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: change argument struct page **hpagep to *hpage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-change-argument-struct-page-hpagep-to-hpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: change argument struct page **hpagep to *hpage

It's unnecessary to pass in a struct page **hpagep because it's never
modified.  Changing to use *hpage to simplify the code.

Link: https://lkml.kernel.org/r/20210814105131.48814-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-change-argument-struct-page-hpagep-to-hpage
+++ a/mm/memory-failure.c
@@ -1271,14 +1271,13 @@ static int get_hwpoison_page(struct page
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
 static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
-				  int flags, struct page **hpagep)
+				  int flags, struct page *hpage)
 {
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_SYNC;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	int kill = 1, forcekill;
-	struct page *hpage = *hpagep;
 	bool mlocked = PageMlocked(hpage);
 
 	/*
@@ -1503,7 +1502,7 @@ static int memory_failure_hugetlb(unsign
 		goto out;
 	}
 
-	if (!hwpoison_user_mappings(p, pfn, flags, &head)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
@@ -1783,7 +1782,7 @@ try_again:
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto unlock_page;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_allocc-avoid-accessing-uninitialized-pcp-page-migratetype.patch
mm-memory_hotplug-use-helper-zone_is_zone_device-to-simplify-the-code.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

