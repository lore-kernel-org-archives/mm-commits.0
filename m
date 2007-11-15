From: akpm@linux-foundation.org
Subject: - oprofile-fix-oops-on-x86-32-bit.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:11:21 -0800
Message-ID: <200711152111.lAFLBLxP015756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321AbXKOVS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, ak@suse.de, mingo@elte.hu, phil.el@wanadoo.fr, robfitz@273k.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     oprofile: fix oops on x86 32-bit
has been removed from the -mm tree.  Its filename was
     oprofile-fix-oops-on-x86-32-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oprofile: fix oops on x86 32-bit
From: Jan Blunck <jblunck@suse.de>

x86 32-bit isn't saving the stack pointer to pt_regs->esp when an
interrupt occurs.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Tested-by: Robert Fitzsimons <robfitz@273k.net>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86/ptrace.h~oprofile-fix-oops-on-x86-32-bit include/asm-x86/ptrace.h
--- a/include/asm-x86/ptrace.h~oprofile-fix-oops-on-x86-32-bit
+++ a/include/asm-x86/ptrace.h
@@ -60,7 +60,7 @@ static inline int v8086_mode(struct pt_r
 
 #define instruction_pointer(regs) ((regs)->eip)
 #define frame_pointer(regs) ((regs)->ebp)
-#define stack_pointer(regs) ((regs)->esp)
+#define stack_pointer(regs) ((unsigned long)(regs))
 #define regs_return_value(regs) ((regs)->eax)
 
 extern unsigned long profile_pc(struct pt_regs *regs);
_

Patches currently in -mm which might be from jblunck@suse.de are

origin.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
one-less-parameter-to-__d_path.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
