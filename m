Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F30C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3465322202
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630224;
	bh=E7SofxE4083ESWBo7ISPtmWZwdifnWHEmGEARJCd2dc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=luMB6hwoqB3G6XnOgmXFI58hP1g7P4R4V0cvsuF4qqpvDfUF1rPXrFhGVBPUk9MYA
	 UIxB2J/Hy0bmZh0iBlhZ4ozHdry1Gy6m4Jig7hV44qPkuGlapQEosswOVkZTFLoO8n
	 coBzhete0v7geaUwpee75iM3WXqKMGwMi1xt0csI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgJMXDn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXDn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:03:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1AB122200;
        Tue, 13 Oct 2020 23:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630222;
        bh=E7SofxE4083ESWBo7ISPtmWZwdifnWHEmGEARJCd2dc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ntm4rrZq5DAA4fBVvWyIxpKlvaMkN58wm/tnCdvDCwdru23ot5znZlXifqlgzxYQU
         inmEgLJbTy5PSPuAIsAiyKuX3hR1CN2edHDYXUG2CcPlHU95ugpYUayRLLO8AMazLS
         B6fi61fG9lUkxGbKi5Tn6XpIBH+w4RS+eVrHKy+Q=
Date:   Tue, 13 Oct 2020 16:03:40 -0700
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
        justin.he@arm.com, lkp@intel.com, luto@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rdunlap@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@linux.ibm.com,
        sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, vgoyal@redhat.com,
        vishal.l.verma@intel.com, will@kernel.org, yanaijie@huawei.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-introduce-default-phys=5Fto=5Ftarget=5Fn?=
 =?US-ASCII?Q?ode-implementation-fix.patch?= removed from -mm tree
Message-ID: <20201013230340.URas5uan_%akpm@linux-foundation.org>
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
     Subject: mm-memory_hotplug-introduce-default-phys_to_target_node-imple=
mentation-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-introduce-default-phys_to_target_node-implementation=
-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-introdu=
ce-default-phys_to_target_node-implementation.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-introduce-default-phys_to_target_node-implementa=
tion-fix

fix CONFIG_MEMORY_HOTPLUG=3Dn build

Link: https://lkml.kernel.org/r/202008252130.7YrHIyMI%25lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
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

 include/linux/memory_hotplug.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-default-ph=
ys_to_target_node-implementation-fix
+++ a/include/linux/memory_hotplug.h
@@ -149,20 +149,6 @@ int add_pages(int nid, unsigned long sta
 	      struct mhp_params *params);
 #endif /* ARCH_HAS_ADD_PAGES */
=20
-#ifdef CONFIG_NUMA
-extern int memory_add_physaddr_to_nid(u64 start);
-extern int phys_to_target_node(u64 start);
-#else
-static inline int memory_add_physaddr_to_nid(u64 start)
-{
-	return 0;
-}
-static inline int phys_to_target_node(u64 start)
-{
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_HAVE_ARCH_NODEDATA_EXTENSION
 /*
  * For supporting node-hotadd, we have to allocate a new pgdat.
@@ -289,6 +275,20 @@ static inline bool movable_node_is_enabl
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mm.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.pat=
ch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api=
-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api=
-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

