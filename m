Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F1DC0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 17:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjG0RMK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 13:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjG0RMH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 13:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2391E30ED
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 10:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAE8F61EF3
        for <mm-commits@vger.kernel.org>; Thu, 27 Jul 2023 17:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00799C433C8;
        Thu, 27 Jul 2023 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690477921;
        bh=2xcTdiCDCZffYVxy6TQ3xz8/9oDulzIMmAsI1u6rFnk=;
        h=Date:To:From:Subject:From;
        b=y5W7fsxfvYjdOORKfSVu+PmXc2uZw35boFhAf9OBExN0+yxdt7idBXZKV9mBI+u25
         tKh9EXavLnOlikGq94vAsUqkyY32IoullSr0fT8R7GnRTHPdiMi7p/XsHFTlFL0KCs
         hNbDC/B2OI0vgJGQqKGihL6NC6RAIrTpgcobvaNc=
Date:   Thu, 27 Jul 2023 10:11:59 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-use-helper-function-page_size.patch added to mm-unstable branch
Message-Id: <20230727171201.00799C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmsan: use helper function page_size()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmsan-use-helper-function-page_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-use-helper-function-page_size.patch

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
Subject: mm: kmsan: use helper function page_size()
Date: Thu, 27 Jul 2023 09:16:10 +0800

Patch series "minor cleanups for kmsan".

Use helper function and macros to improve code readability.  No functional
modification involved.


This patch (of 3):

Use function page_size() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230727011612.2721843-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230727011612.2721843-2-zhangpeng362@huawei.com
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

--- a/mm/kmsan/hooks.c~mm-kmsan-use-helper-function-page_size
+++ a/mm/kmsan/hooks.c
@@ -117,7 +117,7 @@ void kmsan_kfree_large(const void *ptr)
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
 	kmsan_internal_poison_memory((void *)ptr,
-				     PAGE_SIZE << compound_order(page),
+				     page_size(page),
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
--- a/mm/kmsan/shadow.c~mm-kmsan-use-helper-function-page_size
+++ a/mm/kmsan/shadow.c
@@ -210,7 +210,7 @@ void kmsan_free_page(struct page *page,
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page),
-				     PAGE_SIZE << compound_order(page),
+				     page_size(page),
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
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

