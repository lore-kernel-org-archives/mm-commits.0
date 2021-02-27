Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C9FC433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF7D664F32
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhB0CcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhB0Cbd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:31:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7275064F3A;
        Sat, 27 Feb 2021 02:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393077;
        bh=KFKgNo7LSba61lJthFONaV9dTYSqtJVTxxI+fZ0WzXA=;
        h=Date:From:To:Subject:From;
        b=JSZXtC9lPTEwQ52rMAtepXjHPpI08iaC8/iWQk/CHgUOYN8zx3qzoFqyb+HRLyLPs
         HZYp6Qu58Xiz7xIaf0h9qEixtulAk5p4xrDzM/f2Cv/T+O2x3kcMxZqQNTevSK0Li/
         SLP+cmLW/B5M1LzyO84khPYi/dxtWat+o4jbteCw=
Date:   Fri, 26 Feb 2021 18:31:17 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [merged]
 kasan-clean-up-setting-free-info-in-kasan_slab_free.patch removed from -mm
 tree
Message-ID: <20210227023117._P2mlJ6yk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: clean up setting free info in kasan_slab_free
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-setting-free-info-in-kasan_slab_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean up setting free info in kasan_slab_free

Put kasan_stack_collection_enabled() check and kasan_set_free_info() calls
next to each other.

The way this was previously implemented was a minor optimization that
relied of the the fact that kasan_stack_collection_enabled() is always
true for generic KASAN.  The confusion that this brings outweights saving
a few instructions.

Link: https://lkml.kernel.org/r/f838e249be5ab5810bf54a36ef5072cfd80e2da7.1612546384.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/kasan/common.c~kasan-clean-up-setting-free-info-in-kasan_slab_free
+++ a/mm/kasan/common.c
@@ -350,13 +350,11 @@ static bool ____kasan_slab_free(struct k
 
 	kasan_poison(object, cache->object_size, KASAN_KMALLOC_FREE);
 
-	if (!kasan_stack_collection_enabled())
-		return false;
-
 	if ((IS_ENABLED(CONFIG_KASAN_GENERIC) && !quarantine))
 		return false;
 
-	kasan_set_free_info(cache, object, tag);
+	if (kasan_stack_collection_enabled())
+		kasan_set_free_info(cache, object, tag);
 
 	return kasan_quarantine_put(cache, object);
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are


