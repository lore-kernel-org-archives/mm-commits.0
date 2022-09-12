Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C60ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiILDcV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiILDa0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE772653
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A0956116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE82DC433D7;
        Mon, 12 Sep 2022 03:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953372;
        bh=VvwTKwJYf3DWAlwxF4TfNsss7Q+qZOzzuSWvndmC3qI=;
        h=Date:To:From:Subject:From;
        b=dqjnfNLpLM+mkJ7X1mjbo8Ptm5J4uJe8hI4mpbbamTqIcSLgbxCo3cDEMr4ZnygTQ
         WX8XDT1hd4Mgi4gIgmS0BSY4G5qH6DhwkmQo9DX6fGp/mKegYeBzT/ljIqe81RCsuf
         0o8GhXtMZlgxWdCXPq5m3vKrSAP5JAaz1fk2YItw=
Date:   Sun, 11 Sep 2022 20:29:31 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-kill-soft_offline_free_page.patch removed from -mm tree
Message-Id: <20220912032931.DE82DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: kill soft_offline_free_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-kill-soft_offline_free_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: kill soft_offline_free_page()
Date: Fri, 19 Aug 2022 11:34:01 +0800

Open-code the page_handle_poison() into soft_offline_page() and kill
unneeded soft_offline_free_page().

Link: https://lkml.kernel.org/r/20220819033402.156519-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-kill-soft_offline_free_page
+++ a/mm/memory-failure.c
@@ -2511,16 +2511,6 @@ static int soft_offline_in_use_page(stru
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
@@ -2596,7 +2586,7 @@ retry:
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

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch
kernel-exit-cleanup-release_thread.patch

