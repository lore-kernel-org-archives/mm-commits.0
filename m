Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A83DC4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 441032087D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601086746;
	bh=NjgYjBG+udEknBUDP9zYay4frscZjrJm8KtZBPbTWEU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Vas70sLpcsz5Vr3GL+Y461ext/bR2Hqo0zUeZ8zMxvvNCB1jST+7HHC5eq6pij+RM
	 07fMFOMlBPIw4OnLjwLE0au2Z8Sxb8QNbubRMpew+jH6nb3TM/WJXOAj0J/5yapPnL
	 SCns6wh8SbSJ6x5bPbDRuQytdO4obdohBL7omFic=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgIZCTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZCTF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:19:05 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9247C20866;
        Sat, 26 Sep 2020 02:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601086743;
        bh=NjgYjBG+udEknBUDP9zYay4frscZjrJm8KtZBPbTWEU=;
        h=Date:From:To:Subject:From;
        b=1hmnUM2LeZY3Ev/FZrf7fBkiaSCZ7lewd/pnVROduryU4RxsBXl+meGHLnM0iFDtn
         RAwrGCKnAbhXjmrmvFpzpOOBGXOCFTpHnQ6lBTjh62glSZaHPUTIu5X1YtaXOaMeZT
         //6t11Npg7OowpoAUIU3YPpEorz2aAUDiMiiElAE=
Date:   Fri, 25 Sep 2020 19:19:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        joao.m.martins@oracle.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
Subject:  [folded-merged]
 device-dax-make-pgmap-optional-for-instance-creation-fix.patch removed from
 -mm tree
Message-ID: <20200926021903.J_U16%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-make-pgmap-optional-for-instance-creation-fix
has been removed from the -mm tree.  Its filename was
     device-dax-make-pgmap-optional-for-instance-creation-fix.patch

This patch was dropped because it was folded into device-dax-make-pgmap-optional-for-instance-creation.patch

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
linux-next-git-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

