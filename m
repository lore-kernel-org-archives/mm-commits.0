Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E609CDB485
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjJRVg4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8D618A
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B1EC116A8;
        Wed, 18 Oct 2023 21:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664925;
        bh=nMb5MpT393XpPZp3TAbBhMzVUgRWHQqWIo9AWRETd78=;
        h=Date:To:From:Subject:From;
        b=1zRE1EuoaR0NYSFiXzeNvpzKVDprD2L7Bumipdl4+0xwvJqQL61yPJ3xWN2lBJNSc
         dukkU5eRY16JsNYHAvFBqX3KfGGv3vr14D+MGaBkZVpE8t/RTrT5vyY/FXocD5wgpy
         QoXsZN8PjS6xC+glGytGgtsurI2SuTTTz+Z2148c=
Date:   Wed, 18 Oct 2023 14:35:24 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-kasan-update-comment-in-kasan_init.patch removed from -mm tree
Message-Id: <20231018213525.13B1EC116A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64, kasan: update comment in kasan_init
has been removed from the -mm tree.  Its filename was
     arm64-kasan-update-comment-in-kasan_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64, kasan: update comment in kasan_init
Date: Fri, 6 Oct 2023 17:18:42 +0200

Patch series "kasan: assorted fixes and improvements".


This patch (of 5):

Update the comment in kasan_init to also mention the Hardware Tag-Based
KASAN mode.

Link: https://lkml.kernel.org/r/cover.1696605143.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/4186aefd368b019eaf27c907c4fa692a89448d66.1696605143.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/kasan_init.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/kasan_init.c~arm64-kasan-update-comment-in-kasan_init
+++ a/arch/arm64/mm/kasan_init.c
@@ -300,7 +300,11 @@ void __init kasan_init(void)
 	kasan_init_shadow();
 	kasan_init_depth();
 #if defined(CONFIG_KASAN_GENERIC)
-	/* CONFIG_KASAN_SW_TAGS also requires kasan_init_sw_tags(). */
+	/*
+	 * Generic KASAN is now fully initialized.
+	 * Software and Hardware Tag-Based modes still require
+	 * kasan_init_sw_tags() and kasan_init_hw_tags() correspondingly.
+	 */
 	pr_info("KernelAddressSanitizer initialized (generic)\n");
 #endif
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are


