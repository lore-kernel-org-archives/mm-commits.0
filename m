Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D23BC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiLAAIB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiLAAGA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75E19580F
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 597FA61E6E
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84338C433B5;
        Thu,  1 Dec 2022 00:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852942;
        bh=9LhXSGJTa1hOSFnaAMEqeUed/U8GH5xTQgrFFYIZhpI=;
        h=Date:To:From:Subject:From;
        b=qSUOtXTcEneB1B8ikiB7hLFe0qo7bs99xYO1B99uFhyjUfJyuY8jPbaygmff9ioTl
         0qHxOADibVBONiBGHqySRbrVJg1XbRJucQQRT+SGmNe2Y18ezGuMo+oJb28qdxpQ9r
         JSpkL99A9AaGGZ0wAlHPG51EzrEJgR7QIjkEBc3A=
Date:   Wed, 30 Nov 2022 16:02:21 -0800
To:     mm-commits@vger.kernel.org, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, krzysztof.kozlowski@linaro.org,
        inki.dae@samsung.com, daniel.vetter@ffwll.ch, airlied@gmail.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-exynos-remove-foll_force-usage.patch removed from -mm tree
Message-Id: <20221201000222.84338C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm/exynos: remove FOLL_FORCE usage
has been removed from the -mm tree.  Its filename was
     drm-exynos-remove-foll_force-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drm/exynos: remove FOLL_FORCE usage
Date: Wed, 16 Nov 2022 11:26:56 +0100

FOLL_FORCE is really only for ptrace access. As we unpin the pinned pages
using unpin_user_pages_dirty_lock(true), the assumption is that all these
pages are writable.

FOLL_FORCE in this case seems to be a legacy leftover. Let's just remove
it.

Link: https://lkml.kernel.org/r/20221116102659.70287-18-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/exynos/exynos_drm_g2d.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c~drm-exynos-remove-foll_force-usage
+++ a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -477,7 +477,7 @@ static dma_addr_t *g2d_userptr_get_dma_a
 	}
 
 	ret = pin_user_pages_fast(start, npages,
-				  FOLL_FORCE | FOLL_WRITE | FOLL_LONGTERM,
+				  FOLL_WRITE | FOLL_LONGTERM,
 				  g2d_userptr->pages);
 	if (ret != npages) {
 		DRM_DEV_ERROR(g2d->dev,
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

