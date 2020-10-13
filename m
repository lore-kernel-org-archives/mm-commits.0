Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE13C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 539F7221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633013;
	bh=kb+37cP8tGnBbkWqfWtyOrM+ey+VGojQtWYp6Co6HKA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GPX5xz22m6ehU1OBf1YSO3rEwb/dK1nd07cxqS43TGCB1CGX0DOx7MsOJiR0r5bbJ
	 UEugLVfpQtDiDJmZf5o2FBv9o2e82ovOqEO016Qu46ToutdLM5beq1Y4fi08y+6+7S
	 gWsgX6S6TV197I1b+R6qhACLvvsDjJcJCEGxE4SY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgJMXuM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730283AbgJMXuL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:50:11 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D636721D81;
        Tue, 13 Oct 2020 23:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633010;
        bh=kb+37cP8tGnBbkWqfWtyOrM+ey+VGojQtWYp6Co6HKA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jzXpHts9YfNx22C3YElMMeB1F188/CcODUI2sbI7/PxJOULQY8zwIJa1EBivVJW1k
         UeGEga4BzsUIFVNDzlY5tCcpFU3JQCxnv87SEeyPGMSlq/+o6PmM7JnkkiieZdsDjA
         7xPP5WPm1mS/9N1tQFzU1a5uVZX5hHLnfQzw1uUw=
Date:   Tue, 13 Oct 2020 16:50:08 -0700
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
Subject:  [patch 040/181] device-dax: introduce 'struct dev_dax'
 typed-driver operations
Message-ID: <20201013235008.3z6q5dQ5s%akpm@linux-foundation.org>
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
