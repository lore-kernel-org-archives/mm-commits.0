Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFBA3B6BE5
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785521184; cv=none; b=lfcGVg+6hwcqGqTuSkB4ka18Z1/xltYZdKG734T2xn4WR7O7GcilU4e5loT5YuBVyhDfbuOJAKsWVC4VVfvAjamgIIpl47NAQjeoxVu9oxWipE3LlfqLtGSDFNkH/243G9X2Pid2Tep5/r9aO2qybBzSgdXHPgtVyoBvl8ZkOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785521184; c=relaxed/simple;
	bh=XCyyr7Pi9Dc6QO1Njg+ZBypzjEogsJg/mtd8pqJfgPs=;
	h=Date:To:From:Subject:Message-Id; b=KhH2TnlayRkuATnipyxWIVyIIu1ZWzsa8GjwqzuyUxqFHQYnd4Dyra3B2ULdjdZ7LIt+hDN3ziQJmNlF4jwAKEwmdqbEPK+I/aCGB8kWDW3PXJorXZK3MWRbpz6XGsViTR3fGhFCVTVigtI4+h4iR2zODhlvSBcW2gDjcKv+dsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yrl40mCF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yrl40mCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558BE1F00ACA;
	Fri, 31 Jul 2026 18:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521181;
	bh=DaOKSRE5kOjWZTchbdytSpnETIJBaQTJa03k2Et3BaY=;
	h=Date:To:From:Subject;
	b=yrl40mCF/REnffTdzQ5RpJ1rZ7Lc/HRTZiQNQAKFPG3er+SRDTKbbBrFIey2VaBAm
	 VHuR2+bMD8PZb9wt0nN8us42QOF81bT8pzj7y2oAfiz3Mblw3oCEx5HLIcU30gVXFX
	 zmMmc/umOd3jdJDvhVChf8aFYh/kSSLgipPigHLU=
Date: Fri, 31 Jul 2026 11:06:20 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-drop-allocate_pgdat.patch added to mm-new branch
Message-Id: <20260731180621.558BE1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sh: mm: drop allocate_pgdat()
has been added to the -mm mm-new branch.  Its filename is
     sh-mm-drop-allocate_pgdat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-mm-drop-allocate_pgdat.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: mm: drop allocate_pgdat()
Date: Sun, 10 May 2026 16:55:39 +0300

allocate_pgdat() function used to allocate the node data structure and
initialize its node_start_pfn and node_spanned_pages fields.

Without CONFIG_NUMA there is no need to allocate the node data and setting
node_start_pfn and node_spanned_pages are redundant because they are
anyway overwritten later by core MM.

Remove allocate_pgdat() function.

Link: https://lore.kernel.org/20260510135546.13554-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/arch/sh/mm/init.c~sh-mm-drop-allocate_pgdat
+++ a/arch/sh/mm/init.c
@@ -199,20 +199,6 @@ void __init page_table_range_init(unsign
 }
 #endif	/* CONFIG_MMU */
 
-void __init allocate_pgdat(unsigned int nid)
-{
-	unsigned long start_pfn, end_pfn;
-
-	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-
-#ifdef CONFIG_NUMA
-	alloc_node_data(nid);
-#endif
-
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-}
-
 static void __init do_init_bootmem(void)
 {
 	unsigned long start_pfn, end_pfn;
@@ -222,8 +208,6 @@ static void __init do_init_bootmem(void)
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL)
 		__add_active_range(0, start_pfn, end_pfn);
 
-	/* All of system RAM sits in node 0 for the non-NUMA case */
-	allocate_pgdat(0);
 	node_set_online(0);
 
 	plat_mem_setup();
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-split-out-mm_init-and-memblock-declarations-from-internalh.patch
mm-split-out-mm_init-and-memblock-declarations-from-internalh-fix.patch
mm-split-out-sparse-declarations-from-internalh.patch
mm-split-out-vmalloc-declarations-from-internalh.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

