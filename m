From: akpm@linux-foundation.org
Subject: + kdump-kexec-calculate-note-size-at-compile-time-update.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:19:46 -0700
Message-ID: <200704022119.l32LJkM4009766@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965931AbXDBVUp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, vgoyal@in.ibm.com


The patch titled
     kdump/kexec: calculate note size at compile time (update)
has been added to the -mm tree.  Its filename is
     kdump-kexec-calculate-note-size-at-compile-time-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kdump/kexec: calculate note size at compile time (update)
From: Simon Horman <horms@verge.net.au>

Here is a further update to this patch which uses
sizeof(KEXEC_NOTE_NAME_BYTES) as suggested by Milton Miller.
It also adds a comment describing why space for two struct elf_note
is needed, as that question has come up a few times.

Cc: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash.c |    2 +-
 include/linux/kexec.h    |    8 +++++++-
 kernel/kexec.c           |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/crash.c~kdump-kexec-calculate-note-size-at-compile-time-update arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~kdump-kexec-calculate-note-size-at-compile-time-update
+++ a/arch/ia64/kernel/crash.c
@@ -74,7 +74,7 @@ crash_save_this_cpu(void)
 	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
 	if (!buf)
 		return;
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, prstatus,
+	buf = append_elf_note(buf, KEXEC_NOTE_NAME, NT_PRSTATUS, prstatus,
 			sizeof(*prstatus));
 	final_note(buf);
 }
diff -puN include/linux/kexec.h~kdump-kexec-calculate-note-size-at-compile-time-update include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-kexec-calculate-note-size-at-compile-time-update
+++ a/include/linux/kexec.h
@@ -33,9 +33,15 @@
 #error KEXEC_ARCH not defined
 #endif
 
+#define KEXEC_NOTE_NAME "CORE"
 #define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
-#define KEXEC_NOTE_NAME_BYTES 8 /* ALIGN(strlen("CORE") + 1, 4) */
+#define KEXEC_NOTE_NAME_BYTES ALIGN(sizeof("CORE"), 4) /* N.B: Includes '\0' */
 #define KEXEC_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
+/* The notes are read and combined by the code in vmcore.c running
+ * in the second-kernel after kdump is performed. This code
+ * expects the notes area to be a list of notes, terminated
+ * by a "NULL" note header. The "* 2" below is to provide space
+ * for the terminating note header */
 #define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) + \
 			   KEXEC_NOTE_NAME_BYTES + KEXEC_NOTE_DESC_BYTES )
 
diff -puN kernel/kexec.c~kdump-kexec-calculate-note-size-at-compile-time-update kernel/kexec.c
--- a/kernel/kexec.c~kdump-kexec-calculate-note-size-at-compile-time-update
+++ a/kernel/kexec.c
@@ -1118,7 +1118,7 @@ void crash_save_cpu(struct pt_regs *regs
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_regs(&prstatus.pr_reg, regs);
-	buf = append_elf_note(buf, "CORE", NT_PRSTATUS, &prstatus,
+	buf = append_elf_note(buf, KEXEC_NOTE_NAME, NT_PRSTATUS, &prstatus,
 				sizeof(prstatus));
 	final_note(buf);
 }
_

Patches currently in -mm which might be from horms@verge.net.au are

cpusets-add-mems-to-basic-usage-documentation.patch
git-ia64.patch
git-scsi-misc.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
kdump-kexec-calculate-note-size-at-compile-time-update.patch
