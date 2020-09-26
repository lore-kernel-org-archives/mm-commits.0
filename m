Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CF8C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A8C20936
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601086679;
	bh=8MvGskI39Ny4HVnCwIkTNJXaO1DpiuKkWDdN4iNoq5o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LzUSssclgxippVslQVeHSrLxkozSq59pdhR7VzV7TIVoJK9z2z5svxZOZS369wYsi
	 +RU+5PdWXpbKni2eZAP8sKa35FbfVi5l5pk+5nbwWZanYwu8QZmpr0qS+Hs6arShcH
	 s+oMcsadUcliKqSpexQPV2OqVPrgCIuuOqN45+Js=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgIZCR7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgIZCR7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:17:59 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA93120866;
        Sat, 26 Sep 2020 02:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601086678;
        bh=8MvGskI39Ny4HVnCwIkTNJXaO1DpiuKkWDdN4iNoq5o=;
        h=Date:From:To:Subject:From;
        b=eNvB1Vc50GCzhK6mLGXggU9F/6m08THnnZX26+uOh1Ksr9tPk3iGPcHwmcjLJvc6i
         Gxni5hOmSp2L/GW6XIPfE4ezz60AGlxuK3TNK/5OvlDZ7+3RkaQMw6sd8djRGZLN9s
         P/+glupLC5by3KU0vQTE5jYhhrgnwZN5ipLETcRw=
Date:   Fri, 25 Sep 2020 19:17:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        lkp@intel.com, joao.m.martins@oracle.com, dan.j.williams@intel.com,
        akpm@linux-foundation.org
Subject:  [folded-merged]
 device-dax-make-align-a-per-device-property-fix.patch removed from -mm tree
Message-ID: <20200926021757.lYavF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-make-align-a-per-device-property-fix
has been removed from the -mm tree.  Its filename was
     device-dax-make-align-a-per-device-property-fix.patch

This patch was dropped because it was folded into device-dax-make-align-a-per-device-property.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: device-dax-make-align-a-per-device-property-fix

remove unused locals dex_region

Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dax/device.c~device-dax-make-align-a-per-device-property-fix
+++ a/drivers/dax/device.c
@@ -108,7 +108,6 @@ static vm_fault_t __dev_dax_pmd_fault(st
 {
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	struct device *dev = &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	unsigned int fault_size = PMD_SIZE;
@@ -116,7 +115,6 @@ static vm_fault_t __dev_dax_pmd_fault(st
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
 
-	dax_region = dev_dax->region;
 	if (dev_dax->align > PMD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
 			dev_dax->align, fault_size);
@@ -151,7 +149,6 @@ static vm_fault_t __dev_dax_pud_fault(st
 {
 	unsigned long pud_addr = vmf->address & PUD_MASK;
 	struct device *dev = &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	unsigned int fault_size = PUD_SIZE;
@@ -160,7 +157,6 @@ static vm_fault_t __dev_dax_pud_fault(st
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
 
-	dax_region = dev_dax->region;
 	if (dev_dax->align > PUD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
 			dev_dax->align, fault_size);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-pgmap-optional-for-instance-creation-fix.patch
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

