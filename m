Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7117E1
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 23:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722295892; cv=none; b=spVMz23lSXKZ2YuYpdUlNMAZ0M7m/beKuIxZBP2sKsu6E43BN/kmuzpIZ4CGuEq5t4hCI7Gn4RpBjxkm7McR9fFVkqfbRE2oxUXNSqVvX40TBxHXn5ovNKrz1J48U3mKzbUP2PR6ZDYMXD6hmCMG6wHCQt12GkbsC778SHLPSgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722295892; c=relaxed/simple;
	bh=g1MIdOS77lUEEQpP1vsNdDIEs2PlaldVOrxQFZru2Pw=;
	h=Date:To:From:Subject:Message-Id; b=sNwCloqg5rp3zJP4nQiQHmGIGOSuMroMiFgvrsTqAfCCxjWlpNXidraSUkHgXRjCnqk86GbZA9WFF0brvA4YGZh2CLV8f+R2dyPsAZslN2kuVlxU1tdG8DeOkl9Jm3pL5Dq5c7T4sITtCD53d32SzEaH0IYRner4hRntoGhw1Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YaARYcTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YaARYcTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6B7C32786;
	Mon, 29 Jul 2024 23:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722295892;
	bh=g1MIdOS77lUEEQpP1vsNdDIEs2PlaldVOrxQFZru2Pw=;
	h=Date:To:From:Subject:From;
	b=YaARYcTOYfKOHnY8yN1NhKaWydCkHmC5HkGKILLPmU1ZHbuI7kTJzoaPRNHQUhFon
	 WkL8V91Zl90O9JZVajUvM8vorT81cWRDRADvZ/IAQJGPSdWJ5OQMV0DusOhkfy947u
	 HQHMQ50w7K4vCSFvJO8S1Ln6JW0X57tRTxIT/v4c=
Date: Mon, 29 Jul 2024 16:31:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch added to mm-unstable branch
Message-Id: <20240729233132.5B6B7C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings
has been added to the -mm mm-unstable branch.  Its filename is
     arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch

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
Subject: arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings
Date: Mon, 29 Jul 2024 11:10:12 +0200

We want to stop special casing hugetlb mappings and make them go through
generic channels, so teach arch_get_unmapped_area_{topdown_}vmflags to
handle those.

x86 specific hugetlb function does not set either info.start_gap or
info.align_offset so the same here for compability.

Link: https://lkml.kernel.org/r/20240729091018.2152-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
@@ -148,12 +151,15 @@ arch_get_unmapped_area_vmflags(struct fi
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

mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch
arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch
mm-drop-hugetlb_get_unmapped_area_-functions.patch
arch-s390-clean-up-hugetlb-definitions.patch
mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align.patch

