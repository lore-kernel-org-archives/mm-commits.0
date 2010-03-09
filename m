From: akpm@linux-foundation.org
Subject: [merged] coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:39 -0800
Message-ID: <201003091909.o29J9dTh031536__1836.1248694875$1268161896$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab0CITLW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:11:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, dhowells@redhat.com, gerg@snapgear.com, jdike@addtoit.com, linux-arch@vger.kernel.org, mingo@elte.hu, oleg@re


The patch titled
     coredump: unify dump_seek() implementations for each binfmt_*.c
has been removed from the -mm tree.  Its filename was
     coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump: unify dump_seek() implementations for each binfmt_*.c
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>

The current ELF dumper can produce broken corefiles if program headers
exceed 65535.  In particular, the program in 64-bit environment often
demands more than 65535 mmaps.  If you google max_map_count, then you can
find many users facing this problem.

Solaris has already dealt with this issue, and other OSes have also
adopted the same method as in Solaris.  Currently, Sun's document and AMD
64 ABI include the description for the extension, where they call the
extension Extended Numbering.  See Reference for further information.

I believe that linux kernel should adopt the same way as they did, so I've
written this patch.

I am also preparing for patches of GDB and binutils.

How to fix
==========

In new dumping process, there are two cases according to weather or
not the number of program headers is equal to or more than 65535.

 - if less than 65535, the produced corefile format is exactly the same
   as the ordinary one.

 - if equal to or more than 65535, then e_phnum field is set to newly
   introduced constant PN_XNUM(0xffff) and the actual number of program
   headers is set to sh_info field of the section header at index 0.

Compatibility Concern
=====================

 * As already mentioned in Summary, Sun and AMD64 has already adopted
   this.  See Reference.

 * There are four combinations according to whether kernel and userland
   tools are respectively modified or not.  The next table summarizes
   shortly for each combination.

                  ---------------------------------------------
                     Original Kernel    |   Modified Kernel   
                  ---------------------------------------------
    	            < 65535  | >= 65535 | < 65535  | >= 65535 
  -------------------------------------------------------------
   Original Tools |    OK    |  broken  |   OK     | broken (#)
  -------------------------------------------------------------
   Modified Tools |    OK    |  broken  |   OK     |    OK
  -------------------------------------------------------------

  Note that there is no case that `OK' changes to `broken'.

  (#) Although this case remains broken, O-M behaves better than
  O-O. That is, while in O-O case e_phnum field would be extremely
  small due to integer overflow, in O-M case it is guaranteed to be at
  least 65535 by being set to PN_XNUM(0xFFFF), much closer to the
  actual correct value than the O-O case.

Test Program
============

Here is a test program mkmmaps.c that is useful to produce the
corefile with many mmaps. To use this, please take the following
steps:

$ ulimit -c unlimited
$ sysctl vm.max_map_count=70000 # default 65530 is too small
$ sysctl fs.file-max=70000
$ mkmmaps 65535

Then, the program will abort and a corefile will be generated.

If failed, there are two cases according to the error message
displayed.

 * ``out of memory'' means vm.max_map_count is still smaller

 * ``too many open files'' means fs.file-max is still smaller

So, please change it to a larger value, and then retry it.

mkmmaps.c
==
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
int main(int argc, char **argv)
{ 
	int maps_num;
	if (argc < 2) {
		fprintf(stderr, "mkmmaps [number of maps to be created]\n");
		exit(1);
	}
	if (sscanf(argv[1], "%d", &maps_num) == EOF) {
		perror("sscanf");
		exit(2);
	}
	if (maps_num < 0) {
		fprintf(stderr, "%d is invalid\n", maps_num);
		exit(3);
	}
	for (; maps_num > 0; --maps_num) {
		if (MAP_FAILED == mmap((void *)NULL, (size_t) 1, PROT_READ,
					MAP_SHARED | MAP_ANONYMOUS, (int) -1,
					(off_t) NULL)) {
			perror("mmap");
			exit(4);
		}    
	}
	abort();
	{
		char buffer[128];
		sprintf(buffer, "wc -l /proc/%u/maps", getpid());
		system(buffer);
	}
	return 0;
}

Tested on i386, ia64 and um/sys-i386.
Built on sh4 (which covers fs/binfmt_elf_fdpic.c)

References
==========

 - Sun microsystems: Linker and Libraries.
   Part No: 817-1984-17, September 2008.
   URL: http://docs.sun.com/app/docs/doc/817-1984

 - System V ABI AMD64 Architecture Processor Supplement
   Draft Version 0.99., May 11, 2009.
   URL: http://www.x86-64.org/




This patch:

There are three different definitions for dump_seek() functions in
binfmt_aout.c, binfmt_elf.c and binfmt_elf_fdpic.c, respectively.  The
only for binfmt_elf.c.

My next patch will move dump_seek() into a header file in order to share
the same implementations for dump_write() and dump_seek().  As the first
step, this patch unify these three definitions for dump_seek() by applying
the past commits that have been applied only for binfmt_elf.c.

Specifically, the modification made here is part of the following commits:

  * d025c9db7f31fc0554ce7fb2dfc78d35a77f3487
  * 7f14daa19ea36b200d237ad3ac5826ae25360461

This patch does not change a shape of corefiles.

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

 fs/binfmt_aout.c      |   31 ++++++++++++++++-----
 fs/binfmt_elf_fdpic.c |   59 +++++++++++++++++++++++++---------------
 2 files changed, 62 insertions(+), 28 deletions(-)

diff -puN fs/binfmt_aout.c~coredump-unify-dump_seek-implementations-for-each-binfmt_c fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~coredump-unify-dump_seek-implementations-for-each-binfmt_c
+++ a/fs/binfmt_aout.c
@@ -69,16 +69,32 @@ static int dump_write(struct file *file,
 	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
 }
 
+static int dump_seek(struct file *file, loff_t off)
+{
+	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
+		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
+			return 0;
+	} else {
+		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
+		if (!buf)
+			return 0;
+		while (off > 0) {
+			unsigned long n = off;
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
 #define DUMP_WRITE(addr, nr)	\
 	if (!dump_write(file, (void *)(addr), (nr))) \
 		goto end_coredump;
 
-#define DUMP_SEEK(offset) \
-if (file->f_op->llseek) { \
-	if (file->f_op->llseek(file,(offset),0) != (offset)) \
- 		goto end_coredump; \
-} else file->f_pos = (offset)
-
 /*
  * Routine writes a core dump image in the current directory.
  * Currently only a stub-function.
@@ -132,7 +148,8 @@ static int aout_core_dump(struct coredum
 /* struct user */
 	DUMP_WRITE(&dump,sizeof(dump));
 /* Now dump all of the user data.  Include malloced stuff as well */
-	DUMP_SEEK(PAGE_SIZE);
+	if (!dump_seek(cprm->file, PAGE_SIZE - sizeof(dump)))
+		goto end_coredump;
 /* now we start writing out the user space info */
 	set_fs(USER_DS);
 /* Dump the data area */
diff -puN fs/binfmt_elf_fdpic.c~coredump-unify-dump_seek-implementations-for-each-binfmt_c fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~coredump-unify-dump_seek-implementations-for-each-binfmt_c
+++ a/fs/binfmt_elf_fdpic.c
@@ -1226,11 +1226,22 @@ static int dump_write(struct file *file,
 
 static int dump_seek(struct file *file, loff_t off)
 {
-	if (file->f_op->llseek) {
-		if (file->f_op->llseek(file, off, SEEK_SET) != off)
+	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
+		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
 			return 0;
 	} else {
-		file->f_pos = off;
+		char *buf = (char *)get_zeroed_page(GFP_KERNEL);
+		if (!buf)
+			return 0;
+		while (off > 0) {
+			unsigned long n = off;
+			if (n > PAGE_SIZE)
+				n = PAGE_SIZE;
+			if (!dump_write(file, buf, n))
+				return 0;
+			off -= n;
+		}
+		free_page((unsigned long)buf);
 	}
 	return 1;
 }
@@ -1313,30 +1324,35 @@ static int notesize(struct memelfnote *e
 
 /* #define DEBUG */
 
-#define DUMP_WRITE(addr, nr)	\
-	do { if (!dump_write(file, (addr), (nr))) return 0; } while(0)
-#define DUMP_SEEK(off)	\
-	do { if (!dump_seek(file, (off))) return 0; } while(0)
+#define DUMP_WRITE(addr, nr, foffset)	\
+	do { if (!dump_write(file, (addr), (nr))) return 0; *foffset += (nr); } while(0)
 
-static int writenote(struct memelfnote *men, struct file *file)
+static int alignfile(struct file *file, loff_t *foffset)
 {
-	struct elf_note en;
+	static const char buf[4] = { 0, };
+	DUMP_WRITE(buf, roundup(*foffset, 4) - *foffset, foffset);
+	return 1;
+}
 
+static int writenote(struct memelfnote *men, struct file *file,
+			loff_t *foffset)
+{
+	struct elf_note en;
 	en.n_namesz = strlen(men->name) + 1;
 	en.n_descsz = men->datasz;
 	en.n_type = men->type;
 
-	DUMP_WRITE(&en, sizeof(en));
-	DUMP_WRITE(men->name, en.n_namesz);
-	/* XXX - cast from long long to long to avoid need for libgcc.a */
-	DUMP_SEEK(roundup((unsigned long)file->f_pos, 4));	/* XXX */
-	DUMP_WRITE(men->data, men->datasz);
-	DUMP_SEEK(roundup((unsigned long)file->f_pos, 4));	/* XXX */
+	DUMP_WRITE(&en, sizeof(en), foffset);
+	DUMP_WRITE(men->name, en.n_namesz, foffset);
+	if (!alignfile(file, foffset))
+		return 0;
+	DUMP_WRITE(men->data, men->datasz, foffset);
+	if (!alignfile(file, foffset))
+		return 0;
 
 	return 1;
 }
 #undef DUMP_WRITE
-#undef DUMP_SEEK
 
 #define DUMP_WRITE(addr, nr)				\
 	if ((size += (nr)) > cprm->limit ||		\
@@ -1552,7 +1568,7 @@ static int elf_fdpic_dump_segments(struc
 					err = -EIO;
 				kunmap(page);
 				page_cache_release(page);
-			} else if (!dump_seek(file, file->f_pos + PAGE_SIZE))
+			} else if (!dump_seek(file, PAGE_SIZE))
 				err = -EFBIG;
 			if (err)
 				goto out;
@@ -1605,7 +1621,7 @@ static int elf_fdpic_core_dump(struct co
 	int i;
 	struct vm_area_struct *vma;
 	struct elfhdr *elf = NULL;
-	loff_t offset = 0, dataoff;
+	loff_t offset = 0, dataoff, foffset;
 	int numnote;
 	struct memelfnote *notes = NULL;
 	struct elf_prstatus *prstatus = NULL;	/* NT_PRSTATUS */
@@ -1730,6 +1746,7 @@ static int elf_fdpic_core_dump(struct co
 	DUMP_WRITE(elf, sizeof(*elf));
 	offset += sizeof(*elf);				/* Elf header */
 	offset += (segs+1) * sizeof(struct elf_phdr);	/* Program headers */
+	foffset = offset;
 
 	/* Write notes phdr entry */
 	{
@@ -1786,7 +1803,7 @@ static int elf_fdpic_core_dump(struct co
 
  	/* write out the notes section */
 	for (i = 0; i < numnote; i++)
-		if (!writenote(notes + i, cprm->file))
+		if (!writenote(notes + i, cprm->file, &foffset))
 			goto end_coredump;
 
 	/* write out the thread status notes section */
@@ -1795,11 +1812,11 @@ static int elf_fdpic_core_dump(struct co
 				list_entry(t, struct elf_thread_status, list);
 
 		for (i = 0; i < tmp->num_notes; i++)
-			if (!writenote(&tmp->notes[i], cprm->file))
+			if (!writenote(&tmp->notes[i], cprm->file, &foffset))
 				goto end_coredump;
 	}
 
-	if (!dump_seek(cprm->file, dataoff))
+	if (!dump_seek(cprm->file, dataoff - foffset))
 		goto end_coredump;
 
 	if (elf_fdpic_dump_segments(cprm->file, &size, &cprm->limit,
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are


