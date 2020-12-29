Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4594CC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1743421D94
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgL2XPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:15:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgL2XPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F1E22287;
        Tue, 29 Dec 2020 23:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283687;
        bh=EUBUYzUVxiCfDEWYNoVbTWvr07q5l1xLhwxWpkqkpOY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=utBJoZy6Ql5YA1GEpxesMxbYOs6i0hXOYwiTuJlWnDD7n10B2fcDmTysdlPnHr4k3
         SKbZl0p4frVCxpHFekKNx7AlKt+EnrBy7XmFD3o37/QYZo6FUGZPhqa7Y7BIaAwuLg
         cdm7a8CxIC3FQCFmHO7e1bDetawaBvrBCy8ZxgOU=
Date:   Tue, 29 Dec 2020 15:14:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject:  [patch 09/16] kasan: fix null pointer dereference in
 kasan_record_aux_stack
Message-ID: <20201229231446.l1zpffxO9%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: fix null pointer dereference in kasan_record_aux_stack

Syzbot reported the following [1]:

 BUG: kernel NULL pointer dereference, address: 0000000000000008
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 2d993067 P4D 2d993067 PUD 19a3c067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP KASAN
 CPU: 1 PID: 3852 Comm: kworker/1:2 Not tainted 5.10.0-syzkaller #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 Workqueue: events free_ipc
 RIP: 0010:kasan_record_aux_stack+0x77/0xb0

Add null checking slab object from kasan_get_alloc_meta()
in order to avoid null pointer dereference.

[1] https://syzkaller.appspot.com/x/log.txt?x=10a82a50d00000

Link: https://lkml.kernel.org/r/20201228080018.23041-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/generic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kasan/generic.c~kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack
+++ a/mm/kasan/generic.c
@@ -337,6 +337,8 @@ void kasan_record_aux_stack(void *addr)
 	cache = page->slab_cache;
 	object = nearest_obj(cache, page, addr);
 	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return;
 
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
 	alloc_meta->aux_stack[0] = kasan_save_stack(GFP_NOWAIT);
_
