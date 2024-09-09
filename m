Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB93318E05F
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925296; cv=none; b=qPtzMmDIjb7ZSQjePW8nrsWIRga6h4hULTdpZ2X/XeflB5zsEk8cCsS7yUG0hJTfY3lMW56WodmICjm9lK4vu2jv/vPboFZt9DWtrwelsi7Y5nI5ekyinfNvKHIucTBtnhR1jrMunS7PHeFWQsdbpjGWI1f1KagT88NUCbrhwNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925296; c=relaxed/simple;
	bh=6CjB+/gZIG+U6Bq2X8vQP/lrpPfv/paIf6OKKufus9k=;
	h=Date:To:From:Subject:Message-Id; b=mkXC+e3la4ZvSVkeEaHgeOZ1FXGxCkfkzU1fwuI0BgmMGoy6NtxxjkqFdchntUr9c/yB2+pqSx5V2xx6dSpzKEdmtBcrDysQ7D1sHL7EwTvX8Yhy+DocIfd7N1izZqnVcENFt5aLcfkBH/68UlLXgslrYYysH9wpu2hpqtFYazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a/6R4Wuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a/6R4Wuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5E6C4CEC5;
	Mon,  9 Sep 2024 23:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925296;
	bh=6CjB+/gZIG+U6Bq2X8vQP/lrpPfv/paIf6OKKufus9k=;
	h=Date:To:From:Subject:From;
	b=a/6R4WuoY1o72k7xhQTSHhCyjsyKKxacb/1P4QTCJ2tvjDMNgvr7vMgnOGfsN3Rxw
	 4hQtr70gXlcg1rQv3QHhevUaUDsNFGEuR6fBFa2mOP3tb+XGYHD3U0US4eoQTNMFAn
	 +OhHWxTd8jh6yZRyhkDobEsQ897vvTSfmuOiFiYI=
Date: Mon, 09 Sep 2024 16:41:36 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,vgupta@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@linutronix.de,svens@linux.ibm.com,rick.p.edgecombe@intel.com,richard.henderson@linaro.org,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linux@armlinux.org.uk,Liam.Howlett@Oracle.com,kernel@xen0n.name,jcmvbkbc@gmail.com,James.Bottomley@HansenPartnership.com,ink@jurassic.park.msu.ru,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,andreas@gaisler.com,agordeev@linux.ibm.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-arch_get_unmapped_area-take-vm_flags-by-default.patch removed from -mm tree
Message-Id: <20240909234136.AA5E6C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make arch_get_unmapped_area() take vm_flags by default
has been removed from the -mm tree.  Its filename was
     mm-make-arch_get_unmapped_area-take-vm_flags-by-default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: mm: make arch_get_unmapped_area() take vm_flags by default
Date: Wed, 04 Sep 2024 17:57:59 +0100

Patch series "mm: Care about shadow stack guard gap when getting an
unmapped area", v2.

As covered in the commit log for c44357c2e76b ("x86/mm: care about shadow
stack guard gap during placement") our current mmap() implementation does
not take care to ensure that a new mapping isn't placed with existing
mappings inside it's own guard gaps.  This is particularly important for
shadow stacks since if two shadow stacks end up getting placed adjacent to
each other then they can overflow into each other which weakens the
protection offered by the feature.

On x86 there is a custom arch_get_unmapped_area() which was updated by the
above commit to cover this case by specifying a start_gap for allocations
with VM_SHADOW_STACK.  Both arm64 and RISC-V have equivalent features and
use the generic implementation of arch_get_unmapped_area() so let's make
the equivalent change there so they also don't get shadow stack pages
placed without guard pages.  The arm64 and RISC-V shadow stack
implementations are currently on the list:

   https://lore.kernel.org/r/20240829-arm64-gcs-v12-0-42fec94743
   https://lore.kernel.org/lkml/20240403234054.2020347-1-debug@rivosinc.com/

Given the addition of the use of vm_flags in the generic implementation we
also simplify the set of possibilities that have to be dealt with in the
core code by making arch_get_unmapped_area() take vm_flags as standard. 
This is a bit invasive since the prototype change touches quite a few
architectures but since the parameter is ignored the change is
straightforward, the simplification for the generic code seems worth it.


This patch (of 3):

When we introduced arch_get_unmapped_area_vmflags() in 961148704acd ("mm:
introduce arch_get_unmapped_area_vmflags()") we did so as part of properly
supporting guard pages for shadow stacks on x86_64, which uses a custom
arch_get_unmapped_area().  Equivalent features are also present on both
arm64 and RISC-V, both of which use the generic implementation of
arch_get_unmapped_area() and will require equivalent modification there. 
Rather than continue to deal with having two versions of the functions
let's bite the bullet and have all implementations of
arch_get_unmapped_area() take vm_flags as a parameter.

The new parameter is currently ignored by all implementations other than
x86.  The only caller that doesn't have a vm_flags available is
mm_get_unmapped_area(), as for the x86 implementation and the wrapper used
on other architectures this is modified to supply no flags.

No functional changes.

Link: https://lkml.kernel.org/r/20240904-mm-generic-shadow-stack-guard-v2-0-a46b8b6dc0ed@kernel.org
Link: https://lkml.kernel.org/r/20240904-mm-generic-shadow-stack-guard-v2-1-a46b8b6dc0ed@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Helge Deller <deller@gmx.de>	[parisc]
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c       |    2 -
 arch/arc/mm/mmap.c                |    3 +-
 arch/arm/mm/mmap.c                |    7 +++---
 arch/csky/abiv1/mmap.c            |    3 +-
 arch/loongarch/mm/mmap.c          |    5 ++--
 arch/mips/mm/mmap.c               |    5 ++--
 arch/parisc/kernel/sys_parisc.c   |    5 ++--
 arch/parisc/mm/hugetlbpage.c      |    2 -
 arch/powerpc/mm/book3s64/slice.c  |    6 +++--
 arch/s390/mm/mmap.c               |    4 +--
 arch/sh/mm/mmap.c                 |    5 ++--
 arch/sparc/kernel/sys_sparc_32.c  |    2 -
 arch/sparc/kernel/sys_sparc_64.c  |    4 +--
 arch/x86/include/asm/pgtable_64.h |    1 
 arch/x86/kernel/sys_x86_64.c      |   21 ++----------------
 arch/xtensa/kernel/syscall.c      |    3 +-
 include/linux/sched/mm.h          |   23 +++++++-------------
 mm/mmap.c                         |   31 ++++++----------------------
 18 files changed, 51 insertions(+), 81 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/alpha/kernel/osf_sys.c
@@ -1229,7 +1229,7 @@ arch_get_unmapped_area_1(unsigned long a
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		       unsigned long len, unsigned long pgoff,
-		       unsigned long flags)
+		       unsigned long flags, vm_flags_t vm_flags)
 {
 	unsigned long limit;
 
--- a/arch/arc/mm/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/arc/mm/mmap.c
@@ -23,7 +23,8 @@
  */
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+		unsigned long len, unsigned long pgoff,
+		unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
--- a/arch/arm/mm/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/arm/mm/mmap.c
@@ -28,7 +28,8 @@
  */
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+		unsigned long len, unsigned long pgoff,
+		unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -78,8 +79,8 @@ arch_get_unmapped_area(struct file *filp
 
 unsigned long
 arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
-			const unsigned long len, const unsigned long pgoff,
-			const unsigned long flags)
+		        const unsigned long len, const unsigned long pgoff,
+		        const unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
--- a/arch/csky/abiv1/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/csky/abiv1/mmap.c
@@ -23,7 +23,8 @@
  */
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+		unsigned long len, unsigned long pgoff,
+		unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
--- a/arch/loongarch/mm/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/loongarch/mm/mmap.c
@@ -89,7 +89,8 @@ static unsigned long arch_get_unmapped_a
 }
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr0,
-	unsigned long len, unsigned long pgoff, unsigned long flags)
+	unsigned long len, unsigned long pgoff, unsigned long flags,
+	vm_flags_t vm_flags)
 {
 	return arch_get_unmapped_area_common(filp,
 			addr0, len, pgoff, flags, UP);
@@ -101,7 +102,7 @@ unsigned long arch_get_unmapped_area(str
  */
 unsigned long arch_get_unmapped_area_topdown(struct file *filp,
 	unsigned long addr0, unsigned long len, unsigned long pgoff,
-	unsigned long flags)
+	unsigned long flags, vm_flags_t vm_flags)
 {
 	return arch_get_unmapped_area_common(filp,
 			addr0, len, pgoff, flags, DOWN);
--- a/arch/mips/mm/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/mips/mm/mmap.c
@@ -98,7 +98,8 @@ static unsigned long arch_get_unmapped_a
 }
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr0,
-	unsigned long len, unsigned long pgoff, unsigned long flags)
+	unsigned long len, unsigned long pgoff, unsigned long flags,
+	vm_flags_t vm_flags)
 {
 	return arch_get_unmapped_area_common(filp,
 			addr0, len, pgoff, flags, UP);
@@ -110,7 +111,7 @@ unsigned long arch_get_unmapped_area(str
  */
 unsigned long arch_get_unmapped_area_topdown(struct file *filp,
 	unsigned long addr0, unsigned long len, unsigned long pgoff,
-	unsigned long flags)
+	unsigned long flags, vm_flags_t vm_flags)
 {
 	return arch_get_unmapped_area_common(filp,
 			addr0, len, pgoff, flags, DOWN);
--- a/arch/parisc/kernel/sys_parisc.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -167,7 +167,8 @@ static unsigned long arch_get_unmapped_a
 }
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-	unsigned long len, unsigned long pgoff, unsigned long flags)
+	unsigned long len, unsigned long pgoff, unsigned long flags,
+	vm_flags_t vm_flags)
 {
 	return arch_get_unmapped_area_common(filp,
 			addr, len, pgoff, flags, UP);
@@ -175,7 +176,7 @@ unsigned long arch_get_unmapped_area(str
 
 unsigned long arch_get_unmapped_area_topdown(struct file *filp,
 	unsigned long addr, unsigned long len, unsigned long pgoff,
-	unsigned long flags)
+	unsigned long flags, vm_flags_t vm_flags)
 {
 	return arch_get_unmapped_area_common(filp,
 			addr, len, pgoff, flags, DOWN);
--- a/arch/parisc/mm/hugetlbpage.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -40,7 +40,7 @@ hugetlb_get_unmapped_area(struct file *f
 		addr = ALIGN(addr, huge_page_size(h));
 
 	/* we need to make sure the colouring is OK */
-	return arch_get_unmapped_area(file, addr, len, pgoff, flags);
+	return arch_get_unmapped_area(file, addr, len, pgoff, flags, 0);
 }
 
 
--- a/arch/powerpc/mm/book3s64/slice.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/powerpc/mm/book3s64/slice.c
@@ -637,7 +637,8 @@ unsigned long arch_get_unmapped_area(str
 				     unsigned long addr,
 				     unsigned long len,
 				     unsigned long pgoff,
-				     unsigned long flags)
+				     unsigned long flags,
+				     vm_flags_t vm_flags)
 {
 	if (radix_enabled())
 		return generic_get_unmapped_area(filp, addr, len, pgoff, flags);
@@ -650,7 +651,8 @@ unsigned long arch_get_unmapped_area_top
 					     const unsigned long addr0,
 					     const unsigned long len,
 					     const unsigned long pgoff,
-					     const unsigned long flags)
+					     const unsigned long flags,
+					     vm_flags_t vm_flags)
 {
 	if (radix_enabled())
 		return generic_get_unmapped_area_topdown(filp, addr0, len, pgoff, flags);
--- a/arch/s390/mm/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/s390/mm/mmap.c
@@ -82,7 +82,7 @@ static int get_align_mask(struct file *f
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 				     unsigned long len, unsigned long pgoff,
-				     unsigned long flags)
+				     unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -117,7 +117,7 @@ check_asce_limit:
 
 unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 					     unsigned long len, unsigned long pgoff,
-					     unsigned long flags)
+					     unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
--- a/arch/sh/mm/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/sh/mm/mmap.c
@@ -52,7 +52,8 @@ static inline unsigned long COLOUR_ALIGN
 }
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-	unsigned long len, unsigned long pgoff, unsigned long flags)
+	unsigned long len, unsigned long pgoff, unsigned long flags,
+	vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -99,7 +100,7 @@ unsigned long arch_get_unmapped_area(str
 unsigned long
 arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 			  const unsigned long len, const unsigned long pgoff,
-			  const unsigned long flags)
+			  const unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
--- a/arch/sparc/kernel/sys_sparc_32.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -39,7 +39,7 @@ SYSCALL_DEFINE0(getpagesize)
 	return PAGE_SIZE; /* Possibly older binaries want 8192 on sun4's? */
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
+unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_unmapped_area_info info = {};
 
--- a/arch/sparc/kernel/sys_sparc_64.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -87,7 +87,7 @@ static inline unsigned long COLOR_ALIGN(
 	return base + off;
 }
 
-unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
+unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct * vma;
@@ -146,7 +146,7 @@ unsigned long arch_get_unmapped_area(str
 unsigned long
 arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 			  const unsigned long len, const unsigned long pgoff,
-			  const unsigned long flags)
+			  const unsigned long flags, vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
--- a/arch/x86/include/asm/pgtable_64.h~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -245,7 +245,6 @@ extern void cleanup_highmap(void);
 
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
-#define HAVE_ARCH_UNMAPPED_AREA_VMFLAGS
 
 #define PAGE_AGP    PAGE_KERNEL_NOCACHE
 #define HAVE_PAGE_AGP 1
--- a/arch/x86/kernel/sys_x86_64.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -121,7 +121,7 @@ static inline unsigned long stack_guard_
 }
 
 unsigned long
-arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr, unsigned long len,
+arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 		       unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
 	struct mm_struct *mm = current->mm;
@@ -158,7 +158,7 @@ arch_get_unmapped_area_vmflags(struct fi
 }
 
 unsigned long
-arch_get_unmapped_area_topdown_vmflags(struct file *filp, unsigned long addr0,
+arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 			  unsigned long len, unsigned long pgoff,
 			  unsigned long flags, vm_flags_t vm_flags)
 {
@@ -228,20 +228,5 @@ bottomup:
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
-	return arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
-}
-
-unsigned long
-arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
-{
-	return arch_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, 0);
-}
-
-unsigned long
-arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr,
-			  const unsigned long len, const unsigned long pgoff,
-			  const unsigned long flags)
-{
-	return arch_get_unmapped_area_topdown_vmflags(filp, addr, len, pgoff, flags, 0);
+	return arch_get_unmapped_area(filp, addr0, len, pgoff, flags, 0);
 }
--- a/arch/xtensa/kernel/syscall.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/arch/xtensa/kernel/syscall.c
@@ -55,7 +55,8 @@ asmlinkage long xtensa_fadvise64_64(int
 
 #ifdef CONFIG_MMU
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
-		unsigned long len, unsigned long pgoff, unsigned long flags)
+		unsigned long len, unsigned long pgoff, unsigned long flags,
+		vm_flags_t vm_flags)
 {
 	struct vm_area_struct *vmm;
 	struct vma_iterator vmi;
--- a/include/linux/sched/mm.h~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/include/linux/sched/mm.h
@@ -179,27 +179,20 @@ static inline void mm_update_next_owner(
 
 extern void arch_pick_mmap_layout(struct mm_struct *mm,
 				  struct rlimit *rlim_stack);
-extern unsigned long
-arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
-		       unsigned long, unsigned long);
-extern unsigned long
+
+unsigned long
+arch_get_unmapped_area(struct file *filp, unsigned long addr,
+		       unsigned long len, unsigned long pgoff,
+		       unsigned long flags, vm_flags_t vm_flags);
+unsigned long
 arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags);
+			       unsigned long len, unsigned long pgoff,
+			       unsigned long flags, vm_flags_t);
 
 unsigned long mm_get_unmapped_area(struct mm_struct *mm, struct file *filp,
 				   unsigned long addr, unsigned long len,
 				   unsigned long pgoff, unsigned long flags);
 
-unsigned long
-arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
-			       unsigned long len, unsigned long pgoff,
-			       unsigned long flags, vm_flags_t vm_flags);
-unsigned long
-arch_get_unmapped_area_topdown_vmflags(struct file *filp, unsigned long addr,
-				       unsigned long len, unsigned long pgoff,
-				       unsigned long flags, vm_flags_t);
-
 unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm,
 					   struct file *filp,
 					   unsigned long addr,
--- a/mm/mmap.c~mm-make-arch_get_unmapped_area-take-vm_flags-by-default
+++ a/mm/mmap.c
@@ -770,7 +770,7 @@ generic_get_unmapped_area(struct file *f
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		       unsigned long len, unsigned long pgoff,
-		       unsigned long flags)
+		       unsigned long flags, vm_flags_t vm_flags)
 {
 	return generic_get_unmapped_area(filp, addr, len, pgoff, flags);
 }
@@ -834,38 +834,21 @@ generic_get_unmapped_area_topdown(struct
 unsigned long
 arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 			       unsigned long len, unsigned long pgoff,
-			       unsigned long flags)
+			       unsigned long flags, vm_flags_t vm_flags)
 {
 	return generic_get_unmapped_area_topdown(filp, addr, len, pgoff, flags);
 }
 #endif
 
-#ifndef HAVE_ARCH_UNMAPPED_AREA_VMFLAGS
-unsigned long
-arch_get_unmapped_area_vmflags(struct file *filp, unsigned long addr, unsigned long len,
-			       unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
-{
-	return arch_get_unmapped_area(filp, addr, len, pgoff, flags);
-}
-
-unsigned long
-arch_get_unmapped_area_topdown_vmflags(struct file *filp, unsigned long addr,
-				       unsigned long len, unsigned long pgoff,
-				       unsigned long flags, vm_flags_t vm_flags)
-{
-	return arch_get_unmapped_area_topdown(filp, addr, len, pgoff, flags);
-}
-#endif
-
 unsigned long mm_get_unmapped_area_vmflags(struct mm_struct *mm, struct file *filp,
 					   unsigned long addr, unsigned long len,
 					   unsigned long pgoff, unsigned long flags,
 					   vm_flags_t vm_flags)
 {
 	if (test_bit(MMF_TOPDOWN, &mm->flags))
-		return arch_get_unmapped_area_topdown_vmflags(filp, addr, len, pgoff,
-							      flags, vm_flags);
-	return arch_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, vm_flags);
+		return arch_get_unmapped_area_topdown(filp, addr, len, pgoff,
+						      flags, vm_flags);
+	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
 }
 
 unsigned long
@@ -927,8 +910,8 @@ mm_get_unmapped_area(struct mm_struct *m
 		     unsigned long pgoff, unsigned long flags)
 {
 	if (test_bit(MMF_TOPDOWN, &mm->flags))
-		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags);
-	return arch_get_unmapped_area(file, addr, len, pgoff, flags);
+		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags, 0);
+	return arch_get_unmapped_area(file, addr, len, pgoff, flags, 0);
 }
 EXPORT_SYMBOL(mm_get_unmapped_area);
 
_

Patches currently in -mm which might be from broonie@kernel.org are


