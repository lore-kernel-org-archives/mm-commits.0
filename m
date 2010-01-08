From: akpm@linux-foundation.org
Subject: + coredump-move-dump_write-and-dump_seek-into-a-header-file.patch added to -mm tree
Date: Thu, 07 Jan 2010 16:29:48 -0800
Message-ID: <201001080029.o080TmSu026455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab0AHAbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 19:31:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, dhowells@redhat.com, gerg@snapgear.com, jdike@addtoit.com, linux-arch@vger.kernel.org, mingo@elte.hu, oleg@redhat.com, roland@redhat.com, tony.luck@intel.com, viro@zeniv.linux.org.uk


The patch titled
     coredump: move dump_write() and dump_seek() into a header file
has been added to the -mm tree.  Its filename is
     coredump-move-dump_write-and-dump_seek-into-a-header-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: move dump_write() and dump_seek() into a header file
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

My next patch will replace ELF_CORE_EXTRA_* macros by functions, putting
them into other newly created *.c files.  Then, each files will contain
dump_write(), where each pair of binfmt_*.c and elfcore.c should be the
same.  So, this patch moves them into a header file with dump_seek(). 
Also, the patch deletes confusing DUMP_WRITE macros in each files.

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

 fs/binfmt_aout.c         |   49 ++++++---------------------------
 fs/binfmt_elf.c          |   52 +++++++++--------------------------
 fs/binfmt_elf_fdpic.c    |   54 ++++++++++---------------------------
 include/linux/coredump.h |   41 ++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 117 deletions(-)

diff -puN fs/binfmt_aout.c~coredump-move-dump_write-and-dump_seek-into-a-header-file fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~coredump-move-dump_write-and-dump_seek-into-a-header-file
+++ a/fs/binfmt_aout.c
@@ -24,6 +24,7 @@
 #include <linux/binfmts.h>
 #include <linux/personality.h>
 #include <linux/init.h>
+#include <linux/coredump.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -60,42 +61,6 @@ static int set_brk(unsigned long start, 
 }
 
 /*
- * These are the only things you should do on a core-file: use only these
- * macros to write out all the necessary info.
- */
-
-static int dump_write(struct file *file, const void *addr, int nr)
-{
-	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
-}
-
-static int dump_seek(struct file *file, loff_t off)
-{
-	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
-		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
-			return 0;
-	} else {
-		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
-		if (!buf)
-			return 0;
-		while (off > 0) {
-			unsigned long n = off;
-			if (n > PAGE_SIZE)
-				n = PAGE_SIZE;
-			if (!dump_write(file, buf, n))
-				return 0;
-			off -= n;
-		}
-		free_page((unsigned long)buf);
-	}
-	return 1;
-}
-
-#define DUMP_WRITE(addr, nr)	\
-	if (!dump_write(file, (void *)(addr), (nr))) \
-		goto end_coredump;
-
-/*
  * Routine writes a core dump image in the current directory.
  * Currently only a stub-function.
  *
@@ -146,7 +111,8 @@ static int aout_core_dump(struct coredum
 
 	set_fs(KERNEL_DS);
 /* struct user */
-	DUMP_WRITE(&dump,sizeof(dump));
+	if (!dump_write(file, &dump, sizeof(dump)))
+		goto end_coredump;
 /* Now dump all of the user data.  Include malloced stuff as well */
 	if (!dump_seek(cprm->file, PAGE_SIZE - sizeof(dump)))
 		goto end_coredump;
@@ -156,17 +122,20 @@ static int aout_core_dump(struct coredum
 	if (dump.u_dsize != 0) {
 		dump_start = START_DATA(dump);
 		dump_size = dump.u_dsize << PAGE_SHIFT;
-		DUMP_WRITE(dump_start,dump_size);
+		if (!dump_write(file, dump_start, dump_size))
+			goto end_coredump;
 	}
 /* Now prepare to dump the stack area */
 	if (dump.u_ssize != 0) {
 		dump_start = START_STACK(dump);
 		dump_size = dump.u_ssize << PAGE_SHIFT;
-		DUMP_WRITE(dump_start,dump_size);
+		if (!dump_write(file, dump_start, dump_size))
+			goto end_coredump;
 	}
 /* Finally dump the task struct.  Not be used by gdb, but could be useful */
 	set_fs(KERNEL_DS);
-	DUMP_WRITE(current,sizeof(*current));
+	if (!dump_write(file, current, sizeof(*current)))
+		goto end_coredump;
 end_coredump:
 	set_fs(fs);
 	return has_dumped;
diff -puN fs/binfmt_elf.c~coredump-move-dump_write-and-dump_seek-into-a-header-file fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-move-dump_write-and-dump_seek-into-a-header-file
+++ a/fs/binfmt_elf.c
@@ -31,6 +31,7 @@
 #include <linux/random.h>
 #include <linux/elf.h>
 #include <linux/utsname.h>
+#include <linux/coredump.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -1108,36 +1109,6 @@ out:
  * Modelled on fs/exec.c:aout_core_dump()
  * Jeremy Fitzhardinge <jeremy@sw.oz.au>
  */
-/*
- * These are the only things you should do on a core-file: use only these
- * functions to write out all the necessary info.
- */
-static int dump_write(struct file *file, const void *addr, int nr)
-{
-	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
-}
-
-static int dump_seek(struct file *file, loff_t off)
-{
-	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
-		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
-			return 0;
-	} else {
-		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
-		if (!buf)
-			return 0;
-		while (off > 0) {
-			unsigned long n = off;
-			if (n > PAGE_SIZE)
-				n = PAGE_SIZE;
-			if (!dump_write(file, buf, n))
-				return 0;
-			off -= n;
-		}
-		free_page((unsigned long)buf);
-	}
-	return 1;
-}
 
 /*
  * Decide what to dump of a segment, part, all or none.
@@ -1272,11 +1243,6 @@ static int writenote(struct memelfnote *
 }
 #undef DUMP_WRITE
 
-#define DUMP_WRITE(addr, nr)				\
-	if ((size += (nr)) > cprm->limit ||		\
-	    !dump_write(cprm->file, (addr), (nr)))	\
-		goto end_coredump;
-
 static void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags, u8 osabi)
 {
@@ -1957,7 +1923,10 @@ static int elf_core_dump(struct coredump
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	DUMP_WRITE(elf, sizeof(*elf));
+	size += sizeof(*elf);
+	if (size > cprm->limit || !dump_write(cprm->file, elf, sizeof(*elf)))
+		goto end_coredump;
+
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs + 1) * sizeof(struct elf_phdr); /* Program headers */
 	foffset = offset;
@@ -1971,7 +1940,11 @@ static int elf_core_dump(struct coredump
 
 		fill_elf_note_phdr(&phdr, sz, offset);
 		offset += sz;
-		DUMP_WRITE(&phdr, sizeof(phdr));
+
+		size += sizeof(phdr);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 	dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
@@ -2002,7 +1975,10 @@ static int elf_core_dump(struct coredump
 			phdr.p_flags |= PF_X;
 		phdr.p_align = ELF_EXEC_PAGESIZE;
 
-		DUMP_WRITE(&phdr, sizeof(phdr));
+		size += sizeof(phdr);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 #ifdef ELF_CORE_WRITE_EXTRA_PHDRS
diff -puN fs/binfmt_elf_fdpic.c~coredump-move-dump_write-and-dump_seek-into-a-header-file fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-move-dump_write-and-dump_seek-into-a-header-file
+++ a/fs/binfmt_elf_fdpic.c
@@ -34,6 +34,7 @@
 #include <linux/elf.h>
 #include <linux/elf-fdpic.h>
 #include <linux/elfcore.h>
+#include <linux/coredump.h>
 
 #include <asm/uaccess.h>
 #include <asm/param.h>
@@ -1213,37 +1214,6 @@ static int elf_fdpic_map_file_by_direct_
 #ifdef CONFIG_ELF_CORE
 
 /*
- * These are the only things you should do on a core-file: use only these
- * functions to write out all the necessary info.
- */
-static int dump_write(struct file *file, const void *addr, int nr)
-{
-	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
-}
-
-static int dump_seek(struct file *file, loff_t off)
-{
-	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
-		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
-			return 0;
-	} else {
-		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
-		if (!buf)
-			return 0;
-		while (off > 0) {
-			unsigned long n = off;
-			if (n > PAGE_SIZE)
-				n = PAGE_SIZE;
-			if (!dump_write(file, buf, n))
-				return 0;
-			off -= n;
-		}
-		free_page((unsigned long)buf);
-	}
-	return 1;
-}
-
-/*
  * Decide whether a segment is worth dumping; default is yes to be
  * sure (missing info is worse than too much; etc).
  * Personally I'd include everything, and use the coredump limit...
@@ -1351,11 +1321,6 @@ static int writenote(struct memelfnote *
 }
 #undef DUMP_WRITE
 
-#define DUMP_WRITE(addr, nr)				\
-	if ((size += (nr)) > cprm->limit ||		\
-	    !dump_write(cprm->file, (addr), (nr)))	\
-		goto end_coredump;
-
 static inline void fill_elf_fdpic_header(struct elfhdr *elf, int segs)
 {
 	memcpy(elf->e_ident, ELFMAG, SELFMAG);
@@ -1740,7 +1705,11 @@ static int elf_fdpic_core_dump(struct co
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 
-	DUMP_WRITE(elf, sizeof(*elf));
+	size += sizeof(*elf);
+	if (size > cprm->limit
+	    || !dump_write(cprm->file, elf, sizeof(*elf)))
+		goto end_coredump;
+
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs+1) * sizeof(struct elf_phdr);	/* Program headers */
 	foffset = offset;
@@ -1757,7 +1726,11 @@ static int elf_fdpic_core_dump(struct co
 
 		fill_elf_note_phdr(&phdr, sz, offset);
 		offset += sz;
-		DUMP_WRITE(&phdr, sizeof(phdr));
+
+		size += sizeof(phdr);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 	/* Page-align dumped data */
@@ -1791,7 +1764,10 @@ static int elf_fdpic_core_dump(struct co
 			phdr.p_flags |= PF_X;
 		phdr.p_align = ELF_EXEC_PAGESIZE;
 
-		DUMP_WRITE(&phdr, sizeof(phdr));
+		size += sizeof(phdr);
+		if (size > cprm->limit
+		    || !dump_write(cprm->file, &phdr, sizeof(phdr)))
+			goto end_coredump;
 	}
 
 #ifdef ELF_CORE_WRITE_EXTRA_PHDRS
diff -puN /dev/null include/linux/coredump.h
--- /dev/null
+++ a/include/linux/coredump.h
@@ -0,0 +1,41 @@
+#ifndef _LINUX_COREDUMP_H
+#define _LINUX_COREDUMP_H
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+
+/*
+ * These are the only things you should do on a core-file: use only these
+ * functions to write out all the necessary info.
+ */
+static inline int dump_write(struct file *file, const void *addr, int nr)
+{
+	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+}
+
+static inline int dump_seek(struct file *file, loff_t off)
+{
+	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
+		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
+			return 0;
+	} else {
+		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
+
+		if (!buf)
+			return 0;
+		while (off > 0) {
+			unsigned long n = off;
+
+			if (n > PAGE_SIZE)
+				n = PAGE_SIZE;
+			if (!dump_write(file, buf, n))
+				return 0;
+			off -= n;
+		}
+		free_page((unsigned long)buf);
+	}
+	return 1;
+}
+
+#endif /* _LINUX_COREDUMP_H */
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch

