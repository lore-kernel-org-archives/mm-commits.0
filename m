Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80C7C63797
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbjALVcl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240566AbjALVcA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:32:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7480E3631D
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:16:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31775B81E63
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF570C433D2;
        Thu, 12 Jan 2023 21:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673558188;
        bh=Cp1t5h9+3ocIpM6DbOur5y8XRgY0ZE/hwnO2eJBoxMg=;
        h=Date:To:From:Subject:From;
        b=NU1yDQIPMt6d+JGEdWtrOoMl8it7Q0d9I9N6OZbQLNPTIqJOcA6uGkCRhPS9jx7Ye
         ppvwV/jDRjOxnPBIK3TD3p6N5AUsB+SASBQKFTgIZB8bgLD55JiqtgEqWlTk5+oClE
         lEUxL8/6a11lrveor7+FFbPPfN7Vbfo8O2sjwApw=
Date:   Thu, 12 Jan 2023 13:16:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch added to mm-unstable branch
Message-Id: <20230112211628.CF570C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: convert try_memory_failure_hugetlb() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/memory-failure: convert try_memory_failure_hugetlb() to folios
Date: Thu, 12 Jan 2023 14:46:02 -0600

Use a struct folio rather than a head page in try_memory_failure_hugetlb. 
This converts one user of SetHPageMigratable to the folio equivalent.

Link: https://lkml.kernel.org/r/20230112204608.80136-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios
+++ a/mm/memory-failure.c
@@ -1860,7 +1860,7 @@ static int try_memory_failure_hugetlb(un
 {
 	int res;
 	struct page *p = pfn_to_page(pfn);
-	struct page *head;
+	struct folio *folio;
 	unsigned long page_flags;
 	bool migratable_cleared = false;
 
@@ -1873,8 +1873,8 @@ retry:
 	} else if (res == -EHWPOISON) {
 		pr_err("%#lx: already hardware poisoned\n", pfn);
 		if (flags & MF_ACTION_REQUIRED) {
-			head = compound_head(p);
-			res = kill_accessing_process(current, page_to_pfn(head), flags);
+			folio = page_folio(p);
+			res = kill_accessing_process(current, folio_pfn(folio), flags);
 		}
 		return res;
 	} else if (res == -EBUSY) {
@@ -1885,16 +1885,16 @@ retry:
 		return action_result(pfn, MF_MSG_UNKNOWN, MF_IGNORED);
 	}
 
-	head = compound_head(p);
-	lock_page(head);
+	folio = page_folio(p);
+	folio_lock(folio);
 
 	if (hwpoison_filter(p)) {
-		hugetlb_clear_page_hwpoison(head);
+		hugetlb_clear_page_hwpoison(&folio->page);
 		if (migratable_cleared)
-			SetHPageMigratable(head);
-		unlock_page(head);
+			folio_set_hugetlb_migratable(folio);
+		folio_unlock(folio);
 		if (res == 1)
-			put_page(head);
+			folio_put(folio);
 		return -EOPNOTSUPP;
 	}
 
@@ -1903,7 +1903,7 @@ retry:
 	 * or demotion can be prevented by PageHWPoison flag.
 	 */
 	if (res == 0) {
-		unlock_page(head);
+		folio_unlock(folio);
 		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
@@ -1913,10 +1913,10 @@ retry:
 		return action_result(pfn, MF_MSG_FREE_HUGE, res);
 	}
 
-	page_flags = head->flags;
+	page_flags = folio->flags;
 
-	if (!hwpoison_user_mappings(p, pfn, flags, head)) {
-		unlock_page(head);
+	if (!hwpoison_user_mappings(p, pfn, flags, &folio->page)) {
+		folio_unlock(folio);
 		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 	}
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch

