Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85B7C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiILDcH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiILDaD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6C2F3A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 359DB61178
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89923C433C1;
        Mon, 12 Sep 2022 03:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953369;
        bh=dTWaz9b5wfsKK6XQqt2ekwyqJ4xM0KC+OHLQubLCCPc=;
        h=Date:To:From:Subject:From;
        b=jmmrdKQ5+lG5smKGpTJjNZ2bMb5L5LeefYhM8gQPYrSBweBUTtJLtJ1v55OENb4TB
         HO3ZC2Vi2whtK6gkioScJLu06Z9Xbzke91Sb3FZ9/9hw1/tDjP9tUohedeImMO9MiQ
         CwGOkIryaYnpbYr/Dt6mr7CjNzH2lURZhnAr+JPw=
Date:   Sun, 11 Sep 2022 20:29:28 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch removed from -mm tree
Message-Id: <20220912032929.89923C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: avoid trying to unpoison reserved page
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-avoid-trying-to-unpoison-reserved-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: avoid trying to unpoison reserved page
Date: Thu, 18 Aug 2022 21:00:16 +0800

For reserved pages, HWPoison flag will be set without increasing the page
refcnt.  So we shouldn't even try to unpoison these pages and thus
decrease the page refcnt unexpectly.  Add a PageReserved() check to filter
this case out and remove the below unneeded zero page (zero page is
reserved) check.

Link: https://lkml.kernel.org/r/20220818130016.45313-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-avoid-trying-to-unpoison-reserved-page
+++ a/mm/memory-failure.c
@@ -2351,7 +2351,7 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (PageSlab(page) || PageTable(page))
+	if (PageSlab(page) || PageTable(page) || PageReserved(page))
 		goto unlock_mutex;
 
 	ret = get_hwpoison_page(p, MF_UNPOISON);
@@ -2382,7 +2382,7 @@ int unpoison_memory(unsigned long pfn)
 		freeit = !!TestClearPageHWPoison(p);
 
 		put_page(page);
-		if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1)) {
+		if (freeit) {
 			put_page(page);
 			ret = 0;
 		}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

