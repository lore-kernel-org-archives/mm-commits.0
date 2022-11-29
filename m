Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 540F0C4321E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 23:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiK2XFY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 18:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236885AbiK2XFW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 18:05:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2B666CAB
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 15:05:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56E65617EB
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 23:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A40C433D7;
        Tue, 29 Nov 2022 23:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669763119;
        bh=5d+AC10HGjurwcLvjjRuDN7MmSChQ3sf/OzMHifTEIQ=;
        h=Date:To:From:Subject:From;
        b=wR68SfBk4x5ONgjSRFBaEajz6evTZVYylDPjRBQvmgMzuWVEAJG2t/8vbpcGl6HZH
         pdMbw9w9On2R8dFyHJajzjU8Z0MQx9o55Sk937D+6CEVQ+z7UO5IRlxP1sUBHuWdSp
         E12stWAA/xrTtKE7qRf8H8qb7NHwrkuV5sHisFSg=
Date:   Tue, 29 Nov 2022 15:05:19 -0800
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch removed from -mm tree
Message-Id: <20221129230519.94A40C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix
has been removed from the -mm tree.  Its filename was
     kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch

This patch was dropped because it was folded into kasan-allow-sampling-page_alloc-allocations-for-hw_tags.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix
Date: Thu Oct 27 01:50:34 PM PDT 2022

fix build with CONFIG_KASAN=n

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/kasan.h~kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix
+++ a/include/linux/kasan.h
@@ -250,8 +250,8 @@ static __always_inline bool kasan_check_
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
-static inline void kasan_unpoison_pages(struct page *page, unsigned int order,
-					bool init) {}
+static inline bool kasan_unpoison_pages(struct page *page, unsigned int order,
+					bool init) { return false; }
 static inline void kasan_cache_create_kmalloc(struct kmem_cache *cache) {}
 static inline void kasan_poison_slab(struct slab *slab) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch
mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch
revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

