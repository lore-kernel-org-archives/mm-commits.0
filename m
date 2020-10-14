Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551D3C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F17D322259
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709007;
	bh=UVAeN1BJlaVeCZUZ3GmH06OmJX36IYsfwq/jbIcK2oE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=P24NSLJ9G3Pjhgcmov02sULElEm7AmssCWaXWgeV28M+NcCC/sLBtir/BYz+5A7FN
	 tgVF7xVhcvNH1A/wAuw4Oe/qzXZvdsTfEl/kbK+A6DKFQcd+nwXlWvcCUA4lNvuWVi
	 FSVqdgs6YE6pgqaDUVToneXAhnNHN+k8Synq4qyc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgJNU4q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4567322254;
        Wed, 14 Oct 2020 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709005;
        bh=UVAeN1BJlaVeCZUZ3GmH06OmJX36IYsfwq/jbIcK2oE=;
        h=Date:From:To:Subject:From;
        b=F5dCwf2VPbShK0/XFPhuaQo27ud31Xh/DClRe9ek3JS1mz/VUYVgn5D+z/VsKqYXy
         3QqWaS3zP3rETskVZFNCwp1OhdcOeMj+Dehh2sTXCSgisEu+xsU+TWEGM6hITVrI1D
         dpAYebt9aPeNrxmJKKJ0SVXhYdXzvIUvojskqk4w=
Date:   Wed, 14 Oct 2020 13:56:42 -0700
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
Subject:  [merged] x86-numa-add-nohmat-option.patch removed from
 -mm tree
Message-ID: <20201014205642.-8GTRhSJ2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/numa: add 'nohmat' option
has been removed from the -mm tree.  Its filename was
     x86-numa-add-nohmat-option.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: x86/numa: add 'nohmat' option

Disable parsing of the HMAT for debug, to workaround broken platform
instances, or cases where it is otherwise not wanted.

[rdunlap@infradead.org: fix build when CONFIG_ACPI is not set]
  Link: https://lkml.kernel.org/r/70e5ee34-9809-a997-7b49-499e4be61307@infr=
adead.org
Link: https://lkml.kernel.org/r/159643095540.4062302.732962081968036212.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
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

 Documentation/x86/x86_64/boot-options.rst |    4 ++++
 arch/x86/mm/numa.c                        |    2 ++
 drivers/acpi/numa/hmat.c                  |    8 +++++++-
 include/acpi/acpi_numa.h                  |    8 ++++++++
 include/linux/acpi.h                      |    2 ++
 5 files changed, 23 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/numa.c~x86-numa-add-nohmat-option
+++ a/arch/x86/mm/numa.c
@@ -41,6 +41,8 @@ static __init int numa_setup(char *opt)
 		return numa_emu_cmdline(opt + 5);
 	if (!strncmp(opt, "noacpi", 6))
 		disable_srat();
+	if (!strncmp(opt, "nohmat", 6))
+		disable_hmat();
 	return 0;
 }
 early_param("numa", numa_setup);
--- a/Documentation/x86/x86_64/boot-options.rst~x86-numa-add-nohmat-option
+++ a/Documentation/x86/x86_64/boot-options.rst
@@ -173,6 +173,10 @@ NUMA
   numa=3Dnoacpi
     Don't parse the SRAT table for NUMA setup
=20
+  numa=3Dnohmat
+    Don't parse the HMAT table for NUMA setup, or soft-reserved memory
+    partitioning.
+
   numa=3Dfake=3D<size>[MG]
     If given as a memory unit, fills all system RAM with nodes of
     size interleaved over physical nodes.
--- a/drivers/acpi/numa/hmat.c~x86-numa-add-nohmat-option
+++ a/drivers/acpi/numa/hmat.c
@@ -26,6 +26,12 @@
 #include <linux/sysfs.h>
=20
 static u8 hmat_revision;
+static int hmat_disable __initdata;
+
+void __init disable_hmat(void)
+{
+	hmat_disable =3D 1;
+}
=20
 static LIST_HEAD(targets);
 static LIST_HEAD(initiators);
@@ -814,7 +820,7 @@ static __init int hmat_init(void)
 	enum acpi_hmat_type i;
 	acpi_status status;
=20
-	if (srat_disabled())
+	if (srat_disabled() || hmat_disable)
 		return 0;
=20
 	status =3D acpi_get_table(ACPI_SIG_SRAT, 0, &tbl);
--- a/include/acpi/acpi_numa.h~x86-numa-add-nohmat-option
+++ a/include/acpi/acpi_numa.h
@@ -27,4 +27,12 @@ static inline void disable_srat(void)
 {
 }
 #endif				/* CONFIG_ACPI_NUMA */
+
+#ifdef CONFIG_ACPI_HMAT
+extern void disable_hmat(void);
+#else				/* CONFIG_ACPI_HMAT */
+static inline void disable_hmat(void)
+{
+}
+#endif				/* CONFIG_ACPI_HMAT */
 #endif				/* __ACP_NUMA_H */
--- a/include/linux/acpi.h~x86-numa-add-nohmat-option
+++ a/include/linux/acpi.h
@@ -709,6 +709,8 @@ static inline u64 acpi_arch_get_root_poi
 #define ACPI_HANDLE_FWNODE(fwnode)	(NULL)
 #define ACPI_DEVICE_CLASS(_cls, _msk)	.cls =3D (0), .cls_msk =3D (0),
=20
+#include <acpi/acpi_numa.h>
+
 struct fwnode_handle;
=20
 static inline bool acpi_dev_found(const char *hid)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


