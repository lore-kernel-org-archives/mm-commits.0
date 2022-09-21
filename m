Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1FEC6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 19:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIUTls (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 15:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIUTlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 15:41:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B29A00D8
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 12:41:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64AA6B82346
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 19:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA266C433B5;
        Wed, 21 Sep 2022 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663789304;
        bh=p3JOwEtH+SUjPIYmDAxSgprk3bcgnuZPk+KVCQFK/qM=;
        h=Date:To:From:Subject:From;
        b=I9t/jWM8coYGoQ9Gbubz+Ft0Q1HZ4WlwVpvnpu76tLIuaQfnA50Hh3BRQkEDSNfz0
         MpraCwlG5yB4h20xupFUdblPEIJalyTKwQaixITZnnu/vR7/s8ysV0Hsakmspv9KIC
         QFc55ztWsVnNSZkaS06iivAs+2JQcVuD5ECl+riI=
Date:   Wed, 21 Sep 2022 12:41:42 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, elver@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-implement-stack-ring-for-tag-based-modes-fix.patch added to mm-unstable branch
Message-Id: <20220921194143.CA266C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: initialize read-write lock in stack ring
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-implement-stack-ring-for-tag-based-modes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-implement-stack-ring-for-tag-based-modes-fix.patch

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
Subject: kasan: initialize read-write lock in stack ring
Date: Tue, 20 Sep 2022 20:58:07 +0200

Use __RW_LOCK_UNLOCKED to initialize stack_ring.lock.

Link: https://lkml.kernel.org/r/576182d194e27531e8090bad809e4136953895f4.1663700262.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/tags.c~kasan-implement-stack-ring-for-tag-based-modes-fix
+++ a/mm/kasan/tags.c
@@ -22,7 +22,9 @@
 /* Non-zero, as initial pointer values are 0. */
 #define STACK_RING_BUSY_PTR ((void *)1)
 
-struct kasan_stack_ring stack_ring;
+struct kasan_stack_ring stack_ring = {
+	.lock = __RW_LOCK_UNLOCKED(stack_ring.lock)
+};
 
 static void save_stack_info(struct kmem_cache *cache, void *object,
 			gfp_t gfp_flags, bool is_free)
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-check-kasan_no_free_meta-in-__kasan_metadata_size.patch
kasan-rename-kasan_set__info-to-kasan_save__info.patch
kasan-move-is_kmalloc-check-out-of-save_alloc_info.patch
kasan-split-save_alloc_info-implementations.patch
kasan-drop-config_kasan_tags_identify.patch
kasan-introduce-kasan_print_aux_stacks.patch
kasan-introduce-kasan_get_alloc_track.patch
kasan-introduce-kasan_init_object_meta.patch
kasan-clear-metadata-functions-for-tag-based-modes.patch
kasan-move-kasan_get__meta-to-genericc.patch
kasan-introduce-kasan_requires_meta.patch
kasan-introduce-kasan_init_cache_meta.patch
kasan-drop-config_kasan_generic-check-from-kasan_init_cache_meta.patch
kasan-only-define-kasan_metadata_size-for-generic-mode.patch
kasan-only-define-kasan_never_merge-for-generic-mode.patch
kasan-only-define-metadata-offsets-for-generic-mode.patch
kasan-only-define-metadata-structs-for-generic-mode.patch
kasan-only-define-kasan_cache_create-for-generic-mode.patch
kasan-pass-tagged-pointers-to-kasan_save_alloc-free_info.patch
kasan-move-kasan_get_alloc-free_track-definitions.patch
kasan-cosmetic-changes-in-reportc.patch
kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch
kasan-use-kasan_addr_to_slab-in-print_address_description.patch
kasan-make-kasan_addr_to_page-static.patch
kasan-simplify-print_report.patch
kasan-introduce-complete_report_info.patch
kasan-fill-in-cache-and-object-in-complete_report_info.patch
kasan-rework-function-arguments-in-reportc.patch
kasan-introduce-kasan_complete_mode_report_info.patch
kasan-implement-stack-ring-for-tag-based-modes.patch
kasan-implement-stack-ring-for-tag-based-modes-fix.patch
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch
kasan-better-invalid-double-free-report-header.patch

