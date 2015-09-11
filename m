From: akpm@linux-foundation.org
Subject: [merged]
 mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch removed from -mm
 tree
Date: Fri, 11 Sep 2015 11:13:49 -0700
Message-ID: <55f319dd.ri1djcOzUZ6tBf0v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbbIKSNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, luto@amacapital.net, minchan@kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mpx: add "vm_flags_t vm_flags" arg to do_mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm, mpx: add "vm_flags_t vm_flags" arg to do_mmap_pgoff()

Add the additional "vm_flags_t vm_flags" argument to do_mmap_pgoff(),
rename it to do_mmap(), and re-introduce do_mmap_pgoff() as a simple
wrapper on top of do_mmap().  Perhaps we should update the callers of
do_mmap_pgoff() and kill it later.

This way mpx_mmap() can simply call do_mmap(vm_flags => VM_MPX) and do not
play with vm internals.

After this change mmap_region() has a single user outside of mmap.c,
arch/tile/mm/elf.c:arch_setup_additional_pages().  It would be nice to
change arch/tile/ and unexport mmap_region().

[kirill@shutemov.name: fix build]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/mpx.c  |   51 +++++--------------------------------------
 include/linux/mm.h |   12 ++++++++--
 mm/mmap.c          |   10 +++-----
 mm/nommu.c         |   19 ++++++++--------
 4 files changed, 31 insertions(+), 61 deletions(-)

diff -puN arch/x86/mm/mpx.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff arch/x86/mm/mpx.c
--- a/arch/x86/mm/mpx.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff
+++ a/arch/x86/mm/mpx.c
@@ -42,58 +42,21 @@ static inline unsigned long mpx_bt_size_
  */
 static unsigned long mpx_mmap(unsigned long len)
 {
-	unsigned long ret;
-	unsigned long addr, pgoff;
 	struct mm_struct *mm = current->mm;
-	vm_flags_t vm_flags;
-	struct vm_area_struct *vma;
+	unsigned long addr, populate;
 
 	/* Only bounds table can be allocated here */
 	if (len != mpx_bt_size_bytes(mm))
 		return -EINVAL;
 
 	down_write(&mm->mmap_sem);
-
-	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* Obtain the address to map to. we verify (or select) it and ensure
-	 * that it represents a valid section of the address space.
-	 */
-	addr = get_unmapped_area(NULL, 0, len, 0, MAP_ANONYMOUS | MAP_PRIVATE);
-	if (addr & ~PAGE_MASK) {
-		ret = addr;
-		goto out;
-	}
-
-	vm_flags = VM_READ | VM_WRITE | VM_MPX |
-			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
-
-	/* Set pgoff according to addr for anon_vma */
-	pgoff = addr >> PAGE_SHIFT;
-
-	ret = mmap_region(NULL, addr, len, vm_flags, pgoff);
-	if (IS_ERR_VALUE(ret))
-		goto out;
-
-	vma = find_vma(mm, ret);
-	if (!vma) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (vm_flags & VM_LOCKED) {
-		up_write(&mm->mmap_sem);
-		mm_populate(ret, len);
-		return ret;
-	}
-
-out:
+	addr = do_mmap(NULL, 0, len, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, VM_MPX, 0, &populate);
 	up_write(&mm->mmap_sem);
-	return ret;
+	if (populate)
+		mm_populate(addr, populate);
+
+	return addr;
 }
 
 enum reg_type {
diff -puN include/linux/mm.h~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff include/linux/mm.h
--- a/include/linux/mm.h~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff
+++ a/include/linux/mm.h
@@ -1873,11 +1873,19 @@ extern unsigned long get_unmapped_area(s
 
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, vm_flags_t vm_flags, unsigned long pgoff);
-extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
+extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
-	unsigned long pgoff, unsigned long *populate);
+	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate);
 extern int do_munmap(struct mm_struct *, unsigned long, size_t);
 
+static inline unsigned long
+do_mmap_pgoff(struct file *file, unsigned long addr,
+	unsigned long len, unsigned long prot, unsigned long flags,
+	unsigned long pgoff, unsigned long *populate)
+{
+	return do_mmap(file, addr, len, prot, flags, 0, pgoff, populate);
+}
+
 #ifdef CONFIG_MMU
 extern int __mm_populate(unsigned long addr, unsigned long len,
 			 int ignore_errors);
diff -puN mm/mmap.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff mm/mmap.c
--- a/mm/mmap.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff
+++ a/mm/mmap.c
@@ -1260,14 +1260,12 @@ static inline int mlock_future_check(str
 /*
  * The caller must hold down_write(&current->mm->mmap_sem).
  */
-
-unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
+unsigned long do_mmap(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
-			unsigned long flags, unsigned long pgoff,
-			unsigned long *populate)
+			unsigned long flags, vm_flags_t vm_flags,
+			unsigned long pgoff, unsigned long *populate)
 {
 	struct mm_struct *mm = current->mm;
-	vm_flags_t vm_flags;
 
 	*populate = 0;
 
@@ -1311,7 +1309,7 @@ unsigned long do_mmap_pgoff(struct file
 	 * to. we assume access permissions have been handled by the open
 	 * of the memory object, so we don't do any here.
 	 */
-	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
+	vm_flags |= calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
 	if (flags & MAP_LOCKED)
diff -puN mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff mm/nommu.c
--- a/mm/nommu.c~mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff
+++ a/mm/nommu.c
@@ -1233,18 +1233,19 @@ enomem:
 /*
  * handle mapping creation for uClinux
  */
-unsigned long do_mmap_pgoff(struct file *file,
-			    unsigned long addr,
-			    unsigned long len,
-			    unsigned long prot,
-			    unsigned long flags,
-			    unsigned long pgoff,
-			    unsigned long *populate)
+unsigned long do_mmap(struct file *file,
+			unsigned long addr,
+			unsigned long len,
+			unsigned long prot,
+			unsigned long flags,
+			vm_flags_t vm_flags,
+			unsigned long pgoff,
+			unsigned long *populate)
 {
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
-	unsigned long capabilities, vm_flags, result;
+	unsigned long capabilities, result;
 	int ret;
 
 	*populate = 0;
@@ -1262,7 +1263,7 @@ unsigned long do_mmap_pgoff(struct file
 
 	/* we've determined that we can make the mapping, now translate what we
 	 * now know into VMA flags */
-	vm_flags = determine_vm_flags(file, prot, flags, capabilities);
+	vm_flags |= determine_vm_flags(file, prot, flags, capabilities);
 
 	/* we're going to need to record the mapping */
 	region = kmem_cache_zalloc(vm_region_jar, GFP_KERNEL);
_

Patches currently in -mm which might be from oleg@redhat.com are


