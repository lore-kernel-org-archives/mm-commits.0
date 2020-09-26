Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24C0C4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E7D720BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087140;
	bh=wRPwSnnNCk3dsjOwUyJFOLjmpVS20OAYEWba63AeIrs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LTm8CPj4oxaxFwVfoKswxpPCTNEWfUa8E+qgpSR2ccHtLil0YFJ2Quqr5FK8Q4As8
	 m+pfEXmEPXMse+N0LqEb6X0W8Jlg3DcfgvA4Ol3NiE8xW90DRb3Zd5nJM1wUJ2VSds
	 JAdt2sV6OXBH6Xd0/3x1okvmPkJyHNd3PZnWps4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbgIZCZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIZCZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:40 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38DB22087D;
        Sat, 26 Sep 2020 02:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087139;
        bh=wRPwSnnNCk3dsjOwUyJFOLjmpVS20OAYEWba63AeIrs=;
        h=Date:From:To:Subject:From;
        b=eFuE/smoErzqou2uNrQ9LvXguaGDwAS7LP3G+rMAZHPvj9UtK5BGEQDfqzSauHZMX
         s9Pwl6ZfTcI41y7jkHahwm4QQllA7hABVS/cZDKU5A6phQ8HyjGJznZUQyZdldX0I1
         bFgYXivjjoQfHiPjwcSHtO0ET/A8+1DX8xwRgQCQ=
Date:   Fri, 25 Sep 2020 19:25:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yanaijie@huawei.com, will@kernel.org,
        vishal.l.verma@intel.com, vgoyal@redhat.com,
        thomas.lendacky@amd.com, tglx@linutronix.de,
        sstabellini@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@linux.alibaba.com, rdunlap@infradead.org,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        paulus@ozlabs.org, pasha.tatashin@soleen.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, lkp@intel.com,
        justin.he@arm.com, Jonathan.Cameron@huawei.com, jmoyer@redhat.com,
        jgross@suse.com, jglisse@redhat.com, jgg@mellanox.com,
        ira.weiny@intel.com, hulkci@huawei.com, hpa@zytor.com,
        gregkh@linuxfoundation.org, david@redhat.com, dave.jiang@intel.com,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        daniel@ffwll.ch, catalin.marinas@arm.com, bskeggs@redhat.com,
        Brice.Goglin@inria.fr, bp@alien8.de, boris.ostrovsky@oracle.com,
        bhelgaas@google.com, benh@kernel.crashing.org, ardb@kernel.org,
        ard.biesheuvel@linaro.org, airlied@linux.ie,
        joao.m.martins@oracle.com
Subject:  + device-dax-make-align-a-per-device-property.patch added
 to -mm tree
Message-ID: <20200926022536.YM8fU%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: make align a per-device property
has been added to the -mm tree.  Its filename is
     device-dax-make-align-a-per-device-property.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-make-align-a-per-d=
evice-property.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-make-align-a-per-d=
evice-property.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: make align a per-device property

Introduce @align to struct dev_dax.

When creating a new device, we still initialize to the default dax_region
@align.  Child devices belonging to a region may wish to keep a different
alignment property instead of a global region-defined one.

Link: https://lkml.kernel.org/r/159643105377.4062302.4159447829955683131.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-2-joao.m.martins@oracl=
e.com
Link: https://lkml.kernel.org/r/160106117957.30709.1142303024324655705.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |    1=20
 drivers/dax/dax-private.h |    3 ++
 drivers/dax/device.c      |   41 +++++++++++++-----------------------
 3 files changed, 19 insertions(+), 26 deletions(-)

--- a/drivers/dax/bus.c~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/bus.c
@@ -1218,6 +1218,7 @@ struct dev_dax *devm_create_dev_dax(stru
=20
 	dev_dax->dax_dev =3D dax_dev;
 	dev_dax->target_node =3D dax_region->target_node;
+	dev_dax->align =3D dax_region->align;
 	ida_init(&dev_dax->ida);
 	kref_get(&dax_region->kref);
=20
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
+phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsi=
gned long size);
 #endif
--- a/drivers/dax/device.c~device-dax-make-align-a-per-device-property
+++ a/drivers/dax/device.c
@@ -17,7 +17,6 @@
 static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		const char *func)
 {
-	struct dax_region *dax_region =3D dev_dax->region;
 	struct device *dev =3D &dev_dax->dev;
 	unsigned long mask;
=20
@@ -32,7 +31,7 @@ static int check_vma(struct dev_dax *dev
 		return -EINVAL;
 	}
=20
-	mask =3D dax_region->align - 1;
+	mask =3D dev_dax->align - 1;
 	if (vma->vm_start & mask || vma->vm_end & mask) {
 		dev_info_ratelimited(dev,
 				"%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
@@ -78,21 +77,19 @@ static vm_fault_t __dev_dax_pte_fault(st
 				struct vm_fault *vmf, pfn_t *pfn)
 {
 	struct device *dev =3D &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	unsigned int fault_size =3D PAGE_SIZE;
=20
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
=20
-	dax_region =3D dev_dax->region;
-	if (dax_region->align > PAGE_SIZE) {
+	if (dev_dax->align > PAGE_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
=20
-	if (fault_size !=3D dax_region->align)
+	if (fault_size !=3D dev_dax->align)
 		return VM_FAULT_SIGBUS;
=20
 	phys =3D dax_pgoff_to_phys(dev_dax, vmf->pgoff, PAGE_SIZE);
@@ -111,7 +108,6 @@ static vm_fault_t __dev_dax_pmd_fault(st
 {
 	unsigned long pmd_addr =3D vmf->address & PMD_MASK;
 	struct device *dev =3D &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	unsigned int fault_size =3D PMD_SIZE;
@@ -119,16 +115,15 @@ static vm_fault_t __dev_dax_pmd_fault(st
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
=20
-	dax_region =3D dev_dax->region;
-	if (dax_region->align > PMD_SIZE) {
+	if (dev_dax->align > PMD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
=20
-	if (fault_size < dax_region->align)
+	if (fault_size < dev_dax->align)
 		return VM_FAULT_SIGBUS;
-	else if (fault_size > dax_region->align)
+	else if (fault_size > dev_dax->align)
 		return VM_FAULT_FALLBACK;
=20
 	/* if we are outside of the VMA */
@@ -154,7 +149,6 @@ static vm_fault_t __dev_dax_pud_fault(st
 {
 	unsigned long pud_addr =3D vmf->address & PUD_MASK;
 	struct device *dev =3D &dev_dax->dev;
-	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	unsigned int fault_size =3D PUD_SIZE;
@@ -163,16 +157,15 @@ static vm_fault_t __dev_dax_pud_fault(st
 	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
=20
-	dax_region =3D dev_dax->region;
-	if (dax_region->align > PUD_SIZE) {
+	if (dev_dax->align > PUD_SIZE) {
 		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
-			dax_region->align, fault_size);
+			dev_dax->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
=20
-	if (fault_size < dax_region->align)
+	if (fault_size < dev_dax->align)
 		return VM_FAULT_SIGBUS;
-	else if (fault_size > dax_region->align)
+	else if (fault_size > dev_dax->align)
 		return VM_FAULT_FALLBACK;
=20
 	/* if we are outside of the VMA */
@@ -267,9 +260,8 @@ static int dev_dax_split(struct vm_area_
 {
 	struct file *filp =3D vma->vm_file;
 	struct dev_dax *dev_dax =3D filp->private_data;
-	struct dax_region *dax_region =3D dev_dax->region;
=20
-	if (!IS_ALIGNED(addr, dax_region->align))
+	if (!IS_ALIGNED(addr, dev_dax->align))
 		return -EINVAL;
 	return 0;
 }
@@ -278,9 +270,8 @@ static unsigned long dev_dax_pagesize(st
 {
 	struct file *filp =3D vma->vm_file;
 	struct dev_dax *dev_dax =3D filp->private_data;
-	struct dax_region *dax_region =3D dev_dax->region;
=20
-	return dax_region->align;
+	return dev_dax->align;
 }
=20
 static const struct vm_operations_struct dax_vm_ops =3D {
@@ -319,13 +310,11 @@ static unsigned long dax_get_unmapped_ar
 {
 	unsigned long off, off_end, off_align, len_align, addr_align, align;
 	struct dev_dax *dev_dax =3D filp ? filp->private_data : NULL;
-	struct dax_region *dax_region;
=20
 	if (!dev_dax || addr)
 		goto out;
=20
-	dax_region =3D dev_dax->region;
-	align =3D dax_region->align;
+	align =3D dev_dax->align;
 	off =3D pgoff << PAGE_SHIFT;
 	off_end =3D off + len;
 	off_align =3D round_up(off, align);
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.=
patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
device-dax-make-align-a-per-device-property.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

