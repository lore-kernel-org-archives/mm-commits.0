Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AD1C4361B
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53DEB23A33
	for <mm-commits@archiver.kernel.org>; Fri, 11 Dec 2020 22:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395057AbgLKVVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Dec 2020 16:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395437AbgLKVVt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Dec 2020 16:21:49 -0500
Date:   Fri, 11 Dec 2020 13:21:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607721669;
        bh=S+HzrSsWMAFRxsMSBJJz412Np8z2dQjXHgXxUHlK9ok=;
        h=From:To:Subject:From;
        b=V5ekgxy++4443p4rRYBNZE2pP4kmKDZI6nt4nDv57NBA0vuuN41hA7ej5p6sht4uj
         0Np51YmlIVReRcxnKkLlLW7jca4gJc5Pg9eZHwLrHmptKHasHJoY10+fK+Pt8LIHXV
         jOjyQnT3Bql82zBrFABUCPE3lh2WR5Koy1NsuD3g=
From:   akpm@linux-foundation.org
To:     aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com,
        guangye.yang@mediatek.com, Kuan-Ying.Lee@mediatek.com,
        matthias.bgg@gmail.com, miles.chen@mediatek.com,
        mm-commits@vger.kernel.org, nicholas.tang@mediatek.com,
        qcai@redhat.com, qiang.zhang@windriver.com, sfr@canb.auug.org.au
Subject:  [folded-merged]
 kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix.patch removed
 from -mm tree
Message-ID: <20201211212107.Jz9OS_1HJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix slab double free when cpu-hotplug
has been removed from the -mm tree.  Its filename was
     kasan-fix-object-remaining-in-offline-per-cpu-quarantine-fix.patch

This patch was dropped because it was folded into kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch

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

kasan-fix-object-remain-in-offline-per-cpu-quarantine.patch

