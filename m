Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1261C25B0E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 05:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243011AbiHSFEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiHSFEd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 01:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EB6564F5
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 22:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D9DD6156C
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 05:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00929C433C1;
        Fri, 19 Aug 2022 05:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660885471;
        bh=ZIftZ6CmXizqiQZ+D2GfMUx3veo+Hn7og7cl6CAqLKY=;
        h=Date:To:From:Subject:From;
        b=G4bGR4Ba/RZKbrO4l/oeJ8pGO9QIl0vSk7YjM0NSHUe1hHLeUuVAvCUUuGzBzIyBt
         P87Yg9lKGIrn65bRAqvn4NgkykQte/FcwM5vAbFU1MtgveH4l5dwvaTV7UzP9YWy88
         PPvVouzU+TcVCjTruCqLHb/D/LWCoFn2c9Qts2Sk=
Date:   Thu, 18 Aug 2022 22:04:30 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-kill-soft_offline_free_page.patch added to mm-unstable branch
Message-Id: <20220819050431.00929C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory-failure: kill soft_offline_free_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-kill-soft_offline_free_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-kill-soft_offline_free_page.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: kill soft_offline_free_page()
Date: Fri, 19 Aug 2022 11:34:01 +0800

Open-code the page_handle_poison() into soft_offline_page() and kill
unneeded soft_offline_free_page().

Link: https://lkml.kernel.org/r/20220819033402.156519-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-kill-soft_offline_free_page
+++ a/mm/memory-failure.c
@@ -2515,16 +2515,6 @@ static int soft_offline_in_use_page(stru
 	return __soft_offline_page(page);
 }
 
-static int soft_offline_free_page(struct page *page)
-{
-	int rc = 0;
-
-	if (!page_handle_poison(page, true, false))
-		rc = -EBUSY;
-
-	return rc;
-}
-
 static void put_ref_page(struct page *page)
 {
 	if (page)
@@ -2600,7 +2590,7 @@ retry:
 	if (ret > 0) {
 		ret = soft_offline_in_use_page(page);
 	} else if (ret == 0) {
-		if (soft_offline_free_page(page) && try_again) {
+		if (!page_handle_poison(page, true, false) && try_again) {
 			try_again = false;
 			flags &= ~MF_COUNT_INCREASED;
 			goto retry;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-failure-cleanup-try_to_split_thp_page.patch
mm-add-warning-if-__vm_enough_memory-fails.patch
mm-kill-find_min_pfn_with_active_regions.patch
mm-memory-failure-kill-soft_offline_free_page.patch
mm-memory-failure-kill-__soft_offline_page.patch

