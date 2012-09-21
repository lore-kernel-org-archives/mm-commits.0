From: akpm@linux-foundation.org
Subject: [failures] coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch removed from -mm tree
Date: Fri, 21 Sep 2012 12:24:36 -0700
Message-ID: <20120921192437.414ED5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:32839 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069Ab2IUTYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 15:24:39 -0400
Received: by mail-bk0-f74.google.com with SMTP id jc3so238428bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 12:24:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, amwang@redhat.com, jmfoote@cert.org, oleg@redhat.com, palves@redhat.com, roland@hack.frob.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: extend core dump note section to contain file names of mapped files
has been removed from the -mm tree.  Its filename was
     coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: coredump: extend core dump note section to contain file names of mapped files

This note has the following format:

long count     -- how many files are mapped
long page_size -- units for file_ofs
array of [COUNT] elements of
   long start
   long end
   long file_ofs
followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...

[akpm@linux-foundation.org: include vmalloc.h]
[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: "Jonathan M. Foote" <jmfoote@cert.org>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Pedro Alves <palves@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |  110 +++++++++++++++++++++++++++++++++++++--
 fs/compat_binfmt_elf.c |    1 
 include/linux/elf.h    |    1 
 3 files changed, 108 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files
+++ a/fs/binfmt_elf.c
@@ -27,6 +27,7 @@
 #include <linux/compiler.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/vmalloc.h>
 #include <linux/security.h>
 #include <linux/random.h>
 #include <linux/elf.h>
@@ -36,6 +37,9 @@
 #include <asm/param.h>
 #include <asm/page.h>
 
+#ifndef user_long_t
+#define user_long_t long
+#endif
 #ifndef user_siginfo_t
 #define user_siginfo_t siginfo_t
 #endif
@@ -1384,6 +1388,93 @@ static void fill_siginfo_note(struct mem
 	fill_note(note, "CORE", NT_SIGINFO, sizeof(*csigdata), csigdata);
 }
 
+#define MAX_FILE_NOTE_SIZE (4*1024*1024)
+/*
+ * Format of NT_FILE note:
+ *
+ * long count     -- how many files are mapped
+ * long page_size -- units for file_ofs
+ * array of [COUNT] elements of
+ *   long start
+ *   long end
+ *   long file_ofs
+ * followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
+ */
+static void fill_files_note(struct memelfnote *note)
+{
+	struct vm_area_struct *vma;
+	unsigned count, size, names_ofs, remaining, n;
+	user_long_t *data;
+	user_long_t *start_end_ofs;
+	char *name_base, *name_curpos;
+
+	/* *Estimated* file count and total data size needed */
+	count = current->mm->map_count;
+	size = count * 64;
+
+	names_ofs = (2 + 3 * count) * sizeof(data[0]);
+ alloc:
+	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
+		goto err;
+	size = round_up(size, PAGE_SIZE);
+	data = vmalloc(size);
+	if (!data)
+		goto err;
+
+	start_end_ofs = data + 2;
+	name_base = name_curpos = ((char *)data) + names_ofs;
+	remaining = size - names_ofs;
+	count = 0;
+	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
+		struct file *file;
+		const char *filename;
+
+		file = vma->vm_file;
+		if (!file)
+			continue;
+		filename = d_path(&file->f_path, name_curpos, remaining);
+		if (IS_ERR(filename)) {
+			if (PTR_ERR(filename) == -ENAMETOOLONG) {
+				vfree(data);
+				size = size * 5 / 4;
+				goto alloc;
+			}
+			continue;
+		}
+
+		/* d_path() fills at the end, move name down */
+		/* n = strlen(filename) + 1: */
+		n = (name_curpos + remaining) - filename;
+		remaining = filename - name_curpos;
+		memmove(name_curpos, filename, n);
+		name_curpos += n;
+
+		*start_end_ofs++ = vma->vm_start;
+		*start_end_ofs++ = vma->vm_end;
+		*start_end_ofs++ = vma->vm_pgoff;
+		count++;
+	}
+
+	/* Now we know exact count of files, can store it */
+	data[0] = count;
+	data[1] = PAGE_SIZE;
+	/*
+	 * Count usually is less than current->mm->map_count,
+	 * we need to move filenames down.
+	 */
+	n = current->mm->map_count - count;
+	if (n != 0) {
+		unsigned shift_bytes = n * 3 * sizeof(data[0]);
+		memmove(name_base - shift_bytes, name_base,
+			name_curpos - name_base);
+		name_curpos -= shift_bytes;
+	}
+
+	size = name_curpos - (char *)data;
+	fill_note(note, "CORE", NT_FILE, size, data);
+ err: ;
+}
+
 #ifdef CORE_DUMP_USE_REGSET
 #include <linux/regset.h>
 
@@ -1399,6 +1490,7 @@ struct elf_note_info {
 	struct memelfnote psinfo;
 	struct memelfnote signote;
 	struct memelfnote auxv;
+	struct memelfnote files;
 	user_siginfo_t csigdata;
 	size_t size;
 	int thread_notes;
@@ -1579,6 +1671,9 @@ static int fill_note_info(struct elfhdr 
 	fill_auxv_note(&info->auxv, current->mm);
 	info->size += notesize(&info->auxv);
 
+	fill_files_note(&info->files);
+	info->size += notesize(&info->files);
+
 	return 1;
 }
 
@@ -1609,6 +1704,8 @@ static int write_note_info(struct elf_no
 			return 0;
 		if (first && !writenote(&info->auxv, file, foffset))
 			return 0;
+		if (first && !writenote(&info->files, file, foffset))
+			return 0;
 
 		for (i = 1; i < info->thread_notes; ++i)
 			if (t->notes[i].data &&
@@ -1635,6 +1732,7 @@ static void free_note_info(struct elf_no
 		kfree(t);
 	}
 	kfree(info->psinfo.data);
+	vfree(info->files.data);
 }
 
 #else
@@ -1711,7 +1809,7 @@ static int elf_note_info_init(struct elf
 	INIT_LIST_HEAD(&info->thread_list);
 
 	/* Allocate space for ELF notes */
-	info->notes = kmalloc(7 * sizeof(struct memelfnote), GFP_KERNEL);
+	info->notes = kmalloc(8 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
@@ -1781,10 +1879,11 @@ static int fill_note_info(struct elfhdr 
 	fill_note(info->notes + 1, "CORE", NT_PRPSINFO,
 		  sizeof(*info->psinfo), info->psinfo);
 
-	info->numnote = 2;
+	fill_siginfo_note(info->notes + 2, &info->csigdata, siginfo);
+	fill_auxv_note(info->notes + 3, current->mm);
+	fill_files_note(info->notes + 4);
 
-	fill_siginfo_note(&info->notes[info->numnote++], &info->csigdata, siginfo);
-	fill_auxv_note(&info->notes[info->numnote++], current->mm);
+	info->numnote = 5;
 
 	/* Try to dump the FPU. */
 	info->prstatus->pr_fpvalid = elf_core_copy_task_fpregs(current, regs,
@@ -1846,6 +1945,9 @@ static void free_note_info(struct elf_no
 		kfree(list_entry(tmp, struct elf_thread_status, list));
 	}
 
+	/* Free data allocated by fill_files_note(): */
+	vfree(info->notes[4].data);
+
 	kfree(info->prstatus);
 	kfree(info->psinfo);
 	kfree(info->notes);
diff -puN fs/compat_binfmt_elf.c~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files fs/compat_binfmt_elf.c
--- a/fs/compat_binfmt_elf.c~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files
+++ a/fs/compat_binfmt_elf.c
@@ -41,6 +41,7 @@
 /*
  * Some data types as stored in coredump.
  */
+#define user_long_t		compat_long_t
 #define user_siginfo_t		compat_siginfo_t
 #define copy_siginfo_to_user	copy_siginfo_to_user32
 
diff -puN include/linux/elf.h~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files include/linux/elf.h
--- a/include/linux/elf.h~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files
+++ a/include/linux/elf.h
@@ -377,6 +377,7 @@ typedef struct elf64_shdr {
  * in the future to accomodate more fields, don't assume it is fixed!
  */
 #define NT_SIGINFO      0x53494749
+#define NT_FILE         0x46494c45
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
 #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch

