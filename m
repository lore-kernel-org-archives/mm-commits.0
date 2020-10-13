Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76805C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 368DC21D81
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632941;
	bh=KW8R+PgewuuFDNjiUQVTcvoNnje8/XmZVStYuSOA0B0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=v1BE/Q74KUpyf6OhP1I6RARDdsYWcvHiafZzNWYw5ROWwljeZzB75sM8pz51blSNB
	 756AORVYrxLH4ER17FADY/KfAXX3KjuPGTYQvYQIqkufwcLZliyiEd3zuyAAe6xbPL
	 DxLfydwz/+KmiozPXZ4gLn/i/nuCqvyuP+GRLQps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbgJMXtA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgJMXtA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:49:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2243321D7A;
        Tue, 13 Oct 2020 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632939;
        bh=KW8R+PgewuuFDNjiUQVTcvoNnje8/XmZVStYuSOA0B0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U0bTWcvWcO4RW43U9Y+rQbi250XHo5kiHDGxlZJDC08YrIJ9zVyFux8VQEIEtGbPd
         1RXs0xWFzP09GKVjYFPFhZ86GMeEiWNR0hJbGYZlAcgQPRPKo7sNwiw1Y7NtGxVTuC
         9UUU+FdyUeyh2Kdcpe48US968NdaBwZr4DiXAQ/k=
Date:   Tue, 13 Oct 2020 16:48:57 -0700
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
Subject:  [patch 026/181] x86/numa: cleanup configuration dependent
 command-line options
Message-ID: <20201013234857.RW3FdP5XO%akpm@linux-foundation.org>
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
Subject: x86/numa: cleanup configuration dependent command-line options

Patch series "device-dax: Support sub-dividing soft-reserved ranges", v5.

The device-dax facility allows an address range to be directly mapped
through a chardev, or optionally hotplugged to the core kernel page
allocator as System-RAM.  It is the mechanism for converting persistent
memory (pmem) to be used as another volatile memory pool i.e.  the current
Memory Tiering hot topic on linux-mm.

In the case of pmem the nvdimm-namespace-label mechanism can sub-divide
it, but that labeling mechanism is not available / applicable to
soft-reserved ("EFI specific purpose") memory [3].  This series provides a
sysfs-mechanism for the daxctl utility to enable provisioning of
volatile-soft-reserved memory ranges.

The motivations for this facility are:

1/ Allow performance differentiated memory ranges to be split between
   kernel-managed and directly-accessed use cases.

2/ Allow physical memory to be provisioned along performance relevant
   address boundaries. For example, divide a memory-side cache [4] along
   cache-color boundaries.

3/ Parcel out soft-reserved memory to VMs using device-dax as a security
   / permissions boundary [5]. Specifically I have seen people (ab)using
   memmap=3Dnn!ss (mark System-RAM as Persistent Memory) just to get the
   device-dax interface on custom address ranges. A follow-on for the VM
   use case is to teach device-dax to dynamically allocate 'struct page' at
   runtime to reduce the duplication of 'struct page' space in both the
   guest and the host kernel for the same physical pages.

[2]: http://lore.kernel.org/r/20200713160837.13774-11-joao.m.martins@oracle=
.com
[3]: http://lore.kernel.org/r/157309097008.1579826.12818463304589384434.stg=
it@dwillia2-desk3.amr.corp.intel.com
[4]: http://lore.kernel.org/r/154899811738.3165233.12325692939590944259.stg=
it@dwillia2-desk3.amr.corp.intel.com
[5]: http://lore.kernel.org/r/20200110190313.17144-1-joao.m.martins@oracle.=
com


This patch (of 23):

In preparation for adding a new numa=3D option clean up the existing ones to
avoid ifdefs in numa_setup(), and provide feedback when the option is
numa=3Dfake=3D option is invalid due to kernel config.  The same does not n=
eed
to be done for numa=3Dnoacpi, since the capability is already hard disabled
at compile-time.

Link: https://lkml.kernel.org/r/160106109960.30709.7379926726669669398.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/159643094279.4062302.17779410714418721328.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/159643094925.4062302.14979872973043772305.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
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
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
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

 arch/x86/include/asm/numa.h  |    8 +++++++-
 arch/x86/mm/numa.c           |    8 ++------
 arch/x86/mm/numa_emulation.c |    3 ++-
 arch/x86/xen/enlighten_pv.c  |    2 +-
 drivers/acpi/numa/srat.c     |    9 +++++++--
 include/acpi/acpi_numa.h     |    6 +++++-
 6 files changed, 24 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/numa.h~x86-numa-cleanup-configuration-dependent-=
command-line-options
+++ a/arch/x86/include/asm/numa.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_NUMA_H
=20
 #include <linux/nodemask.h>
+#include <linux/errno.h>
=20
 #include <asm/topology.h>
 #include <asm/apicdef.h>
@@ -77,7 +78,12 @@ void debug_cpumask_set_cpu(int cpu, int
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
-void numa_emu_cmdline(char *);
+int numa_emu_cmdline(char *str);
+#else /* CONFIG_NUMA_EMU */
+static inline int numa_emu_cmdline(char *str)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_NUMA_EMU */
=20
 #endif	/* _ASM_X86_NUMA_H */
--- a/arch/x86/mm/numa.c~x86-numa-cleanup-configuration-dependent-command-l=
ine-options
+++ a/arch/x86/mm/numa.c
@@ -37,14 +37,10 @@ static __init int numa_setup(char *opt)
 		return -EINVAL;
 	if (!strncmp(opt, "off", 3))
 		numa_off =3D 1;
-#ifdef CONFIG_NUMA_EMU
 	if (!strncmp(opt, "fake=3D", 5))
-		numa_emu_cmdline(opt + 5);
-#endif
-#ifdef CONFIG_ACPI_NUMA
+		return numa_emu_cmdline(opt + 5);
 	if (!strncmp(opt, "noacpi", 6))
-		acpi_numa =3D -1;
-#endif
+		disable_srat();
 	return 0;
 }
 early_param("numa", numa_setup);
--- a/arch/x86/mm/numa_emulation.c~x86-numa-cleanup-configuration-dependent=
-command-line-options
+++ a/arch/x86/mm/numa_emulation.c
@@ -13,9 +13,10 @@
 static int emu_nid_to_phys[MAX_NUMNODES];
 static char *emu_cmdline __initdata;
=20
-void __init numa_emu_cmdline(char *str)
+int __init numa_emu_cmdline(char *str)
 {
 	emu_cmdline =3D str;
+	return 0;
 }
=20
 static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminf=
o *mi)
--- a/arch/x86/xen/enlighten_pv.c~x86-numa-cleanup-configuration-dependent-=
command-line-options
+++ a/arch/x86/xen/enlighten_pv.c
@@ -1300,7 +1300,7 @@ asmlinkage __visible void __init xen_sta
 	 * any NUMA information the kernel tries to get from ACPI will
 	 * be meaningless.  Prevent it from trying.
 	 */
-	acpi_numa =3D -1;
+	disable_srat();
 #endif
 	WARN_ON(xen_cpuhp_setup(xen_cpu_up_prepare_pv, xen_cpu_dead_pv));
=20
--- a/drivers/acpi/numa/srat.c~x86-numa-cleanup-configuration-dependent-com=
mand-line-options
+++ a/drivers/acpi/numa/srat.c
@@ -27,7 +27,12 @@ static int node_to_pxm_map[MAX_NUMNODES]
 			=3D { [0 ... MAX_NUMNODES - 1] =3D PXM_INVAL };
=20
 unsigned char acpi_srat_revision __initdata;
-int acpi_numa __initdata;
+static int acpi_numa __initdata;
+
+void __init disable_srat(void)
+{
+	acpi_numa =3D -1;
+}
=20
 int pxm_to_node(int pxm)
 {
@@ -163,7 +168,7 @@ static int __init slit_valid(struct acpi
 void __init bad_srat(void)
 {
 	pr_err("SRAT: SRAT not used.\n");
-	acpi_numa =3D -1;
+	disable_srat();
 }
=20
 int __init srat_disabled(void)
--- a/include/acpi/acpi_numa.h~x86-numa-cleanup-configuration-dependent-com=
mand-line-options
+++ a/include/acpi/acpi_numa.h
@@ -17,10 +17,14 @@ extern int pxm_to_node(int);
 extern int node_to_pxm(int);
 extern int acpi_map_pxm_to_node(int);
 extern unsigned char acpi_srat_revision;
-extern int acpi_numa __initdata;
+extern void disable_srat(void);
=20
 extern void bad_srat(void);
 extern int srat_disabled(void);
=20
+#else				/* CONFIG_ACPI_NUMA */
+static inline void disable_srat(void)
+{
+}
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */
_
