Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2291C43461
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E8E221E7
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 00:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600044597;
	bh=GU+tvQExv/DB1Z3d5szuAAa+L+SFUTruEOVOHmuz318=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=aPjJbUXLg7WolJgeunM17RDKa13oByNZgN9FkMiHDTy2RffaJAXFcxPmf/SupXp0g
	 T3VuQ4IWlR9UhifEdTerVLUg+02ynMLuShn7kFusE4f9z8uK24uZ4ewX6CvLB/TFm7
	 CFci+veexPlfXhu21AVkT6J5eMsPM2IehhCZT3LY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgINAt5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:49:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgINAt4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 20:49:56 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C149921D1A;
        Mon, 14 Sep 2020 00:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600044595;
        bh=GU+tvQExv/DB1Z3d5szuAAa+L+SFUTruEOVOHmuz318=;
        h=Date:From:To:Subject:From;
        b=Ys7zrTJOD/Nw4VRtKe8G6xPBBK2DV8Tly1DW/kdT6CP+B07JNjKO1kXLD48rcCioD
         Txu7PnU4XApNKbjcHr+KRJB0jL1NJdhZUDhNFIigm6G1rpF+ZLKAQi14PSgIoIRRay
         fURSOuiiUClvomgbeA4awRs6UbRasXXHQw1dcrs0=
Date:   Sun, 13 Sep 2020 17:49:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        joao.m.martins@oracle.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
Subject:  +
 device-dax-make-pgmap-optional-for-instance-creation-fix.patch added to -mm
 tree
Message-ID: <20200914004955.COfnb%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-make-pgmap-optional-for-instance-creation-fix
has been added to the -mm tree.  Its filename is
     device-dax-make-pgmap-optional-for-instance-creation-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-make-pgmap-optional-for-instance-creation-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-make-pgmap-optional-for-instance-creation-fix.patch

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
Subject: device-dax-make-pgmap-optional-for-instance-creation-fix

MEMORY_DEVICE_DEVDAX was renamed to MEMORY_DEVICE_GENERIC

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/device.c~device-dax-make-pgmap-optional-for-instance-creation-fix
+++ a/drivers/dax/device.c
@@ -419,7 +419,7 @@ int dev_dax_probe(struct device *dev)
 		pgmap->res.start = range->start;
 		pgmap->res.end = range->end;
 	}
-	pgmap->type = MEMORY_DEVICE_DEVDAX;
+	pgmap->type = MEMORY_DEVICE_GENERIC;
 	addr = devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-pgmap-optional-for-instance-creation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

