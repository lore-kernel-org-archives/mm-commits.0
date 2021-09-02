Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DA0C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1254610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347941AbhIBV71 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347950AbhIBV7Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CB4603E9;
        Thu,  2 Sep 2021 21:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619905;
        bh=T07HNwlAejENKSZx9bImdbeqcfvz2pbckPYVGh2LnDg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VbycZeBXvsZWITYrB1YvMsszADXAJRkSKrOfyg2r3SZdwoYQiovfhD1sURvhH2pxE
         oPpiMAzRSRF1MXydeM7ejT2ldHtB+x9Fas6/NZ0mM0t2dOU8TX3lNGMBGXytC3AK2P
         ZVAkZn0YotBkLtwTwdmXQGNCV6lDotsl9NmYjJE8=
Date:   Thu, 02 Sep 2021 14:58:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, torvalds@linux-foundation.org
Subject:  [patch 160/212] mm/hwpoison: change argument struct page
 **hpagep to *hpage
Message-ID: <20210902215825.-4aOtMaJQ%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
