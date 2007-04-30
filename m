From: akpm@linux-foundation.org
Subject: - kdump-kexec-calculate-note-size-at-compile-time-update.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:02:40 -0700
Message-ID: <200704302002.l3UK2eSk013667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423550AbXD3UDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kdump/kexec: calculate note size at compile time (update)
has been removed from the -mm tree.  Its filename was
     kdump-kexec-calculate-note-size-at-compile-time-update.patch

This patch was dropped because it was folded into kdump-kexec-calculate-note-size-at-compile-time.patch

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

origin.patch
git-ia64.patch
git-scsi-misc.patch
kdump-kexec-calculate-note-size-at-compile-time.patch
kdump-kexec-calculate-note-size-at-compile-time-update.patch
kdump-kexec-calculate-note-size-at-compile-time-update-2.patch
use-menuconfig-objects-ipvs.patch
