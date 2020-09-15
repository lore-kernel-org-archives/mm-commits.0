Return-Path: <SRS0=Dxzc=CY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02931C433E2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Sep 2020 23:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0EF32078D
	for <mm-commits@archiver.kernel.org>; Tue, 15 Sep 2020 23:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600213705;
	bh=ghzqLPqd8lOaRh+OuEfRv+8QwJs03SP3681YGq7u5wA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=R+ywUyS38JCOkbhGkeA4bMTVM95vj25NnlZ8b+BSRU29Vpsy07BiaB2BwmClSD+Y+
	 4YIghTeH9Gs8vkgCUPZ+ImlvwNRLtGeMORlXiwxnAMen6dDWHEpOiVA2+uA+u5Zgak
	 r00HdnpxQOpdCfOL2CY35JZaXBzDfE5TmveG+h3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgIOXrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 19:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbgIOXpj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 19:45:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79D55206B6;
        Tue, 15 Sep 2020 23:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213534;
        bh=ghzqLPqd8lOaRh+OuEfRv+8QwJs03SP3681YGq7u5wA=;
        h=Date:From:To:Subject:From;
        b=ahDGTAZ1GAQgZNda6HN7YUXVokR6L8gaO06tteYlPH/NKGVc5N9JqW2bKL0hFJUgb
         8ILTsSGISUkaZT+5sDOGo6nlqXEp9xAi8/nC0K2W1aAAYmDPTOnJXFms+O5hWdMuL+
         /oKNtJMs/0lv0wO5oGHAGNyS1wO94z5pjv5soXng=
Date:   Tue, 15 Sep 2020 16:45:34 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete]
 drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch removed from -mm tree
Message-ID: <20200915234534.XnFzSbklJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/pci/ttpci/av7110_v4l.c: fix build
has been removed from the -mm tree.  Its filename was
     drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/media/pci/ttpci/av7110_v4l.c: fix build

drivers/media/pci/ttpci/av7110_v4l.c: In function vidioc_s_frequency:
drivers/media/pci/ttpci/av7110_v4l.c:163:11: error: SSE register return with SSE disabled
  if (freq < 16U * 168.25)
      ~~~~~^~~~~~~~~~~~~~

revert linux-next change.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/ttpci/av7110_v4l.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/ttpci/av7110_v4l.c~drivers-media-pci-ttpci-av7110_v4lc-fix-build
+++ a/drivers/media/pci/ttpci/av7110_v4l.c
@@ -160,9 +160,9 @@ static int ves1820_set_tv_freq(struct sa
 	buf[1] = div & 0xff;
 	buf[2] = 0x8e;
 
-	if (freq < 16U * 168.25)
+	if (freq < (u32) (16 * 168.25))
 		config = 0xa0;
-	else if (freq < 16U * 447.25)
+	else if (freq < (u32) (16 * 447.25))
 		config = 0x90;
 	else
 		config = 0x30;
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
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

