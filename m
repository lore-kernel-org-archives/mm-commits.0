Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B418B33C9
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736400887; cv=none; b=eHu0jsonnufDYX742XqaScXHpYKRkkj6HFOT9qg4xyPNXPwEKVPNtQtJgsm050/WHwiaUFJqDp9eiu6X1BnBcEYqLt/ekGK8Yi32E8Yaa8im55MtSx7I8X7Y4MczaEPolQ4iZjLl4KBiA9D3DZr7pRqN8o7pZzrtDzpVO2Z2sa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736400887; c=relaxed/simple;
	bh=Is5k0UhdlZe6fxb16wzDfWQQpG7pa7RTvWJJy0qvYOk=;
	h=Date:To:From:Subject:Message-Id; b=FIPU4cWox7aRbxVXZpQi3a7lfBKdBE9DORmdug6+Lauibb9xz5sFjbRZ9P0yBhi+akPa2LixcyiM4nwAXNh2YR0ZlDhjm1OHW1FuYrqn/XuRxQPMyp5SwOVPZtRlKoCdCTW2FeKPrJ/aCWUMLWID/4tAbRKfZgWfQhTFrrSyDCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kjmbwGwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kjmbwGwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C700C4CED2;
	Thu,  9 Jan 2025 05:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736400887;
	bh=Is5k0UhdlZe6fxb16wzDfWQQpG7pa7RTvWJJy0qvYOk=;
	h=Date:To:From:Subject:From;
	b=kjmbwGwdp3SESEHreE9MdlGOqEjoj5iEFGw7D0UOstBfLzSOsTaZbdFgywgP7vkGs
	 Gu+chE0kUwK8UTGjq9DKsRt3s08p5AQSqbYfjuOMYW4Br5KWd4j5CJ3zQfqtd24sEW
	 L7N2qrKMPS+P+z2dbdK0CxBnlutE+0gs4hJbrUYg=
Date: Wed, 08 Jan 2025 21:34:46 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,geert@linux-m68k.org,agordeev@linux.ibm.com,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch added to mm-unstable branch
Message-Id: <20250109053447.1C700C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/s390: save_area_alloc default failure behavior changed to panic
has been added to the -mm mm-unstable branch.  Its filename is
     arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch

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
From: Guo Weikang <guoweikang.kernel@gmail.com>
Subject: arch/s390: save_area_alloc default failure behavior changed to panic
Date: Thu, 9 Jan 2025 11:31:36 +0800

Now with the memblock_alloc_or_panic interface, save_area_alloc no longer
needs to handle panic itself.

Link: https://lkml.kernel.org/r/20250109033136.2845676-1-guoweikang.kernel@gmail.com
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

mm-kmemleak-fix-percpu-memory-leak-detection-failure.patch
mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch
mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference.patch
mm-memblock-add-memblock_alloc_or_panic-interface.patch
arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch
mm-memmap-prevent-double-scanning-of-memmap-by-kmemleak.patch

