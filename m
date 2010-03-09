From: akpm@linux-foundation.org
Subject: [merged] elf-coredump-add-extended-numbering-support.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:54 -0800
Message-ID: <201003091909.o29J9sjd031555__26580.4629111246$1268161921$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637Ab0CITLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:11:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, dhowells@redhat.com, gerg@snapgear.com, jdike@addtoit.com, linux-arch@vger.kernel.org, mingo@elte.hu, oleg@re


The patch titled
     elf coredump: add extended numbering support
has been removed from the -mm tree.  Its filename was
     elf-coredump-add-extended-numbering-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf coredump: add extended numbering support
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

The current ELF dumper implementation can produce broken corefiles if
program headers exceed 65535.  This number is determined by the number of
vmas which the process have.  In particular, some extreme programs may use
more than 65535 vmas.  (If you google max_map_count, you can find some
users facing this problem.) This kind of program never be able to generate
correct coredumps.

This patch implements ``extended numbering'' that uses sh_info field of
the first section header instead of e_phnum field in order to represent
upto 4294967295 vmas.

This is supported by
AMD64-ABI(http://www.x86-64.org/documentation.html) and
Solaris(http://docs.sun.com/app/docs/doc/817-1984/).
Of course, we are preparing patches for gdb and binutils.

Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/elfcore.c |   16 ++++++++
 arch/um/sys-i386/elfcore.c |   16 ++++++++
 fs/binfmt_elf.c            |   66 +++++++++++++++++++++++++++++++++--
 fs/binfmt_elf_fdpic.c      |   63 ++++++++++++++++++++++++++++++++-
 include/linux/elf.h        |   26 +++++++++++++
 include/linux/elfcore.h    |    1 
 kernel/elfcore.c           |    5 ++
 7 files changed, 187 insertions(+), 6 deletions(-)

diff -puN arch/ia64/kernel/elfcore.c~elf-coredump-add-extended-numbering-support arch/ia64/kernel/elfcore.c
--- a/arch/ia64/kernel/elfcore.c~elf-coredump-add-extended-numbering-support
+++ a/arch/ia64/kernel/elfcore.c
@@ -62,3 +62,19 @@ int elf_core_write_extra_data(struct fil
 	}
 	return 1;
 }
+
+size_t elf_core_extra_data_size(void)
+{
+	const struct elf_phdr *const gate_phdrs =
+		(const struct elf_phdr *) (GATE_ADDR + GATE_EHDR->e_phoff);
+	int i;
+	size_t size = 0;
+
+	for (i = 0; i < GATE_EHDR->e_phnum; ++i) {
+		if (gate_phdrs[i].p_type == PT_LOAD) {
+			size += PAGE_ALIGN(gate_phdrs[i].p_memsz);
+			break;
+		}
+	}
+	return size;
+}
diff -puN arch/um/sys-i386/elfcore.c~elf-coredump-add-extended-numbering-support arch/um/sys-i386/elfcore.c
--- a/arch/um/sys-i386/elfcore.c~elf-coredump-add-extended-numbering-support
+++ a/arch/um/sys-i386/elfcore.c
@@ -65,3 +65,19 @@ int elf_core_write_extra_data(struct fil
 	}
 	return 1;
 }
+
+size_t elf_core_extra_data_size(void)
+{
+	if ( vsyscall_ehdr ) {
+		const struct elfhdr *const ehdrp =
+			(struct elfhdr *)vsyscall_ehdr;
+		const struct elf_phdr *const phdrp =
+			(const struct elf_phdr *) (vsyscall_ehdr + ehdrp->e_phoff);
+		int i;
+
+		for (i = 0; i < ehdrp->e_phnum; ++i)
+			if (phdrp[i].p_type == PT_LOAD)
+				return (size_t) phdrp[i].p_filesz;
+	}
+	return 0;
+}
diff -puN fs/binfmt_elf.c~elf-coredump-add-extended-numbering-support fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-coredump-add-extended-numbering-support
+++ a/fs/binfmt_elf.c
@@ -1838,6 +1838,34 @@ static struct vm_area_struct *next_vma(s
 	return gate_vma;
 }
 
+static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
+			     elf_addr_t e_shoff, int segs)
+{
+	elf->e_shoff = e_shoff;
+	elf->e_shentsize = sizeof(*shdr4extnum);
+	elf->e_shnum = 1;
+	elf->e_shstrndx = SHN_UNDEF;
+
+	memset(shdr4extnum, 0, sizeof(*shdr4extnum));
+
+	shdr4extnum->sh_type = SHT_NULL;
+	shdr4extnum->sh_size = elf->e_shnum;
+	shdr4extnum->sh_link = elf->e_shstrndx;
+	shdr4extnum->sh_info = segs;
+}
+
+static size_t elf_core_vma_data_size(struct vm_area_struct *gate_vma,
+				     unsigned long mm_flags)
+{
+	struct vm_area_struct *vma;
+	size_t size = 0;
+
+	for (vma = first_vma(current, gate_vma); vma != NULL;
+	     vma = next_vma(vma, gate_vma))
+		size += vma_dump_size(vma, mm_flags);
+	return size;
+}
+
 /*
  * Actual dumper
  *
@@ -1857,6 +1885,9 @@ static int elf_core_dump(struct coredump
 	unsigned long mm_flags;
 	struct elf_note_info info;
 	struct elf_phdr *phdr4note = NULL;
+	struct elf_shdr *shdr4extnum = NULL;
+	Elf_Half e_phnum;
+	elf_addr_t e_shoff;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1885,12 +1916,19 @@ static int elf_core_dump(struct coredump
 	if (gate_vma != NULL)
 		segs++;
 
+	/* for notes section */
+	segs++;
+
+	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
+	 * this, kernel supports extended numbering. Have a look at
+	 * include/linux/elf.h for further information. */
+	e_phnum = segs > PN_XNUM ? PN_XNUM : segs;
+
 	/*
 	 * Collect all the non-memory information about the process for the
 	 * notes.  This also sets up the file header.
 	 */
-	if (!fill_note_info(elf, segs + 1, /* including notes section */
-			    &info, cprm->signr, cprm->regs))
+	if (!fill_note_info(elf, e_phnum, &info, cprm->signr, cprm->regs))
 		goto cleanup;
 
 	has_dumped = 1;
@@ -1900,7 +1938,7 @@ static int elf_core_dump(struct coredump
 	set_fs(KERNEL_DS);
 
 	offset += sizeof(*elf);				/* Elf header */
-	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
+	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
@@ -1926,6 +1964,19 @@ static int elf_core_dump(struct coredump
 	 */
 	mm_flags = current->mm->flags;
 
+	offset += elf_core_vma_data_size(gate_vma, mm_flags);
+	offset += elf_core_extra_data_size();
+	e_shoff = offset;
+
+	if (e_phnum == PN_XNUM) {
+		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
+		if (!shdr4extnum)
+			goto end_coredump;
+		fill_extnum_info(elf, shdr4extnum, e_shoff, segs);
+	}
+
+	offset = dataoff;
+
 	size += sizeof(*elf);
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;
@@ -2003,11 +2054,20 @@ static int elf_core_dump(struct coredump
 	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
 		goto end_coredump;
 
+	if (e_phnum == PN_XNUM) {
+		size += sizeof(*shdr4extnum);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, shdr4extnum,
+				   sizeof(*shdr4extnum)))
+			goto end_coredump;
+	}
+
 end_coredump:
 	set_fs(fs);
 
 cleanup:
 	free_note_info(&info);
+	kfree(shdr4extnum);
 	kfree(phdr4note);
 	kfree(elf);
 out:
diff -puN fs/binfmt_elf_fdpic.c~elf-coredump-add-extended-numbering-support fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~elf-coredump-add-extended-numbering-support
+++ a/fs/binfmt_elf_fdpic.c
@@ -1505,6 +1505,22 @@ static int elf_dump_thread_status(long s
 	return sz;
 }
 
+static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
+			     elf_addr_t e_shoff, int segs)
+{
+	elf->e_shoff = e_shoff;
+	elf->e_shentsize = sizeof(*shdr4extnum);
+	elf->e_shnum = 1;
+	elf->e_shstrndx = SHN_UNDEF;
+
+	memset(shdr4extnum, 0, sizeof(*shdr4extnum));
+
+	shdr4extnum->sh_type = SHT_NULL;
+	shdr4extnum->sh_size = elf->e_shnum;
+	shdr4extnum->sh_link = elf->e_shstrndx;
+	shdr4extnum->sh_info = segs;
+}
+
 /*
  * dump the segments for an MMU process
  */
@@ -1569,6 +1585,17 @@ static int elf_fdpic_dump_segments(struc
 }
 #endif
 
+static size_t elf_core_vma_data_size(unsigned long mm_flags)
+{
+	struct vm_area_struct *vma;
+	size_t size = 0;
+
+	for (vma = current->mm->mmap; vma; vma->vm_next)
+		if (maydump(vma, mm_flags))
+			size += vma->vm_end - vma->vm_start;
+	return size;
+}
+
 /*
  * Actual dumper
  *
@@ -1601,6 +1628,9 @@ static int elf_fdpic_core_dump(struct co
 	elf_addr_t *auxv;
 	unsigned long mm_flags;
 	struct elf_phdr *phdr4note = NULL;
+	struct elf_shdr *shdr4extnum = NULL;
+	Elf_Half e_phnum;
+	elf_addr_t e_shoff;
 
 	/*
 	 * We no longer stop all VM operations.
@@ -1667,8 +1697,16 @@ static int elf_fdpic_core_dump(struct co
 	segs = current->mm->map_count;
 	segs += elf_core_extra_phdrs();
 
+	/* for notes section */
+	segs++;
+
+	/* If segs > PN_XNUM(0xffff), then e_phnum overflows. To avoid
+	 * this, kernel supports extended numbering. Have a look at
+	 * include/linux/elf.h for further information. */
+	e_phnum = segs > PN_XNUM ? PN_XNUM : segs;
+
 	/* Set up header */
-	fill_elf_fdpic_header(elf, segs + 1);	/* including notes section */
+	fill_elf_fdpic_header(elf, e_phnum);
 
 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
@@ -1708,7 +1746,7 @@ static int elf_fdpic_core_dump(struct co
 	set_fs(KERNEL_DS);
 
 	offset += sizeof(*elf);				/* Elf header */
-	offset += (segs+1) * sizeof(struct elf_phdr);	/* Program headers */
+	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;
 
 	/* Write notes phdr entry */
@@ -1738,6 +1776,19 @@ static int elf_fdpic_core_dump(struct co
 	 */
 	mm_flags = current->mm->flags;
 
+	offset += elf_core_vma_data_size(mm_flags);
+	offset += elf_core_extra_data_size();
+	e_shoff = offset;
+
+	if (e_phnum == PN_XNUM) {
+		shdr4extnum = kmalloc(sizeof(*shdr4extnum), GFP_KERNEL);
+		if (!shdr4extnum)
+			goto end_coredump;
+		fill_extnum_info(elf, shdr4extnum, e_shoff, segs);
+	}
+
+	offset = dataoff;
+
 	size += sizeof(*elf);
 	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
 		goto end_coredump;
@@ -1802,6 +1853,14 @@ static int elf_fdpic_core_dump(struct co
 	if (!elf_core_write_extra_data(cprm->file, &size, cprm->limit))
 		goto end_coredump;
 
+	if (e_phnum == PN_XNUM) {
+		size += sizeof(*shdr4extnum);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, shdr4extnum,
+				   sizeof(*shdr4extnum)))
+			goto end_coredump;
+	}
+
 	if (cprm->file->f_pos != offset) {
 		/* Sanity check */
 		printk(KERN_WARNING
diff -puN include/linux/elf.h~elf-coredump-add-extended-numbering-support include/linux/elf.h
--- a/include/linux/elf.h~elf-coredump-add-extended-numbering-support
+++ a/include/linux/elf.h
@@ -50,6 +50,28 @@ typedef __s64	Elf64_Sxword;
 
 #define PT_GNU_STACK	(PT_LOOS + 0x474e551)
 
+/*
+ * Extended Numbering
+ *
+ * If the real number of program header table entries is larger than
+ * or equal to PN_XNUM(0xffff), it is set to sh_info field of the
+ * section header at index 0, and PN_XNUM is set to e_phnum
+ * field. Otherwise, the section header at index 0 is zero
+ * initialized, if it exists.
+ *
+ * Specifications are available in:
+ *
+ * - Sun microsystems: Linker and Libraries.
+ *   Part No: 817-1984-17, September 2008.
+ *   URL: http://docs.sun.com/app/docs/doc/817-1984
+ *
+ * - System V ABI AMD64 Architecture Processor Supplement
+ *   Draft Version 0.99.,
+ *   May 11, 2009.
+ *   URL: http://www.x86-64.org/
+ */
+#define PN_XNUM 0xffff
+
 /* These constants define the different elf file types */
 #define ET_NONE   0
 #define ET_REL    1
@@ -286,7 +308,7 @@ typedef struct elf64_phdr {
 #define SHN_COMMON	0xfff2
 #define SHN_HIRESERVE	0xffff
  
-typedef struct {
+typedef struct elf32_shdr {
   Elf32_Word	sh_name;
   Elf32_Word	sh_type;
   Elf32_Word	sh_flags;
@@ -394,6 +416,7 @@ typedef struct elf64_note {
 extern Elf32_Dyn _DYNAMIC [];
 #define elfhdr		elf32_hdr
 #define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Off
 #define Elf_Half	Elf32_Half
@@ -403,6 +426,7 @@ extern Elf32_Dyn _DYNAMIC [];
 extern Elf64_Dyn _DYNAMIC [];
 #define elfhdr		elf64_hdr
 #define elf_phdr	elf64_phdr
+#define elf_shdr	elf64_shdr
 #define elf_note	elf64_note
 #define elf_addr_t	Elf64_Off
 #define Elf_Half	Elf64_Half
diff -puN include/linux/elfcore.h~elf-coredump-add-extended-numbering-support include/linux/elfcore.h
--- a/include/linux/elfcore.h~elf-coredump-add-extended-numbering-support
+++ a/include/linux/elfcore.h
@@ -166,5 +166,6 @@ elf_core_write_extra_phdrs(struct file *
 			   unsigned long limit);
 extern int
 elf_core_write_extra_data(struct file *file, size_t *size, unsigned long limit);
+extern size_t elf_core_extra_data_size(void);
 
 #endif /* _LINUX_ELFCORE_H */
diff -puN kernel/elfcore.c~elf-coredump-add-extended-numbering-support kernel/elfcore.c
--- a/kernel/elfcore.c~elf-coredump-add-extended-numbering-support
+++ a/kernel/elfcore.c
@@ -21,3 +21,8 @@ int __weak elf_core_write_extra_data(str
 {
 	return 1;
 }
+
+size_t __weak elf_core_extra_data_size(void)
+{
+	return 0;
+}
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are


