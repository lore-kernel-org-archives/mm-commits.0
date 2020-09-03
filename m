Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADFEC433E2
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43D8D208C7
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599168837;
	bh=1QG02/4Ffi7JdeMOzwQpqDa4LGwxQOTeC9r03RYnomk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WVhlAz9D/b0CCPmHkWaVdz5bb1EDTV30PKE4RkHS5XM//M/WdwrpsUIOc9fllyLdK
	 NbNTCMh5TOp8irhW0luau4geyY1NBre+9ExJrZM7Ip7PPfNRLWnruNMkUOpeYf69+B
	 jXZ5ispYN7KQdoNCikb2zF+UvWn/C+7G+g+TYtD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgICVd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgICVdy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:33:54 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9361D20797;
        Thu,  3 Sep 2020 21:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599168833;
        bh=1QG02/4Ffi7JdeMOzwQpqDa4LGwxQOTeC9r03RYnomk=;
        h=Date:From:To:Subject:From;
        b=RT+itvOyzi0ab0F89AzUV65K2a1ahEkP04EpgCES9wDvZunuQ4sHqUmbXBPIzHdma
         yng8sLTCTbtrXCfJr0srSY8JI4WmFZBp7U8pKqtQQo990tf4rI7E6tC7KU4XoXb57x
         l3jwf8/4I2+bwqMimqKOn5RuhNGC1qRx5g02FaeE=
Date:   Thu, 03 Sep 2020 14:33:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        osalvador@suse.com, naoya.horiguchi@nec.com, mhocko@kernel.org,
        osalvador@suse.de
Subject:  + mmhwpoison-refactor-madvise_inject_error.patch added to
 -mm tree
Message-ID: <20200903213353.GAp_c%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: refactor madvise_inject_error
has been added to the -mm tree.  Its filename is
     mmhwpoison-refactor-madvise_inject_error.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-refactor-madvise_inject_error.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-refactor-madvise_inject_error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: refactor madvise_inject_error

Make a proper if-else condition for {hard,soft}-offline.

Link: https://lkml.kernel.org/r/20200902094510.10727-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/mm/madvise.c~mmhwpoison-refactor-madvise_inject_error
+++ a/mm/madvise.c
@@ -869,7 +869,6 @@ static long madvise_remove(struct vm_are
 static int madvise_inject_error(int behavior,
 		unsigned long start, unsigned long end)
 {
-	struct page *page;
 	struct zone *zone;
 	unsigned long size;
 
@@ -879,6 +878,7 @@ static int madvise_inject_error(int beha
 
 	for (; start < end; start += size) {
 		unsigned long pfn;
+		struct page *page;
 		int ret;
 
 		ret = get_user_pages_fast(start, 1, 0, &page);
@@ -895,25 +895,21 @@ static int madvise_inject_error(int beha
 
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
-					pfn, start);
-
+				 pfn, start);
 			ret = soft_offline_page(pfn, MF_COUNT_INCREASED);
-			if (ret)
-				return ret;
-			continue;
+		} else {
+			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
+				 pfn, start);
+			/*
+			 * Drop the page reference taken by get_user_pages_fast(). In
+			 * the absence of MF_COUNT_INCREASED the memory_failure()
+			 * routine is responsible for pinning the page to prevent it
+			 * from being released back to the page allocator.
+			 */
+			put_page(page);
+			ret = memory_failure(pfn, 0);
 		}
 
-		pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
-				pfn, start);
-
-		/*
-		 * Drop the page reference taken by get_user_pages_fast(). In
-		 * the absence of MF_COUNT_INCREASED the memory_failure()
-		 * routine is responsible for pinning the page to prevent it
-		 * from being released back to the page allocator.
-		 */
-		put_page(page);
-		ret = memory_failure(pfn, 0);
 		if (ret)
 			return ret;
 	}
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch

