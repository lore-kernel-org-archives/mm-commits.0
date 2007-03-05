From: akpm@linux-foundation.org
Subject: - fully-honor-vdso_enabled.patch removed from -mm tree
Date: Mon, 05 Mar 2007 02:19:25 -0800
Message-ID: <200703051019.l25AJPva015850@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40101 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbXCEKV2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 05:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jreiser@BitWagon.com, ak@suse.de, arjan@infradead.org, lethal@linux-sh.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fully honor vdso_enabled [i386, sh; x86_64?]
has been removed from the -mm tree.  Its filename was
     fully-honor-vdso_enabled.patch

This patch was dropped because I am hopelessly confused - please resend

------------------------------------------------------
Subject: fully honor vdso_enabled [i386, sh; x86_64?]
From: John Reiser <jreiser@BitWagon.com>

Architectures such as i386, sh, x86_64 have a flag
/proc/sys/vm/vdso_enabled to choose whether the kernel should setup a
process to use vdso after execve().  Informing the user code via
AT_SYSINFO* is controlled by macro ARCH_DLINFO in fs/binfmt_elf.c and
include/asm-$ARCH/elf.h, but the vdso page is established always via
arch_setup_additonal_pages() called from load_elf_binary().  If
vdso_enabled is off, then current code wastes kernel time during execve()
and fragments the address space unnecessarily.

This patch changes arch_setup_additonal_pages() to honor vdso_enabled.  For
i386 it also allows the option of a fixed addresss to avoid fragmenting the
address space.  Compiles and runs on i386.  x86_64 [IA32 support] and sh
maintainers also please comment.

For some related history, including interaction with exec-shield, see:
http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229304
and also 207020 and 162797.

Signed-off-by: John Reiser <jreiser@BitWagon.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c        |   19 ++++++++++++++++++-
 arch/sh/kernel/vsyscall/vsyscall.c |    3 +++
 include/asm-i386/a.out.h           |    2 +-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~fully-honor-vdso_enabled arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~fully-honor-vdso_enabled
+++ a/arch/i386/kernel/sysenter.c
@@ -22,6 +22,8 @@
 #include <asm/msr.h>
 #include <asm/pgtable.h>
 #include <asm/unistd.h>
+#include <asm/a.out.h>
+#include <asm/mman.h>
 
 /*
  * Should the kernel map a VDSO page into processes and pass its
@@ -105,10 +107,25 @@ int arch_setup_additional_pages(struct l
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
+	unsigned long flags;
 	int ret;
 
+	switch (vdso_enabled) {
+	case 0:  /* none */
+		return 0;
+	default:
+	case 1:  /* vdso in random available page */
+		addr = 0ul;
+		flags = 0ul;
+		break;
+	case 2:  /* out of user's way */
+		addr = STACK_TOP;
+		flags = MAP_FIXED;
+		break;
+	}
+
 	down_write(&mm->mmap_sem);
-	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+	addr = get_unmapped_area(NULL, addr, PAGE_SIZE, 0, flags);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
diff -puN arch/sh/kernel/vsyscall/vsyscall.c~fully-honor-vdso_enabled arch/sh/kernel/vsyscall/vsyscall.c
--- a/arch/sh/kernel/vsyscall/vsyscall.c~fully-honor-vdso_enabled
+++ a/arch/sh/kernel/vsyscall/vsyscall.c
@@ -64,6 +64,9 @@ int arch_setup_additional_pages(struct l
 	unsigned long addr;
 	int ret;
 
+	if (!vdso_enabled)
+		return 0;
+
 	down_write(&mm->mmap_sem);
 	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
diff -puN include/asm-i386/a.out.h~fully-honor-vdso_enabled include/asm-i386/a.out.h
--- a/include/asm-i386/a.out.h~fully-honor-vdso_enabled
+++ a/include/asm-i386/a.out.h
@@ -19,7 +19,7 @@ struct exec
 
 #ifdef __KERNEL__
 
-#define STACK_TOP	TASK_SIZE
+#define STACK_TOP	(TASK_SIZE - PAGE_SIZE)  /* 1 page optional for vdso */
 
 #endif
 
_

Patches currently in -mm which might be from jreiser@BitWagon.com are

fully-honor-vdso_enabled.patch
