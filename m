Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB134152166
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570306; cv=none; b=YIaVjpv61n/pedUX5kdoffND8e9V6zjO6JGmERnnUfgxPeHOKBN+/+LtBTdeJOsQ33b0umTdgwgYOoTm024iB+D84p5RWG93wqrKIdaEqD71z9R0sqoevGCEa73QpsGwbvVgllrYjnYDuuhGwibDz+wGR7D3IzcJm8waf8HcHlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570306; c=relaxed/simple;
	bh=UYdv9hkR0G19Khex6fIQRvOQJd16rq3CwK3eWPKAIZ4=;
	h=Date:To:From:Subject:Message-Id; b=Kg9aUhGpONHpXDQ7l406il4u0Hz8B3WqNzdxzt/5H7pgrSv0da/yQYAFG5fn7sJOg/KEAwG8garf2m5feHbBVW2as6LSiEETHa/2JfITbajv7xAxskvLWHPynuNA/Mr21AQHwNY/pzMyecl+D+QrmxwJnXXvnwzQt7fVBJDwc2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oRMlV25u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oRMlV25u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CC9C433F1;
	Wed, 27 Mar 2024 20:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570305;
	bh=UYdv9hkR0G19Khex6fIQRvOQJd16rq3CwK3eWPKAIZ4=;
	h=Date:To:From:Subject:From;
	b=oRMlV25uFl0VwKmj12s8TwwG4OBH6iZM8MIK89UQ3xRjlfBeI8dwnfTrO83fSnF75
	 2NZGA5E1lda5Yf6HymYkTtliAp71fb0QW0Jg7bmrhZsT4BKTKVIbLu2/nKltodP4bF
	 rKQukrvmStSL6xMNDdvYmOe4dDtUOAZEAVywL8yU=
Date: Wed, 27 Mar 2024 13:11:45 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + treewide-use-initializer-for-struct-vm_unmapped_area_info.patch added to mm-unstable branch
Message-Id: <20240327201145.91CC9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: treewide: use initializer for struct vm_unmapped_area_info
has been added to the -mm mm-unstable branch.  Its filename is
     treewide-use-initializer-for-struct-vm_unmapped_area_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/treewide-use-initializer-for-struct-vm_unmapped_area_info.patch

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
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: treewide: use initializer for struct vm_unmapped_area_info
Date: Mon, 25 Mar 2024 19:16:52 -0700

Future changes will need to add a new member to struct
vm_unmapped_area_info.  This would cause trouble for any call site that
doesn't initialize the struct.  Currently every caller sets each member
manually, so if new ones are added they will be uninitialized and the core
code parsing the struct will see garbage in the new member.

It could be possible to initialize the new member manually to 0 at each
call site.  This and a couple other options were discussed.  Having some
struct vm_unmapped_area_info instances not zero initialized will put those
sites at risk of feeding garbage into vm_unmapped_area(), if the
convention is to zero initialize the struct and any new field addition
missed a call site that initializes each field manually.  So it is useful
to do things similar across the kernel.

The consensus (see links) was that in general the best way to accomplish
taking into account both code cleanliness and minimizing the chance of
introducing bugs, was to do C99 static initialization.  As in: struct
vm_unmapped_area_info info = {};

With this method of initialization, the whole struct will be zero
initialized, and any statements setting fields to zero will be unneeded. 
The change should not leave cleanup at the call sides.

While iterating though the possible solutions a few archs kindly acked
other variations that still zero initialized the struct.  These sites have
been modified in previous changes using the pattern acked by the
respective arch.

So to be reduce the chance of bugs via uninitialized fields, perform a
tree wide change using the consensus for the best general way to do this
change.  Use C99 static initializing to zero the struct and remove and
statements that simply set members to zero.

Link: https://lkml.kernel.org/r/20240326021656.202649-11-rick.p.edgecombe@intel.com
Link: https://lore.kernel.org/lkml/202402280912.33AEE7A9CF@keescook/#t
Link: https://lore.kernel.org/lkml/j7bfvig3gew3qruouxrh7z7ehjjafrgkbcmg6tcghhfh3rhmzi@wzlcoecgy5rs/
Link: https://lore.kernel.org/lkml/ec3e377a-c0a0-4dd3-9cb9-96517e54d17e@csgroup.eu/
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c      |    5 +----
 arch/arc/mm/mmap.c               |    4 +---
 arch/arm/mm/mmap.c               |    5 ++---
 arch/loongarch/mm/mmap.c         |    3 +--
 arch/mips/mm/mmap.c              |    3 +--
 arch/s390/mm/hugetlbpage.c       |    7 ++-----
 arch/s390/mm/mmap.c              |    5 ++---
 arch/sh/mm/mmap.c                |    5 ++---
 arch/sparc/kernel/sys_sparc_32.c |    3 +--
 arch/sparc/kernel/sys_sparc_64.c |    5 ++---
 arch/sparc/mm/hugetlbpage.c      |    7 ++-----
 arch/x86/kernel/sys_x86_64.c     |    7 ++-----
 arch/x86/mm/hugetlbpage.c        |    7 ++-----
 fs/hugetlbfs/inode.c             |    7 ++-----
 mm/mmap.c                        |    9 ++-------
 15 files changed, 25 insertions(+), 57 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/alpha/kernel/osf_sys.c
@@ -1218,14 +1218,11 @@ static unsigned long
 arch_get_unmapped_area_1(unsigned long addr, unsigned long len,
 		         unsigned long limit)
 {
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = addr;
 	info.high_limit = limit;
-	info.align_mask = 0;
-	info.align_offset = 0;
 	return vm_unmapped_area(&info);
 }
 
--- a/arch/arc/mm/mmap.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/arc/mm/mmap.c
@@ -27,7 +27,7 @@ arch_get_unmapped_area(struct file *filp
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	/*
 	 * We enforce the MAP_FIXED case.
@@ -51,11 +51,9 @@ arch_get_unmapped_area(struct file *filp
 			return addr;
 	}
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
-	info.align_mask = 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
--- a/arch/arm/mm/mmap.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/arm/mm/mmap.c
@@ -34,7 +34,7 @@ arch_get_unmapped_area(struct file *filp
 	struct vm_area_struct *vma;
 	int do_align = 0;
 	int aliasing = cache_is_vipt_aliasing();
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	/*
 	 * We only need to do colour alignment if either the I or D
@@ -68,7 +68,6 @@ arch_get_unmapped_area(struct file *filp
 			return addr;
 	}
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
@@ -87,7 +86,7 @@ arch_get_unmapped_area_topdown(struct fi
 	unsigned long addr = addr0;
 	int do_align = 0;
 	int aliasing = cache_is_vipt_aliasing();
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	/*
 	 * We only need to do colour alignment if either the I or D
--- a/arch/loongarch/mm/mmap.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/loongarch/mm/mmap.c
@@ -24,7 +24,7 @@ static unsigned long arch_get_unmapped_a
 	struct vm_area_struct *vma;
 	unsigned long addr = addr0;
 	int do_color_align;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
@@ -82,7 +82,6 @@ static unsigned long arch_get_unmapped_a
 		 */
 	}
 
-	info.flags = 0;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	return vm_unmapped_area(&info);
--- a/arch/mips/mm/mmap.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/mips/mm/mmap.c
@@ -34,7 +34,7 @@ static unsigned long arch_get_unmapped_a
 	struct vm_area_struct *vma;
 	unsigned long addr = addr0;
 	int do_color_align;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
@@ -92,7 +92,6 @@ static unsigned long arch_get_unmapped_a
 		 */
 	}
 
-	info.flags = 0;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	return vm_unmapped_area(&info);
--- a/arch/s390/mm/hugetlbpage.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/s390/mm/hugetlbpage.c
@@ -248,14 +248,12 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	return vm_unmapped_area(&info);
 }
 
@@ -264,7 +262,7 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 	unsigned long addr;
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
@@ -272,7 +270,6 @@ static unsigned long hugetlb_get_unmappe
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = current->mm->mmap_base;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	/*
--- a/arch/s390/mm/mmap.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/s390/mm/mmap.c
@@ -86,7 +86,7 @@ unsigned long arch_get_unmapped_area(str
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
@@ -102,7 +102,6 @@ unsigned long arch_get_unmapped_area(str
 			goto check_asce_limit;
 	}
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
@@ -122,7 +121,7 @@ unsigned long arch_get_unmapped_area_top
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE - mmap_min_addr)
--- a/arch/sh/mm/mmap.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/sh/mm/mmap.c
@@ -57,7 +57,7 @@ unsigned long arch_get_unmapped_area(str
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int do_colour_align;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -88,7 +88,6 @@ unsigned long arch_get_unmapped_area(str
 			return addr;
 	}
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = TASK_UNMAPPED_BASE;
 	info.high_limit = TASK_SIZE;
@@ -106,7 +105,7 @@ arch_get_unmapped_area_topdown(struct fi
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
 	int do_colour_align;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
--- a/arch/sparc/kernel/sys_sparc_32.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -41,7 +41,7 @@ SYSCALL_DEFINE0(getpagesize)
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -59,7 +59,6 @@ unsigned long arch_get_unmapped_area(str
 	if (!addr)
 		addr = TASK_UNMAPPED_BASE;
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = addr;
 	info.high_limit = TASK_SIZE;
--- a/arch/sparc/kernel/sys_sparc_64.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -93,7 +93,7 @@ unsigned long arch_get_unmapped_area(str
 	struct vm_area_struct * vma;
 	unsigned long task_size = TASK_SIZE;
 	int do_color_align;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -126,7 +126,6 @@ unsigned long arch_get_unmapped_area(str
 			return addr;
 	}
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = TASK_UNMAPPED_BASE;
 	info.high_limit = min(task_size, VA_EXCLUDE_START);
@@ -154,7 +153,7 @@ arch_get_unmapped_area_topdown(struct fi
 	unsigned long task_size = STACK_TOP32;
 	unsigned long addr = addr0;
 	int do_color_align;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	/* This should only ever run for 32-bit processes.  */
 	BUG_ON(!test_thread_flag(TIF_32BIT));
--- a/arch/sparc/mm/hugetlbpage.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -31,17 +31,15 @@ static unsigned long hugetlb_get_unmappe
 {
 	struct hstate *h = hstate_file(filp);
 	unsigned long task_size = TASK_SIZE;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	if (test_thread_flag(TIF_32BIT))
 		task_size = STACK_TOP32;
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = TASK_UNMAPPED_BASE;
 	info.high_limit = min(task_size, VA_EXCLUDE_START);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
@@ -63,7 +61,7 @@ hugetlb_get_unmapped_area_topdown(struct
 	struct hstate *h = hstate_file(filp);
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	/* This should only ever run for 32-bit processes.  */
 	BUG_ON(!test_thread_flag(TIF_32BIT));
@@ -73,7 +71,6 @@ hugetlb_get_unmapped_area_topdown(struct
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	/*
--- a/arch/x86/kernel/sys_x86_64.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -118,7 +118,7 @@ arch_get_unmapped_area(struct file *filp
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 	unsigned long begin, end;
 
 	if (flags & MAP_FIXED)
@@ -137,11 +137,9 @@ arch_get_unmapped_area(struct file *filp
 			return addr;
 	}
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = begin;
 	info.high_limit = end;
-	info.align_mask = 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	if (filp) {
 		info.align_mask = get_align_mask();
@@ -158,7 +156,7 @@ arch_get_unmapped_area_topdown(struct fi
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
@@ -203,7 +201,6 @@ get_unmapped_area:
 	if (addr > DEFAULT_MAP_WINDOW && !in_32bit_syscall())
 		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
 
-	info.align_mask = 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	if (filp) {
 		info.align_mask = get_align_mask();
--- a/arch/x86/mm/hugetlbpage.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/arch/x86/mm/hugetlbpage.c
@@ -25,9 +25,8 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = get_mmap_base(1);
 
@@ -39,7 +38,6 @@ static unsigned long hugetlb_get_unmappe
 		task_size_32bit() : task_size_64bit(addr > DEFAULT_MAP_WINDOW);
 
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	return vm_unmapped_area(&info);
 }
 
@@ -48,7 +46,7 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
@@ -63,7 +61,6 @@ static unsigned long hugetlb_get_unmappe
 		info.high_limit += TASK_SIZE_MAX - DEFAULT_MAP_WINDOW;
 
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	/*
--- a/fs/hugetlbfs/inode.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/fs/hugetlbfs/inode.c
@@ -176,14 +176,12 @@ hugetlb_get_unmapped_area_bottomup(struc
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_base;
 	info.high_limit = arch_get_mmap_end(addr, len, flags);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	return vm_unmapped_area(&info);
 }
 
@@ -192,14 +190,13 @@ hugetlb_get_unmapped_area_topdown(struct
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
-	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	/*
--- a/mm/mmap.c~treewide-use-initializer-for-struct-vm_unmapped_area_info
+++ a/mm/mmap.c
@@ -1704,7 +1704,7 @@ generic_get_unmapped_area(struct file *f
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
 
 	if (len > mmap_end - mmap_min_addr)
@@ -1722,12 +1722,9 @@ generic_get_unmapped_area(struct file *f
 			return addr;
 	}
 
-	info.flags = 0;
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = mmap_end;
-	info.align_mask = 0;
-	info.align_offset = 0;
 	return vm_unmapped_area(&info);
 }
 
@@ -1752,7 +1749,7 @@ generic_get_unmapped_area_topdown(struct
 {
 	struct vm_area_struct *vma, *prev;
 	struct mm_struct *mm = current->mm;
-	struct vm_unmapped_area_info info;
+	struct vm_unmapped_area_info info = {};
 	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
 
 	/* requested length too big for entire address space */
@@ -1776,8 +1773,6 @@ generic_get_unmapped_area_topdown(struct
 	info.length = len;
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
-	info.align_mask = 0;
-	info.align_offset = 0;
 	addr = vm_unmapped_area(&info);
 
 	/*
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are

proc-refactor-pde_get_unmapped_area-as-prep.patch
mm-switch-mm-get_unmapped_area-to-a-flag.patch
mm-introduce-arch_get_unmapped_area_vmflags.patch
mm-remove-export-for-get_unmapped_area.patch
mm-use-get_unmapped_area_vmflags.patch
thp-add-thp_get_unmapped_area_vmflags.patch
csky-use-initializer-for-struct-vm_unmapped_area_info.patch
parisc-use-initializer-for-struct-vm_unmapped_area_info.patch
powerpc-use-initializer-for-struct-vm_unmapped_area_info.patch
treewide-use-initializer-for-struct-vm_unmapped_area_info.patch
mm-take-placement-mappings-gap-into-account.patch
x86-mm-implement-have_arch_unmapped_area_vmflags.patch
x86-mm-care-about-shadow-stack-guard-gap-during-placement.patch
selftests-x86-add-placement-guard-gap-test-for-shstk.patch

