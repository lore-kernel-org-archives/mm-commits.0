From: akpm@linux-foundation.org
Subject: - pie-executable-randomization-fix-3.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:11:09 -0700
Message-ID: <200710162211.l9GMB9Nt020256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966055AbXJPWME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:12:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, ak@suse.de, hpa@zytor.com, jakub@redhat.com, kune@deine-taler.de, magnade@gmail.com, mingo@elte.hu, roland@redhat.com, zlynx@acm.org, mm-commits@vger.kernel.org


The patch titled
     Handle MAP_32BIT flags properly in x86_64 flexmmap
has been removed from the -mm tree.  Its filename was
     pie-executable-randomization-fix-3.patch

This patch was dropped because it was folded into pie-executable-randomization.patch

------------------------------------------------------
Subject: Handle MAP_32BIT flags properly in x86_64 flexmmap
From: Jiri Kosina <jkosina@suse.cz>

We need to handle MAP_32BIT flags of mmap() properly for 64bit applications
with filexible mmap layout.

This patch introduces x86_64-specific version of
arch_get_unmapped_area_topdown() which differs from the generic one in
handling of the MAP_32BIT flag -- when this flag is passed to mmap(), we
stick back to the legacy layout for this particular mmap, which gives
proper 32bit range.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Zan Lynx <zlynx@acm.org>
Cc: Bret Towe <magnade@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/sys_x86_64.c |   98 +++++++++++++++++++++++++++++++++
 include/asm-x86/pgtable_64.h |    1 
 2 files changed, 99 insertions(+)

diff -puN arch/x86/kernel/sys_x86_64.c~pie-executable-randomization-fix-3 arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~pie-executable-randomization-fix-3
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -12,6 +12,7 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/personality.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/ia32.h>
@@ -65,6 +66,7 @@ static void find_start_end(unsigned long
 			   unsigned long *end)
 {
 	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT)) {
+		unsigned long new_begin;
 		/* This is usually used needed to map code in small
 		   model, so it needs to be in the first 31bit. Limit
 		   it to that.  This means we need to move the
@@ -74,6 +76,11 @@ static void find_start_end(unsigned long
 		   of playground for now. -AK */ 
 		*begin = 0x40000000; 
 		*end = 0x80000000;		
+		if (current->flags & PF_RANDOMIZE) {
+			new_begin = randomize_range(*begin, *begin + 0x02000000, 0);
+			if (new_begin)
+				*begin = new_begin;
+		}
 	} else {
 		*begin = TASK_UNMAPPED_BASE;
 		*end = TASK_SIZE; 
@@ -143,6 +150,97 @@ full_search:
 	}
 }
 
+
+unsigned long
+arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
+			  const unsigned long len, const unsigned long pgoff,
+			  const unsigned long flags)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
+	unsigned long addr = addr0;
+
+	/* requested length too big for entire address space */
+	if (len > TASK_SIZE)
+		return -ENOMEM;
+
+	if (flags & MAP_FIXED)
+		return addr;
+
+	/* for MAP_32BIT mappings we force the legact mmap base */
+	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT))
+		goto bottomup;
+
+	/* requesting a specific address */
+	if (addr) {
+		addr = PAGE_ALIGN(addr);
+		vma = find_vma(mm, addr);
+		if (TASK_SIZE - len >= addr &&
+				(!vma || addr + len <= vma->vm_start))
+			return addr;
+	}
+
+	/* check if free_area_cache is useful for us */
+	if (len <= mm->cached_hole_size) {
+ 	        mm->cached_hole_size = 0;
+ 		mm->free_area_cache = mm->mmap_base;
+ 	}
+
+	/* either no address requested or can't fit in requested address hole */
+	addr = mm->free_area_cache;
+
+	/* make sure it can fit in the remaining address space */
+	if (addr > len) {
+		vma = find_vma(mm, addr-len);
+		if (!vma || addr <= vma->vm_start)
+			/* remember the address as a hint for next time */
+			return (mm->free_area_cache = addr-len);
+	}
+
+	if (mm->mmap_base < len)
+		goto bottomup;
+
+	addr = mm->mmap_base-len;
+
+	do {
+		/*
+		 * Lookup failure means no vma is above this address,
+		 * else if new region fits below vma->vm_start,
+		 * return with success:
+		 */
+		vma = find_vma(mm, addr);
+		if (!vma || addr+len <= vma->vm_start)
+			/* remember the address as a hint for next time */
+			return (mm->free_area_cache = addr);
+
+ 		/* remember the largest hole we saw so far */
+ 		if (addr + mm->cached_hole_size < vma->vm_start)
+ 		        mm->cached_hole_size = vma->vm_start - addr;
+
+		/* try just below the current vma->vm_start */
+		addr = vma->vm_start-len;
+	} while (len < vma->vm_start);
+
+bottomup:
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	mm->cached_hole_size = ~0UL;
+  	mm->free_area_cache = TASK_UNMAPPED_BASE;
+	addr = arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
+	/*
+	 * Restore the topdown base:
+	 */
+	mm->free_area_cache = mm->mmap_base;
+	mm->cached_hole_size = ~0UL;
+
+	return addr;
+}
+
+
 asmlinkage long sys_uname(struct new_utsname __user * name)
 {
 	int err;
diff -puN include/asm-x86/pgtable_64.h~pie-executable-randomization-fix-3 include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h~pie-executable-randomization-fix-3
+++ a/include/asm-x86/pgtable_64.h
@@ -411,6 +411,7 @@ pte_t *lookup_address(unsigned long addr
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
 #define HAVE_ARCH_UNMAPPED_AREA
+#define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
 #define pgtable_cache_init()   do { } while (0)
 #define check_pgt_cache()      do { } while (0)
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
pie-executable-randomization.patch
pie-executable-randomization-fix-3.patch
add-config_vt_unicode.patch
get-rid-of-input-bit-duplicate-defines.patch
