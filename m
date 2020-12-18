Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD7BC2BBCF
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 03:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7429C23A57
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 03:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbgLRD3P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 22:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbgLRD3P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 22:29:15 -0500
Date:   Thu, 17 Dec 2020 19:28:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608262114;
        bh=TG1YjWmsfbvWFguWoDl5lgR2hikbRF1uw07yJ89ECDE=;
        h=From:To:Subject:From;
        b=rXS8E+qkyGeg5+JuGee0PptH0MNV7Xnqjkt3CMfuXhKp6VJ+feIzZ1q6DMlMka1R4
         YNlMdH/V5VGRT41XhCzL4YqAM18KK5UsJqFGJeGkt+rTfntnYJ0pnOaqIJ/TjBWbE1
         Zm1WC+YoqNqsuaV7Weqbi0FrZspAUjFf6O0XRSf4=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        matthias.bgg@gmail.com, glider@google.com, dvyukov@google.com,
        aryabinin@virtuozzo.com, Kuan-Ying.Lee@mediatek.com
Subject:  + kasan-fix-memory-leak-of-kasan-quarantine.patch added to
 -mm tree
Message-ID: <20201218032833.Ovslq%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix memory leak of kasan quarantine
has been added to the -mm tree.  Its filename is
     kasan-fix-memory-leak-of-kasan-quarantine.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-memory-leak-of-kasan-quarantine.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-memory-leak-of-kasan-quarantine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: kasan: fix memory leak of kasan quarantine

When cpu is going offline, set q->offline as true and interrupt happened. 
The interrupt may call the quarantine_put.  But quarantine_put do not free
the the object.  The object will cause memory leak.

Add qlink_free() to free the object.

Link: https://lkml.kernel.org/r/1608207487-30537-2-git-send-email-Kuan-Ying.Lee@mediatek.com
Fixes: 6c82d45c7f03 (kasan: fix object remaining in offline per-cpu quarantine)
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: <stable@vger.kernel.org>    [5.10-]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kasan/quarantine.c~kasan-fix-memory-leak-of-kasan-quarantine
+++ a/mm/kasan/quarantine.c
@@ -191,6 +191,7 @@ void quarantine_put(struct kasan_free_me
 
 	q = this_cpu_ptr(&cpu_quarantine);
 	if (q->offline) {
+		qlink_free(&info->quarantine_link, cache);
 		local_irq_restore(flags);
 		return;
 	}
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

kasan-fix-memory-leak-of-kasan-quarantine.patch

