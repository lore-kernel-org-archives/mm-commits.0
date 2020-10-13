Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27858C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D23E522200
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630175;
	bh=rnmIvU5tSZHaAk9oaPROAQAgWGj5koR/1UG0GX6e6hM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=znk/tMRRZsmz8g5f6STtP69KTlwVCCFmHucD6WLyxa0DKsYn5nba9kT30SOJD5+I/
	 lbdcg3ppymR2iboeMJ7F2WZ9IBrWVwnWofhu37CYflx9daO4GasUB22Pg8q6pGf9ZR
	 s2NRKyQQgI/fB2A9QOBLoZPXq+LvcMKj/SuGUJfA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgJMXCz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXCz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:02:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8DF221D81;
        Tue, 13 Oct 2020 23:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630173;
        bh=rnmIvU5tSZHaAk9oaPROAQAgWGj5koR/1UG0GX6e6hM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zXlSE2XNOhm0p1uIGOw6FTG0fGFlTQZD0G9oiyNn3CmNkmPrO4Q0XGUCdpKFx8fTZ
         IxvVfbB6zi0YeYRpPC3wQ6kP9mEj/SiYM2Uxg6VPjBmd3cU7UNbt0b1MX0JPb0Fk+N
         7JaCmIFF33BM5zFc/7Ht+WYA6ZH/eDls+4lD6gbQ=
Date:   Tue, 13 Oct 2020 16:02:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
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
Subject:  [folded-merged]
 =?US-ASCII?Q?acpi-hmat-refactor-hmat=5Fregister=5Ftarget=5Fdevice-to-hm?=
 =?US-ASCII?Q?em=5Fregister=5Fdevice-fix.patch?= removed from -mm tree
Message-ID: <20201013230251.a57ul8iZN%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: CONFIG_DEV_DAX_HMEM_DEVICES should depend on CONF=
IG_DAX=3Dy
has been removed from the -mm tree.  Its filename was
     acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device=
-fix.patch

This patch was dropped because it was folded into acpi-hmat-refactor-hmat_r=
egister_target_device-to-hmem_register_device.patch

------------------------------------------------------
=46rom: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: CONFIG_DEV_DAX_HMEM_DEVICES should depend on CONFIG_DA=
X=3Dy

HMAT requires hmem_register_device() which is now placed under
drivers/dax.  ACPI_HMAT is a bool and built-in, and to use
hmem_register_device() CONFIG_DAX also needs to be builtin.

Link: https://lkml.kernel.org/r/8f34727f-ec2d-9395-cb18-969ec8a5d0d4@oracle=
.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
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

 drivers/dax/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dax/Kconfig~acpi-hmat-refactor-hmat_register_target_device-to=
-hmem_register_device-fix
+++ a/drivers/dax/Kconfig
@@ -49,7 +49,7 @@ config DEV_DAX_HMEM
 	  Say M if unsure.
=20
 config DEV_DAX_HMEM_DEVICES
-	depends on DEV_DAX_HMEM
+	depends on DEV_DAX_HMEM && DAX=3Dy
 	def_bool y
=20
 config DEV_DAX_KMEM
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch
device-dax-make-align-a-per-device-property.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

