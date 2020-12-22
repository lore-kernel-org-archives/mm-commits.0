Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9B5C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E51023133
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgLVTFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 14:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgLVTFK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 14:05:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B7D123130;
        Tue, 22 Dec 2020 19:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608663869;
        bh=wiudhR4TUHqvEB059Rd0oktGGzHQF4uLW0rikpS6g2c=;
        h=Date:From:To:Subject:From;
        b=ZrnyKFbvbkWyuls84rbrCU0ZD+shgfAdB8xQEdJlk/bxqB1mGw0rHckfUFEEqDYF2
         d9UqnBGaiBJWjyA4Xf5uk4AhPItnu5WOPQLoZJjpqltxBCKpv2HoogJa1YBbU4RlPW
         MNyNUfZnJm9UTK97387h6A5DwftW0UOqcBGNjdm8=
Date:   Tue, 22 Dec 2020 11:04:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        matthias.bgg@gmail.com, glider@google.com, dvyukov@google.com,
        aryabinin@virtuozzo.com, Kuan-Ying.Lee@mediatek.com
Subject:  [to-be-updated]
 kasan-fix-memory-leak-of-kasan-quarantine.patch removed from -mm tree
Message-ID: <20201222190426.zM-LA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix memory leak of kasan quarantine
has been removed from the -mm tree.  Its filename was
     kasan-fix-memory-leak-of-kasan-quarantine.patch

This patch was dropped because an updated version will be merged

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
@@ -194,6 +194,7 @@ bool quarantine_put(struct kmem_cache *c
 
 	q = this_cpu_ptr(&cpu_quarantine);
 	if (q->offline) {
+		qlink_free(&info->quarantine_link, cache);
 		local_irq_restore(flags);
 		return false;
 	}
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


