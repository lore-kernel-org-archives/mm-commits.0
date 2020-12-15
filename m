Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A72CC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F7820782
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgLOCTF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgLOCS6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:18:58 -0500
Date:   Mon, 14 Dec 2020 18:18:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998697;
        bh=WkE0oIAxg79lPIOc/eM2+9oH4HvwBjFMtMPmMjmeFc8=;
        h=From:To:Subject:From;
        b=Gw1CY+jwUJ57NRHHQHHzoPvP+ZxiQzIJDHcFDgvDQCw+k21pqHVYfZat3T1u/o8ns
         krJkq/dzTHHQYNN81NwfAdoK0sFtvZKBbHWTzVcCe/QwPAVBi6Yhp7EbRfgIABjYsm
         +3IAUexDEnNtX6JGKgJbVhR3UOV7uifchy7aqWuE=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  [folded-merged]
 mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
 removed from -mm tree
Message-ID: <20201215021817.aSEK8r2Wm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: take free pages off the buddy freelists for hugetlb
has been removed from the -mm tree.  Its filename was
     mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch

This patch was dropped because it was folded into mmhwpoison-take-free-pages-off-the-buddy-freelists.patch

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: take free pages off the buddy freelists for hugetlb

Currently, free hugetlb get dissolved, but we also need to make sure to
take the poisoned subpage off the buddy frelists, so no one stumbles upon
it (see previous patch for more information).

Link: https://lkml.kernel.org/r/20201013144447.6706-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb
+++ a/mm/memory-failure.c
@@ -809,7 +809,7 @@ static int me_swapcache_clean(struct pag
  */
 static int me_huge_page(struct page *p, unsigned long pfn)
 {
-	int res = 0;
+	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
 
@@ -820,6 +820,7 @@ static int me_huge_page(struct page *p,
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
 	} else {
+		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
 		 * migration entry prevents later access on error anonymous
@@ -828,8 +829,10 @@ static int me_huge_page(struct page *p,
 		 */
 		if (PageAnon(hpage))
 			put_page(hpage);
-		dissolve_free_huge_page(p);
-		res = MF_RECOVERED;
+		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
+		}
 		lock_page(hpage);
 	}
 
@@ -1196,9 +1199,13 @@ static int memory_failure_hugetlb(unsign
 			}
 		}
 		unlock_page(head);
-		dissolve_free_huge_page(p);
-		action_result(pfn, MF_MSG_FREE_HUGE, MF_DELAYED);
-		return 0;
+		res = MF_FAILED;
+		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
+		}
+		action_result(pfn, MF_MSG_FREE_HUGE, res);
+		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
 	lock_page(head);
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-refactor-get_any_page.patch
mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch
mmhwpoison-remove-drain_all_pages-from-shake_page.patch
mmmemory_failure-always-pin-the-page-in-madvise_inject_error.patch
mmhwpoison-return-ebusy-when-migration-fails.patch
mmhugetlb-remove-unneded-initialization.patch

