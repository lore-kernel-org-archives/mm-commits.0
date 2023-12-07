Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773DDC10F05
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441805AbjLGANS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441832AbjLGANN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0028FB2
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F85C433C9;
        Thu,  7 Dec 2023 00:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701907999;
        bh=9Gl8yYnygPeS7BsCcvm6fzKaTHUJXtlkXR2XJtQUeWo=;
        h=Date:To:From:Subject:From;
        b=g1KA0CBSb1cRkX/+NPkS4FNNCS7dp4U10go0nSbauFLVBbEPZKUGeEZeG/Cn9fjLg
         Fmc3k/1O19dp933QsQXiMrfcNgy+lBrAklP2BDm5VDw3i2RtHNpTVwCEo8Tdq2NulJ
         Jk8afrvK+2cki42Y4ZAfSXpABsS8xfWPad/xMJmA=
Date:   Wed, 06 Dec 2023 16:13:19 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        patrick.wang.shcn@gmail.com, geert+renesas@glider.be,
        catalin.marinas@arm.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-kmemleak-move-set_track_prepare-outside-raw_spinlocks.patch removed from -mm tree
Message-Id: <20231207001319.92F85C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak: move set_track_prepare() outside raw_spinlocks
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-move-set_track_prepare-outside-raw_spinlocks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch

