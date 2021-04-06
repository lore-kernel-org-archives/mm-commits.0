Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4EFC433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 05:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B70613C0
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 05:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhDFFzD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 01:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhDFFzD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Apr 2021 01:55:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41595613BC;
        Tue,  6 Apr 2021 05:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617688494;
        bh=1hIHpIOFdPurKEgWX/ewFNQ0Grqj0pd2s3fIODilDiY=;
        h=Date:From:To:Subject:From;
        b=kVPdvkR4x4advPVy4RYcNIcBXQYU+qh3lUO9CK42SOCm95b1DkM6BQ5Et7IxgcYS9
         thesjreQufVXHemIHThpa7NzJgdWdX/85YCjmY1S05NqvA6yTpKKYCQjXDDCQB/9Ek
         7keK07EyNUQ3Fi5pkdx1udA6q0tMK03umNKh7Suw=
Date:   Mon, 05 Apr 2021 22:54:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org,
        npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  + mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
 added to -mm tree
Message-ID: <20210406055453.MLuTCcBH_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-remove-unmap_kernel_range-fix-fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-remove-unmap_kernel_range-fix-fix

move vunmap_range_noflush() stub inside !CONFIG_MMU, not !CONFIG_NUMA

Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/internal.h~mm-vmalloc-remove-unmap_kernel_range-fix-fix
+++ a/mm/internal.h
@@ -447,7 +447,9 @@ static inline struct file *maybe_unlock_
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
-
+static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
+{
+}
 #endif /* !CONFIG_MMU */
 
 /*
@@ -541,9 +543,6 @@ static inline int node_reclaim(struct pg
 {
 	return NODE_RECLAIM_NOSCAN;
 }
-static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
-{
-}
 #endif
 
 extern int hwpoison_filter(struct page *p);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
lib-test_kasan_modulec-suppress-unused-var-warning.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

