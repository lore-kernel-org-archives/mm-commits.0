Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F13AEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjHUUja (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjHUUjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FB5130
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECB0364526
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C733C433C7;
        Mon, 21 Aug 2023 20:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650352;
        bh=j3ejBV0CRECPgEXXR5ABjc9aYaGU0OXG72DNmFWwt2I=;
        h=Date:To:From:Subject:From;
        b=W6Zv35LyGEUUOrTPxBY56x7fvhsWPnv93wqhCdt8n7DJk2YIFGK8OK2wbT7n+0NON
         G08o0JlQcZb7H8/ni3BIFD8hu2DwxMVa/93LJpOUc9YaYoNUlNz6/gk+wpB+8VswPT
         2aV+VA46dL8AL5BH0nHzFJ4/6wu6uo8p+fsJTD58=
Date:   Mon, 21 Aug 2023 13:39:11 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch removed from -mm tree
Message-Id: <20230821203912.4C733C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmsan: use helper macros PAGE_ALIGN and PAGE_ALIGN_DOWN
has been removed from the -mm tree.  Its filename was
     mm-kmsan-use-helper-macros-page_align-and-page_align_down.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: kmsan: use helper macros PAGE_ALIGN and PAGE_ALIGN_DOWN
Date: Thu, 27 Jul 2023 09:16:12 +0800

Use helper macros PAGE_ALIGN and PAGE_ALIGN_DOWN to improve code
readability.  No functional modification involved.

Link: https://lkml.kernel.org/r/20230727011612.2721843-4-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
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


