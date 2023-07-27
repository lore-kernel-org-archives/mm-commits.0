Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA88CC0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 17:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjG0RMV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjG0RMK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 13:12:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EA02727
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 10:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8073D61EEE
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 17:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FEFC433C8;
        Thu, 27 Jul 2023 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690477925;
        bh=Y+Hy06G8HntKtOWbB5ezlmmcRCiHVTfqPgtX+Lc58L8=;
        h=Date:To:From:Subject:From;
        b=TwcGdQmoiy+PZ4qT4PwPjyYAU3fWZZDtABtf1zwQmrT/7QESgR47OQAKWnd5khluu
         sXxQdPGQEUHgwzwfbXRtI4lQlqmAzDAicUPY5cBI8bxgw1dMB/ifGsSEcViz0WJVcA
         r9op5ZRLw2j53SoMKHUdACJa35meK4f302XZ6l9U=
Date:   Thu, 27 Jul 2023 10:12:03 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-use-helper-macro-offset_in_page.patch added to mm-unstable branch
Message-Id: <20230727171205.D3FEFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmsan: use helper macro offset_in_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmsan-use-helper-macro-offset_in_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-use-helper-macro-offset_in_page.patch

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
Subject: mm: kmsan: use helper macro offset_in_page()
Date: Thu, 27 Jul 2023 09:16:11 +0800

Use helper macro offset_in_page() to improve code readability.  No
functional modification involved.

Link: https://lkml.kernel.org/r/20230727011612.2721843-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marco Elver <elver@google.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c  |    2 +-
 mm/kmsan/shadow.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmsan/hooks.c~mm-kmsan-use-helper-macro-offset_in_page
+++ a/mm/kmsan/hooks.c
@@ -339,7 +339,7 @@ void kmsan_handle_dma(struct page *page,
 	 * internal KMSAN checks.
 	 */
 	while (size > 0) {
-		page_offset = addr % PAGE_SIZE;
+		page_offset = offset_in_page(addr);
 		to_go = min(PAGE_SIZE - page_offset, (u64)size);
 		kmsan_handle_dma_page((void *)addr, to_go, dir);
 		addr += to_go;
--- a/mm/kmsan/shadow.c~mm-kmsan-use-helper-macro-offset_in_page
+++ a/mm/kmsan/shadow.c
@@ -145,7 +145,7 @@ void *kmsan_get_metadata(void *address,
 		return NULL;
 	if (!page_has_metadata(page))
 		return NULL;
-	off = addr % PAGE_SIZE;
+	off = offset_in_page(addr);
 
 	return (is_origin ? origin_ptr_for(page) : shadow_ptr_for(page)) + off;
 }
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are

mm-use-a-folio-in-fault_dirty_shared_page.patch
mm-remove-page_rmapping.patch
mm-page_io-remove-unneeded-clearpageuptodate.patch
mm-page_io-remove-unneeded-setpageerror.patch
mm-page_io-introduce-bio_first_folio_all.patch
mm-page_io-use-a-folio-in-__end_swap_bio_write.patch
mm-page_io-use-a-folio-in-__end_swap_bio_read.patch
mm-page_io-use-a-folio-in-sio_read_complete.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_sync.patch
mm-page_io-use-a-folio-in-swap_writepage_bdev_async.patch
mm-page_io-convert-count_swpout_vm_event-to-take-in-a-folio.patch
mm-page_io-convert-bio_associate_blkg_from_page-to-take-in-a-folio.patch
mm-kmsan-use-helper-function-page_size.patch
mm-kmsan-use-helper-macro-offset_in_page.patch
mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch

