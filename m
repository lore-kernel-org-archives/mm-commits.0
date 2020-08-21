Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D49C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1E272087D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052262;
	bh=nw1z3ZWfLbbM55YpO9HDJFMOiSn9lmkEisWKjm2LhII=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ywf1gaJZfuJFmzMJGXJ3x4mYtldwWUN8sRI6oL5kvV6VtMmwRfPe+EKSdl62Ijm5u
	 cQGqiDke3rVHCKrMI0DnXvoSKZI+/plZuBMgz8DG9brRb5aAk7UhnC+VkXz58zsxlv
	 nT6FuVtAlFA60qbjINypf5sbuTu6/OhpoqkuOEQc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgHUXYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHUXYU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:24:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D92D207DF;
        Fri, 21 Aug 2020 23:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052259;
        bh=nw1z3ZWfLbbM55YpO9HDJFMOiSn9lmkEisWKjm2LhII=;
        h=Date:From:To:Subject:From;
        b=HuTlknLuOg4ayPUP2Xq5dWohwJQROQxP/nlDo+tYQx6vLtandt80JPh1YIhKmbYCt
         p7BejiurAVesZtprO1IDv1o7pDaCMMk9AxuiLg2dlOUrOAONNqzprqDRbRMWUUeRi5
         x8XCakne/K/1N1nhMHSSgi1mnSyXBBlH6osyiUaw=
Date:   Fri, 21 Aug 2020 16:24:17 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        ira.weiny@intel.com, jgg@mellanox.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rafael@kernel.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  + device-dax-make-align-a-per-device-property.patch added
 to -mm tree
Message-ID: <20200821232417.BTQRWJTvw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: make align a per-device property
has been added to the -mm tree.  Its filename is
     device-dax-make-align-a-per-device-property.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-make-align-a-per-device-property.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-make-align-a-per-device-property.patch

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
Subject: device-dax: make align a per-device property

Introduce @align to struct dev_dax.

When creating a new device, we still initialize to the default dax_region
@align.  Child devices belonging to a region may wish to keep a different
alignment property instead of a global region-defined one.

Link: https://lkml.kernel.org/r/159643105377.4062302.4159447829955683131.stgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-2-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |    1 
 drivers/dax/dax-private.h |    3 ++
 drivers/dax/device.c      |   37 ++++++++++++++----------------------
 3 files changed, 19 insertions(+), 22 deletions(-)

--- a/drivers/dax/bus.c~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/bus.c
@@ -1215,6 +1215,7 @@ struct dev_dax *devm_create_dev_dax(stru
 
 	dev_dax->dax_dev = dax_dev;
 	dev_dax->target_node = dax_region->target_node;
+	dev_dax->align = dax_region->align;
 	ida_init(&dev_dax->ida);
 	kref_get(&dax_region->kref);
 
--- a/drivers/dax/dax-private.h~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/dax-private.h
@@ -62,6 +62,7 @@ struct dax_mapping {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	unsigned int align;
 	int target_node;
 	int id;
 	struct ida ida;
@@ -84,4 +85,6 @@ static inline struct dax_mapping *to_dax
 {
 	return container_of(dev, struct dax_mapping, dev);
 }
+
+phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
 #endif
--- a/drivers/dax/device.c~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/device.c
@@ -17,7 +17,6 @@
 static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		const char *func)
 {
-	struct dax_region *dax_region = dev_dax->region;
 	struct device *dev = &dev_dax->dev;
 	unsigned long mask;
 
@@ -32,7 +31,7 @@ static int check_vma(struct dev_dax *dev
 		return -EINVAL;
 	}
 
-	mask = dax_region->align - 1;
+	mask = dev_dax->align - 1;
 	if (vma->vm_start & mask || vma->vm_end & mask) {
 		dev_info_ratelimited(dev,
 				"%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
@@ -78,21 +77,19 @@ static vm_fault_t __dev_dax_pte_fault(st
 				struct vm_fault *vmf, pfn_t *pfn)
 {
 	struct device *dev = &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	unsigned int fault_size = PAGE_SIZE;
 
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
 
-	dax_region = dev_dax->region;
-	if (dax_region->align > PAGE_SIZE) {
+	if (dev_dax->align > PAGE_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
-	if (fault_size != dax_region->align)
+	if (fault_size != dev_dax->align)
 		return VM_FAULT_SIGBUS;
 
 	phys = dax_pgoff_to_phys(dev_dax, vmf->pgoff, PAGE_SIZE);
@@ -120,15 +117,15 @@ static vm_fault_t __dev_dax_pmd_fault(st
 		return VM_FAULT_SIGBUS;
 
 	dax_region = dev_dax->region;
-	if (dax_region->align > PMD_SIZE) {
+	if (dev_dax->align > PMD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
-	if (fault_size < dax_region->align)
+	if (fault_size < dev_dax->align)
 		return VM_FAULT_SIGBUS;
-	else if (fault_size > dax_region->align)
+	else if (fault_size > dev_dax->align)
 		return VM_FAULT_FALLBACK;
 
 	/* if we are outside of the VMA */
@@ -164,15 +161,15 @@ static vm_fault_t __dev_dax_pud_fault(st
 		return VM_FAULT_SIGBUS;
 
 	dax_region = dev_dax->region;
-	if (dax_region->align > PUD_SIZE) {
+	if (dev_dax->align > PUD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
-	if (fault_size < dax_region->align)
+	if (fault_size < dev_dax->align)
 		return VM_FAULT_SIGBUS;
-	else if (fault_size > dax_region->align)
+	else if (fault_size > dev_dax->align)
 		return VM_FAULT_FALLBACK;
 
 	/* if we are outside of the VMA */
@@ -267,9 +264,8 @@ static int dev_dax_split(struct vm_area_
 {
 	struct file *filp = vma->vm_file;
 	struct dev_dax *dev_dax = filp->private_data;
-	struct dax_region *dax_region = dev_dax->region;
 
-	if (!IS_ALIGNED(addr, dax_region->align))
+	if (!IS_ALIGNED(addr, dev_dax->align))
 		return -EINVAL;
 	return 0;
 }
@@ -278,9 +274,8 @@ static unsigned long dev_dax_pagesize(st
 {
 	struct file *filp = vma->vm_file;
 	struct dev_dax *dev_dax = filp->private_data;
-	struct dax_region *dax_region = dev_dax->region;
 
-	return dax_region->align;
+	return dev_dax->align;
 }
 
 static const struct vm_operations_struct dax_vm_ops = {
@@ -319,13 +314,11 @@ static unsigned long dax_get_unmapped_ar
 {
 	unsigned long off, off_end, off_align, len_align, addr_align, align;
 	struct dev_dax *dev_dax = filp ? filp->private_data : NULL;
-	struct dax_region *dax_region;
 
 	if (!dev_dax || addr)
 		goto out;
 
-	dax_region = dev_dax->region;
-	align = dax_region->align;
+	align = dev_dax->align;
 	off = pgoff << PAGE_SHIFT;
 	off_end = off + len;
 	off_align = round_up(off, align);
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

device-dax-make-align-a-per-device-property.patch
device-dax-add-an-align-attribute.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

