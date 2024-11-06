Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCA4155C97
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854773; cv=none; b=spguu6VuzxXbQVQ5eaBsZIi1rt1YfZ3yaN0nOd1NBkMOiqf1ro4q+4hmFOMyeS9xQ7T8ZsB3jXTNl1/OkdgOUkrU94pXalPgMqmqAAQauw/pLqT7nJzQSOP3d8HFmxGil9p7UDZxYSTUWcxt1KR2go0cbepJIhVwHAqyWHa7vyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854773; c=relaxed/simple;
	bh=qnJgtIg6NumHBVSMSaHMB8KFYGLjjcqKk+ScAqKqmh0=;
	h=Date:To:From:Subject:Message-Id; b=Qah7uWUNAGimhDrhJKI6i6iMIVlCrSnxsQlQfqv57cJO+riNEKgvBK9DozDF2ZzA30vQU8m3axZmLX6dSpIdEO8jBFzJ9o1tG33Zi7B2yeY9GwoaHLvRAjnqmWOXBtyPfjBwrrkM/zGnuG+u1PAmgRkNSUcUMHOUe+8Ia3/n+MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eEvXbchu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eEvXbchu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7419C4CECF;
	Wed,  6 Nov 2024 00:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854773;
	bh=qnJgtIg6NumHBVSMSaHMB8KFYGLjjcqKk+ScAqKqmh0=;
	h=Date:To:From:Subject:From;
	b=eEvXbchuT+5+02NQ5CV9i/PdrFccwIMa3+OyBoGcP4ks2i9bR5VyI1ZBNfOXzrOoC
	 xghbIDRf39ML9kWJqFnC+/pcpXY7oHcsY2vhfZm4srLLlDtZ7ya7LHtO0yZVWABf9O
	 gBiq433F3nZe+jzByPofAQ6HPaZvM24CdznQsDp0=
Date: Tue, 05 Nov 2024 16:59:32 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch removed from -mm tree
Message-Id: <20241106005932.E7419C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings
has been removed from the -mm tree.  Its filename was
     arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings
Date: Mon, 7 Oct 2024 09:50:31 +0200

We want to stop special casing hugetlb mappings and make them go through
generic channels, so teach arch_get_unmapped_area_{topdown_}vmflags to
handle those.

x86 specific hugetlb function does not set either info.start_gap or
info.align_offset so the same here for compatibility.

Link: https://lkml.kernel.org/r/20241007075037.267650-4-osalvador@suse.de
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

 arch/x86/kernel/sys_x86_64.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/sys_x86_64.c~arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -18,6 +18,7 @@
 #include <linux/random.h>
 #include <linux/uaccess.h>
 #include <linux/elf.h>
+#include <linux/hugetlb.h>
 
 #include <asm/elf.h>
 #include <asm/ia32.h>
@@ -25,8 +26,10 @@
 /*
  * Align a virtual address to avoid aliasing in the I$ on AMD F15h.
  */
-static unsigned long get_align_mask(void)
+static unsigned long get_align_mask(struct file *filp)
 {
+	if (filp && is_file_hugepages(filp))
+		return huge_page_mask_align(filp);
 	/* handle 32- and 64-bit case with a single conditional */
 	if (va_align.flags < 0 || !(va_align.flags & (2 - mmap_is_ia32())))
 		return 0;
@@ -49,7 +52,7 @@ static unsigned long get_align_mask(void
  */
 static unsigned long get_align_bits(void)
 {
-	return va_align.bits & get_align_mask();
+	return va_align.bits & get_align_mask(NULL);
 }
 
 static int __init control_va_addr_alignment(char *str)
@@ -148,12 +151,15 @@ arch_get_unmapped_area(struct file *filp
 	info.length = len;
 	info.low_limit = begin;
 	info.high_limit = end;
-	info.align_offset = pgoff << PAGE_SHIFT;
-	info.start_gap = stack_guard_placement(vm_flags);
+	if (!(filp && is_file_hugepages(filp))) {
+		info.align_offset = pgoff << PAGE_SHIFT;
+		info.start_gap = stack_guard_placement(vm_flags);
+	}
 	if (filp) {
-		info.align_mask = get_align_mask();
+		info.align_mask = get_align_mask(filp);
 		info.align_offset += get_align_bits();
 	}
+
 	return vm_unmapped_area(&info);
 }
 
@@ -199,7 +205,10 @@ get_unmapped_area:
 		info.low_limit = PAGE_SIZE;
 
 	info.high_limit = get_mmap_base(0);
-	info.start_gap = stack_guard_placement(vm_flags);
+	if (!(filp && is_file_hugepages(filp))) {
+		info.start_gap = stack_guard_placement(vm_flags);
+		info.align_offset = pgoff << PAGE_SHIFT;
+	}
 
 	/*
 	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
@@ -211,9 +220,8 @@ get_unmapped_area:
 	if (addr > DEFAULT_MAP_WINDOW && !in_32bit_syscall())
 		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
 
-	info.align_offset = pgoff << PAGE_SHIFT;
 	if (filp) {
-		info.align_mask = get_align_mask();
+		info.align_mask = get_align_mask(filp);
 		info.align_offset += get_align_bits();
 	}
 	addr = vm_unmapped_area(&info);
_

Patches currently in -mm which might be from osalvador@suse.de are


