Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDD8C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D073420725
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709042;
	bh=6wob70EF6Q4SX7dFdtl4n6Aosjzeh4GrsvLQuIA8yLM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UrOSC+NL6figoEwcLm6JsUiGAp7ef6TMN2O95WW1VWzm69mE6Mrwy1v+ExVCx9m4i
	 de2vRQal9hoBZNOnhhD8cikxz7YMdfeLGjs939POLg0zt/maTFeozb0k0AJN+aKCaX
	 bcmmPHiILybIk2XirWYUEkzLmCnBbhJ+3Y33e8a8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbgJNU5W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:57:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU5W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:57:22 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1152224E;
        Wed, 14 Oct 2020 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709041;
        bh=6wob70EF6Q4SX7dFdtl4n6Aosjzeh4GrsvLQuIA8yLM=;
        h=Date:From:To:Subject:From;
        b=jOOlcanuSZJ+LJF6sSoBlQCwPLv9T6yNBfI639lzDrGn87jbi4jtVNLAvrs6L7GUp
         Wh1Bb0RdKWL8ug0SJOLoN6emY/2eqD2x9GNMTAOH/H5WP5N0T7fKrBLYkrFOHY5sJ9
         QWZ6XC7e5nYTMrep4km/Ux4mUdLDS16xkH2JiEUs=
Date:   Wed, 14 Oct 2020 13:57:18 -0700
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
 device-dax-move-instance-creation-parameters-to-struct-dev_dax_data.patch
 removed from -mm tree
Message-ID: <20201014205718.uanpOsG_n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: move instance creation parameters to 'struct dev_=
dax_data'
has been removed from the -mm tree.  Its filename was
     device-dax-move-instance-creation-parameters-to-struct-dev_dax_data.pa=
tch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: move instance creation parameters to 'struct dev_dax_d=
ata'

In preparation for adding more parameters to instance creation, move
existing parameters to a new struct.

Link: https://lkml.kernel.org/r/159643099411.4062302.1337305960720423895.st=
git@dwillia2-desk3.amr.corp.intel.com
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

 drivers/dax/bus.c       |   14 +++++++-------
 drivers/dax/bus.h       |   16 ++++++++--------
 drivers/dax/hmem/hmem.c |    8 +++++++-
 drivers/dax/pmem/core.c |    9 ++++++++-
 4 files changed, 30 insertions(+), 17 deletions(-)

--- a/drivers/dax/bus.c~device-dax-move-instance-creation-parameters-to-str=
uct-dev_dax_data
+++ a/drivers/dax/bus.c
@@ -395,9 +395,9 @@ static void unregister_dev_dax(void *dev
 	put_device(dev);
 }
=20
-struct dev_dax *__devm_create_dev_dax(struct dax_region *dax_region, int i=
d,
-		struct dev_pagemap *pgmap, enum dev_dax_subsys subsys)
+struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 {
+	struct dax_region *dax_region =3D data->dax_region;
 	struct device *parent =3D dax_region->dev;
 	struct dax_device *dax_dev;
 	struct dev_dax *dev_dax;
@@ -405,14 +405,14 @@ struct dev_dax *__devm_create_dev_dax(st
 	struct device *dev;
 	int rc =3D -ENOMEM;
=20
-	if (id < 0)
+	if (data->id < 0)
 		return ERR_PTR(-EINVAL);
=20
 	dev_dax =3D kzalloc(sizeof(*dev_dax), GFP_KERNEL);
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
=20
-	memcpy(&dev_dax->pgmap, pgmap, sizeof(*pgmap));
+	memcpy(&dev_dax->pgmap, data->pgmap, sizeof(struct dev_pagemap));
=20
 	/*
 	 * No 'host' or dax_operations since there is no access to this
@@ -438,13 +438,13 @@ struct dev_dax *__devm_create_dev_dax(st
=20
 	inode =3D dax_inode(dax_dev);
 	dev->devt =3D inode->i_rdev;
-	if (subsys =3D=3D DEV_DAX_BUS)
+	if (data->subsys =3D=3D DEV_DAX_BUS)
 		dev->bus =3D &dax_bus_type;
 	else
 		dev->class =3D dax_class;
 	dev->parent =3D parent;
 	dev->type =3D &dev_dax_type;
-	dev_set_name(dev, "dax%d.%d", dax_region->id, id);
+	dev_set_name(dev, "dax%d.%d", dax_region->id, data->id);
=20
 	rc =3D device_add(dev);
 	if (rc) {
@@ -464,7 +464,7 @@ struct dev_dax *__devm_create_dev_dax(st
=20
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_GPL(__devm_create_dev_dax);
+EXPORT_SYMBOL_GPL(devm_create_dev_dax);
=20
 static int match_always_count;
=20
--- a/drivers/dax/bus.h~device-dax-move-instance-creation-parameters-to-str=
uct-dev_dax_data
+++ a/drivers/dax/bus.h
@@ -13,18 +13,18 @@ struct dax_region *alloc_dax_region(stru
 		struct resource *res, int target_node, unsigned int align);
=20
 enum dev_dax_subsys {
-	DEV_DAX_BUS,
+	DEV_DAX_BUS =3D 0, /* zeroed dev_dax_data picks this by default */
 	DEV_DAX_CLASS,
 };
=20
-struct dev_dax *__devm_create_dev_dax(struct dax_region *dax_region, int i=
d,
-		struct dev_pagemap *pgmap, enum dev_dax_subsys subsys);
+struct dev_dax_data {
+	struct dax_region *dax_region;
+	struct dev_pagemap *pgmap;
+	enum dev_dax_subsys subsys;
+	int id;
+};
=20
-static inline struct dev_dax *devm_create_dev_dax(struct dax_region *dax_r=
egion,
-		int id, struct dev_pagemap *pgmap)
-{
-	return __devm_create_dev_dax(dax_region, id, pgmap, DEV_DAX_BUS);
-}
+struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
=20
 /* to be deleted when DEV_DAX_CLASS is removed */
 struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys s=
ubsys);
--- a/drivers/dax/hmem/hmem.c~device-dax-move-instance-creation-parameters-=
to-struct-dev_dax_data
+++ a/drivers/dax/hmem/hmem.c
@@ -11,6 +11,7 @@ static int dax_hmem_probe(struct platfor
 	struct dev_pagemap pgmap =3D { };
 	struct dax_region *dax_region;
 	struct memregion_info *mri;
+	struct dev_dax_data data;
 	struct dev_dax *dev_dax;
 	struct resource *res;
=20
@@ -26,7 +27,12 @@ static int dax_hmem_probe(struct platfor
 	if (!dax_region)
 		return -ENOMEM;
=20
-	dev_dax =3D devm_create_dev_dax(dax_region, 0, &pgmap);
+	data =3D (struct dev_dax_data) {
+		.dax_region =3D dax_region,
+		.id =3D 0,
+		.pgmap =3D &pgmap,
+	};
+	dev_dax =3D devm_create_dev_dax(&data);
 	if (IS_ERR(dev_dax))
 		return PTR_ERR(dev_dax);
=20
--- a/drivers/dax/pmem/core.c~device-dax-move-instance-creation-parameters-=
to-struct-dev_dax_data
+++ a/drivers/dax/pmem/core.c
@@ -14,6 +14,7 @@ struct dev_dax *__dax_pmem_probe(struct
 	resource_size_t offset;
 	struct nd_pfn_sb *pfn_sb;
 	struct dev_dax *dev_dax;
+	struct dev_dax_data data;
 	struct nd_namespace_io *nsio;
 	struct dax_region *dax_region;
 	struct dev_pagemap pgmap =3D { };
@@ -57,7 +58,13 @@ struct dev_dax *__dax_pmem_probe(struct
 	if (!dax_region)
 		return ERR_PTR(-ENOMEM);
=20
-	dev_dax =3D __devm_create_dev_dax(dax_region, id, &pgmap, subsys);
+	data =3D (struct dev_dax_data) {
+		.dax_region =3D dax_region,
+		.id =3D id,
+		.pgmap =3D &pgmap,
+		.subsys =3D subsys,
+	};
+	dev_dax =3D devm_create_dev_dax(&data);
=20
 	/* child dev_dax instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


