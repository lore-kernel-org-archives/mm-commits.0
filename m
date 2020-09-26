Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05FEC4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A2E20BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087150;
	bh=TpSjhzycyNXvNc2nhpu+vmaIIWj7HLGXvkElUMmdZHc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m/gGJfcGLp/DSnuJv30hOoDEZOVzl1+RTI+5iT76ktgFYRtOosXVsIjGbgEW2o5Pu
	 7CTmGzm75+IaPiLPIX1dHNloxRz+S7lTWWfvKO227cU4tw3NE0uY7/5yX//Apap8w3
	 2V2z3tk5avX+UVwUdc3umGccZ8INlyjwLLUrozCE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbgIZCZu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIZCZu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:50 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C80A20866;
        Sat, 26 Sep 2020 02:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087149;
        bh=TpSjhzycyNXvNc2nhpu+vmaIIWj7HLGXvkElUMmdZHc=;
        h=Date:From:To:Subject:From;
        b=uhEOrS2RslJicvmietf9b7NO7r/03VrUXvMOy7rp1mIp3LDRzB91+nNVqjCjZk1ny
         7n64ldSnUzXjZHB/LzV1boSQZkJ8y4yeHDpPVxhljKoAugAQeeO9kroZvHYy6GeAos
         XlkaoOu0anHbc0dA4jk6p4WI4nGITHlXgfjxyVhs=
Date:   Fri, 25 Sep 2020 19:25:46 -0700
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
Subject:  + dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
 added to -mm tree
Message-ID: <20200926022546.84plV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax/hmem: introduce dax_hmem.region_idle parameter
has been added to the -mm tree.  Its filename is
     dax-hmem-introduce-dax_hmemregion_idle-parameter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dax-hmem-introduce-dax_hmemre=
gion_idle-parameter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dax-hmem-introduce-dax_hmemre=
gion_idle-parameter.patch

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
Subject: dax/hmem: introduce dax_hmem.region_idle parameter

Introduce a new module parameter for dax_hmem which initializes all region
devices as free, rather than allocating a pagemap for the region by
default.

All hmem devices created with dax_hmem.region_idle=3D1 will have full
available size for creating dynamic dax devices.

Link: https://lkml.kernel.org/r/159643106460.4062302.5868522341307530091.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-4-joao.m.martins@oracl=
e.com
Link: https://lkml.kernel.org/r/160106119033.30709.11249962152222193448.stg=
it@dwillia2-desk3.amr.corp.intel.com
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

 drivers/dax/hmem/hmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dax/hmem/hmem.c~dax-hmem-introduce-dax_hmemregion_idle-parame=
ter
+++ a/drivers/dax/hmem/hmem.c
@@ -5,6 +5,9 @@
 #include <linux/pfn_t.h>
 #include "../bus.h"
=20
+static bool region_idle;
+module_param_named(region_idle, region_idle, bool, 0644);
+
 static int dax_hmem_probe(struct platform_device *pdev)
 {
 	struct device *dev =3D &pdev->dev;
@@ -30,7 +33,7 @@ static int dax_hmem_probe(struct platfor
 	data =3D (struct dev_dax_data) {
 		.dax_region =3D dax_region,
 		.id =3D -1,
-		.size =3D resource_size(res),
+		.size =3D region_idle ? 0 : resource_size(res),
 	};
 	dev_dax =3D devm_create_dev_dax(&data);
 	if (IS_ERR(dev_dax))
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device-fix.=
patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
device-dax-make-align-a-per-device-property.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

