Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7638646
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 00:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733962376; cv=none; b=gY0ZMBaWIotm6xIlbwnPw6+12ZEU+OzM16CK7NHFNW4/9NBETvZPbMIkWide5GaWBglYXfGp+d7UhFj/SJ53eH+7nsD8jmO4p/tSiXLpRHjGo+PL2yGOwuK8MkE7fdzt9013nB/rCCyRj68Bul3MGRA3063U7ABByj83wlc/ReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733962376; c=relaxed/simple;
	bh=qDSxXY9Rw0Xo2+z+weCBOnhV4PcXXZ30cgbOPwtPNTI=;
	h=Date:To:From:Subject:Message-Id; b=ezOz8eaeRJZVpseSIGH6pq+cMdj9XuE7X5twaAGOPBMxi4vMvqlArn6CCMpHrudswJIam73bgvCFKwopbgVaXd8ULDDls5UMTD2X3FCnUd01kYCZ6uqE/gqBoEpV55IuE2rj2aKPH63LY+3RoOYFLNOwagzgZfH4824s84v+ELo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tbZu34UG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbZu34UG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8C4C4CED2;
	Thu, 12 Dec 2024 00:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733962376;
	bh=qDSxXY9Rw0Xo2+z+weCBOnhV4PcXXZ30cgbOPwtPNTI=;
	h=Date:To:From:Subject:From;
	b=tbZu34UGwSzRbqf59m3VWDjqMsAe2HZYtcFYGSgfpZSaU4SEBknxgRCGcBbfmcOYR
	 rqwFoNCj2O0S21B3bkc6lB3/CGZeiCv8tTFy5sgeIXwYK8DZgIbPO457Zr8c1y9Xgp
	 9aNm/fJfFdfTQqhn66HMVjK8W7fesIkKvrwPYpSw=
Date: Wed, 11 Dec 2024 16:12:55 -0800
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yang@os.amperecomputing.com,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,riel@surriel.com,minchan@kernel.org,linux@armlinux.org.uk,leitao@debian.org,jcmvbkbc@gmail.com,jason.andryuk@amd.com,James.Bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,bp@alien8.de,bhelgaas@google.com,andreas@gaisler.com,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-introduce-arch_mmap_hint.patch added to mm-unstable branch
Message-Id: <20241212001256.3E8C4C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: x86: introduce arch_mmap_hint()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-x86-introduce-arch_mmap_hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-introduce-arch_mmap_hint.patch

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
From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm: x86: introduce arch_mmap_hint()
Date: Wed, 11 Dec 2024 15:27:40 -0800

Introduce x86 arch_mmap_hint() and define HAVE_ARCH_MMAP_HINT.  This is a
preparatory patch, no functional change is introduced.

Fallback to generic_mmap_hint() if an architecture doesn't provide
HAVE_ARCH_MMAP_HINT.

Link: https://lkml.kernel.org/r/20241211232754.1583023-3-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jason Andryuk <jason.andryuk@amd.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_64.h |    1 
 arch/x86/kernel/sys_x86_64.c      |   64 +++++++++++++---------------
 include/linux/sched/mm.h          |    5 ++
 mm/mmap.c                         |    9 +++
 4 files changed, 45 insertions(+), 34 deletions(-)

--- a/arch/x86/include/asm/pgtable_64.h~mm-x86-introduce-arch_mmap_hint
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -245,6 +245,7 @@ extern void cleanup_highmap(void);
 
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
+#define HAVE_ARCH_MMAP_HINT
 
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
--- a/arch/x86/kernel/sys_x86_64.c~mm-x86-introduce-arch_mmap_hint
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -123,31 +123,44 @@ static inline unsigned long stack_guard_
 	return 0;
 }
 
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+			     unsigned long len, unsigned long pgoff,
+			     unsigned long flags)
+{
+	unsigned long begin, end;
+
+	find_start_end(addr, flags, &begin, &end);
+
+	/* requested length too big for entire address space */
+	if (len > end || len > TASK_SIZE)
+		return -ENOMEM;
+
+	/* No address checking. See comment at mmap_address_hint_valid() */
+	if (flags & MAP_FIXED)
+		return addr;
+
+	addr = PAGE_ALIGN(addr);
+
+	/* Fallback to VA space search? */
+	if (!mmap_address_hint_valid(addr, len))
+		return 0;
+
+	return generic_mmap_hint(filp, addr, len, pgoff, flags);
+}
+
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 		       unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	struct vm_unmapped_area_info info = {};
 	unsigned long begin, end;
 
-	if (flags & MAP_FIXED)
+	addr = arch_mmap_hint(filp, addr, len, pgoff, flags);
+	if (addr)
 		return addr;
 
 	find_start_end(addr, flags, &begin, &end);
 
-	if (len > end)
-		return -ENOMEM;
-
-	if (addr) {
-		addr = PAGE_ALIGN(addr);
-		vma = find_vma(mm, addr);
-		if (end - len >= addr &&
-		    (!vma || addr + len <= vm_start_gap(vma)))
-			return addr;
-	}
-
 	info.length = len;
 	info.low_limit = begin;
 	info.high_limit = end;
@@ -168,34 +181,17 @@ arch_get_unmapped_area_topdown(struct fi
 			  unsigned long len, unsigned long pgoff,
 			  unsigned long flags, vm_flags_t vm_flags)
 {
-	struct vm_area_struct *vma;
-	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
 	struct vm_unmapped_area_info info = {};
 
-	/* requested length too big for entire address space */
-	if (len > TASK_SIZE)
-		return -ENOMEM;
-
-	/* No address checking. See comment at mmap_address_hint_valid() */
-	if (flags & MAP_FIXED)
-		return addr;
-
 	/* for MAP_32BIT mappings we force the legacy mmap base */
 	if (!in_32bit_syscall() && (flags & MAP_32BIT))
 		goto bottomup;
 
 	/* requesting a specific address */
-	if (addr) {
-		addr &= PAGE_MASK;
-		if (!mmap_address_hint_valid(addr, len))
-			goto get_unmapped_area;
-
-		vma = find_vma(mm, addr);
-		if (!vma || addr + len <= vm_start_gap(vma))
-			return addr;
-	}
-get_unmapped_area:
+	addr = arch_mmap_hint(filp, addr, len, pgoff, flags);
+	if (addr)
+		return addr;
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
--- a/include/linux/sched/mm.h~mm-x86-introduce-arch_mmap_hint
+++ a/include/linux/sched/mm.h
@@ -205,6 +205,11 @@ unsigned long generic_mmap_hint(struct f
 				unsigned long len, unsigned long pgoff,
 				unsigned long flags);
 
+/* See generic_mmap_hint() */
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+			     unsigned long len, unsigned long pgoff,
+			     unsigned long flags);
+
 unsigned long
 generic_get_unmapped_area(struct file *filp, unsigned long addr,
 			  unsigned long len, unsigned long pgoff,
--- a/mm/mmap.c~mm-x86-introduce-arch_mmap_hint
+++ a/mm/mmap.c
@@ -705,6 +705,15 @@ arch_get_unmapped_area(struct file *filp
 }
 #endif
 
+#ifndef HAVE_ARCH_MMAP_HINT
+unsigned long arch_mmap_hint(struct file *filp, unsigned long addr,
+				      unsigned long len, unsigned long pgoff,
+				      unsigned long flags)
+{
+	return generic_mmap_hint(filp, addr, len, pgoff, flags);
+}
+#endif
+
 /*
  * This mmap-allocator allocates new areas top-down from below the
  * stack's low limit (the base):
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-introduce-generic_mmap_hint.patch
mm-x86-introduce-arch_mmap_hint.patch
mm-arm-introduce-arch_mmap_hint.patch
mm-alpha-introduce-arch_mmap_hint.patch
mm-arc-use-generic_mmap_hint.patch
mm-csky-introduce-arch_mmap_hint.patch
mm-loongarch-introduce-arch_mmap_hint.patch
mm-mips-introduce-arch_align_mmap_hint.patch
mm-parisc-introduce-arch_align_mmap_hint.patch
mm-s390-use-generic_mmap_hint.patch
mm-sh-introduce-arch_mmap_hint.patch
mm-sparc32-introduce-arch_mmap_hint.patch
mm-sparc64-introduce-arch_mmap_hint.patch
mm-xtensa-introduce-arch_mmap_hint.patch
mm-powerpc-introduce-arch_mmap_hint.patch
mm-respect-mmap-hint-before-thp-alignment-if-allocation-is-possible.patch

