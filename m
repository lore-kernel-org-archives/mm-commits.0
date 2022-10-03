Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3DCC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJCVJ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJCVHz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC9A4DF3D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F344B6118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532CAC433D7;
        Mon,  3 Oct 2022 21:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831165;
        bh=UysQ2erfHUz4s96vo5krNgwSO/uGzW5BdoUi+uTTSJ8=;
        h=Date:To:From:Subject:From;
        b=oNKSUbbWnHc5rTXkqiFJomIyO6cSbmkr+qhevx9ab/Xuna+9lu682DWsH9qlkvo7o
         9T18xo7U5L3WYQT3EKNA4Ss/ohP3xrWNdF/hFX77NoNdIf2Zy9ERU2oVODW35bJ3pX
         bjJJonjrT1hhCpisxgPLSGAC8j5YM1qxXk6ZKLmE=
Date:   Mon, 03 Oct 2022 14:06:04 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-only-define-metadata-offsets-for-generic-mode.patch removed from -mm tree
Message-Id: <20221003210605.532CAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: only define metadata offsets for Generic mode
has been removed from the -mm tree.  Its filename was
     kasan-only-define-metadata-offsets-for-generic-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: only define metadata offsets for Generic mode
Date: Mon, 5 Sep 2022 23:05:31 +0200

Hide the definitions of alloc_meta_offset and free_meta_offset under an
ifdef CONFIG_KASAN_GENERIC check, as these fields are now only used when
the Generic mode is enabled.

Link: https://lkml.kernel.org/r/d4bafa0534facafd1a23c465a94261e64f366493.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/kasan.h~kasan-only-define-metadata-offsets-for-generic-mode
+++ a/include/linux/kasan.h
@@ -98,8 +98,10 @@ static inline bool kasan_has_integrated_
 #ifdef CONFIG_KASAN
 
 struct kasan_cache {
+#ifdef CONFIG_KASAN_GENERIC
 	int alloc_meta_offset;
 	int free_meta_offset;
+#endif
 	bool is_kmalloc;
 };
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

