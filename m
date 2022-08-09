Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35535C00140
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244802AbiHIBPM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244812AbiHIBOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58B31E3CD
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4260E61171
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96689C433D6;
        Tue,  9 Aug 2022 01:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007673;
        bh=J1xyreJgOsrxhHnc9cMHk3n3AZZoPUuoHXJ9nLutgaI=;
        h=Date:To:From:Subject:From;
        b=CQzoSWGK9EBq2awizCefC2wcggKztsyVvrvm08bf6+l/fEVMCMSp1Qo4s7IWVkihx
         wbmVMhR6CozIZ8oKagqxsOPgGsR0vNArpeSzh3SKy9usg+pfQwbUOdNGFoWNZOBOzy
         lji3K9p7C6f3PsUvZfiwh2BXmCc2GhZ9QDzHWmEQ=
Date:   Mon, 08 Aug 2022 18:14:30 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        lkp@intel.com, liushixin2@huawei.com, linmiaohe@huawei.com,
        david@redhat.com, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch removed from -mm tree
Message-Id: <20220809011433.96689C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: skip raw hwpoison page in freeing 1GB hugepage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: skip raw hwpoison page in freeing 1GB hugepage
Date: Thu, 14 Jul 2022 13:24:19 +0900

Currently if memory_failure() (modified to remove blocking code with
subsequent patch) is called on a page in some 1GB hugepage, memory error
handling fails and the raw error page gets into leaked state.  The impact
is small in production systems (just leaked single 4kB page), but this
limits the testability because unpoison doesn't work for it.  We can no
longer create 1GB hugepage on the 1GB physical address range with such
leaked pages, that's not useful when testing on small systems.

When a hwpoison page in a 1GB hugepage is handled, it's caught by the
PageHWPoison check in free_pages_prepare() because the 1GB hugepage is
broken down into raw error pages before coming to this point:

        if (unlikely(PageHWPoison(page)) && !order) {
                ...
                return false;
        }

Then, the page is not sent to buddy and the page refcount is left 0.

Originally this check is supposed to work when the error page is freed
from page_handle_poison() (that is called from soft-offline), but now we
are opening another path to call it, so the callers of
__page_handle_poison() need to handle the case by considering the return
value 0 as success.  Then page refcount for hwpoison is properly
incremented so unpoison works.

Link: https://lkml.kernel.org/r/20220714042420.1847125-8-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage
+++ a/mm/memory-failure.c
@@ -1084,7 +1084,6 @@ static int me_huge_page(struct page_stat
 		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
 		unlock_page(hpage);
 	} else {
-		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
 		 * migration entry prevents later access on error hugepage,
@@ -1092,9 +1091,11 @@ static int me_huge_page(struct page_stat
 		 * subpages.
 		 */
 		put_page(hpage);
-		if (__page_handle_poison(p) > 0) {
+		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
+		} else {
+			res = MF_FAILED;
 		}
 	}
 
@@ -1872,10 +1873,11 @@ retry:
 	 */
 	if (res == 0) {
 		unlock_page(head);
-		res = MF_FAILED;
-		if (__page_handle_poison(p) > 0) {
+		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
+		} else {
+			res = MF_FAILED;
 		}
 		action_result(pfn, MF_MSG_FREE_HUGE, res);
 		return res == MF_RECOVERED ? 0 : -EBUSY;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


