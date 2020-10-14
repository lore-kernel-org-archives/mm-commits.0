Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81C6C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5891B22254
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709038;
	bh=YYKOIOVG5bNqXpuI4eBDDLrQKEKkWpltT12zaiLVYlY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EKjr2SlN/ZT8xUJKJFW/vTFNC8HVumDJVHyaloIMm27fLGLe3kVhALUfOsnOUWps/
	 4da9Rgey/D9STOKQ9y3989XzA+BBOAa7l19NN4rNCv7B33gZWGjn2Hz2qq+McPWPsw
	 OE67IEIwQBE4OTATzjW7++SuLhCkvRynYTtf67Rw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389433AbgJNU5R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU5R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:57:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D32C622253;
        Wed, 14 Oct 2020 20:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709035;
        bh=YYKOIOVG5bNqXpuI4eBDDLrQKEKkWpltT12zaiLVYlY=;
        h=Date:From:To:Subject:From;
        b=GdrJ/LNu+zTbGCMs+BuFcEur4QdBmWplIxvqEyUAl7YMWk2kKh3n2nbr42eallDzQ
         NkPCMtCXQ5XnkRafqr9O7qWa/E9TDlWKtviQ+zhyWTn3t70Bj9l80WPowne4bAhBuB
         qdGgsdQWZL9i+5apv9L+Bd8iAo9m42dN+PYmgvdo=
Date:   Wed, 14 Oct 2020 13:57:13 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, lkp@intel.com, luto@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rdunlap@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@linux.ibm.com,
        sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, vgoyal@redhat.com,
        vishal.l.verma@intel.com, will@kernel.org, yanaijie@huawei.com
Subject:  [merged]
 device-dax-drop-the-dax_regionpfn_flags-attribute.patch removed from -mm
 tree
Message-ID: <20201014205713.agSN5GTpR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: drop the dax_region.pfn_flags attribute
has been removed from the -mm tree.  Its filename was
     device-dax-drop-the-dax_regionpfn_flags-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: drop the dax_region.pfn_flags attribute

All callers specify the same flags to alloc_dax_region(), so there is no
need to allow for anything other than PFN_DEV|PFN_MAP, or carry a
->pfn_flags around on the region.  Device-dax instances are always page
backed.

Link: https://lkml.kernel.org/r/159643098829.4062302.13611520567669439046.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
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
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |    4 +---
 drivers/dax/bus.h         |    3 +--
 drivers/dax/dax-private.h |    2 --
 drivers/dax/device.c      |   26 +++-----------------------
 drivers/dax/hmem/hmem.c   |    2 +-
 drivers/dax/pmem/core.c   |    3 +--
 6 files changed, 7 insertions(+), 33 deletions(-)

--- a/drivers/dax/bus.c~device-dax-drop-the-dax_regionpfn_flags-attribute
+++ a/drivers/dax/bus.c
@@ -226,8 +226,7 @@ static void dax_region_unregister(void *
 }
=20
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align,
-		unsigned long long pfn_flags)
+		struct resource *res, int target_node, unsigned int align)
 {
 	struct dax_region *dax_region;
=20
@@ -251,7 +250,6 @@ struct dax_region *alloc_dax_region(stru
=20
 	dev_set_drvdata(parent, dax_region);
 	memcpy(&dax_region->res, res, sizeof(*res));
-	dax_region->pfn_flags =3D pfn_flags;
 	kref_init(&dax_region->kref);
 	dax_region->id =3D region_id;
 	dax_region->align =3D align;
--- a/drivers/dax/bus.h~device-dax-drop-the-dax_regionpfn_flags-attribute
+++ a/drivers/dax/bus.h
@@ -10,8 +10,7 @@ struct dax_device;
 struct dax_region;
 void dax_region_put(struct dax_region *dax_region);
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align,
-		unsigned long long flags);
+		struct resource *res, int target_node, unsigned int align);
=20
 enum dev_dax_subsys {
 	DEV_DAX_BUS,
--- a/drivers/dax/dax-private.h~device-dax-drop-the-dax_regionpfn_flags-att=
ribute
+++ a/drivers/dax/dax-private.h
@@ -23,7 +23,6 @@ void dax_bus_exit(void);
  * @dev: parent device backing this region
  * @align: allocation and mapping alignment for child dax devices
  * @res: physical address range of the region
- * @pfn_flags: identify whether the pfns are paged back or not
  */
 struct dax_region {
 	int id;
@@ -32,7 +31,6 @@ struct dax_region {
 	struct device *dev;
 	unsigned int align;
 	struct resource res;
-	unsigned long long pfn_flags;
 };
=20
 /**
--- a/drivers/dax/device.c~device-dax-drop-the-dax_regionpfn_flags-attribute
+++ a/drivers/dax/device.c
@@ -41,14 +41,6 @@ static int check_vma(struct dev_dax *dev
 		return -EINVAL;
 	}
=20
-	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) =3D=3D PFN_DEV
-			&& (vma->vm_flags & VM_DONTCOPY) =3D=3D 0) {
-		dev_info_ratelimited(dev,
-				"%s: %s: fail, dax range requires MADV_DONTFORK\n",
-				current->comm, func);
-		return -EINVAL;
-	}
-
 	if (!vma_is_dax(vma)) {
 		dev_info_ratelimited(dev,
 				"%s: %s: fail, vma is not DAX capable\n",
@@ -102,7 +94,7 @@ static vm_fault_t __dev_dax_pte_fault(st
 		return VM_FAULT_SIGBUS;
 	}
=20
-	*pfn =3D phys_to_pfn_t(phys, dax_region->pfn_flags);
+	*pfn =3D phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
=20
 	return vmf_insert_mixed(vmf->vma, vmf->address, *pfn);
 }
@@ -127,12 +119,6 @@ static vm_fault_t __dev_dax_pmd_fault(st
 		return VM_FAULT_SIGBUS;
 	}
=20
-	/* dax pmd mappings require pfn_t_devmap() */
-	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) !=3D (PFN_DEV|PFN_MAP)) {
-		dev_dbg(dev, "region lacks devmap flags\n");
-		return VM_FAULT_SIGBUS;
-	}
-
 	if (fault_size < dax_region->align)
 		return VM_FAULT_SIGBUS;
 	else if (fault_size > dax_region->align)
@@ -150,7 +136,7 @@ static vm_fault_t __dev_dax_pmd_fault(st
 		return VM_FAULT_SIGBUS;
 	}
=20
-	*pfn =3D phys_to_pfn_t(phys, dax_region->pfn_flags);
+	*pfn =3D phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
=20
 	return vmf_insert_pfn_pmd(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
@@ -177,12 +163,6 @@ static vm_fault_t __dev_dax_pud_fault(st
 		return VM_FAULT_SIGBUS;
 	}
=20
-	/* dax pud mappings require pfn_t_devmap() */
-	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) !=3D (PFN_DEV|PFN_MAP)) {
-		dev_dbg(dev, "region lacks devmap flags\n");
-		return VM_FAULT_SIGBUS;
-	}
-
 	if (fault_size < dax_region->align)
 		return VM_FAULT_SIGBUS;
 	else if (fault_size > dax_region->align)
@@ -200,7 +180,7 @@ static vm_fault_t __dev_dax_pud_fault(st
 		return VM_FAULT_SIGBUS;
 	}
=20
-	*pfn =3D phys_to_pfn_t(phys, dax_region->pfn_flags);
+	*pfn =3D phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
=20
 	return vmf_insert_pfn_pud(vmf, *pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
--- a/drivers/dax/hmem/hmem.c~device-dax-drop-the-dax_regionpfn_flags-attri=
bute
+++ a/drivers/dax/hmem/hmem.c
@@ -22,7 +22,7 @@ static int dax_hmem_probe(struct platfor
 	memcpy(&pgmap.res, res, sizeof(*res));
=20
 	dax_region =3D alloc_dax_region(dev, pdev->id, res, mri->target_node,
-			PMD_SIZE, PFN_DEV|PFN_MAP);
+			PMD_SIZE);
 	if (!dax_region)
 		return -ENOMEM;
=20
--- a/drivers/dax/pmem/core.c~device-dax-drop-the-dax_regionpfn_flags-attri=
bute
+++ a/drivers/dax/pmem/core.c
@@ -53,8 +53,7 @@ struct dev_dax *__dax_pmem_probe(struct
 	memcpy(&res, &pgmap.res, sizeof(res));
 	res.start +=3D offset;
 	dax_region =3D alloc_dax_region(dev, region_id, &res,
-			nd_region->target_node, le32_to_cpu(pfn_sb->align),
-			PFN_DEV|PFN_MAP);
+			nd_region->target_node, le32_to_cpu(pfn_sb->align));
 	if (!dax_region)
 		return ERR_PTR(-ENOMEM);
=20
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


