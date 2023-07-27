Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E03C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 17:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjG0RMa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjG0RMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 13:12:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122230F0
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 10:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2F6961EF7
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 17:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DF6C433CA;
        Thu, 27 Jul 2023 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690477929;
        bh=+LwJJNoVH5Wws2n8KtqjNpUwA2kD7pSkuqd9kZY0+XI=;
        h=Date:To:From:Subject:From;
        b=yP/5mYLCn9NXnucydmBHBRBureZ2XNiWjnW0V0lmqDxJUPEwDTUBmUArKlw9i1+E7
         6Vat0MYp3DJQrHgloK4+KRMqgi1Z8C61O3yfmuSh4Vrq/qT6karhmPxZXWeXaiAnn0
         OlQayJPVIShOsVb6eazufjKHe/IqAUcaw1lf469Q=
Date:   Thu, 27 Jul 2023 10:12:08 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch added to mm-unstable branch
Message-Id: <20230727171209.21DF6C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmsan: use helper macros PAGE_ALIGN and PAGE_ALIGN_DOWN
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch

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
Subject: mm: kmsan: use helper macros PAGE_ALIGN and PAGE_ALIGN_DOWN
Date: Thu, 27 Jul 2023 09:16:12 +0800

Use helper macros PAGE_ALIGN and PAGE_ALIGN_DOWN to improve code
readability.  No functional modification involved.

Link: https://lkml.kernel.org/r/20230727011612.2721843-4-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marco Elver <elver@google.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/shadow.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmsan/shadow.c~mm-kmsan-use-helper-macros-page_align-and-page_align_down
+++ a/mm/kmsan/shadow.c
@@ -281,8 +281,8 @@ void __init kmsan_init_alloc_meta_for_ra
 	struct page *page;
 	u64 size;
 
-	start = (void *)ALIGN_DOWN((u64)start, PAGE_SIZE);
-	size = ALIGN((u64)end - (u64)start, PAGE_SIZE);
+	start = (void *)PAGE_ALIGN_DOWN((u64)start);
+	size = PAGE_ALIGN((u64)end - (u64)start);
 	shadow = memblock_alloc(size, PAGE_SIZE);
 	origin = memblock_alloc(size, PAGE_SIZE);
 	for (u64 addr = 0; addr < size; addr += PAGE_SIZE) {
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

