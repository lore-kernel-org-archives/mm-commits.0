From: akpm@linux-foundation.org
Subject: [merged] powerpc-do-not-make-the-entire-heap-executable.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:16:16 -0800
Message-ID: <58af5120.YX30jj5V2584l1h1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:16:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvlasenk@redhat.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, fweimer@redhat.com, jgunthorpe@obsidianresearch.com, keescook@chromium.org, mpe@ellerman.id.au, oleg@redhat.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: do not make the entire heap executable
has been removed from the -mm tree.  Its filename was
     powerpc-do-not-make-the-entire-heap-executable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Denys Vlasenko <dvlasenk@redhat.com>
Subject: powerpc: do not make the entire heap executable

On 32-bit powerpc the ELF PLT sections of binaries (built with --bss-plt,
or with a toolchain which defaults to it) look like this:

  [17] .sbss             NOBITS          0002aff8 01aff8 000014 00  WA  0   0  4
  [18] .plt              NOBITS          0002b00c 01aff8 000084 00 WAX  0   0  4
  [19] .bss              NOBITS          0002b090 01aff8 0000a4 00  WA  0   0  4

Which results in an ELF load header:

  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x019c70 0x00029c70 0x00029c70 0x01388 0x014c4 RWE 0x10000

This is all correct, the load region containing the PLT is marked as
executable.  Note that the PLT starts at 0002b00c but the file mapping
ends at 0002aff8, so the PLT falls in the 0 fill section described by the
load header, and after a page boundary.

Unfortunately the generic ELF loader ignores the X bit in the load headers
when it creates the 0 filled non-file backed mappings.  It assumes all of
these mappings are RW BSS sections, which is not the case for PPC.

gcc/ld has an option (--secure-plt) to not do this, this is said to incur
a small performance penalty.

Currently, to support 32-bit binaries with PLT in BSS kernel maps *entire
brk area* with executable rights for all binaries, even --secure-plt ones.

Stop doing that.

Teach the ELF loader to check the X bit in the relevant load header and
create 0 filled anonymous mappings that are executable if the load header
requests that.

Test program showing the difference in /proc/$PID/maps:

int main() {
	char buf[16*1024];
	char *p = malloc(123); /* make "[heap]" mapping appear */
	int fd = open("/proc/self/maps", O_RDONLY);
	int len = read(fd, buf, sizeof(buf));
	write(1, buf, len);
	printf("%p\n", p);
	return 0;
}

Compiled using: gcc -mbss-plt -m32 -Os test.c -otest

Unpatched ppc64 kernel:
00100000-00120000 r-xp 00000000 00:00 0                                  [vdso]
0fe10000-0ffd0000 r-xp 00000000 fd:00 67898094                           /usr/lib/libc-2.17.so
0ffd0000-0ffe0000 r--p 001b0000 fd:00 67898094                           /usr/lib/libc-2.17.so
0ffe0000-0fff0000 rw-p 001c0000 fd:00 67898094                           /usr/lib/libc-2.17.so
10000000-10010000 r-xp 00000000 fd:00 100674505                          /home/user/test
10010000-10020000 r--p 00000000 fd:00 100674505                          /home/user/test
10020000-10030000 rw-p 00010000 fd:00 100674505                          /home/user/test
10690000-106c0000 rwxp 00000000 00:00 0                                  [heap]
f7f70000-f7fa0000 r-xp 00000000 fd:00 67898089                           /usr/lib/ld-2.17.so
f7fa0000-f7fb0000 r--p 00020000 fd:00 67898089                           /usr/lib/ld-2.17.so
f7fb0000-f7fc0000 rw-p 00030000 fd:00 67898089                           /usr/lib/ld-2.17.so
ffa90000-ffac0000 rw-p 00000000 00:00 0                                  [stack]
0x10690008

Patched ppc64 kernel:
00100000-00120000 r-xp 00000000 00:00 0                                  [vdso]
0fe10000-0ffd0000 r-xp 00000000 fd:00 67898094                           /usr/lib/libc-2.17.so
0ffd0000-0ffe0000 r--p 001b0000 fd:00 67898094                           /usr/lib/libc-2.17.so
0ffe0000-0fff0000 rw-p 001c0000 fd:00 67898094                           /usr/lib/libc-2.17.so
10000000-10010000 r-xp 00000000 fd:00 100674505                          /home/user/test
10010000-10020000 r--p 00000000 fd:00 100674505                          /home/user/test
10020000-10030000 rw-p 00010000 fd:00 100674505                          /home/user/test
10180000-101b0000 rw-p 00000000 00:00 0                                  [heap]
                  ^^^^ this has changed
f7c60000-f7c90000 r-xp 00000000 fd:00 67898089                           /usr/lib/ld-2.17.so
f7c90000-f7ca0000 r--p 00020000 fd:00 67898089                           /usr/lib/ld-2.17.so
f7ca0000-f7cb0000 rw-p 00030000 fd:00 67898089                           /usr/lib/ld-2.17.so
ff860000-ff890000 rw-p 00000000 00:00 0                                  [stack]
0x10180008

The patch was originally posted in 2012 by Jason Gunthorpe
and apparently ignored:

https://lkml.org/lkml/2012/9/30/138

Lightly run-tested.

Link: http://lkml.kernel.org/r/20161215131950.23054-1-dvlasenk@redhat.com
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/page.h |    4 +++-
 fs/binfmt_elf.c                 |   30 ++++++++++++++++++++++--------
 include/linux/mm.h              |    1 +
 mm/mmap.c                       |   24 +++++++++++++++++++-----
 4 files changed, 45 insertions(+), 14 deletions(-)

diff -puN arch/powerpc/include/asm/page.h~powerpc-do-not-make-the-entire-heap-executable arch/powerpc/include/asm/page.h
--- a/arch/powerpc/include/asm/page.h~powerpc-do-not-make-the-entire-heap-executable
+++ a/arch/powerpc/include/asm/page.h
@@ -230,7 +230,9 @@ extern long long virt_phys_offset;
  * and needs to be executable.  This means the whole heap ends
  * up being executable.
  */
-#define VM_DATA_DEFAULT_FLAGS32	(VM_READ | VM_WRITE | VM_EXEC | \
+#define VM_DATA_DEFAULT_FLAGS32 \
+	(((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
+				 VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #define VM_DATA_DEFAULT_FLAGS64	(VM_READ | VM_WRITE | \
diff -puN fs/binfmt_elf.c~powerpc-do-not-make-the-entire-heap-executable fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~powerpc-do-not-make-the-entire-heap-executable
+++ a/fs/binfmt_elf.c
@@ -91,12 +91,18 @@ static struct linux_binfmt elf_format =
 
 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
-static int set_brk(unsigned long start, unsigned long end)
+static int set_brk(unsigned long start, unsigned long end, int prot)
 {
 	start = ELF_PAGEALIGN(start);
 	end = ELF_PAGEALIGN(end);
 	if (end > start) {
-		int error = vm_brk(start, end - start);
+		/*
+		 * Map the last of the bss segment.
+		 * If the header is requesting these pages to be
+		 * executable, honour that (ppc32 needs this).
+		 */
+		int error = vm_brk_flags(start, end - start,
+				prot & PROT_EXEC ? VM_EXEC : 0);
 		if (error)
 			return error;
 	}
@@ -524,6 +530,7 @@ static unsigned long load_elf_interp(str
 	unsigned long load_addr = 0;
 	int load_addr_set = 0;
 	unsigned long last_bss = 0, elf_bss = 0;
+	int bss_prot = 0;
 	unsigned long error = ~0UL;
 	unsigned long total_size;
 	int i;
@@ -606,8 +613,10 @@ static unsigned long load_elf_interp(str
 			 * elf_bss and last_bss is the bss section.
 			 */
 			k = load_addr + eppnt->p_vaddr + eppnt->p_memsz;
-			if (k > last_bss)
+			if (k > last_bss) {
 				last_bss = k;
+				bss_prot = elf_prot;
+			}
 		}
 	}
 
@@ -623,13 +632,14 @@ static unsigned long load_elf_interp(str
 	/*
 	 * Next, align both the file and mem bss up to the page size,
 	 * since this is where elf_bss was just zeroed up to, and where
-	 * last_bss will end after the vm_brk() below.
+	 * last_bss will end after the vm_brk_flags() below.
 	 */
 	elf_bss = ELF_PAGEALIGN(elf_bss);
 	last_bss = ELF_PAGEALIGN(last_bss);
 	/* Finally, if there is still more bss to allocate, do it. */
 	if (last_bss > elf_bss) {
-		error = vm_brk(elf_bss, last_bss - elf_bss);
+		error = vm_brk_flags(elf_bss, last_bss - elf_bss,
+				bss_prot & PROT_EXEC ? VM_EXEC : 0);
 		if (error)
 			goto out;
 	}
@@ -674,6 +684,7 @@ static int load_elf_binary(struct linux_
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
 	unsigned long elf_bss, elf_brk;
+	int bss_prot = 0;
 	int retval, i;
 	unsigned long elf_entry;
 	unsigned long interp_load_addr = 0;
@@ -882,7 +893,8 @@ static int load_elf_binary(struct linux_
 			   before this one. Map anonymous pages, if needed,
 			   and clear the area.  */
 			retval = set_brk(elf_bss + load_bias,
-					 elf_brk + load_bias);
+					 elf_brk + load_bias,
+					 bss_prot);
 			if (retval)
 				goto out_free_dentry;
 			nbyte = ELF_PAGEOFFSET(elf_bss);
@@ -976,8 +988,10 @@ static int load_elf_binary(struct linux_
 		if (end_data < k)
 			end_data = k;
 		k = elf_ppnt->p_vaddr + elf_ppnt->p_memsz;
-		if (k > elf_brk)
+		if (k > elf_brk) {
+			bss_prot = elf_prot;
 			elf_brk = k;
+		}
 	}
 
 	loc->elf_ex.e_entry += load_bias;
@@ -993,7 +1007,7 @@ static int load_elf_binary(struct linux_
 	 * mapping in the interpreter, to make sure it doesn't wind
 	 * up getting placed where the bss needs to go.
 	 */
-	retval = set_brk(elf_bss, elf_brk);
+	retval = set_brk(elf_bss, elf_brk, bss_prot);
 	if (retval)
 		goto out_free_dentry;
 	if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
diff -puN include/linux/mm.h~powerpc-do-not-make-the-entire-heap-executable include/linux/mm.h
--- a/include/linux/mm.h~powerpc-do-not-make-the-entire-heap-executable
+++ a/include/linux/mm.h
@@ -2083,6 +2083,7 @@ static inline void mm_populate(unsigned
 
 /* These take the mm semaphore themselves */
 extern int __must_check vm_brk(unsigned long, unsigned long);
+extern int __must_check vm_brk_flags(unsigned long, unsigned long, unsigned long);
 extern int vm_munmap(unsigned long, size_t);
 extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
         unsigned long, unsigned long,
diff -puN mm/mmap.c~powerpc-do-not-make-the-entire-heap-executable mm/mmap.c
--- a/mm/mmap.c~powerpc-do-not-make-the-entire-heap-executable
+++ a/mm/mmap.c
@@ -2806,11 +2806,11 @@ static inline void verify_mm_writelocked
  *  anonymous maps.  eventually we may be able to do some
  *  brk-specific accounting here.
  */
-static int do_brk(unsigned long addr, unsigned long request)
+static int do_brk_flags(unsigned long addr, unsigned long request, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
-	unsigned long flags, len;
+	unsigned long len;
 	struct rb_node **rb_link, *rb_parent;
 	pgoff_t pgoff = addr >> PAGE_SHIFT;
 	int error;
@@ -2821,7 +2821,10 @@ static int do_brk(unsigned long addr, un
 	if (!len)
 		return 0;
 
-	flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
+	/* Until we need other flags, refuse anything except VM_EXEC. */
+	if ((flags & (~VM_EXEC)) != 0)
+		return -EINVAL;
+	flags |= VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
 	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
 	if (offset_in_page(error))
@@ -2889,7 +2892,12 @@ out:
 	return 0;
 }
 
-int vm_brk(unsigned long addr, unsigned long len)
+static int do_brk(unsigned long addr, unsigned long len)
+{
+	return do_brk_flags(addr, len, 0);
+}
+
+int vm_brk_flags(unsigned long addr, unsigned long len, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
 	int ret;
@@ -2898,13 +2906,19 @@ int vm_brk(unsigned long addr, unsigned
 	if (down_write_killable(&mm->mmap_sem))
 		return -EINTR;
 
-	ret = do_brk(addr, len);
+	ret = do_brk_flags(addr, len, flags);
 	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	up_write(&mm->mmap_sem);
 	if (populate && !ret)
 		mm_populate(addr, len);
 	return ret;
 }
+EXPORT_SYMBOL(vm_brk_flags);
+
+int vm_brk(unsigned long addr, unsigned long len)
+{
+	return vm_brk_flags(addr, len, 0);
+}
 EXPORT_SYMBOL(vm_brk);
 
 /* Release all mmaps. */
_

Patches currently in -mm which might be from dvlasenk@redhat.com are


