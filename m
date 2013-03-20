From: akpm@linux-foundation.org
Subject: [nacked] kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:33:02 -0700
Message-ID: <20130320233302.8242D5A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42567 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:33:03 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so211826vcb.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:33:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fill note buffers by NT_VMCORE_PAD notes in page-size boundary
has been removed from the -mm tree.  Its filename was
     kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: kexec: fill note buffers by NT_VMCORE_PAD notes in page-size boundary

Fill both crash_notes and vmcoreinfo_note buffers by NT_VMCORE_PAD note
type to make them satisfy mmap()'s page-size boundary requirement.

So far, end of note segments has been marked by zero-filled elf header. 
Instead, this patch writes NT_VMCORE_PAD note in the end of note segments
until the offset on page-size boundary.

Also, old kernel can treat the ELF segments created without null header
because it stops reading ELF segments if real size it reads reachs
p_memsz.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/kexec.h |    8 +++--
 include/linux/kexec.h         |   12 ++++----
 kernel/kexec.c                |   46 ++++++++++++++++++++------------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff -puN arch/s390/include/asm/kexec.h~kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary arch/s390/include/asm/kexec.h
--- a/arch/s390/include/asm/kexec.h~kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary
+++ a/arch/s390/include/asm/kexec.h
@@ -41,8 +41,8 @@
 /*
  * Size for s390x ELF notes per CPU
  *
- * Seven notes plus zero note at the end: prstatus, fpregset, timer,
- * tod_cmp, tod_reg, control regs, and prefix
+ * Seven notes plus note with NT_VMCORE_PAD type at the end: prstatus,
+ * fpregset, timer, tod_cmp, tod_reg, control regs, and prefix
  */
 #define KEXEC_NOTE_BYTES \
 	(ALIGN(sizeof(struct elf_note), 4) * 8 + \
@@ -53,7 +53,9 @@
 	 ALIGN(sizeof(u64), 4) + \
 	 ALIGN(sizeof(u32), 4) + \
 	 ALIGN(sizeof(u64) * 16, 4) + \
-	 ALIGN(sizeof(u32), 4) \
+	 ALIGN(sizeof(u32), 4) + \
+	 KEXEC_CORE_NOTE_DESC_BYTES + \
+	 VMCOREINFO_NOTE_NAME_BYTES \
 	)
 
 /* Provide a dummy definition to avoid build failures. */
diff -puN include/linux/kexec.h~kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary
+++ a/include/linux/kexec.h
@@ -47,14 +47,16 @@
 #define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
 #define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
 /*
- * The per-cpu notes area is a list of notes terminated by a "NULL"
- * note header.  For kdump, the code in vmcore.c runs in the context
- * of the second kernel to combine them into one note.
+ * The per-cpu notes area is a list of notes terminated by a note
+ * header with NT_VMCORE_PAD type. For kdump, the code in vmcore.c
+ * runs in the context of the second kernel to combine them into one
+ * note.
  */
 #ifndef KEXEC_NOTE_BYTES
 #define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
 			    KEXEC_CORE_NOTE_NAME_BYTES +		\
-			    KEXEC_CORE_NOTE_DESC_BYTES )
+			    KEXEC_CORE_NOTE_DESC_BYTES +		\
+			    VMCOREINFO_NOTE_NAME_BYTES)
 #endif
 
 /*
@@ -187,7 +189,7 @@ extern struct kimage *kexec_crash_image;
 #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
 #define VMCOREINFO_NOTE_SIZE       ALIGN(KEXEC_NOTE_HEAD_BYTES*2	\
 					 +VMCOREINFO_BYTES		\
-					 +VMCOREINFO_NOTE_NAME_BYTES,	\
+					 +VMCOREINFO_NOTE_NAME_BYTES*2,	\
 					 PAGE_SIZE)
 
 /* Location of a reserved region to hold the crash kernel.
diff -puN kernel/kexec.c~kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary kernel/kexec.c
--- a/kernel/kexec.c~kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary
+++ a/kernel/kexec.c
@@ -40,6 +40,7 @@
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
+static size_t crash_notes_size = ALIGN(sizeof(note_buf_t), PAGE_SIZE);
 
 /* vmcoreinfo stuff */
 static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
@@ -1166,6 +1167,7 @@ unlock:
 	return ret;
 }
 
+/* If @data is NULL, fill @buf with 0 in @data_len bytes. */
 static u32 *append_elf_note(u32 *buf, char *name, unsigned type, void *data,
 			    size_t data_len)
 {
@@ -1178,26 +1180,36 @@ static u32 *append_elf_note(u32 *buf, ch
 	buf += (sizeof(note) + 3)/4;
 	memcpy(buf, name, note.n_namesz);
 	buf += (note.n_namesz + 3)/4;
-	memcpy(buf, data, note.n_descsz);
+	if (data)
+		memcpy(buf, data, note.n_descsz);
+	else
+		memset(buf, 0, note.n_descsz);
 	buf += (note.n_descsz + 3)/4;
 
 	return buf;
 }
 
-static void final_note(u32 *buf)
+static void final_note(u32 *buf, size_t buf_len, size_t data_len)
 {
-	struct elf_note note;
+	size_t used_bytes, pad_hdr_size;
 
-	note.n_namesz = 0;
-	note.n_descsz = 0;
-	note.n_type   = 0;
-	memcpy(buf, &note, sizeof(note));
+	pad_hdr_size = KEXEC_NOTE_HEAD_BYTES + VMCOREINFO_NOTE_NAME_BYTES;
+
+	/*
+	 * keep space for ELF note header and "VMCOREINFO" name to
+	 * terminate ELF segment by NT_VMCORE_PAD note.
+	 */
+	BUG_ON(data_len + pad_hdr_size > buf_len);
+
+	used_bytes = data_len + pad_hdr_size;
+	append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_PAD, NULL,
+			roundup(used_bytes, PAGE_SIZE) - used_bytes);
 }
 
 void crash_save_cpu(struct pt_regs *regs, int cpu)
 {
 	struct elf_prstatus prstatus;
-	u32 *buf;
+	u32 *buf, *buf_end;
 
 	if ((cpu < 0) || (cpu >= nr_cpu_ids))
 		return;
@@ -1215,16 +1227,15 @@ void crash_save_cpu(struct pt_regs *regs
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
-		      	      &prstatus, sizeof(prstatus));
-	final_note(buf);
+	buf_end = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
+				  &prstatus, sizeof(prstatus));
+	final_note(buf_end, crash_notes_size, (buf_end - buf) * sizeof(u32));
 }
 
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = __alloc_percpu(roundup(sizeof(note_buf_t), PAGE_SIZE),
-				     PAGE_SIZE);
+	crash_notes = __alloc_percpu(crash_notes_size, PAGE_SIZE);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");
@@ -1423,13 +1434,14 @@ int __init parse_crashkernel_low(char *c
 
 static void update_vmcoreinfo_note(void)
 {
-	u32 *buf = vmcoreinfo_note;
+	u32 *buf = vmcoreinfo_note, *buf_end;
 
 	if (!vmcoreinfo_size)
 		return;
-	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_DEBUGINFO,
-			      vmcoreinfo_data, vmcoreinfo_size);
-	final_note(buf);
+	buf_end = append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_DEBUGINFO,
+				  vmcoreinfo_data, vmcoreinfo_size);
+	final_note(buf_end, sizeof(vmcoreinfo_note),
+		   (buf_end - buf) * sizeof(u32));
 }
 
 void crash_save_vmcoreinfo(void)
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

