Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C48C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 092C4224B1
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbhAQU1X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbhAQU1V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 15:27:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66A1121D7F;
        Sun, 17 Jan 2021 20:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610915200;
        bh=klFJWte8QlGeKTYu3G3C7RWNSiP/HxzW2bIhmySeJgI=;
        h=Date:From:To:Subject:From;
        b=axn2FKB8B0spTMC1F2vnm79uf4eqYASTZ8cxkh7vtVHcNmTUWE5EB6ldqQ9Mwm1Yi
         OVe4O8UYFeN4p8Dc+5br0E23jcvTr5XhaiKtLVeu8iWGEVOF+HMx1eOzlwl/0q4Sbd
         +rY/eSdqSE7BY50GCvM+6d1h8WZRnSFX9rmAVUEc=
Date:   Sun, 17 Jan 2021 12:26:38 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        Branislav.Rankov@arm.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, eugenis@google.com,
        glider@google.com, kevin.brodsky@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, vbabka@suse.cz,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  + kasan-mm-fix-conflicts-with-init_on_alloc-free.patch
 added to -mm tree
Message-ID: <20210117202638.wb8CbdCca%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, mm: fix conflicts with init_on_alloc/free
has been added to the -mm tree.  Its filename is
     kasan-mm-fix-conflicts-with-init_on_alloc-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mm-fix-conflicts-with-init_on_alloc-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mm-fix-conflicts-with-init_on_alloc-free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, mm: fix conflicts with init_on_alloc/free

A few places where SLUB accesses object's data or metadata were missed in
a previous patch.  This leads to false positives with hardware tag-based
KASAN when bulk allocations are used with init_on_alloc/free.

Fix the false-positives by resetting pointer tags during these accesses.

(The kasan_reset_tag call is removed from slab_alloc_node, as it's added
 into maybe_wipe_obj_freeptr.)

Link: https://linux-review.googlesource.com/id/I50dd32838a666e173fe06c3c5c766f2c36aae901
Link: https://lkml.kernel.org/r/093428b5d2ca8b507f4a79f92f9929b35f7fada7.1610731872.git.andreyknvl@google.com
Fixes: aa1ef4d7b3f67 ("kasan, mm: reset tags when accessing metadata")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slub.c~kasan-mm-fix-conflicts-with-init_on_alloc-free
+++ a/mm/slub.c
@@ -2791,7 +2791,8 @@ static __always_inline void maybe_wipe_o
 						   void *obj)
 {
 	if (unlikely(slab_want_init_on_free(s)) && obj)
-		memset((void *)((char *)obj + s->offset), 0, sizeof(void *));
+		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
+			0, sizeof(void *));
 }
 
 /*
@@ -2883,7 +2884,7 @@ redo:
 		stat(s, ALLOC_FASTPATH);
 	}
 
-	maybe_wipe_obj_freeptr(s, kasan_reset_tag(object));
+	maybe_wipe_obj_freeptr(s, object);
 
 	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
 		memset(kasan_reset_tag(object), 0, s->object_size);
@@ -3329,7 +3330,7 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		int j;
 
 		for (j = 0; j < i; j++)
-			memset(p[j], 0, s->object_size);
+			memset(kasan_reset_tag(p[j]), 0, s->object_size);
 	}
 
 	/* memcg and kmem_cache debug support */
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-hw_tags-boot-parameters.patch
kasan-mm-fix-conflicts-with-init_on_alloc-free.patch
kasan-prefix-global-functions-with-kasan_.patch
kasan-clarify-hw_tags-impact-on-tbi.patch
kasan-clean-up-comments-in-tests.patch
kasan-add-macros-to-simplify-checking-test-constraints.patch
kasan-add-match-all-tag-tests.patch
kasan-arm64-allow-using-kunit-tests-with-hw_tags-mode.patch
kasan-rename-config_test_kasan_module.patch
kasan-add-compiler-barriers-to-kunit_expect_kasan_fail.patch
kasan-adapt-kmalloc_uaf2-test-to-hw_tags-mode.patch
kasan-fix-memory-corruption-in-kasan_bitops_tags-test.patch
kasan-move-_ret_ip_-to-inline-wrappers.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode.patch
kasan-add-proper-page-allocator-tests.patch
kasan-add-a-test-for-kmem_cache_alloc-free_bulk.patch
kasan-dont-run-tests-when-kasan-is-not-enabled.patch

