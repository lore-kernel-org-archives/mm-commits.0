From: akpm@linux-foundation.org
Subject: + uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_.patch added to -mm tree
Date: Wed, 01 Apr 2009 15:34:23 -0700
Message-ID: <200904012234.n31MYOQF011631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbZDAWkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 18:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miklos@szeredi.hu, brgerst@gmail.com, jdike@addtoit.com, mingo@elte.hu, mszeredi@suse.cz, tj@kernel.org, xiyou.wangcong@gmail.com


The patch titled
     uml: fix link error from prefixing of i386 syscalls with ptregs_
has been added to the -mm tree.  Its filename is
     uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_.patch

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
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held-fix.patch
uml-fix-link-error-from-prefixing-of-i386-syscalls-with-ptregs_.patch
notify_change-callers-must-hold-i_mutex.patch

