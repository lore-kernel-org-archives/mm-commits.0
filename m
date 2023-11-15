Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC39C2BB3F
	for <mm-commits@archiver.kernel.org>; Wed, 15 Nov 2023 22:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbjKOWSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 17:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234678AbjKOWSW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 17:18:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14494195
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 14:18:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB17C433C9;
        Wed, 15 Nov 2023 22:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700086698;
        bh=18kOx6b+lX89W8Uy9vaMEGQsnVOk5oNB6SJ6L2o3KJY=;
        h=Date:To:From:Subject:From;
        b=ndUmoHK1sUS2azZmZGzXAz+P7Wu/MKfJZklMB9c5PVmcOWU2qoUviyW1U7y6rVYYM
         wgBg3mOS6rW5mfbux8yZypxY2ZmZ+fS+C2TcCPTLsHnF3UJu2Its528qSl3pbb+qwX
         qnOriZvx02aL5gLsOl34y7bdw0D3Dlzkdy5ZeWmg=
Date:   Wed, 15 Nov 2023 14:18:17 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, geert+renesas@glider.be,
        catalin.marinas@arm.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-move-set_track_prepare-outside-raw_spinlocks.patch added to mm-hotfixes-unstable branch
Message-Id: <20231115221818.8AB17C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak: move set_track_prepare() outside raw_spinlocks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmemleak-move-set_track_prepare-outside-raw_spinlocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-move-set_track_prepare-outside-raw_spinlocks.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/kmemleak: move set_track_prepare() outside raw_spinlocks
Date: Wed, 15 Nov 2023 16:21:38 +0800

set_track_prepare() will call __alloc_pages() which attempts to acquire
zone->lock(spinlocks), so move it outside object->lock(raw_spinlocks)
because it's not right to acquire spinlocks while holding raw_spinlocks in
RT mode.

Link: https://lkml.kernel.org/r/20231115082138.2649870-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Patrick Wang <patrick.wang.shcn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-move-set_track_prepare-outside-raw_spinlocks
+++ a/mm/kmemleak.c
@@ -1152,6 +1152,7 @@ EXPORT_SYMBOL_GPL(kmemleak_free_percpu);
 void __ref kmemleak_update_trace(const void *ptr)
 {
 	struct kmemleak_object *object;
+	depot_stack_handle_t trace_handle;
 	unsigned long flags;
 
 	pr_debug("%s(0x%px)\n", __func__, ptr);
@@ -1168,8 +1169,9 @@ void __ref kmemleak_update_trace(const v
 		return;
 	}
 
+	trace_handle = set_track_prepare();
 	raw_spin_lock_irqsave(&object->lock, flags);
-	object->trace_handle = set_track_prepare();
+	object->trace_handle = trace_handle;
 	raw_spin_unlock_irqrestore(&object->lock, flags);
 
 	put_object(object);
_

Patches currently in -mm which might be from liushixin2@huawei.com are

revert-mm-kmemleak-move-the-initialisation-of-object-to-__link_object.patch
mm-kmemleak-move-set_track_prepare-outside-raw_spinlocks.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

