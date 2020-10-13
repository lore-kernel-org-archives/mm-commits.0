Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72D7C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A75A922202
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630254;
	bh=TTNpBTNqyF8x5JcwHGLHQz0tV6BTu1G+EBH3BV1lQBg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=v/q44V5iQlmorWg5LQ6YsGPPcv2xiL8ovP/wXAmOIpyOBd5vvycrnjfVMLCrP0Rin
	 KgOngvlppY8kfrGcX3uGjLkf9VD0Zdovv32hQd5c4NiZqcGm305EznvqjRbajersi3
	 41cCCByG9ndM1SNKp8HatXBrLGCETkbcXqze1lzw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgJMXEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXEO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:04:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1624A22201;
        Tue, 13 Oct 2020 23:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630253;
        bh=TTNpBTNqyF8x5JcwHGLHQz0tV6BTu1G+EBH3BV1lQBg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c1pbDO4U9npTl3HQotpu/ZwF3yH8NDwpjeE2HbAi9g99cxjCY/D6FpkmJQUtFRUcI
         qXpqDE64B2Dwc0doJujDr8GbaxiMvbl3VsWzt6MO+k5jFSQcPYgqfUgy6r5H3klHbY
         QuYgeMGDxRH73t3gDakiQCskgcVLJ8Npekww1qAY=
Date:   Tue, 13 Oct 2020 16:04:11 -0700
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
 acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch removed
 from -mm tree
Message-ID: <20201013230411.VuruZ5-Xn%akpm@linux-foundation.org>
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
     Subject: device-dax: require NUMA_KEEP_MEMINFO for phys_to_target_node=
()
has been removed from the -mm tree.  Its filename was
     acpi-hmat-attach-a-device-for-each-soft-reserved-range-fix.patch

This patch was dropped because it was folded into acpi-hmat-attach-a-device=
-for-each-soft-reserved-range.patch

------------------------------------------------------
=46rom: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: require NUMA_KEEP_MEMINFO for phys_to_target_node()

phys_to_target_node() and memory_add_physaddr_to_nid() are only defined
with both CONFIG_NUMA=3Dy and CONFIG_MEMORY_HOTPLUG=3Dy.  Oherwise we see:

drivers/dax/hmem/device.o: in function `hmem_register_one':
drivers/dax/hmem/device.c:85: undefined reference to `phys_to_target_node'

lkp also reports such build failures:

ld.lld: error: undefined symbol: phys_to_target_node

X86 is a special case in which both can be defined without depending on
MEMORY_HOTPLUG=3Dy. The other case is powerpc (for
memory_add_physaddr_to_nid) but like ARM64 dependencies, the
arch-specific override requires CONFIG_NUMA and CONFIG_MEMORY_HOTPLUG.

In all cases this ends up depending on CONFIG_NUMA_KEEP_MEMINFO to
signal the presence of phys_to_target_node() which is what
CONFIG_DEV_DAX_HMEM_DEVICES should depend on. Additionally, the X86
arch-override is not selected unless X86_PMEM_LEGACY=3Dy. So on
CONFIG_DEV_DAX_HMEM we select CONFIG_NUMA_KEEP_INFO ourselves if both
NUMA and X86 are set.

Link: https://lkml.kernel.org/r/aaae71a7-4846-f5cc-5acf-cf05fdb1f2dc@oracle=
.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
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

 drivers/dax/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dax/Kconfig~acpi-hmat-attach-a-device-for-each-soft-reserved-=
range-fix
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

Patches currently in -mm which might be from joao.m.martins@oracle.com are

acpi-hmat-attach-a-device-for-each-soft-reserved-range.patch
device-dax-make-align-a-per-device-property.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

