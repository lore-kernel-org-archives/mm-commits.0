Return-Path: <SRS0=wvGk=CD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3D2C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 25 Aug 2020 21:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55153206EB
	for <mm-commits@archiver.kernel.org>; Tue, 25 Aug 2020 21:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598391135;
	bh=s+FAXZnPBiwWOdQWe95uYL1wYfrgpsYBSu8SDHqLoUM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Yrq6KgSZvN9/P327xsHM7bkPn63o89YYrs728fuB+nPkhoL5sFJgfIcdh5sSLpHYL
	 qvMoHMbW+mYG5Azp/L2t0a2ttVPfQQZAJJ4zm/+DcmNzTcyflL+X2eT2FQjIv6MCdd
	 MQDh58ItpHsesOzuzP4R9EkEAN1SadYZtnnZTenM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgHYVcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 17:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHYVcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 17:32:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995C5206EB;
        Tue, 25 Aug 2020 21:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598391132;
        bh=s+FAXZnPBiwWOdQWe95uYL1wYfrgpsYBSu8SDHqLoUM=;
        h=Date:From:To:Subject:From;
        b=aHqy+o++8mRwM5PxfWW1zbIq3jm0EQWHr35Y5mSALgi7al+aFIGepvAaCtvybDjqD
         d6LQsQR/o22TkxOUFjAKLAor/7D0E18AXaafVaR8MS6/kwKDQIqesjh8DUgtCjT0I1
         x+hdG8T5+nIfcIrRFxBnnMVMx7VpxqjXhPalIN5k=
Date:   Tue, 25 Aug 2020 14:32:12 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        joao.m.martins@oracle.com, lkp@intel.com,
        mm-commits@vger.kernel.org, vishal.l.verma@intel.com
Subject:  + device-dax-make-align-a-per-device-property-fix.patch
 added to -mm tree
Message-ID: <20200825213212.Jfa82Fl4o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax-make-align-a-per-device-property-fix
has been added to the -mm tree.  Its filename is
     device-dax-make-align-a-per-device-property-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-make-align-a-per-device-property-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-make-align-a-per-device-property-fix.patch

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

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
device-dax-make-align-a-per-device-property-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

