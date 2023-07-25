Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75379EB64DD
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 19:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjGYTbT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 15:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjGYTbR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 15:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E105FE
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 12:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7EB26188F
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 19:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25657C433C7;
        Tue, 25 Jul 2023 19:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690313475;
        bh=m7cYTmOJOCXKOIf+SM7HOZHRFo7w8GTiwmmxXfPtHjk=;
        h=Date:To:From:Subject:From;
        b=KSZds16tR6zPy15HWiIgXcc6mgB9/w4Jf0pCqEm/IvVSD/IcU3Um4A0qRYsbKjS5l
         p7kHQKa5gFKtWK4rtuOxP9yKnTLdBrfD1mcMFnUYxZlilNlK0j5MRINTkLfVnB4j9s
         p+TSjMaxGJgzDKajU48FBlzBLk+IDyRDYjbH/qZA=
Date:   Tue, 25 Jul 2023 12:31:14 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch added to mm-unstable branch
Message-Id: <20230725193115.25657C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmemmap: allow architectures to override how vmemmap optimization works
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-hugepage-pud-allow-arch-specific-helper-function-to-check-huge-page-pud-support.patch
mm-change-pudp_huge_get_and_clear_full-take-vm_area_struct-as-arg.patch
mm-vmemmap-improve-vmemmap_can_optimize-and-allow-architectures-to-override.patch
mm-vmemmap-allow-architectures-to-override-how-vmemmap-optimization-works.patch
mm-add-pud_same-similar-to-__have_arch_p4d_same.patch
mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch
mm-vmemmap-optimization-split-hugetlb-and-devdax-vmemmap-optimization.patch
powerpc-mm-trace-convert-trace-event-to-trace-event-class.patch
powerpc-book3s64-mm-enable-transparent-pud-hugepage.patch
powerpc-book3s64-vmemmap-switch-radix-to-use-a-different-vmemmap-handling-function.patch
powerpc-book3s64-radix-add-support-for-vmemmap-optimization-for-radix.patch
powerpc-book3s64-radix-remove-mmu_vmemmap_psize.patch
powerpc-book3s64-radix-add-debug-message-to-give-more-details-of-vmemmap-allocation.patch

