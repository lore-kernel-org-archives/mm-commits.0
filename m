From: akpm@linux-foundation.org
Subject: + break-elf_platform-and-stack-pointer-randomization-dependency.patch added to -mm tree
Date: Fri, 28 Sep 2007 10:49:31 -0700
Message-ID: <200709281749.l8SHnVQY010047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbXI1RuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 13:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fbuihuu@gmail.com, arjan@infradead.org, mingo@elte.hu, ralf@linux-mips.org


The patch titled
     Break ELF_PLATFORM and stack pointer randomization dependency
has been added to the -mm tree.  Its filename is
     break-elf_platform-and-stack-pointer-randomization-dependency.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Break ELF_PLATFORM and stack pointer randomization dependency
From: Franck Bui-Huu <fbuihuu@gmail.com>

Currently arch_align_stack() is used by fs/binfmt_elf.c to randomize
stack pointer inside a page. But this happens only if ELF_PLATFORM
symbol is defined.

ELF_PLATFORM is normally set if the architecture wants ld.so to load
implementation specific libraries for optimization. And currently a
lot of architectures just yield this symbol to NULL.

This is the case for MIPS architecture where ELF_PLATFORM is NULL but
arch_align_stack() has been redefined to do stack inside page
randomization. So in this case no randomization is actually done.

This patch breaks this dependency which seems to be useless and allows
platforms such MIPS to do the randomization.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/binfmt_elf.c~break-elf_platform-and-stack-pointer-randomization-dependency fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~break-elf_platform-and-stack-pointer-randomization-dependency
+++ a/fs/binfmt_elf.c
@@ -151,6 +151,14 @@ create_elf_tables(struct linux_binprm *b
 	struct vm_area_struct *vma;
 
 	/*
+	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
+	 * evictions by the processes running on the same package. One
+	 * thing we can do is to shuffle the initial stack for them.
+	 */
+
+	p = arch_align_stack(p);
+
+	/*
 	 * If this architecture has a platform capability string, copy it
 	 * to userspace.  In some cases (Sparc), this info is impossible
 	 * for userspace to get any other way, in others (i386) it is
@@ -160,14 +168,6 @@ create_elf_tables(struct linux_binprm *b
 	if (k_platform) {
 		size_t len = strlen(k_platform) + 1;
 
-		/*
-		 * In some cases (e.g. Hyper-Threading), we want to avoid L1
-		 * evictions by the processes running on the same package. One
-		 * thing we can do is to shuffle the initial stack for them.
-		 */
-
-		p = arch_align_stack(p);
-
 		u_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
 		if (__copy_to_user(u_platform, k_platform, len))
 			return -EFAULT;
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

git-mips.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
