Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F1FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1135622259
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709029;
	bh=x/gmbBNHiGNq2jp2Jcmp6chftJATIsAqVB3xA1rKoNc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u0iQgxuYgUmtUrX6nKx0TeV7ZhHxlap9bMWi74xhXHArofhvTWerWjCGzDNAhCONP
	 qglppd+/qOY45Ykc4cZ2rPtbrU1Rl+oNQB7g85zvHq/mDJm6B9C9Vj0wE39W0aVkim
	 AKaf59lhLEIYBjiq7RbiCc+ZLalUcwtgWI0zlWW4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgJNU5I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730361AbgJNU5I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:57:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C3E2224E;
        Wed, 14 Oct 2020 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709026;
        bh=x/gmbBNHiGNq2jp2Jcmp6chftJATIsAqVB3xA1rKoNc=;
        h=Date:From:To:Subject:From;
        b=EyzZSFxYR62gYz98/LTgETphLzCGhJKB3ibY/FOiJ+/XbyLhnbOSk4SBwav2bB07y
         +SQ4uwbkejavhFfDiiBziX8OL4ej3EFAGMLfJ9j1VxcxXZ9AVRVamgvd5kVfKquhX/
         +oh4sa317gUlMDCVzbfuO0wOO0SQbsuHStUYcx88=
Date:   Wed, 14 Oct 2020 13:57:03 -0700
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
 =?US-ASCII?Q?mm-memory=5Fhotplug-introduce-default-phys=5Fto=5Ftarget=5Fn?=
 =?US-ASCII?Q?ode-implementation.patch?= removed from -mm tree
Message-ID: <20201014205703.qsrOHIue-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: introduce default phys_to_target_node() im=
plementation
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-introduce-default-phys_to_target_node-implementation=
.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memory_hotplug: introduce default phys_to_target_node() impleme=
ntation

In preparation to set a fallback value for dev_dax->target_node, introduce
generic fallback helpers for phys_to_target_node()

A generic implementation based on node-data or memblock was proposed, but
as noted by Mike:

    "Here again, I would prefer to add a weak default for
     phys_to_target_node() because the "generic" implementation is not real=
ly
     generic.

     The fallback to reserved ranges is x86 specfic because on x86 most of
     the reserved areas is not in memblock.memory. AFAIK, no other
     architecture does this."

The info message in the generic memory_add_physaddr_to_nid()
implementation is fixed up to properly reflect that
memory_add_physaddr_to_nid() communicates "online" node info and
phys_to_target_node() indicates "target / to-be-onlined" node info.

[akpm@linux-foundation.org: fix CONFIG_MEMORY_HOTPLUG=3Dn build]
  Link: https://lkml.kernel.org/r/202008252130.7YrHIyMI%25lkp@intel.com
Link: https://lkml.kernel.org/r/159643097768.4062302.3135192588966888630.st=
git@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jia He <justin.he@arm.com>
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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
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

 arch/x86/mm/numa.c             |    1 -
 include/linux/memory_hotplug.h |   23 ++++++++++++++---------
 include/linux/numa.h           |   11 -----------
 mm/memory_hotplug.c            |   10 +++++++++-
 4 files changed, 23 insertions(+), 22 deletions(-)

--- a/arch/x86/mm/numa.c~mm-memory_hotplug-introduce-default-phys_to_target=
_node-implementation
+++ a/arch/x86/mm/numa.c
@@ -917,7 +917,6 @@ int phys_to_target_node(phys_addr_t star
=20
 	return meminfo_to_nid(&numa_reserved_meminfo, start);
 }
-EXPORT_SYMBOL_GPL(phys_to_target_node);
=20
 int memory_add_physaddr_to_nid(u64 start)
 {
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-default-ph=
ys_to_target_node-implementation
+++ a/include/linux/memory_hotplug.h
@@ -149,15 +149,6 @@ int add_pages(int nid, unsigned long sta
 	      struct mhp_params *params);
 #endif /* ARCH_HAS_ADD_PAGES */
=20
-#ifdef CONFIG_NUMA
-extern int memory_add_physaddr_to_nid(u64 start);
-#else
-static inline int memory_add_physaddr_to_nid(u64 start)
-{
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
 /*
  * For supporting node-hotadd, we have to allocate a new pgdat.
@@ -284,6 +275,20 @@ static inline bool movable_node_is_enabl
 }
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
=20
+#ifdef CONFIG_NUMA
+extern int memory_add_physaddr_to_nid(u64 start);
+extern int phys_to_target_node(u64 start);
+#else
+static inline int memory_add_physaddr_to_nid(u64 start)
+{
+	return 0;
+}
+static inline int phys_to_target_node(u64 start)
+{
+	return 0;
+}
+#endif
+
 #if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_DEFERRED_STRUCT_PAGE_=
INIT)
 /*
  * pgdat resizing functions
--- a/include/linux/numa.h~mm-memory_hotplug-introduce-default-phys_to_targ=
et_node-implementation
+++ a/include/linux/numa.h
@@ -23,22 +23,11 @@
 #ifdef CONFIG_NUMA
 /* Generic implementation available */
 int numa_map_to_online_node(int node);
-
-/*
- * Optional architecture specific implementation, users need a "depends
- * on $ARCH"
- */
-int phys_to_target_node(phys_addr_t addr);
 #else
 static inline int numa_map_to_online_node(int node)
 {
 	return NUMA_NO_NODE;
 }
-
-static inline int phys_to_target_node(phys_addr_t addr)
-{
-	return NUMA_NO_NODE;
-}
 #endif
=20
 #endif /* _LINUX_NUMA_H */
--- a/mm/memory_hotplug.c~mm-memory_hotplug-introduce-default-phys_to_targe=
t_node-implementation
+++ a/mm/memory_hotplug.c
@@ -353,11 +353,19 @@ int __ref __add_pages(int nid, unsigned
 #ifdef CONFIG_NUMA
 int __weak memory_add_physaddr_to_nid(u64 start)
 {
-	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n=
",
+	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n=
",
 			start);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+
+int __weak phys_to_target_node(u64 start)
+{
+	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n=
",
+			start);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phys_to_target_node);
 #endif
=20
 /* find the smallest valid pfn in the range [start_pfn, end_pfn) */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


