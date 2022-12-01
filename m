Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F43C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiLAAHv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiLAAFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCD492A12
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDB6B61E5B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02208C433D6;
        Thu,  1 Dec 2022 00:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852939;
        bh=yHj+5zHXEDD3ncnJPdmDazN1zvSDYzt1j5x1KNPYutM=;
        h=Date:To:From:Subject:From;
        b=RbkpPJ41xZk8BW7c0jzwPOS6iFJLqrgiOrlpkkD49UXJNwvWavqRODd70QWDghLkX
         2p+/WCj1hFW2tVW8e9NTUja3UMFq/y9BetB8MXwmJhsoXnwfG5hz3ImaKaNV2hw6RG
         o6XSxXj6zZK6Z5RF3U+Fmx6ePEL+462PfyEmPHk4=
Date:   Wed, 30 Nov 2022 16:02:18 -0800
To:     mm-commits@vger.kernel.org, l.stach@pengutronix.de,
        linux+etnaviv@armlinux.org.uk, daniel.vetter@ffwll.ch,
        christian.gmeiner@gmail.com, airlied@gmail.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-etnaviv-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000219.02208C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm/etnaviv: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     drm-etnaviv-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drm/etnaviv: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:53 +0100

GUP now supports reliable R/O long-term pinning in COW mappings, such
that we break COW early. MAP_SHARED VMAs only use the shared zeropage so
far in one corner case (DAXFS file with holes), which can be ignored
because GUP does not support long-term pinning in fsdax (see
check_vma_flags()).

commit cd5297b0855f ("drm/etnaviv: Use FOLL_FORCE for userptr")
documents that FOLL_FORCE | FOLL_WRITE was really only used for reliable
R/O pinning.

Consequently, FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM is no longer required
for reliable R/O long-term pinning: FOLL_LONGTERM is sufficient. So stop
using FOLL_FORCE, which is really only for ptrace access.

Link: https://lkml.kernel.org/r/20221116102659.70287-15-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Russell King <linux+etnaviv@armlinux.org.uk>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: David Airlie <airlied@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/etnaviv/etnaviv_gem.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c~drm-etnaviv-remove-foll_force-usage
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -638,6 +638,7 @@ static int etnaviv_gem_userptr_get_pages
 	struct page **pvec = NULL;
 	struct etnaviv_gem_userptr *userptr = &etnaviv_obj->userptr;
 	int ret, pinned = 0, npages = etnaviv_obj->base.size >> PAGE_SHIFT;
+	unsigned int gup_flags = FOLL_LONGTERM;
 
 	might_lock_read(&current->mm->mmap_lock);
 
@@ -648,14 +649,15 @@ static int etnaviv_gem_userptr_get_pages
 	if (!pvec)
 		return -ENOMEM;
 
+	if (!userptr->ro)
+		gup_flags |= FOLL_WRITE;
+
 	do {
 		unsigned num_pages = npages - pinned;
 		uint64_t ptr = userptr->ptr + pinned * PAGE_SIZE;
 		struct page **pages = pvec + pinned;
 
-		ret = pin_user_pages_fast(ptr, num_pages,
-					  FOLL_WRITE | FOLL_FORCE | FOLL_LONGTERM,
-					  pages);
+		ret = pin_user_pages_fast(ptr, num_pages, gup_flags, pages);
 		if (ret < 0) {
 			unpin_user_pages(pvec, pinned);
 			kvfree(pvec);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

