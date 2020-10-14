Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1418DC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B000C22255
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709032;
	bh=NUn4jdfHYMB6GUHNcTJwT2A6BWA98Hus4FBXox3EvGE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YHXKcMhhQ4pYcSPpY5/KvymWxBNlC445BMc4CvEO8m7Q5LA8MCOdynQtxSs6a4sS1
	 TCK2WLHHnmP28oWhIM4CBfmRUqDdmOxUTwB6mO+Z1ciNJ/XWqWow39ctxNMhHEMmaW
	 G0sjduXnTJBWemF8k3TRabi08ocGHdJzknPeN7Y4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgJNU5M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730361AbgJNU5M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:57:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A9F22250;
        Wed, 14 Oct 2020 20:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709030;
        bh=NUn4jdfHYMB6GUHNcTJwT2A6BWA98Hus4FBXox3EvGE=;
        h=Date:From:To:Subject:From;
        b=XTv0sNA/Ri7lKjs1l/JRlMFTzYcR85YVhkdueMltdSCsNOo21QL3O7TW/ZuZzMs5A
         jAjKnoFG4BhvXRlAXIpv+7kdOkJjcGJXNBgqjs5M+wDlwf4x2McH/Q6e5kwMWnoxzg
         e7nRGTTGSE5NT/1ETKVLgWLuNshjzRITV2HJIiXo=
Date:   Wed, 14 Oct 2020 13:57:08 -0700
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
 acpi-hmat-attach-a-device-for-each-soft-reserved-range.patch removed from
 -mm tree
Message-ID: <20201014205708.Hd0VoXNuv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ACPI: HMAT: attach a device for each soft-reserved range
has been removed from the -mm tree.  Its filename was
     acpi-hmat-attach-a-device-for-each-soft-reserved-range.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: ACPI: HMAT: attach a device for each soft-reserved range

The hmem enabling in commit cf8741ac57ed ("ACPI: NUMA: HMAT: Register
"soft reserved" memory as an "hmem" device") only registered ranges to the
hmem driver for each soft-reservation that also appeared in the HMAT.=20
While this is meant to encourage platform firmware to "do the right thing"
and publish an HMAT, the corollary is that platforms that fail to publish
an accurate HMAT will strand memory from Linux usage.  Additionally, the
"efi_fake_mem" kernel command line option enabling will strand memory by
default without an HMAT.

Arrange for "soft reserved" memory that goes unclaimed by HMAT entries to
be published as raw resource ranges for the hmem driver to consume.

Include a module parameter to disable either this fallback behavior, or
the hmat enabling from creating hmem devices.  The module parameter
requires the hmem device enabling to have unique name in the module
namespace: "device_hmem".

The driver depends on the architecture providing phys_to_target_node()
which is only x86 via numa_meminfo() and arm64 via a generic memblock
implementation.

[joao.m.martins@oracle.com: require NUMA_KEEP_MEMINFO for phys_to_target_no=
de()]
  Link: https://lkml.kernel.org/r/aaae71a7-4846-f5cc-5acf-cf05fdb1f2dc@orac=
le.com
Link: https://lkml.kernel.org/r/159643098298.4062302.17587338161136144730.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
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
Cc: Jia He <justin.he@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
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

 drivers/dax/Kconfig       |    2 ++
 drivers/dax/hmem/Makefile |    3 ++-
 drivers/dax/hmem/device.c |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

--- a/drivers/dax/hmem/device.c~acpi-hmat-attach-a-device-for-each-soft-res=
erved-range
+++ a/drivers/dax/hmem/device.c
@@ -5,6 +5,9 @@
 #include <linux/dax.h>
 #include <linux/mm.h>
=20
+static bool nohmem;
+module_param_named(disable, nohmem, bool, 0444);
+
 void hmem_register_device(int target_nid, struct resource *r)
 {
 	/* define a clean / non-busy resource for the platform device */
@@ -17,6 +20,9 @@ void hmem_register_device(int target_nid
 	struct memregion_info info;
 	int rc, id;
=20
+	if (nohmem)
+		return;
+
 	rc =3D region_intersects(res.start, resource_size(&res), IORESOURCE_MEM,
 			IORES_DESC_SOFT_RESERVED);
 	if (rc !=3D REGION_INTERSECTS)
@@ -63,3 +69,32 @@ out_resource:
 out_pdev:
 	memregion_free(id);
 }
+
+static __init int hmem_register_one(struct resource *res, void *data)
+{
+	/*
+	 * If the resource is not a top-level resource it was already
+	 * assigned to a device by the HMAT parsing.
+	 */
+	if (res->parent !=3D &iomem_resource) {
+		pr_info("HMEM: skip %pr, already claimed\n", res);
+		return 0;
+	}
+
+	hmem_register_device(phys_to_target_node(res->start), res);
+
+	return 0;
+}
+
+static __init int hmem_init(void)
+{
+	walk_iomem_res_desc(IORES_DESC_SOFT_RESERVED,
+			IORESOURCE_MEM, 0, -1, NULL, hmem_register_one);
+	return 0;
+}
+
+/*
+ * As this is a fallback for address ranges unclaimed by the ACPI HMAT
+ * parsing it must be at an initcall level greater than hmat_init().
+ */
+late_initcall(hmem_init);
--- a/drivers/dax/hmem/Makefile~acpi-hmat-attach-a-device-for-each-soft-res=
erved-range
+++ a/drivers/dax/hmem/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_DEV_DAX_HMEM) +=3D dax_hmem.o
-obj-$(CONFIG_DEV_DAX_HMEM_DEVICES) +=3D device.o
+obj-$(CONFIG_DEV_DAX_HMEM_DEVICES) +=3D device_hmem.o
=20
+device_hmem-y :=3D device.o
 dax_hmem-y :=3D hmem.o
--- a/drivers/dax/Kconfig~acpi-hmat-attach-a-device-for-each-soft-reserved-=
range
+++ a/drivers/dax/Kconfig
@@ -35,6 +35,7 @@ config DEV_DAX_PMEM
 config DEV_DAX_HMEM
 	tristate "HMEM DAX: direct access to 'specific purpose' memory"
 	depends on EFI_SOFT_RESERVE
+	select NUMA_KEEP_MEMINFO if (NUMA && X86)
 	default DEV_DAX
 	help
 	  EFI 2.8 platforms, and others, may advertise 'specific purpose'
@@ -49,6 +50,7 @@ config DEV_DAX_HMEM
 	  Say M if unsure.
=20
 config DEV_DAX_HMEM_DEVICES
+	depends on NUMA_KEEP_MEMINFO # for phys_to_target_node()
 	depends on DEV_DAX_HMEM && DAX=3Dy
 	def_bool y
=20
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


