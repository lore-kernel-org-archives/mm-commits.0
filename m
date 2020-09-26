Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA6CC4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F230E207EA
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601084883;
	bh=h+SN3ySRqfj+25HTwrYkrFD48c8f/2GC9k+r9UrNbsE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1vtpy8R0V12JYEFG8GSVnXKVKdYRjKv0gD2kH/8C+HNL391/zBidEAd4GF5Cv+0gM
	 gXMYAYu1TqdfL1cUOJcjdzqhUBalleQd4dEUDyn/EXDsIIplOIt/ZrfQ4zeT7zwkEL
	 Z8vHyppq5ZVWeOEYcgGJEfnvE+uvr/Cbpq4VXTu8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgIZBsC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729008AbgIZBsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:48:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CD67207EA;
        Sat, 26 Sep 2020 01:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601084880;
        bh=h+SN3ySRqfj+25HTwrYkrFD48c8f/2GC9k+r9UrNbsE=;
        h=Date:From:To:Subject:From;
        b=vrtNr5s3tnPclFeDGzeaXK1ZdgdEFCzrPZ8sQ0u2baEqKst5Zo+cw2oc35Yv3r+xp
         VqKRCr8/WFWNltbx8gLA4/qeV62fatG+VuJ9lRsmeki8hsZy+cna94/gGOXyB1M3Bu
         4493h4Yta7IM8CY2aC2YM8wyFz0/B1/cN/Vdwt9Q=
Date:   Fri, 25 Sep 2020 18:47:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20200926014759.ZE0pk7HqJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/regmap/regmap.c                     |    3 ---
 drivers/gpu/drm/i915/selftests/mock_gem_device.c |    4 ----
 2 files changed, 7 deletions(-)

--- a/drivers/base/regmap/regmap.c~linux-next-git-rejects
+++ a/drivers/base/regmap/regmap.c
@@ -722,11 +722,8 @@ struct regmap *__regmap_init(struct devi
 	ret = regmap_set_name(map, config);
 	if (ret)
 		goto err_map;
-<<<<<<< HEAD
-=======
 
 	ret = -EINVAL; /* Later error paths rely on this */
->>>>>>> linux-next/akpm-base
 
 	if (config->disable_locking) {
 		map->lock = map->unlock = regmap_lock_unlock_none;
--- a/drivers/gpu/drm/i915/selftests/mock_gem_device.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/selftests/mock_gem_device.c
@@ -121,10 +121,6 @@ struct drm_i915_private *mock_gem_device
 #endif
 	struct drm_i915_private *i915;
 	struct pci_dev *pdev;
-<<<<<<< HEAD
-	int err;
-=======
->>>>>>> linux-next/akpm-base
 
 	pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
 	if (!pdev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-pgmap-optional-for-instance-creation-fix.patch
mm-memremap_pages-support-multiple-ranges-per-invocation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

