Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DF5C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbjHKXGa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbjHKXFV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19FB3C27
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B4867AD3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA86EC433C7;
        Fri, 11 Aug 2023 23:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794996;
        bh=36WPO+aZyX1lRA/y0Xyd4KUrovkymaHx9KfqN5SvfT4=;
        h=Date:To:From:Subject:From;
        b=uQuDAzW6SUYetGcWD5SqFHL6S/VOUxK9H2K3yQygYbVMnbhcFcgoIEZLF/pwtTEAB
         5lKB8CVqEzDA0Yc00IJ+nOBVst+31KWVSVKCg6JOs5QjQut/mx8+TIbS0c6qjhUf3w
         TvRak3pk/MKtrIv98qndrtMQf6buEy8NxG6gvQuA=
Date:   Fri, 11 Aug 2023 16:03:15 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-pud_same-similar-to-__have_arch_p4d_same.patch removed from -mm tree
Message-Id: <20230811230315.DA86EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add pud_same similar to __HAVE_ARCH_P4D_SAME
has been removed from the -mm tree.  Its filename was
     mm-add-pud_same-similar-to-__have_arch_p4d_same.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm: add pud_same similar to __HAVE_ARCH_P4D_SAME
Date: Tue, 25 Jul 2023 00:37:51 +0530

This helps architectures to override pmd_same and pud_same independently.

Link: https://lkml.kernel.org/r/20230724190759.483013-6-aneesh.kumar@linux.ibm.com
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

 include/linux/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/pgtable.h~mm-add-pud_same-similar-to-__have_arch_p4d_same
+++ a/include/linux/pgtable.h
@@ -699,11 +699,14 @@ static inline int pmd_same(pmd_t pmd_a,
 {
 	return pmd_val(pmd_a) == pmd_val(pmd_b);
 }
+#endif
 
+#ifndef pud_same
 static inline int pud_same(pud_t pud_a, pud_t pud_b)
 {
 	return pud_val(pud_a) == pud_val(pud_b);
 }
+#define pud_same pud_same
 #endif
 
 #ifndef __HAVE_ARCH_P4D_SAME
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

