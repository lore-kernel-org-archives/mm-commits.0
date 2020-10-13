Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B6DC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B04102222C
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633013;
	bh=k5MRtz2FmH2p/WutJa1cpFq/QS3FIU9bXcdzbbLUwGY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jO7CZzedrhl8QIMyvpgahamPLFpNq65OtWfW7wyBkF/aZkfYNr9MhKkAAdRso9Nor
	 Z4575cXN0Rj7fg5w3uvdDlWmVu4ln0Q288VAobVVrpmSJW0DCPxz0ZgWbZ8Cx3SiT8
	 aRoOBlV8aqtJNuIEOIDXUMhQvZjFd/geN/xq15fY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgJMXuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbgJMXuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:50:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9396221FF;
        Tue, 13 Oct 2020 23:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633000;
        bh=k5MRtz2FmH2p/WutJa1cpFq/QS3FIU9bXcdzbbLUwGY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tdWl3Rb1VH1gAbB+d2aoflJ0NJKf0QjrYHr4iDfimecT+PBzEgjuMuvi1uRUqfoUt
         nX4jxn7Kxv74inD4n/DvloonjjMn7cbhYYlbDEir0pI4tQkVM9DueTLMN5mnit0snT
         cYXjEp5YhnZF3vohDHTy6uJC7+Q3E+th8bbBL5VQ=
Date:   Tue, 13 Oct 2020 16:49:58 -0700
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
Subject:  [patch 038/181] device-dax/kmem: replace
 release_resource() with release_mem_region()
Message-ID: <20201013234958.FOTI8zIwm%akpm@linux-foundation.org>
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
