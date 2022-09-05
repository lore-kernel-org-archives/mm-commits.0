Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9D0C54EE9
	for <mm-commits@archiver.kernel.org>; Mon,  5 Sep 2022 22:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiIEWtH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Sep 2022 18:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiIEWsh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Sep 2022 18:48:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F8344576
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 15:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43FA7B815D5
        for <mm-commits@vger.kernel.org>; Mon,  5 Sep 2022 22:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D1BC433D7;
        Mon,  5 Sep 2022 22:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662418112;
        bh=ejUWWE1r18b1AdcY3jDzdrck1NLiMERvvfHBqeej9BM=;
        h=Date:To:From:Subject:From;
        b=mDr05oPq6znJdwnuUU1i9kvB2jYssaDJtc5D2lon4VgB1Qg756MLt3aKfRNjIniJo
         2msMzcH41IAi6/xLjaKbCxBH+h4idxFLbBHMyPPt9JFTORxi9YX6zqQB/WibcXJ/BR
         qIX+WU4WQM6Rt3II1lMFxZ+aj6qz10tBH2H6XwQ0=
Date:   Mon, 05 Sep 2022 15:48:31 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-kasan_addr_to_slab-in-print_address_description.patch added to mm-unstable branch
Message-Id: <20220905224832.01D1BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use kasan_addr_to_slab in print_address_description
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-use-kasan_addr_to_slab-in-print_address_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-use-kasan_addr_to_slab-in-print_address_description.patch

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
Subject: kasan: use kasan_addr_to_slab in print_address_description
Date: Mon, 5 Sep 2022 23:05:38 +0200

Use the kasan_addr_to_slab() helper in print_address_description() instead
of separately invoking PageSlab() and page_slab().

Link: https://lkml.kernel.org/r/8b744fbf8c3c7fc5d34329ec70b60ee5c8dba66c.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |    7 +++++++
 mm/kasan/report.c |   11 ++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/mm/kasan/common.c~kasan-use-kasan_addr_to_slab-in-print_address_description
+++ a/mm/kasan/common.c
@@ -30,6 +30,13 @@
 #include "kasan.h"
 #include "../slab.h"
 
+struct slab *kasan_addr_to_slab(const void *addr)
+{
+	if (virt_addr_valid(addr))
+		return virt_to_slab(addr);
+	return NULL;
+}
+
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
--- a/mm/kasan/report.c~kasan-use-kasan_addr_to_slab-in-print_address_description
+++ a/mm/kasan/report.c
@@ -213,13 +213,6 @@ struct page *kasan_addr_to_page(const vo
 	return NULL;
 }
 
-struct slab *kasan_addr_to_slab(const void *addr)
-{
-	if (virt_addr_valid(addr))
-		return virt_to_slab(addr);
-	return NULL;
-}
-
 static void describe_object_addr(struct kmem_cache *cache, void *object,
 				const void *addr)
 {
@@ -297,12 +290,12 @@ static inline bool init_task_stack_addr(
 static void print_address_description(void *addr, u8 tag)
 {
 	struct page *page = kasan_addr_to_page(addr);
+	struct slab *slab = kasan_addr_to_slab(addr);
 
 	dump_stack_lvl(KERN_ERR);
 	pr_err("\n");
 
-	if (page && PageSlab(page)) {
-		struct slab *slab = page_slab(page);
+	if (slab) {
 		struct kmem_cache *cache = slab->slab_cache;
 		void *object = nearest_obj(cache, slab,	addr);
 
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
kasan-support-kasanstacktrace-for-sw_tags.patch
kasan-dynamically-allocate-stack-ring-entries.patch
kasan-better-identify-bug-types-for-tag-based-modes.patch
kasan-add-another-use-after-free-test.patch
kasan-move-tests-to-mm-kasan.patch

