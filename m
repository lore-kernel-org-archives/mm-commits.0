Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8736DC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F36D21D1B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 21:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgL2VB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 16:01:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgL2VB7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 16:01:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA3A121D1B;
        Tue, 29 Dec 2020 21:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609275678;
        bh=flpeRGdt2BPGOeJm6C/KTRFdqmPOq6cMFwhMa7EpLnY=;
        h=Date:From:To:Subject:From;
        b=WePEtubsic3XRqxsA4e+UuflRCzHkTDdc8DAbo6nZTaHnQPdHUMuMuTJFNy+4++1K
         UwkS2IfyyNSfrz9K82IJxX2CgmHtHAqxEnTX7ft3yLh872ZyxrEIvWAj9Z8HexDPVo
         ZzOcbvgQvgDzSux5BxdqBc32m1L770YSgTkCyJV0=
Date:   Tue, 29 Dec 2020 13:01:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, glider@google.com, dvyukov@google.com,
        aryabinin@virtuozzo.com, andreyknvl@google.com,
        walter-zh.wu@mediatek.com
Subject:  +
 kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack.patch added to
 -mm tree
Message-ID: <20201229210116.fk6NS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix null pointer dereference in kasan_record_aux_stack
has been added to the -mm tree.  Its filename is
     kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-fix-null-pointer-dereference-in-kasan_record_aux_stack.patch

