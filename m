Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7F4C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbjHKXGg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237108AbjHKXFV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2410B3C2B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF42463F1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158EEC433C7;
        Fri, 11 Aug 2023 23:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794997;
        bh=+M5EFeIoeNVgdcGnbkl2D3yqrvUSSi0t+kYHlnSnx3k=;
        h=Date:To:From:Subject:From;
        b=BXz9T4lY4EhIxDa+UCIsa++ifzj+oPq2UQKV24KVWIymn6s4nJKThORTMpAGKqVHW
         ylLOsxtyJD6eXYedicw8r5RUxKRoUnme4llwA/cUYtV7PPKbKZ7KqGaks99Hq3h359
         KF58k2JZPeQNq475c7gCDgwiw8wjHrs64waN1n44=
Date:   Fri, 11 Aug 2023 16:03:16 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, osalvador@suse.de,
        npiggin@gmail.com, muchun.song@linux.dev, mpe@ellerman.id.au,
        mike.kravetz@oracle.com, joao.m.martins@oracle.com,
        dan.j.williams@intel.com, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, aneesh.kumar@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch removed from -mm tree
Message-Id: <20230811230317.158EEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge pud: use transparent huge pud helpers only with CONFIG_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/huge pud: use transparent huge pud helpers only with CONFIG_TRANSPARENT_HUGEPAGE
Date: Tue, 25 Jul 2023 00:37:52 +0530

pudp_set_wrprotect and move_huge_pud helpers are only used when
CONFIG_TRANSPARENT_HUGEPAGE is enabled.  Similar to pmdp_set_wrprotect and
move_huge_pmd_helpers use architecture override only if
CONFIG_TRANSPARENT_HUGEPAGE is set

Link: https://lkml.kernel.org/r/20230724190759.483013-7-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

 include/linux/pgtable.h |    2 ++
 mm/mremap.c             |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage
+++ a/include/linux/pgtable.h
@@ -564,6 +564,7 @@ static inline void pmdp_set_wrprotect(st
 #endif
 #ifndef __HAVE_ARCH_PUDP_SET_WRPROTECT
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void pudp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pud_t *pudp)
 {
@@ -577,6 +578,7 @@ static inline void pudp_set_wrprotect(st
 {
 	BUILD_BUG();
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 #endif
 
--- a/mm/mremap.c~mm-huge-pud-use-transparent-huge-pud-helpers-only-with-config_transparent_hugepage
+++ a/mm/mremap.c
@@ -349,7 +349,7 @@ static inline bool move_normal_pud(struc
 }
 #endif
 
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
 			  unsigned long new_addr, pud_t *old_pud, pud_t *new_pud)
 {
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-memory_hotplug-simplify-arch_mhp_memmap_on_memory_enable-kconfig.patch
mm-memory_hotplug-allow-memmap-on-memory-hotplug-request-to-fallback.patch
mm-memory_hotplug-allow-architecture-to-override-memmap-on-memory-support-check.patch
mm-memory_hotplug-support-memmap_on_memory-when-memmap-is-not-aligned-to-pageblocks.patch
powerpc-book3s64-memhotplug-enable-memmap-on-memory-for-radix.patch
mm-memory_hotplug-embed-vmem_altmap-details-in-memory-block.patch

