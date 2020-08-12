Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B548C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F25207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266149;
	bh=aPE8MWbUL4LxBCUGacsrfGPdK4qY52Mg5QHF3Nq4ooU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tf0Ox7OkmT04cabVHjPYu+/n7a35ehGaPWndz93IUS2r6uhGZWDylKBdsSCt/ghqV
	 xVFni2yzkPpENDIdiwP3Cky1y5PZJIXAFfVeGG6o/DnpNpEXPRODM9O7Weexqk+/nz
	 ThQ9Gw+26+kJbBw+eC4a5rEEQVfMmnsLt0W85Sc8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHLVC3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgHLVC2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5E2C20774;
        Wed, 12 Aug 2020 21:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266146;
        bh=aPE8MWbUL4LxBCUGacsrfGPdK4qY52Mg5QHF3Nq4ooU=;
        h=Date:From:To:Subject:From;
        b=YYLIKZxnq1FW5MzzZNsf072egz19C6ibTVImSwJG4ayzAvGcwUYK/hre7LaIT1exU
         F3katjRKiHH/COWek/hHrd33p8GPamMdi9IDb+rv0i2OIOHfblkgvsbug0/m76bHQu
         j8qtgAZUTyPvepfZJwS4LKGglzK2iFkPiaAAJk+o=
Date:   Wed, 12 Aug 2020 14:02:25 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, bp@alien8.de, catalin.marinas@arm.com,
        dalias@libc.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, fenghua.yu@intel.com, hpa@zytor.com,
        hslester96@gmail.com, Jonathan.Cameron@Huawei.com,
        justin.he@arm.com, Kaly.Xin@arm.com, logang@deltatee.com,
        luto@kernel.org, masahiroy@kernel.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        rppt@linux.ibm.com, tglx@linutronix.de, tony.luck@intel.com,
        vishal.l.verma@intel.com, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  [merged]
 mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid.patch
 removed from -mm tree
Message-ID: <20200812210225.KN9fW-9_F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: introduce default dummy memory_add_physaddr_to_nid()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jia He <justin.he@arm.com>
Subject: mm/memory_hotplug: introduce default dummy memory_add_physaddr_to_nid()

This is to introduce a general dummy helper.  memory_add_physaddr_to_nid()
is a fallback option to get the nid in case NUMA_NO_NID is detected.

After this patch, arm64/sh/s390 can simply use the general dummy version. 
PowerPC/x86/ia64 will still use their specific version.

This is the preparation to set a fallback value for dev_dax->target_node.

Link: http://lkml.kernel.org/r/20200710031619.18762-2-justin.he@arm.com
Signed-off-by: Jia He <justin.he@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chuhong Yuan <hslester96@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Kaly Xin <Kaly.Xin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/numa.c |   10 ----------
 arch/ia64/mm/numa.c  |    2 --
 arch/sh/mm/init.c    |    9 ---------
 arch/x86/mm/numa.c   |    1 -
 mm/memory_hotplug.c  |   10 ++++++++++
 5 files changed, 10 insertions(+), 22 deletions(-)

--- a/arch/arm64/mm/numa.c~mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid
+++ a/arch/arm64/mm/numa.c
@@ -461,13 +461,3 @@ void __init arm64_numa_init(void)
 
 	numa_init(dummy_numa_init);
 }
-
-/*
- * We hope that we will be hotplugging memory on nodes we already know about,
- * such that acpi_get_node() succeeds and we never fall back to this...
- */
-int memory_add_physaddr_to_nid(u64 addr)
-{
-	pr_warn("Unknown node for memory at 0x%llx, assuming node 0\n", addr);
-	return 0;
-}
--- a/arch/ia64/mm/numa.c~mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid
+++ a/arch/ia64/mm/numa.c
@@ -106,7 +106,5 @@ int memory_add_physaddr_to_nid(u64 addr)
 		return 0;
 	return nid;
 }
-
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
 #endif
--- a/arch/sh/mm/init.c~mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid
+++ a/arch/sh/mm/init.c
@@ -425,15 +425,6 @@ int arch_add_memory(int nid, u64 start,
 	return ret;
 }
 
-#ifdef CONFIG_NUMA
-int memory_add_physaddr_to_nid(u64 addr)
-{
-	/* Node 0 for now.. */
-	return 0;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-
 void arch_remove_memory(int nid, u64 start, u64 size,
 			struct vmem_altmap *altmap)
 {
--- a/arch/x86/mm/numa.c~mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid
+++ a/arch/x86/mm/numa.c
@@ -929,5 +929,4 @@ int memory_add_physaddr_to_nid(u64 start
 		nid = numa_meminfo.blk[0].nid;
 	return nid;
 }
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
--- a/mm/memory_hotplug.c~mm-memory_hotplug-introduce-default-dummy-memory_add_physaddr_to_nid
+++ a/mm/memory_hotplug.c
@@ -350,6 +350,16 @@ int __ref __add_pages(int nid, unsigned
 	return err;
 }
 
+#ifdef CONFIG_NUMA
+int __weak memory_add_physaddr_to_nid(u64 start)
+{
+	pr_info_once("Unknown target node for memory at 0x%llx, assuming node 0\n",
+			start);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
+
 /* find the smallest valid pfn in the range [start_pfn, end_pfn) */
 static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
 				     unsigned long start_pfn,
_

Patches currently in -mm which might be from justin.he@arm.com are


