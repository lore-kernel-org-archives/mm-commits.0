Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C58189BBD
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728335254; cv=none; b=ekeXWrx3Vi9W+NO12j3Bd8Qi+2gpeFlqbsmoZJmb2ySzuFO3BfUwj5cC4eAS1ZM5Co2GyYu74rhdSgot2/uPdfmedjn0Pr7EYQomKK6Iq8CUCx6vLvILwi6P3KIZp2dXaj4vtyjtzn76nByaNDP0MjoPbyHng1tXRkDeAzaH6DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728335254; c=relaxed/simple;
	bh=mHL5ZTVFKbQcJt9a0vB2vq2LxyqLHm1u+pS1aP+9wkg=;
	h=Date:To:From:Subject:Message-Id; b=LNUGlBtOsxSvNyT/eYwcXphpzohnVWtyfEC7Bk2fYR2KftE0Ti+OHjYkUEW3esisAn8foui3IBLUvCOIg7mooVh3DP9Uv7h9D+yhEKREYlvkW/jq7ARxqMxWpPdKgmXcLIHeLXK5HB0kfodVHUv93uVSJswo2f2uXSFEs2fCA4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ey6CQFKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ey6CQFKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51FEC4CEC6;
	Mon,  7 Oct 2024 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728335253;
	bh=mHL5ZTVFKbQcJt9a0vB2vq2LxyqLHm1u+pS1aP+9wkg=;
	h=Date:To:From:Subject:From;
	b=Ey6CQFKHW5jg5TBSDBy/bxJgHCCLQqoxV5iLq0A0FQ5mB/1uPX5xa8REpSsf3On4J
	 IEB8ADtaEe4zFR9jQZcBW7k+n5SlOHPLZESdMSZXBTTuHO2eWdcBhbPILRT+zQSm3I
	 s5d8BXIT8EuNyAq3taaOoDuIwAELAoguJ3F6IaVk=
Date: Mon, 07 Oct 2024 14:07:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch added to mm-unstable branch
Message-Id: <20241007210733.D51FEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/s390: teach arch_get_unmapped_area{_topdown} to handle hugetlb mappings
has been added to the -mm mm-unstable branch.  Its filename is
     arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch

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

mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch
arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch
mm-drop-hugetlb_get_unmapped_area_-functions.patch
arch-s390-clean-up-hugetlb-definitions.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

