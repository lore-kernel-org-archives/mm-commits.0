Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F55C43334
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 19:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiF0Tb6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 15:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236307AbiF0Tb5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 15:31:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A25C3A
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 12:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1D2E615C9
        for <mm-commits@vger.kernel.org>; Mon, 27 Jun 2022 19:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2763BC341CA;
        Mon, 27 Jun 2022 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656358315;
        bh=xrImyGVJrqlWCnN9e6gs+vkW+jwjH0U9LRy6MAsDHRY=;
        h=Date:To:From:Subject:From;
        b=mKufArvh7AztjMAgzuQjxXg655io0h6kxQzte0lzZsfTK6lsEqfAepj9bW3CZfF7i
         Wq6IzWb2ChsRz5y7sF+CIzyZcH3XHpgBOSLIvIoE60DpvEWep3XNEm8g/0ZLAVTVJh
         G74HTuFaLOlmYCEgyVWEZFserB4eVjL0bfUWX6S8=
Date:   Mon, 27 Jun 2022 12:31:54 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org, lkp@intel.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch removed from -mm tree
Message-Id: <20220627193155.2763BC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
Date: Fri, 3 Jun 2022 02:10:43 +0000

build fix

__get_huge_page_for_hwpoison() is not needed when CONFIG_HUGETLB_PAGE is
n, so extending "#ifdef CONFIG_HUGETLB_PAG" to cover
__get_huge_page_for_hwpoison() would be a simple resolution.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-hugetlb-introduce-subpage_index_hwpoison-to-save-raw-error-page-fix
+++ a/mm/memory-failure.c
@@ -1498,6 +1498,7 @@ static int try_to_split_thp_page(struct
 	return 0;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Called from hugetlb code with hugetlb_lock held.
  *
@@ -1546,7 +1547,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_HUGETLB_PAGE
 /*
  * Taking refcount of hugetlb pages needs extra care about race conditions
  * with basic operations like hugepage allocation/free/demotion.
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

