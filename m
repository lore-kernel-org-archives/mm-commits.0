Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA7CC4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB3E21741
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087097;
	bh=aj9rlcgTSN7yIxYZ72gS0vAq7JFamJaemGlWA+4lzCw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Jdx3u4CDMZz4RgXCrsNgWTMDWFacb2Dui8ziy9vUpJchMoyDkjuUh2wUeCrP7x55Z
	 WmoVRT5aHW59+CO7YhZV0IuCVEwRd3jUzN7YriglgCN9i8A5lktjthjD8agXqngLU6
	 jKWgUGYF2yz1W5bwY8s3RRFXxBuH/BCP71tuiznw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgIZCY5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgIZCY5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:24:57 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 285EE20936;
        Sat, 26 Sep 2020 02:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087096;
        bh=aj9rlcgTSN7yIxYZ72gS0vAq7JFamJaemGlWA+4lzCw=;
        h=Date:From:To:Subject:From;
        b=a6xR0xF76Px6xJibqG8y9JakUx1SE6EX9ikZCArDI0n2b0vJYlNAdCIumAIzov6wA
         EzSHcuAL/wySuOMLgwNOuvCrKb0xSmj/0vW4XluKVqzln8+Q32KBq3hlBx+C2D1FUl
         FjK7Q4KAcYv8eOxxltq1Ra+nEbp5C/n3iu22twCk=
Date:   Fri, 25 Sep 2020 19:24:53 -0700
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
 device-dax-introduce-struct-dev_dax-typed-driver-operations.patch added to
 -mm tree
Message-ID: <20200926022453.gtMN7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: introduce 'struct dev_dax' typed-driver operations
has been added to the -mm tree.  Its filename is
     device-dax-introduce-struct-dev_dax-typed-driver-operations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-introduce-struct-d=
ev_dax-typed-driver-operations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-introduce-struct-d=
ev_dax-typed-driver-operations.patch

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
Subject: device-dax: introduce 'struct dev_dax' typed-driver operations

In preparation for introducing seed devices the dax-bus core needs to be
able to intercept ->probe() and ->remove() operations.  Towards that end
arrange for the bus and drivers to switch from raw 'struct device' driver
operations to 'struct dev_dax' typed operations.

Link: https://lkml.kernel.org/r/160106113357.30709.4541750544799737855.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
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
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |   18 ++++++++++++++++++
 drivers/dax/bus.h         |    4 +++-
 drivers/dax/device.c      |   12 +++++-------
 drivers/dax/kmem.c        |   18 ++++++++----------
 drivers/dax/pmem/compat.c |    2 +-
 5 files changed, 35 insertions(+), 19 deletions(-)

--- a/drivers/dax/bus.c~device-dax-introduce-struct-dev_dax-typed-driver-op=
erations
+++ a/drivers/dax/bus.c
@@ -135,10 +135,28 @@ static bool is_static(struct dax_region
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) !=3D 0;
 }
=20
+static int dax_bus_probe(struct device *dev)
+{
+	struct dax_device_driver *dax_drv =3D to_dax_drv(dev->driver);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+
+	return dax_drv->probe(dev_dax);
+}
+
+static int dax_bus_remove(struct device *dev)
+{
+	struct dax_device_driver *dax_drv =3D to_dax_drv(dev->driver);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+
+	return dax_drv->remove(dev_dax);
+}
+
 static struct bus_type dax_bus_type =3D {
 	.name =3D "dax",
 	.uevent =3D dax_bus_uevent,
 	.match =3D dax_bus_match,
+	.probe =3D dax_bus_probe,
+	.remove =3D dax_bus_remove,
 	.drv_groups =3D dax_drv_groups,
 };
=20
--- a/drivers/dax/bus.h~device-dax-introduce-struct-dev_dax-typed-driver-op=
erations
+++ a/drivers/dax/bus.h
@@ -38,6 +38,8 @@ struct dax_device_driver {
 	struct device_driver drv;
 	struct list_head ids;
 	int match_always;
+	int (*probe)(struct dev_dax *dev);
+	int (*remove)(struct dev_dax *dev);
 };
=20
 int __dax_driver_register(struct dax_device_driver *dax_drv,
@@ -48,7 +50,7 @@ void dax_driver_unregister(struct dax_de
 void kill_dev_dax(struct dev_dax *dev_dax);
=20
 #if IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
-int dev_dax_probe(struct device *dev);
+int dev_dax_probe(struct dev_dax *dev_dax);
 #endif
=20
 /*
--- a/drivers/dax/device.c~device-dax-introduce-struct-dev_dax-typed-driver=
-operations
+++ a/drivers/dax/device.c
@@ -392,11 +392,11 @@ static void dev_dax_kill(void *dev_dax)
 	kill_dev_dax(dev_dax);
 }
=20
-int dev_dax_probe(struct device *dev)
+int dev_dax_probe(struct dev_dax *dev_dax)
 {
-	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct dax_device *dax_dev =3D dev_dax->dax_dev;
 	struct range *range =3D &dev_dax->range;
+	struct device *dev =3D &dev_dax->dev;
 	struct dev_pagemap *pgmap;
 	struct inode *inode;
 	struct cdev *cdev;
@@ -446,17 +446,15 @@ int dev_dax_probe(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dev_dax_probe);
=20
-static int dev_dax_remove(struct device *dev)
+static int dev_dax_remove(struct dev_dax *dev_dax)
 {
 	/* all probe actions are unwound by devm */
 	return 0;
 }
=20
 static struct dax_device_driver device_dax_driver =3D {
-	.drv =3D {
-		.probe =3D dev_dax_probe,
-		.remove =3D dev_dax_remove,
-	},
+	.probe =3D dev_dax_probe,
+	.remove =3D dev_dax_remove,
 	.match_always =3D 1,
 };
=20
--- a/drivers/dax/kmem.c~device-dax-introduce-struct-dev_dax-typed-driver-o=
perations
+++ a/drivers/dax/kmem.c
@@ -29,10 +29,10 @@ static struct range dax_kmem_range(struc
 	return range;
 }
=20
-int dev_dax_kmem_probe(struct device *dev)
+static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
-	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct range range =3D dax_kmem_range(dev_dax);
+	struct device *dev =3D &dev_dax->dev;
 	struct resource *res;
 	char *res_name;
 	int numa_node;
@@ -88,12 +88,12 @@ int dev_dax_kmem_probe(struct device *de
 }
=20
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static int dev_dax_kmem_remove(struct device *dev)
+static int dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	int rc;
+	struct device *dev =3D &dev_dax->dev;
 	struct range range =3D dax_kmem_range(dev_dax);
 	const char *res_name =3D dev_get_drvdata(dev);
-	int rc;
=20
 	/*
 	 * We have one shot for removing memory, if some memory blocks were not
@@ -116,7 +116,7 @@ static int dev_dax_kmem_remove(struct de
 	return 0;
 }
 #else
-static int dev_dax_kmem_remove(struct device *dev)
+static int dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
@@ -131,10 +131,8 @@ static int dev_dax_kmem_remove(struct de
 #endif /* CONFIG_MEMORY_HOTREMOVE */
=20
 static struct dax_device_driver device_dax_kmem_driver =3D {
-	.drv =3D {
-		.probe =3D dev_dax_kmem_probe,
-		.remove =3D dev_dax_kmem_remove,
-	},
+	.probe =3D dev_dax_kmem_probe,
+	.remove =3D dev_dax_kmem_remove,
 };
=20
 static int __init dax_kmem_init(void)
--- a/drivers/dax/pmem/compat.c~device-dax-introduce-struct-dev_dax-typed-d=
river-operations
+++ a/drivers/dax/pmem/compat.c
@@ -22,7 +22,7 @@ static int dax_pmem_compat_probe(struct
 		return -ENOMEM;
=20
 	device_lock(&dev_dax->dev);
-	rc =3D dev_dax_probe(&dev_dax->dev);
+	rc =3D dev_dax_probe(dev_dax);
 	device_unlock(&dev_dax->dev);
=20
 	devres_close_group(&dev_dax->dev, dev_dax);
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

