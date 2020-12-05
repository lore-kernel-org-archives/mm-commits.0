Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E30C433FE
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB3C22D74
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 01:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgLEBZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 20:25:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgLEBZj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 20:25:39 -0500
Date:   Fri, 04 Dec 2020 17:24:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607131499;
        bh=JCHLPfQhrKE7UoBc07URoH10CS5GOoZfq/CuvivUwK4=;
        h=From:To:Subject:From;
        b=Bx8TplHdrHeuDkhOEr1nAR/M3RaNbL7khaKiCX6al1hTP4EYIZkpowbisyNQ7qEZV
         CrohJ1x6ie1kXRmWC/lKcK96hBf3Hg7bUZBR/gI0W12Y6bNjRk18h4EfC1+n8yfvdm
         tp1l+lA7rXP2MsUxEBmm4UH5WXz1xlbLnaTwmS3M=
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        guangye.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        matthias.bgg@gmail.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, nicholas.tang@mediatek.com,
        qcai@redhat.com, qiang.zhang@windriver.com, sfr@canb.auug.org.au
Subject:  +
 kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix.patch added to
 -mm tree
Message-ID: <20201205012458.lap5_HTje%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix slab double free when cpu-hotplug
has been added to the -mm tree.  Its filename is
     kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zqiang <qiang.zhang@windriver.com>
Subject: kasan: fix slab double free when cpu-hotplug

When a CPU offline, the per-cpu quarantine's offline be set true, after
this, if the quarantine_put be called in this CPU, the objects will be
free and return false, free objects doesn't to be done, due to return
false, the slab memory manager will free this objects.

Link: https://lkml.kernel.org/r/20201204102206.20237-1-qiang.zhang@windriver.com
Fixes: 41ab1aae781f ("kasan: fix object remaining in offline per-cpu quarantine")
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Guangye Yang <guangye.yang@mediatek.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Nicholas Tang <nicholas.tang@mediatek.com>
Cc: Miles Chen <miles.chen@mediatek.com>
Cc: Qian Cai <qcai@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/kasan/quarantine.c~kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix
+++ a/mm/kasan/quarantine.c
@@ -191,7 +191,6 @@ void quarantine_put(struct kasan_free_me
 
 	q = this_cpu_ptr(&cpu_quarantine);
 	if (q->offline) {
-		qlink_free(&info->quarantine_link, cache);
 		local_irq_restore(flags);
 		return;
 	}
_

Patches currently in -mm which might be from qiang.zhang@windriver.com are

kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix.patch

