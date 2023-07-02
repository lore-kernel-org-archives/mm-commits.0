Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4894C04A6A
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 17:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjGBRnR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 13:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjGBRnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 13:43:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBCBE67
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 10:43:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36D8260C04
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 17:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A272C4AF6F;
        Sun,  2 Jul 2023 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688319784;
        bh=AP/Mqod3xRWSeXN5d6IcO0SYE7CZ0jVeWnz+qa/Xszg=;
        h=Date:To:From:Subject:From;
        b=okFj5ZgwFv6+CCPoII93nfa6bzK0E6505EizUDB7fueZ0bU5+lTzJUupn6v8CJmhE
         aJKLUQyGWRx500sblxNQ72JP/BQ4pjcuu7AbY8vnu3VDKmKCvQk6AxJjxaYRhitI6K
         U8lDwnWMoBIxu6gth8k0+XX9aM4liSa2GCPNxz7c=
Date:   Sun, 02 Jul 2023 10:43:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        sidhartha.kumar@oracle.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_rmapping.patch added to mm-unstable branch
Message-Id: <20230702174304.7A272C4AF6F@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove page_rmapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_rmapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_rmapping.patch

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
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: remove page_rmapping()
Date: Sat, 1 Jul 2023 11:28:53 +0800

After converting the last user to folio_raw_mapping(), we can safely
remove the function.

Link: https://lkml.kernel.org/r/20230701032853.258697-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/util.c          |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/mm.h~mm-remove-page_rmapping
+++ a/include/linux/mm.h
@@ -2151,7 +2151,6 @@ static inline void *folio_address(const
 	return page_address(&folio->page);
 }
 
-extern void *page_rmapping(struct page *page);
 extern pgoff_t __page_file_index(struct page *page);
 
 /*
--- a/mm/util.c~mm-remove-page_rmapping
+++ a/mm/util.c
@@ -734,12 +734,6 @@ void *vcalloc(size_t n, size_t size)
 }
 EXPORT_SYMBOL(vcalloc);
 
-/* Neutral page->mapping pointer to address_space or anon_vma or other */
-void *page_rmapping(struct page *page)
-{
-	return folio_raw_mapping(page_folio(page));
-}
-
 struct anon_vma *folio_anon_vma(struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch

