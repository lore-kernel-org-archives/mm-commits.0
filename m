Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7F4FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 21:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbiJ0VBb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbiJ0VA6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 17:00:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97A0D03B6
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:52:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 731B5B8276A
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C2AC433D6;
        Thu, 27 Oct 2022 20:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666903960;
        bh=US9VimYn1yZ4VwccafgNoL2b8LpDSkzG3VHdKxr8orI=;
        h=Date:To:From:Subject:From;
        b=ZuyX9qC/DRhr0dxMpmPcpZ7wlSVEClOamSyZDid8wfsO77QI9gyliZFr1w0hLkvZM
         O+hcAbSQ8OcL5H8m7AZqWGhF5Yvs6ipLjjCqGZCjIKcyThYisZgUrc/8wzKOGA+T5u
         ymlr1xccBz6Idk7HJGDXhzzkRTKQiH9158MLcgOY=
Date:   Thu, 27 Oct 2022 13:52:39 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch added to mm-unstable branch
Message-Id: <20221027205240.13C2AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch

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

ipc-msgc-fix-percpu_counter-use-after-free.patch
fs-ext4-superc-remove-unused-deprecated_msg.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

