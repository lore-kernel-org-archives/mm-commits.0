Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0AAC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA3C2076D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709056;
	bh=+Js5/mb/1opbqMOuqSIwaNV/EwNmXtkCK2LkEE6cOF4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XRBA9CnotBh8UWF2uqhbNACED479/XUiGDciQ+MkLb9NQMFM96tx+Jl5TWI5YTXeU
	 ie+RPWYxoUQwA+qbZx6QYxpalFRaHMi/jlppVNdj3ln1wC+sZKWbn1TAWISRybvOJl
	 hnqTk0dlHHdJgKqLTWC1P3cL08JLWgOy/L4fVAFQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389095AbgJNU5g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU5g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:57:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F3382224D;
        Wed, 14 Oct 2020 20:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709055;
        bh=+Js5/mb/1opbqMOuqSIwaNV/EwNmXtkCK2LkEE6cOF4=;
        h=Date:From:To:Subject:From;
        b=PyeBF407UYqhTUw3iAlY7tMdQkjbyhm2uUsPLOsBbvqSuid3wWlzGo0jz5+ArzLYs
         +mDgmxfPNa8FoSJS9QEOhOhXoi3zRFly1/X0zydeYYDwmoSmU5Blzkyj7cFjedD2qT
         Lcl3b2Qcdl3QExgnmPSaTAp5VFJKImkkrhBcvtXs=
Date:   Wed, 14 Oct 2020 13:57:32 -0700
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
 device-dax-kmem-move-resource-name-tracking-to-drvdata.patch removed from
 -mm tree
Message-ID: <20201014205732.M8nRiIAyA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax/kmem: move resource name tracking to drvdata
has been removed from the -mm tree.  Its filename was
     device-dax-kmem-move-resource-name-tracking-to-drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax/kmem: move resource name tracking to drvdata

Towards removing the mode specific @dax_kmem_res attribute from the
generic 'struct dev_dax', and preparing for multi-range support, move
resource name tracking to driver data.  The memory for the resource name
needs to have its own lifetime separate from the device bind lifetime for
cases where the driver is unbound, but the kmem range could not be
unplugged from the page allocator.

Link: https://lkml.kernel.org/r/160106111639.30709.17624822766862009183.stg=
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

 drivers/dax/kmem.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/dax/kmem.c~device-dax-kmem-move-resource-name-tracking-to-drv=
data
+++ a/drivers/dax/kmem.c
@@ -34,7 +34,7 @@ int dev_dax_kmem_probe(struct device *de
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct range range =3D dax_kmem_range(dev_dax);
 	struct resource *new_res;
-	const char *new_res_name;
+	char *res_name;
 	int numa_node;
 	int rc;
=20
@@ -51,15 +51,15 @@ int dev_dax_kmem_probe(struct device *de
 		return -EINVAL;
 	}
=20
-	new_res_name =3D kstrdup(dev_name(dev), GFP_KERNEL);
-	if (!new_res_name)
+	res_name =3D kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!res_name)
 		return -ENOMEM;
=20
 	/* Region is permanently reserved if hotremove fails. */
-	new_res =3D request_mem_region(range.start, range_len(&range), new_res_na=
me);
+	new_res =3D request_mem_region(range.start, range_len(&range), res_name);
 	if (!new_res) {
 		dev_warn(dev, "could not reserve region [%#llx-%#llx]\n", range.start, r=
ange.end);
-		kfree(new_res_name);
+		kfree(res_name);
 		return -EBUSY;
 	}
=20
@@ -80,9 +80,11 @@ int dev_dax_kmem_probe(struct device *de
 	if (rc) {
 		release_resource(new_res);
 		kfree(new_res);
-		kfree(new_res_name);
+		kfree(res_name);
 		return rc;
 	}
+
+	dev_set_drvdata(dev, res_name);
 	dev_dax->dax_kmem_res =3D new_res;
=20
 	return 0;
@@ -94,7 +96,7 @@ static int dev_dax_kmem_remove(struct de
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct range range =3D dax_kmem_range(dev_dax);
 	struct resource *res =3D dev_dax->dax_kmem_res;
-	const char *res_name =3D res->name;
+	const char *res_name =3D dev_get_drvdata(dev);
 	int rc;
=20
 	/*
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


