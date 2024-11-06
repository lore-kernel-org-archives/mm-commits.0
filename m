Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA43A155C97
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854771; cv=none; b=DKevmFL6ehgTzKcBxGsiEUyavINZ2fXPOzzOhxTsnrpUCGGB1Gp1OLDv8qFJFDKYnimBi77hqFmz05sFoyUC7N86CMAg5CmSwW6srPtK58JCVu7DU/ucpeEJJNe/iShJrNW5fY8ePdMqODJORzb5p7IIKcAvO2h/34L0QgeBPu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854771; c=relaxed/simple;
	bh=fOk5V2no5Lygdn7AqwIOp7AphbfGBaIgIlSCbV6URbo=;
	h=Date:To:From:Subject:Message-Id; b=OWYN9O8kMufeoCUK7UoWCVkNXn84TLHbr7wAYgebkEyLtfrcxaatya7xcCt5Cp9ijuhM8SpNRKFL10Dnd7GPUANPHAbq1nbOU4lcE+nCYdRJp0UnYML0TM5ufzEezsh7iKYbrsBzWOWwVY0zreoylYSo2VQe9o2SilPINe6591c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LNABfu20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LNABfu20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0D2C4CECF;
	Wed,  6 Nov 2024 00:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854771;
	bh=fOk5V2no5Lygdn7AqwIOp7AphbfGBaIgIlSCbV6URbo=;
	h=Date:To:From:Subject:From;
	b=LNABfu20KOH8P88eagxv8VN+WC5WJWACUpTHmZWA6X+mgVWlFKXkUV3Ls+qMX69sD
	 wkKJ2BEaS8Tos5XX2QV3L1BUtyGftC0owL+H7dDyQUyWJcU5IYmyaz1jOVtxsh6U+8
	 cfkjBRjndmiSROMm3BqgBSkLlBbzVVMOoMsSEleY=
Date: Tue, 05 Nov 2024 16:59:30 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch removed from -mm tree
Message-Id: <20241106005931.7C0D2C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/s390: teach arch_get_unmapped_area{_topdown} to handle hugetlb mappings
has been removed from the -mm tree.  Its filename was
     arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: arch/s390: teach arch_get_unmapped_area{_topdown} to handle hugetlb mappings
Date: Mon, 7 Oct 2024 09:50:30 +0200

We want to stop special casing hugetlb mappings and make them go through
generic channels, so teach arch_get_unmapped_area{_topdown} to handle
those.

s390 specific hugetlb function does not set info.align_offset, so do the
same here for compatibility.

Link: https://lkml.kernel.org/r/20241007075037.267650-3-osalvador@suse.de
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

 arch/s390/mm/mmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/mmap.c~arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings
+++ a/arch/s390/mm/mmap.c
@@ -17,6 +17,7 @@
 #include <linux/random.h>
 #include <linux/compat.h>
 #include <linux/security.h>
+#include <linux/hugetlb.h>
 #include <asm/elf.h>
 
 static unsigned long stack_maxrandom_size(void)
@@ -73,6 +74,8 @@ static inline unsigned long mmap_base(un
 
 static int get_align_mask(struct file *filp, unsigned long flags)
 {
+	if (filp && is_file_hugepages(filp))
+		return huge_page_mask_align(filp);
 	if (!(current->flags & PF_RANDOMIZE))
 		return 0;
 	if (filp || (flags & MAP_SHARED))
@@ -106,7 +109,8 @@ unsigned long arch_get_unmapped_area(str
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = get_align_mask(filp, flags);
-	info.align_offset = pgoff << PAGE_SHIFT;
+	if (!(filp && is_file_hugepages(filp)))
+		info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 	if (offset_in_page(addr))
 		return addr;
@@ -144,7 +148,8 @@ unsigned long arch_get_unmapped_area_top
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	info.align_mask = get_align_mask(filp, flags);
-	info.align_offset = pgoff << PAGE_SHIFT;
+	if (!(filp && is_file_hugepages(filp)))
+		info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
 	/*
_

Patches currently in -mm which might be from osalvador@suse.de are


