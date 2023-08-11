Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CF0C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbjHKXGa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbjHKXFP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D723C3C22
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E5CB67942
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4958C433C7;
        Fri, 11 Aug 2023 23:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794994;
        bh=SebKII2bcXa688vVyaGioI14t85i/2aQpEr8LSQjhNE=;
        h=Date:To:From:Subject:From;
        b=KoC9ZF9IkdK7bJo9LQ92spGHHOj3CiGuy2rduFIkF4VC0uqKXJXKAvsnYWe4d02Ha
         9CeeuInrrbD/Tb+4p8T1mC83g4u9YWE3fB85aAAEwarBYuCp5Gi7ttCioKz5vogE9S
         kc3Yun6WPX3+zNwWovT7FaBtAgdTaEnIvsAOs468=
Date:   Fri, 11 Aug 2023 16:03:14 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch removed from -mm tree
Message-Id: <20230811230314.C4958C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmemmap: allow architectures to override how vmemmap optimization works
has been removed from the -mm tree.  Its filename was
     mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/vmemmap: allow architectures to override how vmemmap optimization works
Date: Tue, 25 Jul 2023 00:37:50 +0530

Architectures like powerpc will like to use different page table
allocators and mapping mechanisms to implement vmemmap optimization. 
Similar to vmemmap_populate allow architectures to implement
vmemap_populate_compound_pages

Link: https://lkml.kernel.org/r/20230724190759.483013-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/sparse-vmemmap.c~mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works
+++ a/mm/sparse-vmemmap.c
@@ -358,6 +358,7 @@ int __meminit vmemmap_populate_hugepages
 	return 0;
 }
 
+#ifndef vmemmap_populate_compound_pages
 /*
  * For compound pages bigger than section size (e.g. x86 1G compound
  * pages with 2M subsection size) fill the rest of sections as tail
@@ -446,6 +447,8 @@ static int __meminit vmemmap_populate_co
 	return 0;
 }
 
+#endif
+
 struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

