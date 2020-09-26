Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F362BC4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0DAA20BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087087;
	bh=frZMS9CPTK+ARLdxYO3j3NA9rD/bXDO7kbL/CswGjkc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lE5ksytb8ub0hTHAosM73CTAwEmvMppubf+Z2NYEEWw+359/2jbdGU8xP0pD1t+3a
	 ulBMN+rmHJ2IIhLVpIRG7hAFQjWUbUVe3Y2goCidsGLNHMEhcArZEy7iw3BfiSIF1w
	 9rMMyN3M+QRii7UMSPx204RQekGo2dU0m2yLmzJg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgIZCYr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgIZCYr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:24:47 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212A920866;
        Sat, 26 Sep 2020 02:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087086;
        bh=frZMS9CPTK+ARLdxYO3j3NA9rD/bXDO7kbL/CswGjkc=;
        h=Date:From:To:Subject:From;
        b=fFlbRq66GoCVQSBcyjLjWrMfmKHLSOCQTxFC2UDFB+ObwvMfuQGh3Gl4amacBwPda
         EoHNaGMM0FjMrpugWS3qvhMspMyJxBGWrMHH4htCe/SMEmnOp5qGfiHTZoIQXentfM
         9TWjrm/rIGyxY3eiEUyw8ikfwTFZDzceRmTIWIBo=
Date:   Fri, 25 Sep 2020 19:24:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yanaijie@huawei.com, will@kernel.org,
        vishal.l.verma@intel.com, vgoyal@redhat.com,
        thomas.lendacky@amd.com, tglx@linutronix.de,
        sstabellini@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@linux.alibaba.com, rdunlap@infradead.org,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        paulus@ozlabs.org, pasha.tatashin@soleen.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, lkp@intel.com,
        justin.he@arm.com, Jonathan.Cameron@huawei.com,
        joao.m.martins@oracle.com, jmoyer@redhat.com, jgross@suse.com,
        jglisse@redhat.com, jgg@mellanox.com, ira.weiny@intel.com,
        hulkci@huawei.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        david@redhat.com, dave.jiang@intel.com,
        dave.hansen@linux.intel.com, daniel@ffwll.ch,
        catalin.marinas@arm.com, bskeggs@redhat.com, Brice.Goglin@inria.fr,
        bp@alien8.de, boris.ostrovsky@oracle.com, bhelgaas@google.com,
        benh@kernel.crashing.org, ardb@kernel.org,
        ard.biesheuvel@linaro.org, airlied@linux.ie,
        dan.j.williams@intel.com
Subject:  +
 device-dax-kmem-replace-release_resource-with-release_mem_region.patch added
 to -mm tree
Message-ID: <20200926022443.lNatA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax/kmem: replace release_resource() with release_mem_=
region()
has been added to the -mm tree.  Its filename is
     device-dax-kmem-replace-release_resource-with-release_mem_region.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-kmem-replace-relea=
se_resource-with-release_mem_region.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-kmem-replace-relea=
se_resource-with-release_mem_region.patch

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
From: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax/kmem: replace release_resource() with release_mem_regio=
n()

Towards removing the mode specific @dax_kmem_res attribute from the
generic 'struct dev_dax', and preparing for multi-range support, change
the kmem driver to use the idiomatic release_mem_region() to pair with the
initial request_mem_region().  This also eliminates the need to open code
the release of the resource allocated by request_mem_region().

As there are no more dax_kmem_res users, delete this struct member.

Link: https://lkml.kernel.org/r/160106112239.30709.15909567572288425294.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/dax-private.h |    3 ---
 drivers/dax/kmem.c        |   20 +++++++-------------
 2 files changed, 7 insertions(+), 16 deletions(-)

--- a/drivers/dax/dax-private.h~device-dax-kmem-replace-release_resource-wi=
th-release_mem_region
+++ a/drivers/dax/dax-private.h
@@ -42,8 +42,6 @@ struct dax_region {
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
  * @range: resource range for the instance
- * @dax_mem_res: physical address range of hotadded DAX memory
- * @dax_mem_name: name for hotadded DAX memory via add_memory_driver_manag=
ed()
  */
 struct dev_dax {
 	struct dax_region *region;
@@ -52,7 +50,6 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	struct range range;
-	struct resource *dax_kmem_res;
 };
=20
 static inline u64 range_len(struct range *range)
--- a/drivers/dax/kmem.c~device-dax-kmem-replace-release_resource-with-rele=
ase_mem_region
+++ a/drivers/dax/kmem.c
@@ -33,7 +33,7 @@ int dev_dax_kmem_probe(struct device *de
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct range range =3D dax_kmem_range(dev_dax);
-	struct resource *new_res;
+	struct resource *res;
 	char *res_name;
 	int numa_node;
 	int rc;
@@ -56,8 +56,8 @@ int dev_dax_kmem_probe(struct device *de
 		return -ENOMEM;
=20
 	/* Region is permanently reserved if hotremove fails. */
-	new_res =3D request_mem_region(range.start, range_len(&range), res_name);
-	if (!new_res) {
+	res =3D request_mem_region(range.start, range_len(&range), res_name);
+	if (!res) {
 		dev_warn(dev, "could not reserve region [%#llx-%#llx]\n", range.start, r=
ange.end);
 		kfree(res_name);
 		return -EBUSY;
@@ -69,23 +69,20 @@ int dev_dax_kmem_probe(struct device *de
 	 * inherit flags from the parent since it may set new flags
 	 * unknown to us that will break add_memory() below.
 	 */
-	new_res->flags =3D IORESOURCE_SYSTEM_RAM;
+	res->flags =3D IORESOURCE_SYSTEM_RAM;
=20
 	/*
 	 * Ensure that future kexec'd kernels will not treat this as RAM
 	 * automatically.
 	 */
-	rc =3D add_memory_driver_managed(numa_node, new_res->start,
-				       resource_size(new_res), kmem_name);
+	rc =3D add_memory_driver_managed(numa_node, range.start, range_len(&range=
), kmem_name);
 	if (rc) {
-		release_resource(new_res);
-		kfree(new_res);
+		release_mem_region(range.start, range_len(&range));
 		kfree(res_name);
 		return rc;
 	}
=20
 	dev_set_drvdata(dev, res_name);
-	dev_dax->dax_kmem_res =3D new_res;
=20
 	return 0;
 }
@@ -95,7 +92,6 @@ static int dev_dax_kmem_remove(struct de
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct range range =3D dax_kmem_range(dev_dax);
-	struct resource *res =3D dev_dax->dax_kmem_res;
 	const char *res_name =3D dev_get_drvdata(dev);
 	int rc;
=20
@@ -114,10 +110,8 @@ static int dev_dax_kmem_remove(struct de
 	}
=20
 	/* Release and free dax resources */
-	release_resource(res);
-	kfree(res);
+	release_mem_region(range.start, range_len(&range));
 	kfree(res_name);
-	dev_dax->dax_kmem_res =3D NULL;
=20
 	return 0;
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

x86-numa-cleanup-configuration-dependent-command-line-options.patch
x86-numa-add-nohmat-option.patch
efi-fake_mem-arrange-for-a-resource-entry-per-efi_fake_mem-instance.patch
acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device.patch
resource-report-parent-to-walk_iomem_res_desc-callback.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range.patch
device-dax-drop-the-dax_regionpfn_flags-attribute.patch
device-dax-move-instance-creation-parameters-to-struct-dev_dax_data.patch
device-dax-make-pgmap-optional-for-instance-creation.patch
device-dax-kmem-introduce-dax_kmem_range.patch
device-dax-kmem-move-resource-name-tracking-to-drvdata.patch
device-dax-kmem-replace-release_resource-with-release_mem_region.patch
device-dax-add-an-allocation-interface-for-device-dax-instances.patch
device-dax-introduce-struct-dev_dax-typed-driver-operations.patch
device-dax-introduce-seed-devices.patch
drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inputs.pa=
tch
device-dax-add-resize-support.patch
mm-memremap_pages-convert-to-struct-range.patch
mm-memremap_pages-support-multiple-ranges-per-invocation.patch
device-dax-add-dis-contiguous-resource-support.patch
device-dax-introduce-mapping-devices.patch
device-dax-add-an-align-attribute.patch

