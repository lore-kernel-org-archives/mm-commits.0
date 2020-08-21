Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EC5C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9656C207CD
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052186;
	bh=DTtLEzt+pOqeQM6Tfx2SLgRD3ufpueNhqujX457ipPM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LYf0FiZDfqL27lHqtbE9IlPYWLqj3THT+Ts3v3L1faTrSl/fyeuTXYaMHPs/kPu5q
	 pK8Xgv3LDo4UIPtvAG0E7qJVaE+G+WuccKELePcO4ft/dmG3SKQppW9+BZpH17ljDf
	 ohqafqgNAOpkj9MdHvuGE5Cm+Ksen5Jlb6KhEyN0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgHUXXG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHUXXG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:23:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7043E207C3;
        Fri, 21 Aug 2020 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052185;
        bh=DTtLEzt+pOqeQM6Tfx2SLgRD3ufpueNhqujX457ipPM=;
        h=Date:From:To:Subject:From;
        b=BWvpw6y4vxueECOV/i0p4KrqlhO/g1uANKPIM+q7woej3GBt5TVdXOifFPaUEtcrU
         OGkS6QqrWV1srFiIQbdiME4hybNFSLykfNEl9fzEMorZfQAgOowKMyxCt/xgVmrZve
         HLwmoC3x5HHlKHij+yk1C3TqLfxIyE1iCGRebnzY=
Date:   Fri, 21 Aug 2020 16:23:02 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        ira.weiny@intel.com, jgg@mellanox.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rafael@kernel.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-introduce-default-phys=5Fto=5Ftarget=5Fn?=
 =?US-ASCII?Q?ode-implementation.patch?= added to -mm tree
Message-ID: <20200821232302.ra8EIMQQ7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: introduce default phys_to_target_node() implementation
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memory_hotplug: introduce default phys_to_target_node() implementation

In preparation to set a fallback value for dev_dax->target_node, introduce
generic fallback helpers for phys_to_target_node()

A generic implementation based on node-data or memblock was proposed, but
as noted by Mike:

    "Here again, I would prefer to add a weak default for
     phys_to_target_node() because the "generic" implementation is not really
     generic.

     The fallback to reserved ranges is x86 specfic because on x86 most of
     the reserved areas is not in memblock.memory. AFAIK, no other
     architecture does this."

The info message in the generic memory_add_physaddr_to_nid()
implementation is fixed up to properly reflect that
memory_add_physaddr_to_nid() communicates "online" node info and
phys_to_target_node() indicates "target / to-be-onlined" node info.

Link: https://lkml.kernel.org/r/159643097768.4062302.3135192588966888630.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jia He <justin.he@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/numa.c             |    1 -
 include/linux/memory_hotplug.h |    5 +++++
 include/linux/numa.h           |   11 -----------
 mm/memory_hotplug.c            |   10 +++++++++-
 4 files changed, 14 insertions(+), 13 deletions(-)

--- a/arch/x86/mm/numa.c~mm-memory_hotplug-introduce-default-phys_to_target_node-implementation
+++ a/arch/x86/mm/numa.c
@@ -917,7 +917,6 @@ int phys_to_target_node(phys_addr_t star
 
 	return meminfo_to_nid(&numa_reserved_meminfo, start);
 }
-EXPORT_SYMBOL_GPL(phys_to_target_node);
 
 int memory_add_physaddr_to_nid(u64 start)
 {
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-default-phys_to_target_node-implementation
+++ a/include/linux/memory_hotplug.h
@@ -151,11 +151,16 @@ int add_pages(int nid, unsigned long sta
 
 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
+extern int phys_to_target_node(u64 start);
 #else
 static inline int memory_add_physaddr_to_nid(u64 start)
 {
 	return 0;
 }
+static inline int phys_to_target_node(u64 start)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
--- a/include/linux/numa.h~mm-memory_hotplug-introduce-default-phys_to_target_node-implementation
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
 
 #endif /* _LINUX_NUMA_H */
--- a/mm/memory_hotplug.c~mm-memory_hotplug-introduce-default-phys_to_target_node-implementation
+++ a/mm/memory_hotplug.c
@@ -353,11 +353,19 @@ int __ref __add_pages(int nid, unsigned
 #ifdef CONFIG_NUMA
 int __weak memory_add_physaddr_to_nid(u64 start)
 {
-	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
+	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
 			start);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+
+int __weak phys_to_target_node(u64 start)
+{
+	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phys_to_target_node);
 #endif
 
 /* find the smallest valid pfn in the range [start_pfn, end_pfn) */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

x86-numa-cleanup-configuration-dependent-command-line-options.patch
x86-numa-add-nohmat-option.patch
efi-fake_mem-arrange-for-a-resource-entry-per-efi_fake_mem-instance.patch
acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device.patch
resource-report-parent-to-walk_iomem_res_desc-callback.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range.patch
device-dax-drop-the-dax_regionpfn_flags-attribute.patch
device-dax-move-instance-creation-parameters-to-struct-dev_dax_data.patch
device-dax-make-pgmap-optional-for-instance-creation.patch
device-dax-kill-dax_kmem_res.patch
device-dax-add-an-allocation-interface-for-device-dax-instances.patch
device-dax-introduce-seed-devices.patch
drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inputs.patch
device-dax-add-resize-support.patch
mm-memremap_pages-convert-to-struct-range.patch
mm-memremap_pages-support-multiple-ranges-per-invocation.patch
device-dax-add-dis-contiguous-resource-support.patch
device-dax-introduce-mapping-devices.patch

