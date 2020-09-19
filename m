Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DD2C43466
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1CC21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475076;
	bh=pdEh4tuiXm1JGliVE4M/X6GtWCj3tcIpuTGZssvTsFE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=AfqUfOZUee1RB3UBLXMp9gpuGCNodaLkrhqJTZZ0wHhN1pCU9RiEn87X2Ctxd4r1L
	 vjwy/rGJ9KdkZvfOW5gRFhvKBR5gngpLWsDPjDzNohWvdPzRVsQicOr9wgFrSdz7Iu
	 NTuX5H5x+9GrkUqgUmsNRfc7ms2lZ2rtzGV4kdVc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgISAYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:35 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11B0F21D43;
        Sat, 19 Sep 2020 00:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475075;
        bh=pdEh4tuiXm1JGliVE4M/X6GtWCj3tcIpuTGZssvTsFE=;
        h=Date:From:To:Subject:From;
        b=p1nFyKAr2wnqLFS4CNF1dzyNx28n22jzZsIRSQW5o/AOBYgqQQPhiAldCStPL+Dl7
         9wNwYhNsgsb48Swk0Mk/KnZ6zDv/TOrtl0nA2kBNtBjIzpePhZ9da3W7em51XGicd1
         ggDD1Pdhdsytvb7cqngniNLSIIOyt7mVASKqdE1k=
Date:   Fri, 18 Sep 2020 17:24:34 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        osalvador@suse.de, naoya.horiguchi@nec.com,
        dan.j.williams@intel.com, akpm@linux-foundation.org
Subject:  [to-be-updated]
 mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
 removed from -mm tree
Message-ID: <20200919002434.YMJLE%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix
has been removed from the -mm tree.  Its filename was
     mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix

fix bogus conflict resolution

Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix
+++ a/mm/memory-failure.c
@@ -1760,8 +1760,6 @@ static bool isolate_page(struct page *pa
 
 		if (isolated)
 			list_add(&page->lru, pagelist);
-
-		return -EBUSY;
 	}
 
 	if (isolated && lru)
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
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

