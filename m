Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C502E94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbjJFTR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjJFTR6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:17:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8149783
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:17:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A51C433C7;
        Fri,  6 Oct 2023 19:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619873;
        bh=lvJod7apmT76K0Jx4TzDxuH9hSRbcKCDyJetl55l+XU=;
        h=Date:To:From:Subject:From;
        b=DNdpb3Fn/JvBcfkzRg68LeS27qroxsKm+b03Al2SxGiewVRNm0qiFhnMOcfBoBSR7
         1UI/QKxwvLNNEF8jnd1G0kN4eZEqtzGwvAtjoIU1Is8WmJcQUU7tRrmddJ5SvXrRxo
         T4VgUjmO5T3SswQQSOB8MKfFS3TK6idLqulsI1VM=
Date:   Fri, 06 Oct 2023 12:17:51 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-kasan-update-comment-in-kasan_init.patch added to mm-unstable branch
Message-Id: <20231006191753.73A51C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64, kasan: update comment in kasan_init
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-kasan-update-comment-in-kasan_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-kasan-update-comment-in-kasan_init.patch

This patch will later appear in the mm-unstable branch at
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

arm64-kasan-update-comment-in-kasan_init.patch
kasan-unify-printk-prefixes.patch
kasan-use-unchecked-__memset-internally.patch
kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch
documentation-san-drop-the-from-article-titles.patch

