Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF45C35268
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB4CA21D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633207;
	bh=sun0mQETdRWCmBllFVKoDr3NvtgbsoGF3Y6laN4Q41M=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=amp+xV/jxaLFyPw4sF4uza63OEVlICrJbpxscmP5DcP6cnRv6gZIzj5dhMYnmaj1o
	 DWKPjKuE8bS7/hPIGCmWi/nojIruiHGyOR94DNOeFrgGhJNSOyqDS4fm8u4+O85QLo
	 +IN58N2pmtWp9XXf2cE/ipqHbqbakaTF9fEZzuKU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgJMXx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgJMXtQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:49:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A440421D81;
        Tue, 13 Oct 2020 23:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632955;
        bh=sun0mQETdRWCmBllFVKoDr3NvtgbsoGF3Y6laN4Q41M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GosMy3K8m/xcj48JN9aZi4oL6sb00Z79hy44zJB7xK/E+y1mZrDg7Y1+6Aidoka3D
         BDyp7k00hU05b8sqxgQX0wbGlRtznNRseU4kgz2IHL93GPTQd1Tij6OKlYo9HN0/p0
         6v+JIsDF5gaxpxnndL+hbyhBQErU99L8V6Ia3YwE=
Date:   Tue, 13 Oct 2020 16:49:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org,
        ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, linux-mm@kvack.org, lkp@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, pasha.tatashin@soleen.com, paulus@ozlabs.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rdunlap@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@linux.ibm.com, sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, torvalds@linux-foundation.org,
        vgoyal@redhat.com, vishal.l.verma@intel.com, will@kernel.org,
        yanaijie@huawei.com
Subject:  [patch 029/181] ACPI: HMAT: refactor
 hmat_register_target_device to hmem_register_device
Message-ID: <20201013234913.Im0fMSgJl%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: ACPI: HMAT: refactor hmat_register_target_device to hmem_register_=
device

In preparation for exposing "Soft Reserved" memory ranges without an HMAT,
move the hmem device registration to its own compilation unit and make the
implementation generic.

The generic implementation drops usage acpi_map_pxm_to_online_node() that
was translating ACPI proximity domain values and instead relies on
numa_map_to_online_node() to determine the numa node for the device.

[joao.m.martins@oracle.com: CONFIG_DEV_DAX_HMEM_DEVICES should depend on CO=
NFIG_DAX=3Dy]
  Link: https://lkml.kernel.org/r/8f34727f-ec2d-9395-cb18-969ec8a5d0d4@orac=
le.com
Link: https://lkml.kernel.org/r/159643096584.4062302.5035370788475153738.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/158318761484.2216124.2049322072599482736.st=
git@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
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
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
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

 drivers/acpi/numa/hmat.c  |   68 +++---------------------------------
 drivers/dax/Kconfig       |    4 ++
 drivers/dax/Makefile      |    3 -
 drivers/dax/hmem.c        |   56 -----------------------------
 drivers/dax/hmem/Makefile |    5 ++
 drivers/dax/hmem/device.c |   65 ++++++++++++++++++++++++++++++++++
 drivers/dax/hmem/hmem.c   |   56 +++++++++++++++++++++++++++++
 include/linux/dax.h       |    8 ++++
 8 files changed, 145 insertions(+), 120 deletions(-)

--- a/drivers/acpi/numa/hmat.c~acpi-hmat-refactor-hmat_register_target_devi=
ce-to-hmem_register_device
+++ a/drivers/acpi/numa/hmat.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/node.h>
 #include <linux/sysfs.h>
+#include <linux/dax.h>
=20
 static u8 hmat_revision;
 static int hmat_disable __initdata;
@@ -640,66 +641,6 @@ static void hmat_register_target_perf(st
 	node_set_perf_attrs(mem_nid, &target->hmem_attrs, 0);
 }
=20
-static void hmat_register_target_device(struct memory_target *target,
-		struct resource *r)
-{
-	/* define a clean / non-busy resource for the platform device */
-	struct resource res =3D {
-		.start =3D r->start,
-		.end =3D r->end,
-		.flags =3D IORESOURCE_MEM,
-	};
-	struct platform_device *pdev;
-	struct memregion_info info;
-	int rc, id;
-
-	rc =3D region_intersects(res.start, resource_size(&res), IORESOURCE_MEM,
-			IORES_DESC_SOFT_RESERVED);
-	if (rc !=3D REGION_INTERSECTS)
-		return;
-
-	id =3D memregion_alloc(GFP_KERNEL);
-	if (id < 0) {
-		pr_err("memregion allocation failure for %pr\n", &res);
-		return;
-	}
-
-	pdev =3D platform_device_alloc("hmem", id);
-	if (!pdev) {
-		pr_err("hmem device allocation failure for %pr\n", &res);
-		goto out_pdev;
-	}
-
-	pdev->dev.numa_node =3D acpi_map_pxm_to_online_node(target->memory_pxm);
-	info =3D (struct memregion_info) {
-		.target_node =3D acpi_map_pxm_to_node(target->memory_pxm),
-	};
-	rc =3D platform_device_add_data(pdev, &info, sizeof(info));
-	if (rc < 0) {
-		pr_err("hmem memregion_info allocation failure for %pr\n", &res);
-		goto out_pdev;
-	}
-
-	rc =3D platform_device_add_resources(pdev, &res, 1);
-	if (rc < 0) {
-		pr_err("hmem resource allocation failure for %pr\n", &res);
-		goto out_resource;
-	}
-
-	rc =3D platform_device_add(pdev);
-	if (rc < 0) {
-		dev_err(&pdev->dev, "device add failed for %pr\n", &res);
-		goto out_resource;
-	}
-
-	return;
-
-out_resource:
-	put_device(&pdev->dev);
-out_pdev:
-	memregion_free(id);
-}
-
 static void hmat_register_target_devices(struct memory_target *target)
 {
 	struct resource *res;
@@ -711,8 +652,11 @@ static void hmat_register_target_devices
 	if (!IS_ENABLED(CONFIG_DEV_DAX_HMEM))
 		return;
=20
-	for (res =3D target->memregions.child; res; res =3D res->sibling)
-		hmat_register_target_device(target, res);
+	for (res =3D target->memregions.child; res; res =3D res->sibling) {
+		int target_nid =3D acpi_map_pxm_to_node(target->memory_pxm);
+
+		hmem_register_device(target_nid, res);
+	}
 }
=20
 static void hmat_register_target(struct memory_target *target)
--- a/drivers/dax/hmem.c
+++ /dev/null
@@ -1,56 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/platform_device.h>
-#include <linux/memregion.h>
-#include <linux/module.h>
-#include <linux/pfn_t.h>
-#include "bus.h"
-
-static int dax_hmem_probe(struct platform_device *pdev)
-{
-	struct device *dev =3D &pdev->dev;
-	struct dev_pagemap pgmap =3D { };
-	struct dax_region *dax_region;
-	struct memregion_info *mri;
-	struct dev_dax *dev_dax;
-	struct resource *res;
-
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOMEM;
-
-	mri =3D dev->platform_data;
-	memcpy(&pgmap.res, res, sizeof(*res));
-
-	dax_region =3D alloc_dax_region(dev, pdev->id, res, mri->target_node,
-			PMD_SIZE, PFN_DEV|PFN_MAP);
-	if (!dax_region)
-		return -ENOMEM;
-
-	dev_dax =3D devm_create_dev_dax(dax_region, 0, &pgmap);
-	if (IS_ERR(dev_dax))
-		return PTR_ERR(dev_dax);
-
-	/* child dev_dax instances now own the lifetime of the dax_region */
-	dax_region_put(dax_region);
-	return 0;
-}
-
-static int dax_hmem_remove(struct platform_device *pdev)
-{
-	/* devm handles teardown */
-	return 0;
-}
-
-static struct platform_driver dax_hmem_driver =3D {
-	.probe =3D dax_hmem_probe,
-	.remove =3D dax_hmem_remove,
-	.driver =3D {
-		.name =3D "hmem",
-	},
-};
-
-module_platform_driver(dax_hmem_driver);
-
-MODULE_ALIAS("platform:hmem*");
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Intel Corporation");
--- /dev/null
+++ a/drivers/dax/hmem/device.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/platform_device.h>
+#include <linux/memregion.h>
+#include <linux/module.h>
+#include <linux/dax.h>
+#include <linux/mm.h>
+
+void hmem_register_device(int target_nid, struct resource *r)
+{
+	/* define a clean / non-busy resource for the platform device */
+	struct resource res =3D {
+		.start =3D r->start,
+		.end =3D r->end,
+		.flags =3D IORESOURCE_MEM,
+	};
+	struct platform_device *pdev;
+	struct memregion_info info;
+	int rc, id;
+
+	rc =3D region_intersects(res.start, resource_size(&res), IORESOURCE_MEM,
+			IORES_DESC_SOFT_RESERVED);
+	if (rc !=3D REGION_INTERSECTS)
+		return;
+
+	id =3D memregion_alloc(GFP_KERNEL);
+	if (id < 0) {
+		pr_err("memregion allocation failure for %pr\n", &res);
+		return;
+	}
+
+	pdev =3D platform_device_alloc("hmem", id);
+	if (!pdev) {
+		pr_err("hmem device allocation failure for %pr\n", &res);
+		goto out_pdev;
+	}
+
+	pdev->dev.numa_node =3D numa_map_to_online_node(target_nid);
+	info =3D (struct memregion_info) {
+		.target_node =3D target_nid,
+	};
+	rc =3D platform_device_add_data(pdev, &info, sizeof(info));
+	if (rc < 0) {
+		pr_err("hmem memregion_info allocation failure for %pr\n", &res);
+		goto out_pdev;
+	}
+
+	rc =3D platform_device_add_resources(pdev, &res, 1);
+	if (rc < 0) {
+		pr_err("hmem resource allocation failure for %pr\n", &res);
+		goto out_resource;
+	}
+
+	rc =3D platform_device_add(pdev);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "device add failed for %pr\n", &res);
+		goto out_resource;
+	}
+
+	return;
+
+out_resource:
+	put_device(&pdev->dev);
+out_pdev:
+	memregion_free(id);
+}
--- /dev/null
+++ a/drivers/dax/hmem/hmem.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/platform_device.h>
+#include <linux/memregion.h>
+#include <linux/module.h>
+#include <linux/pfn_t.h>
+#include "../bus.h"
+
+static int dax_hmem_probe(struct platform_device *pdev)
+{
+	struct device *dev =3D &pdev->dev;
+	struct dev_pagemap pgmap =3D { };
+	struct dax_region *dax_region;
+	struct memregion_info *mri;
+	struct dev_dax *dev_dax;
+	struct resource *res;
+
+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOMEM;
+
+	mri =3D dev->platform_data;
+	memcpy(&pgmap.res, res, sizeof(*res));
+
+	dax_region =3D alloc_dax_region(dev, pdev->id, res, mri->target_node,
+			PMD_SIZE, PFN_DEV|PFN_MAP);
+	if (!dax_region)
+		return -ENOMEM;
+
+	dev_dax =3D devm_create_dev_dax(dax_region, 0, &pgmap);
+	if (IS_ERR(dev_dax))
+		return PTR_ERR(dev_dax);
+
+	/* child dev_dax instances now own the lifetime of the dax_region */
+	dax_region_put(dax_region);
+	return 0;
+}
+
+static int dax_hmem_remove(struct platform_device *pdev)
+{
+	/* devm handles teardown */
+	return 0;
+}
+
+static struct platform_driver dax_hmem_driver =3D {
+	.probe =3D dax_hmem_probe,
+	.remove =3D dax_hmem_remove,
+	.driver =3D {
+		.name =3D "hmem",
+	},
+};
+
+module_platform_driver(dax_hmem_driver);
+
+MODULE_ALIAS("platform:hmem*");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
--- /dev/null
+++ a/drivers/dax/hmem/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_DEV_DAX_HMEM) +=3D dax_hmem.o
+obj-$(CONFIG_DEV_DAX_HMEM_DEVICES) +=3D device.o
+
+dax_hmem-y :=3D hmem.o
--- a/drivers/dax/Kconfig~acpi-hmat-refactor-hmat_register_target_device-to=
-hmem_register_device
+++ a/drivers/dax/Kconfig
@@ -48,6 +48,10 @@ config DEV_DAX_HMEM
=20
 	  Say M if unsure.
=20
+config DEV_DAX_HMEM_DEVICES
+	depends on DEV_DAX_HMEM && DAX=3Dy
+	def_bool y
+
 config DEV_DAX_KMEM
 	tristate "KMEM DAX: volatile-use of persistent memory"
 	default DEV_DAX
--- a/drivers/dax/Makefile~acpi-hmat-refactor-hmat_register_target_device-t=
o-hmem_register_device
+++ a/drivers/dax/Makefile
@@ -2,11 +2,10 @@
 obj-$(CONFIG_DAX) +=3D dax.o
 obj-$(CONFIG_DEV_DAX) +=3D device_dax.o
 obj-$(CONFIG_DEV_DAX_KMEM) +=3D kmem.o
-obj-$(CONFIG_DEV_DAX_HMEM) +=3D dax_hmem.o
=20
 dax-y :=3D super.o
 dax-y +=3D bus.o
 device_dax-y :=3D device.o
-dax_hmem-y :=3D hmem.o
=20
 obj-y +=3D pmem/
+obj-y +=3D hmem/
--- a/include/linux/dax.h~acpi-hmat-refactor-hmat_register_target_device-to=
-hmem_register_device
+++ a/include/linux/dax.h
@@ -238,4 +238,12 @@ static inline bool dax_mapping(struct ad
 	return mapping->host && IS_DAX(mapping->host);
 }
=20
+#ifdef CONFIG_DEV_DAX_HMEM_DEVICES
+void hmem_register_device(int target_nid, struct resource *r);
+#else
+static inline void hmem_register_device(int target_nid, struct resource *r)
+{
+}
+#endif
+
 #endif
_
