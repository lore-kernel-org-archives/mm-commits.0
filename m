Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03C4ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 18:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiJ0S4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 14:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiJ0S4G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 14:56:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08361240BF
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 11:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB94B82775
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 18:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CCFC433D6;
        Thu, 27 Oct 2022 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666896961;
        bh=93KtveWhEZWBYaN3xYONknkXzpbh1+WrYYdkjVIvms8=;
        h=Date:To:From:Subject:From;
        b=CQpxP0phANksMPos2Lpa3QN1zRqbmGp8eQHMp0Ma7o1O06vIusKm2rScITOLfSxyN
         Agti7bC8ahWePzMiEGvTX2PnoY4m6upe3qE/zYATB8eJblQ0hB26RckFIfEqnI/frH
         0LYeg+3+1E18PY5ilAY0ovkg/fOItLFDFfihGB5Q=
Date:   Thu, 27 Oct 2022 11:56:00 -0700
To:     mm-commits@vger.kernel.org, yang.lee@linux.alibaba.com,
        Felix.Kuehling@amd.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch added to mm-unstable branch
Message-Id: <20221027185601.37CCFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch

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
Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2
Date: Thu Oct 27 11:53:07 AM PDT 2022

fix whitespace, per Felix and Yang Li

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -328,8 +328,8 @@ svm_migrate_copy_to_vram(struct amdgpu_d
 
 		dst[i] = cursor.start + (j << PAGE_SHIFT);
 		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
-			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
-						  migrate->dst[i]);
+		svm_migrate_get_vram_page(&kfddev->pgmap, prange,
+					  migrate->dst[i]);
 		migrate->dst[i] = migrate_pfn(migrate->dst[i]);
 
 		spage = migrate_pfn_to_page(migrate->src[i]);
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
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

