Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E9EC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0265E223E4
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgLaSYG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgLaSYG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70EF12247F;
        Thu, 31 Dec 2020 18:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438982;
        bh=EmyRPTgVWPNo8fB4a8dKG5OurB+EtIu0qiQcquxIc74=;
        h=Date:From:To:Subject:From;
        b=X/6RtDsQ5dkTJDxiJ25nmyuKdBPwWuevHiBicmdW8a+AN2DxAj9sx6IXEK1O9iXIG
         NfAKTcAV2CMArkC0vvkDC8E30F4jBqVP4cNHUFf/w0LHs9+SkfeiFF4knFnBTb1JAI
         p9HE38q4GNbKFYo+lTYcYCtjgHvlPStPtJqTGYeQ=
Date:   Thu, 31 Dec 2020 10:23:02 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack.patch removed
 from -mm tree
Message-ID: <20201231182302.Wi-JaeNUS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix null pointer dereference in kasan_record_aux_stack
has been removed from the -mm tree.  Its filename was
     kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are


