Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FD2C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356778AbhK1Akc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351577AbhK1Aib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:38:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9183C061574
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 16:35:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A551B80B23
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D452CC53FBF;
        Sun, 28 Nov 2021 00:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638059714;
        bh=qNg2dDncka5PxL5aTzDJlMA/FG5491Nuarra1bbV87I=;
        h=Date:From:To:Subject:From;
        b=e5hPwVidFewqe63xhYsMqXRuTVxmbP+Zm8V690LlW3adRtrG4JIcDSE644iHDWtK2
         REMKrojqjxms1xxzQx4VMqErwqXTpMwYdZnbnHzSKNz/56UDaneGtZVhvRYjxmq+Tk
         TFcPZ0B1pCm9za6mOQ7c2eI2WVV/z5kZpi91jGg4=
Date:   Sat, 27 Nov 2021 16:35:13 -0800
From:   akpm@linux-foundation.org
To:     joao.m.martins@oracle.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix.patch added to
 -mm tree
Message-ID: <20211128003513.txuq1mGQQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix
has been added to the -mm tree.  Its filename is
     device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix

fix warnings


Link: https://lkml.kernel.org/r/96b53b3c-5c18-5f93-c595-a7d509d58f92@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dax/device.c~device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix
+++ a/drivers/dax/device.c
@@ -223,7 +223,6 @@ static vm_fault_t dev_dax_huge_fault(str
 		enum page_entry_size pe_size)
 {
 	struct file *filp = vmf->vma->vm_file;
-	unsigned long fault_size;
 	vm_fault_t rc = VM_FAULT_SIGBUS;
 	int id;
 	pfn_t pfn;
@@ -236,15 +235,12 @@ static vm_fault_t dev_dax_huge_fault(str
 	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		fault_size = PAGE_SIZE;
 		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PMD:
-		fault_size = PMD_SIZE;
 		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PUD:
-		fault_size = PUD_SIZE;
 		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
 		break;
 	default:
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch
mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix.patch
device-dax-compound-devmap-support.patch

