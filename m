Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE40C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE37619A7
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhCaEjY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhCaEjP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D272A6146B;
        Wed, 31 Mar 2021 04:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617165555;
        bh=NzpN9izDJW3PECgjL/h1opzfnLk4ZpWvCD33CwYT0Kc=;
        h=Date:From:To:Subject:From;
        b=WxvkOHouQyjD44JBw39+qB/awQGeLkX0hFqCGEB6BBBo8lAaMbc3Ww5szwLX6LHi0
         6ey5rhusPK3/L8Cq1ebkRiCypU3M0e9P58PYdT+sFr0ivPxOtrYWmffK9LWoaRWTTx
         wC1FbW6cMgj36UnfKiKlDoVmcmnhiDPcTOOgewVQ=
Date:   Tue, 30 Mar 2021 21:39:14 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  + kasan-fix-conflict-with-page-poisoning.patch added to
 -mm tree
Message-ID: <20210331043914.a9tdW93J6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix conflict with page poisoning
has been added to the -mm tree.  Its filename is
     kasan-fix-conflict-with-page-poisoning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-conflict-with-page-poisoning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-conflict-with-page-poisoning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix conflict with page poisoning

When page poisoning is enabled, it accesses memory that is marked as
poisoned by KASAN, which leas to false-positive KASAN reports.

Suppress the reports by adding KASAN annotations to unpoison_page()
(poison_page() already has them).

Link: https://lkml.kernel.org/r/2dc799014d31ac13fd97bd906bad33e16376fc67.1617118501.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_poison.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_poison.c~kasan-fix-conflict-with-page-poisoning
+++ a/mm/page_poison.c
@@ -77,12 +77,14 @@ static void unpoison_page(struct page *p
 	void *addr;
 
 	addr = kmap_atomic(page);
+	kasan_disable_current();
 	/*
 	 * Page poisoning when enabled poisons each and every page
 	 * that is freed to buddy. Thus no extra check is done to
 	 * see if a page was poisoned.
 	 */
-	check_poison_mem(addr, PAGE_SIZE);
+	check_poison_mem(kasan_reset_tag(addr), PAGE_SIZE);
+	kasan_enable_current();
 	kunmap_atomic(addr);
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-conflict-with-page-poisoning.patch
kasan-initialize-shadow-to-tag_invalid-for-sw_tags.patch
mm-kasan-dont-poison-boot-memory-with-tag-based-modes.patch
arm64-kasan-allow-to-init-memory-when-setting-tags.patch
kasan-init-memory-in-kasan_unpoison-for-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags.patch
kasan-mm-integrate-page_alloc-init-with-hw_tags-fix.patch
kasan-mm-integrate-slab-init_on_alloc-with-hw_tags.patch
kasan-mm-integrate-slab-init_on_free-with-hw_tags.patch
kasan-docs-clean-up-sections.patch
kasan-docs-update-overview-section.patch
kasan-docs-update-usage-section.patch
kasan-docs-update-error-reports-section.patch
kasan-docs-update-boot-parameters-section.patch
kasan-docs-update-generic-implementation-details-section.patch
kasan-docs-update-sw_tags-implementation-details-section.patch
kasan-docs-update-hw_tags-implementation-details-section.patch
kasan-docs-update-shadow-memory-section.patch
kasan-docs-update-ignoring-accesses-section.patch
kasan-docs-update-tests-section.patch

