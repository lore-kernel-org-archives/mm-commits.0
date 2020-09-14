Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFACEC433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 04:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C5720EDD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 04:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600057591;
	bh=hP0x2Owz4u6pYqYY3OQzq5/l1cebEuAaL3onW1SA568=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wP6rKCyVCfQ7g6PWYIDBICZTqCSnglFJXVMZYzZQXGa9y1Wcsa/O5QionwIvuLpQQ
	 WoJe1pBpUQf1Tbru+5IdTnO8dD1gcqUtgmkIwZW0xvtBPHt43i6ssqhVBOxhNhqdYI
	 FV3Wt5J8BSFQPrf2RE7MVPX56xqXSlYraMLgtA6w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgINE0b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Sep 2020 00:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgINE03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Sep 2020 00:26:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B809207EA;
        Mon, 14 Sep 2020 04:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600057589;
        bh=hP0x2Owz4u6pYqYY3OQzq5/l1cebEuAaL3onW1SA568=;
        h=Date:From:To:Subject:From;
        b=rjHiyJWk+Lx8KnDFIls6dbGpfu23kg9uDr5MDfCzwsUE28hZGd3KVmR9qrmGR0s7I
         j7SMWBJCXQVv/8loWU93bdlPsJ/7I+nqloegCp0SfzJG380MeyAxyOeQSM05UxrmcZ
         PWWB7+NaxZOztDjoV4PYJGF7fGIBSphKUcWqSoIE=
Date:   Sun, 13 Sep 2020 21:26:28 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch
 added to -mm tree
Message-ID: <20200914042628.wSS8JRaub%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/pci/ttpci/av7110_v4l.c: fix build
has been added to the -mm tree.  Its filename is
     drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch

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
linux-next-git-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch

