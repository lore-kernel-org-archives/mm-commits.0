Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2294EE49B6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjHUUj3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjHUUjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E46129
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDC6D64A1B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41351C433C8;
        Mon, 21 Aug 2023 20:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650351;
        bh=o39iQE8Aw12S6jx7v9r4Y3P1kKBHkXdceMKKHzK9B5M=;
        h=Date:To:From:Subject:From;
        b=W9fB07JuRb5dBB7Fpk/AcMZIZvvfBIu0g90266D0yZ2l0JaL0ZLfHVWo+Tw9gUrSZ
         C4gNhf44ZskzadLWSCk/WM3hCgqTmKCbAvXlaAur+zREUb4J5aC3LnLURbWXiTCSjO
         uEuch5lf8Wre50uU2YEx0ILTbluFugxB6yTdotAQ=
Date:   Mon, 21 Aug 2023 13:39:10 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmsan-use-helper-macro-offset_in_page.patch removed from -mm tree
Message-Id: <20230821203911.41351C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmsan: use helper macro offset_in_page()
has been removed from the -mm tree.  Its filename was
     mm-kmsan-use-helper-macro-offset_in_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: kmsan: use helper macro offset_in_page()
Date: Thu, 27 Jul 2023 09:16:11 +0800

Use helper macro offset_in_page() to improve code readability.  No
functional modification involved.

Link: https://lkml.kernel.org/r/20230727011612.2721843-3-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
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


