Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F22155C97
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854774; cv=none; b=RCeTvwcjq/mL5P4EaL4lG4hy8eCA1M19cz6QrHeqnT4eRZK8gaw/tNOISp7k2lMtdSwprcxM8ID3k6ClRTr7ccK8xYcu2rXmdsQCk2672g6QUeABEjqpI2Gjj913gcjkxzkiLyWQoYfMmok86HEUylyPWqD+u+ygjfeWMxWPxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854774; c=relaxed/simple;
	bh=HpwwnmMptpQ/EvoWUs2Os7zZ4Wqmo8it7Dn+bK/0n6Q=;
	h=Date:To:From:Subject:Message-Id; b=besFE3+rSL2j/bBvQGXi6V9IdKoch5qFeUOK2ACXnXxXa78ihCRoGiwATLSafvYOjvUbLGVxgIZ/Uo5tEI2d0x82AJECi6e+a1k3oKfykNR3hTCw7kv9Rum0Do/nxvd3PNt4y4W4lOMBcc6ndAWXNWD24VShQEmLyeIxg4ShUQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sfy9nl2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sfy9nl2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD22C4CECF;
	Wed,  6 Nov 2024 00:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854774;
	bh=HpwwnmMptpQ/EvoWUs2Os7zZ4Wqmo8it7Dn+bK/0n6Q=;
	h=Date:To:From:Subject:From;
	b=Sfy9nl2S9/E/nE/nVlK49zBU6NAxgyzL/Xa1SgZqiJ6Guau+U+lloGnCCVATtEfiK
	 u9F0Y6gac4xcd6R0pWrMqUSLvRfFlgDl0Yt4b7l1H/kAiDxIY845Vt5ApnqQ9AUTrV
	 zC1IGoSjFz4MF+50ok5ZG5o0rBFIsioDa1cm3XPI=
Date: Tue, 05 Nov 2024 16:59:33 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch removed from -mm tree
Message-Id: <20241106005934.4CD22C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/sparc: teach arch_get_unmapped_area{_topdown} to handle hugetlb mappings
has been removed from the -mm tree.  Its filename was
     arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/sparc: teach arch_get_unmapped_area{_topdown} to handle hugetlb mappings
Date: Mon, 7 Oct 2024 09:50:32 +0200

We want to stop special casing hugetlb mappings and make them go through
generic channels, so teach arch_get_unmapped_area{_topdown} to handle
those.

sparc specific hugetlb function does not set info.align_offset, and does
not care about adjusting the align_mask for MAP_SHARED cases, so the same
here for compatibility.

Link: https://lkml.kernel.org/r/20241007075037.267650-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_32.c |   17 ++++++++++---
 arch/sparc/kernel/sys_sparc_64.c |   37 ++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 12 deletions(-)

--- a/arch/sparc/kernel/sys_sparc_32.c~arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -23,6 +23,7 @@
 #include <linux/utsname.h>
 #include <linux/smp.h>
 #include <linux/ipc.h>
+#include <linux/hugetlb.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -42,12 +43,16 @@ SYSCALL_DEFINE0(getpagesize)
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_unmapped_area_info info = {};
+	bool file_hugepage = false;
+
+	if (filp && is_file_hugepages(filp))
+		file_hugepage = true;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if ((flags & MAP_SHARED) &&
+		if (!file_hugepage && (flags & MAP_SHARED) &&
 		    ((addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1)))
 			return -EINVAL;
 		return addr;
@@ -62,9 +67,13 @@ unsigned long arch_get_unmapped_area(str
 	info.length = len;
 	info.low_limit = addr;
 	info.high_limit = TASK_SIZE;
-	info.align_mask = (flags & MAP_SHARED) ?
-		(PAGE_MASK & (SHMLBA - 1)) : 0;
-	info.align_offset = pgoff << PAGE_SHIFT;
+	if (!file_hugepage) {
+		info.align_mask = (flags & MAP_SHARED) ?
+			(PAGE_MASK & (SHMLBA - 1)) : 0;
+		info.align_offset = pgoff << PAGE_SHIFT;
+	} else {
+		info.align_mask = huge_page_mask_align(filp);
+	}
 	return vm_unmapped_area(&info);
 }
 
--- a/arch/sparc/kernel/sys_sparc_64.c~arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -30,6 +30,7 @@
 #include <linux/context_tracking.h>
 #include <linux/timex.h>
 #include <linux/uaccess.h>
+#include <linux/hugetlb.h>
 
 #include <asm/utrap.h>
 #include <asm/unistd.h>
@@ -87,6 +88,16 @@ static inline unsigned long COLOR_ALIGN(
 	return base + off;
 }
 
+static unsigned long get_align_mask(struct file *filp, unsigned long flags)
+{
+	if (filp && is_file_hugepages(filp))
+		return huge_page_mask_align(filp);
+	if (filp || (flags & MAP_SHARED))
+		return PAGE_MASK & (SHMLBA - 1);
+
+	return 0;
+}
+
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
@@ -94,12 +105,16 @@ unsigned long arch_get_unmapped_area(str
 	unsigned long task_size = TASK_SIZE;
 	int do_color_align;
 	struct vm_unmapped_area_info info = {};
+	bool file_hugepage = false;
+
+	if (filp && is_file_hugepages(filp))
+		file_hugepage = true;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if ((flags & MAP_SHARED) &&
+		if (!file_hugepage && (flags & MAP_SHARED) &&
 		    ((addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1)))
 			return -EINVAL;
 		return addr;
@@ -111,7 +126,7 @@ unsigned long arch_get_unmapped_area(str
 		return -ENOMEM;
 
 	do_color_align = 0;
-	if (filp || (flags & MAP_SHARED))
+	if ((filp || (flags & MAP_SHARED)) && !file_hugepage)
 		do_color_align = 1;
 
 	if (addr) {
@@ -129,8 +144,9 @@ unsigned long arch_get_unmapped_area(str
 	info.length = len;
 	info.low_limit = TASK_UNMAPPED_BASE;
 	info.high_limit = min(task_size, VA_EXCLUDE_START);
-	info.align_mask = do_color_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
-	info.align_offset = pgoff << PAGE_SHIFT;
+	info.align_mask = get_align_mask(filp, flags);
+	if (!file_hugepage)
+		info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
 	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
@@ -154,15 +170,19 @@ arch_get_unmapped_area_topdown(struct fi
 	unsigned long addr = addr0;
 	int do_color_align;
 	struct vm_unmapped_area_info info = {};
+	bool file_hugepage = false;
 
 	/* This should only ever run for 32-bit processes.  */
 	BUG_ON(!test_thread_flag(TIF_32BIT));
 
+	if (filp && is_file_hugepages(filp))
+		file_hugepage = true;
+
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if ((flags & MAP_SHARED) &&
+		if (!file_hugepage && (flags & MAP_SHARED) &&
 		    ((addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1)))
 			return -EINVAL;
 		return addr;
@@ -172,7 +192,7 @@ arch_get_unmapped_area_topdown(struct fi
 		return -ENOMEM;
 
 	do_color_align = 0;
-	if (filp || (flags & MAP_SHARED))
+	if ((filp || (flags & MAP_SHARED)) && !file_hugepage)
 		do_color_align = 1;
 
 	/* requesting a specific address */
@@ -192,8 +212,9 @@ arch_get_unmapped_area_topdown(struct fi
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = do_color_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
-	info.align_offset = pgoff << PAGE_SHIFT;
+	info.align_mask = get_align_mask(filp, flags);
+	if (!file_hugepage)
+		info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
 	/*
_

Patches currently in -mm which might be from osalvador@suse.de are


