From: akpm@linux-foundation.org
Subject: [patch 75/84] vdso: make arch_setup_additional_pages wait for
 mmap_sem for write killable
Date: Mon, 23 May 2016 16:25:54 -0700
Message-ID: <57439182.j7V6qEg1alN5QlNx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbcEWXZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, luto@amacapital.net, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: vdso: make arch_setup_additional_pages wait for mmap_sem for write killable

most architectures are relying on mmap_sem for write in their
arch_setup_additional_pages.  If the waiting task gets killed by the oom
killer it would block oom_reaper from asynchronous address space reclaim
and reduce the chances of timely OOM resolving.  Wait for the lock in the
killable mode and return with EINTR if the task got killed while waiting.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>	[x86 vdso]
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/process.c          |    3 ++-
 arch/arm64/kernel/vdso.c           |    6 ++++--
 arch/hexagon/kernel/vdso.c         |    3 ++-
 arch/mips/kernel/vdso.c            |    3 ++-
 arch/powerpc/kernel/vdso.c         |    3 ++-
 arch/s390/kernel/vdso.c            |    3 ++-
 arch/sh/kernel/vsyscall/vsyscall.c |    4 +++-
 arch/x86/entry/vdso/vma.c          |    3 ++-
 arch/x86/um/vdso/vma.c             |    3 ++-
 9 files changed, 21 insertions(+), 10 deletions(-)

diff -puN arch/arm/kernel/process.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/arm/kernel/process.c
@@ -420,7 +420,8 @@ int arch_setup_additional_pages(struct l
 	npages = 1; /* for sigpage */
 	npages += vdso_total_pages;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 	hint = sigpage_addr(mm, npages);
 	addr = get_unmapped_area(NULL, hint, npages << PAGE_SHIFT, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
diff -puN arch/arm64/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/arm64/kernel/vdso.c
--- a/arch/arm64/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/arm64/kernel/vdso.c
@@ -95,7 +95,8 @@ int aarch32_setup_vectors_page(struct li
 	};
 	void *ret;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 	current->mm->context.vdso = (void *)addr;
 
 	/* Map vectors page at the high address. */
@@ -163,7 +164,8 @@ int arch_setup_additional_pages(struct l
 	/* Be sure to map the data page */
 	vdso_mapping_len = vdso_text_len + PAGE_SIZE;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
 		ret = ERR_PTR(vdso_base);
diff -puN arch/hexagon/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/hexagon/kernel/vdso.c
--- a/arch/hexagon/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/hexagon/kernel/vdso.c
@@ -65,7 +65,8 @@ int arch_setup_additional_pages(struct l
 	unsigned long vdso_base;
 	struct mm_struct *mm = current->mm;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 
 	/* Try to get it loaded right near ld.so/glibc. */
 	vdso_base = STACK_TOP;
diff -puN arch/mips/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/mips/kernel/vdso.c
--- a/arch/mips/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/mips/kernel/vdso.c
@@ -104,7 +104,8 @@ int arch_setup_additional_pages(struct l
 	struct resource gic_res;
 	int ret;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 
 	/*
 	 * Determine total area size. This includes the VDSO data itself, the
diff -puN arch/powerpc/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/powerpc/kernel/vdso.c
--- a/arch/powerpc/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/powerpc/kernel/vdso.c
@@ -195,7 +195,8 @@ int arch_setup_additional_pages(struct l
 	 * and end up putting it elsewhere.
 	 * Add enough to the size so that the result can be aligned.
 	 */
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 	vdso_base = get_unmapped_area(NULL, vdso_base,
 				      (vdso_pages << PAGE_SHIFT) +
 				      ((VDSO_ALIGNMENT - 1) & PAGE_MASK),
diff -puN arch/s390/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/s390/kernel/vdso.c
--- a/arch/s390/kernel/vdso.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/s390/kernel/vdso.c
@@ -216,7 +216,8 @@ int arch_setup_additional_pages(struct l
 	 * it at vdso_base which is the "natural" base for it, but we might
 	 * fail and end up putting it elsewhere.
 	 */
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 	vdso_base = get_unmapped_area(NULL, 0, vdso_pages << PAGE_SHIFT, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
 		rc = vdso_base;
diff -puN arch/sh/kernel/vsyscall/vsyscall.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -64,7 +64,9 @@ int arch_setup_additional_pages(struct l
 	unsigned long addr;
 	int ret;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
diff -puN arch/x86/entry/vdso/vma.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/x86/entry/vdso/vma.c
--- a/arch/x86/entry/vdso/vma.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/x86/entry/vdso/vma.c
@@ -163,7 +163,8 @@ static int map_vdso(const struct vdso_im
 		addr = 0;
 	}
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 
 	addr = get_unmapped_area(NULL, addr,
 				 image->size - image->sym_vvar_start, 0, 0);
diff -puN arch/x86/um/vdso/vma.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable arch/x86/um/vdso/vma.c
--- a/arch/x86/um/vdso/vma.c~vdso-make-arch_setup_additional_pages-wait-for-mmap_sem-for-write-killable
+++ a/arch/x86/um/vdso/vma.c
@@ -61,7 +61,8 @@ int arch_setup_additional_pages(struct l
 	if (!vdso_enabled)
 		return 0;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
 
 	err = install_special_mapping(mm, um_vdso_addr, PAGE_SIZE,
 		VM_READ|VM_EXEC|
_
