From: akpm@linux-foundation.org
Subject: [merged] uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:05 -0700
Message-ID: <200904061933.n36JX5BS010995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756819AbZDFTkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:40:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, brgerst@gmail.com, jdike@addtoit.com, mingo@elte.hu, mszeredi@suse.cz, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix link error from prefixing of i386 syscalls with ptregs_
has been removed from the -mm tree.  Its filename was
     uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix link error from prefixing of i386 syscalls with ptregs_
From: Miklos Szeredi <miklos@szeredi.hu>

Fix the following link error:

arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x11c): undefined reference to `ptregs_fork'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x140): undefined reference to `ptregs_execve'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x2cc): undefined reference to `ptregs_iopl'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x2d8): undefined reference to `ptregs_vm86old'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x2f0): undefined reference to `ptregs_sigreturn'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x2f4): undefined reference to `ptregs_clone'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x3ac): undefined reference to `ptregs_vm86'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x3c8): undefined reference to `ptregs_rt_sigreturn'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x3fc): undefined reference to `ptregs_sigaltstack'
arch/um/sys-i386/built-in.o: In function `sys_call_table':
(.rodata+0x40c): undefined reference to `ptregs_vfork'

This was introduced by commit 253f29a4, "x86: pass in pt_regs pointer
for syscalls that need it"

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Dike <jdike@addtoit.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/sys_call_table.S |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN arch/um/sys-i386/sys_call_table.S~uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_ arch/um/sys-i386/sys_call_table.S
--- a/arch/um/sys-i386/sys_call_table.S~uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_
+++ a/arch/um/sys-i386/sys_call_table.S
@@ -9,6 +9,17 @@
 
 #define old_mmap old_mmap_i386
 
+#define ptregs_fork sys_fork
+#define ptregs_execve sys_execve
+#define ptregs_iopl sys_iopl
+#define ptregs_vm86old sys_vm86old
+#define ptregs_sigreturn sys_sigreturn
+#define ptregs_clone sys_clone
+#define ptregs_vm86 sys_vm86
+#define ptregs_rt_sigreturn sys_rt_sigreturn
+#define ptregs_sigaltstack sys_sigaltstack
+#define ptregs_vfork sys_vfork
+
 .section .rodata,"a"
 
 #include "../../x86/kernel/syscall_table_32.S"
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch
notify_change-callers-must-hold-i_mutex.patch

