Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1DC5661
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005837; cv=none; b=NCBG0UVV+6ovVcdB+OVCeQKn1t2ZJyrB3agxDc8Jih0M/PWvbkn0iOOgK2U2LQu4cVgy9jITgdCDcl+CiXSM8GG1la8NqhreJAjwrjA3nt9re5H6cmetlHrYngf2w5wsYQWnlrA9lRyVaIdv9lq2N/JpNwdOrOGHXQaFFLcL3Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005837; c=relaxed/simple;
	bh=17mn2Uy1n1HxNwSUCYsTRaRy7CKmsmdFY2OIfz+OdcI=;
	h=Date:To:From:Subject:Message-Id; b=FRq1HAi/SO1KaTL8LHRMJ1Xg1Gh2QTwro6H5urOD1MfoRsdwUER+6i6PoyMtSeKLEMVbgfTg7yT3mDX5mNYOwmPA3n5wP9XIWdwcXFWtc9UfWalbbOujT6pFwZe1Ybwcvlnb9DN67iK9A4ZVvYqDe4tYsZZjy4pwpepd8648dRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ATUq50pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ATUq50pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A047C4CED6;
	Thu, 16 Jan 2025 05:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737005837;
	bh=17mn2Uy1n1HxNwSUCYsTRaRy7CKmsmdFY2OIfz+OdcI=;
	h=Date:To:From:Subject:From;
	b=ATUq50pOKfbPoGJAoVVMViqaRY7krGTKpNUFZxjFDAe/BVOKaKsWbaeE5AoF+6e3F
	 8db2kUmuMdZiuFaa33L+NWk53bx2XrLzw9m+uN+fQrcDfBz0/JPaBbdLJXLUMqGJHy
	 vQ8goCvrn1yoJIFF9C15CcumPzJuvAlGXdLvBE4c=
Date: Wed, 15 Jan 2025 21:37:16 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,geert@linux-m68k.org,agordeev@linux.ibm.com,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch removed from -mm tree
Message-Id: <20250116053717.1A047C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/s390: save_area_alloc default failure behavior changed to panic
has been removed from the -mm tree.  Its filename was
     arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch

This patch was dropped because it was folded into mm-memblock-add-memblock_alloc_or_panic-interface.patch

------------------------------------------------------
From: Guo Weikang <guoweikang.kernel@gmail.com>
Subject: arch/s390: save_area_alloc default failure behavior changed to panic
Date: Thu, 9 Jan 2025 11:31:36 +0800

Now with the memblock_alloc_or_panic interface, save_area_alloc no longer
needs to handle panic itself.

Link: https://lkml.kernel.org/r/20250109033136.2845676-1-guoweikang.kernel@gmail.com
Link: https://lore.kernel.org/lkml/Z2fknmnNtiZbCc7x@kernel.org/
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/crash_dump.c |    4 +---
 arch/s390/kernel/numa.c       |    3 +--
 arch/s390/kernel/smp.c        |    4 ----
 3 files changed, 2 insertions(+), 9 deletions(-)

--- a/arch/s390/kernel/crash_dump.c~arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic
+++ a/arch/s390/kernel/crash_dump.c
@@ -63,9 +63,7 @@ struct save_area * __init save_area_allo
 {
 	struct save_area *sa;
 
-	sa = memblock_alloc(sizeof(*sa), 8);
-	if (!sa)
-		return NULL;
+	sa = memblock_alloc_or_panic(sizeof(*sa), 8);
 
 	if (is_boot_cpu)
 		list_add(&sa->list, &dump_save_areas);
--- a/arch/s390/kernel/numa.c~arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic
+++ a/arch/s390/kernel/numa.c
@@ -21,9 +21,8 @@ void __init numa_setup(void)
 	nodes_clear(node_possible_map);
 	node_set(0, node_possible_map);
 	node_set_online(0);
-	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		NODE_DATA(nid) = memblock_alloc_or_panic(sizeof(pg_data_t), 8);
-	}
 	NODE_DATA(0)->node_spanned_pages = memblock_end_of_DRAM() >> PAGE_SHIFT;
 	NODE_DATA(0)->node_id = 0;
 }
--- a/arch/s390/kernel/smp.c~arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic
+++ a/arch/s390/kernel/smp.c
@@ -611,8 +611,6 @@ void __init smp_save_dump_ipl_cpu(void)
 	if (!dump_available())
 		return;
 	sa = save_area_alloc(true);
-	if (!sa)
-		panic("could not allocate memory for boot CPU save area\n");
 	regs = memblock_alloc_or_panic(512, 8);
 	copy_oldmem_kernel(regs, __LC_FPREGS_SAVE_AREA, 512);
 	save_area_add_regs(sa, regs);
@@ -646,8 +644,6 @@ void __init smp_save_dump_secondary_cpus
 		    SIGP_CC_NOT_OPERATIONAL)
 			continue;
 		sa = save_area_alloc(false);
-		if (!sa)
-			panic("could not allocate memory for save area\n");
 		__pcpu_sigp_relax(addr, SIGP_STORE_STATUS_AT_ADDRESS, __pa(page));
 		save_area_add_regs(sa, page);
 		if (cpu_has_vx()) {
_

Patches currently in -mm which might be from guoweikang.kernel@gmail.com are

mm-memblock-add-memblock_alloc_or_panic-interface.patch

