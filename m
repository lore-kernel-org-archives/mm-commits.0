From: akpm@osdl.org
Subject: + fix-cow-d-cache-aliasing-on-fork.patch added to -mm tree
Date: Tue, 12 Dec 2006 16:36:11 -0800
Message-ID: <200612130036.kBD0aBAi022667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33400 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbWLMAgX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 19:36:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, ralf@linux-mips.org


The patch titled
     Fix COW D-cache aliasing on fork
has been added to the -mm tree.  Its filename is
     fix-cow-d-cache-aliasing-on-fork.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix COW D-cache aliasing on fork
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Problem:

1. There is a process containing two thread (T1 and T2).  The
   thread T1 calls fork().  Then dup_mmap() function called on T1 context.

static inline int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
	...
	flush_cache_mm(current->mm);
	...	/* A */
	(write-protect all Copy-On-Write pages)
	...	/* B */
	flush_tlb_mm(current->mm);
	...

2. When preemption happens between A and B (or on SMP kernel), the
   thread T2 can run and modify data on COW pages without page fault
   (modified data will stay in cache).

3. Some time after fork() completed, the thread T2 may cause a page
   fault by write-protect on a COW page.

4. Then data of the COW page will be copied to newly allocated
   physical page (copy_cow_page()).  It reads data via kernel mapping.
   The kernel mapping can have different 'color' with user space
   mapping of the thread T2 (dcache aliasing).  Therefore
   copy_cow_page() will copy stale data.  Then the modified data in
   cache will be lost.

In order to allow architecture code to deal with this problem allow
architecture code to override copy_user_highpage() by defining
__HAVE_ARCH_COPY_USER_HIGHPAGE in <asm/page.h>.

The main part of this patch was originally written by Ralf Baechle;
Atushi Nemoto did the the debugging.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/highmem.h |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN include/linux/highmem.h~fix-cow-d-cache-aliasing-on-fork include/linux/highmem.h
--- a/include/linux/highmem.h~fix-cow-d-cache-aliasing-on-fork
+++ a/include/linux/highmem.h
@@ -96,6 +96,8 @@ static inline void memclear_highpage_flu
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
+#ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
+
 static inline void copy_user_highpage(struct page *to, struct page *from, unsigned long vaddr)
 {
 	char *vfrom, *vto;
@@ -109,6 +111,8 @@ static inline void copy_user_highpage(st
 	smp_wmb();
 }
 
+#endif
+
 static inline void copy_highpage(struct page *to, struct page *from)
 {
 	char *vfrom, *vto;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
fix-cow-d-cache-aliasing-on-fork.patch
pass-vma-argument-to-copy_user_highpage.patch
mips-fix-cow-d-cache-aliasing-on-fork.patch

