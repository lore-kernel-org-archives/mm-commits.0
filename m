From: akpm@linux-foundation.org
Subject: + kdump-kexec-calculate-note-size-at-compile-time-update-2.patch added to -mm tree
Date: Tue, 03 Apr 2007 17:37:40 -0700
Message-ID: <200704040037.l340bfc2007922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50151 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934045AbXDDAhw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 20:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, vgoyal@in.ibm.com


The patch titled
     kdump/kexec: calculate note size at compile time (update2)
has been added to the -mm tree.  Its filename is
     kdump-kexec-calculate-note-size-at-compile-time-update-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kdump/kexec: calculate note size at compile time (update2)
From: Simon Horman <horms@verge.net.au>

Currently the size of the per-cpu region reserved to save crash notes is
set by the per-architecture value MAX_NOTE_BYTES.  Which in turn is
currently set to 1024 on all supported architectures.

While testing ia64 I recently discovered that this value is in fact too
small.  The particular setup I was using actually needs 1172 bytes.  This
lead to very tedious failure mode where the tail of one elf note would
overwrite the head of another if they ended up being alocated sequentially
by kmalloc, which was often the case.

It seems to me that a far better approach is to caclculate the size that
the area needs to be.  This patch does just that.

If a simpler stop-gap patch for ia64 to be squeezed into 2.6.21(.X) is
needed then this should be as easy as making MAX_NOTE_BYTES larger in
arch/asm-ia64/kexec.h.  Perhaps 2048 would be a good choice.  However, I
think that the approach in this patch is a much more robust idea.

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by:  Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash.c |    2 +-
 include/linux/kexec.h    |   21 +++++++++++----------
 kernel/kexec.c           |    4 ++--
 3 files changed, 14 insertions(+), 13 deletions(-)

diff -puN arch/ia64/kernel/crash.c~kdump-kexec-calculate-note-size-at-compile-time-update-2 arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~kdump-kexec-calculate-note-size-at-compile-time-update-2
+++ a/arch/ia64/kernel/crash.c
@@ -74,7 +74,7 @@ crash_save_this_cpu(void)
 	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
 	if (!buf)
 		return;
-	buf = append_elf_note(buf, KEXEC_NOTE_NAME, NT_PRSTATUS, prstatus,
+	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS, prstatus,
 			sizeof(*prstatus));
 	final_note(buf);
 }
diff -puN include/linux/kexec.h~kdump-kexec-calculate-note-size-at-compile-time-update-2 include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-kexec-calculate-note-size-at-compile-time-update-2
+++ a/include/linux/kexec.h
@@ -33,17 +33,18 @@
 #error KEXEC_ARCH not defined
 #endif
 
-#define KEXEC_NOTE_NAME "CORE"
 #define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
-#define KEXEC_NOTE_NAME_BYTES ALIGN(sizeof("CORE"), 4) /* N.B: Includes '\0' */
-#define KEXEC_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
-/* The notes are read and combined by the code in vmcore.c running
- * in the second-kernel after kdump is performed. This code
- * expects the notes area to be a list of notes, terminated
- * by a "NULL" note header. The "* 2" below is to provide space
- * for the terminating note header */
-#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) + \
-			   KEXEC_NOTE_NAME_BYTES + KEXEC_NOTE_DESC_BYTES )
+#define KEXEC_CORE_NOTE_NAME "CORE"
+#define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
+#define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
+/*
+ * The per-cpu notes area is a list of notes terminated by a "NULL"
+ * note header.  For kdump, the code in vmcore.c runs in the context
+ * of the second kernel to combine them into one note.
+ */
+#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
+			    KEXEC_CORE_NOTE_NAME_BYTES +		\
+			    KEXEC_CORE_NOTE_DESC_BYTES )
 
 /*
  * This structure is used to hold the arguments that are used when loading
diff -puN kernel/kexec.c~kdump-kexec-calculate-note-size-at-compile-time-update-2 kernel/kexec.c
--- a/kernel/kexec.c~kdump-kexec-calculate-note-size-at-compile-time-update-2
+++ a/kernel/kexec.c
@@ -1118,8 +1118,8 @@ void crash_save_cpu(struct pt_regs *regs
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, KEXEC_NOTE_NAME, NT_PRSTATUS, &prstatus,
-				sizeof(prstatus));
+	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
+		      	      &prstatus, sizeof(prstatus));
 	final_note(buf);
 }
 
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch
git-ia64.patch
git-net.patch
git-scsi-misc.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
kdump-kexec-calculate-note-size-at-compile-time-update.patch
kdump-kexec-calculate-note-size-at-compile-time-update-2.patch
