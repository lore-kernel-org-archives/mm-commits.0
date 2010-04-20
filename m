From: akpm@linux-foundation.org
Subject: [merged] x86-correctly-wire-up-the-newuname-system-call.patch removed from -mm tree
Date: Tue, 20 Apr 2010 10:58:47 -0400
Message-ID: <201004201800.o3KI0Ntg002068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab0DTSFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Apr 2010 14:05:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, adi@hexapodia.org, hpa@zytor.com, maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: correctly wire up the newuname system call
has been removed from the -mm tree.  Its filename was
     x86-correctly-wire-up-the-newuname-system-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: correctly wire up the newuname system call
From: Christoph Hellwig <hch@lst.de>

Before commit e28cbf22933d0c0ccaf3c4c27a1a263b41f73859 ("improve
sys_newuname() for compat architectures") 64-bit x86 had a private
implementation of sys_uname which was just called sys_uname, which other
architectures used for the old uname.  Due to some merge issues with the
uname refactoring patches we ended up calling the old uname version for
both the old and new system call slots, which lead to the domainname filed
never be set which caused failures with libnss_nis.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15812

Reported-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/ia32/ia32entry.S~x86-correctly-wire-up-the-newuname-system-call arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S~x86-correctly-wire-up-the-newuname-system-call
+++ a/arch/x86/ia32/ia32entry.S
@@ -626,7 +626,7 @@ ia32_sys_call_table:
 	.quad stub32_sigreturn
 	.quad stub32_clone		/* 120 */
 	.quad sys_setdomainname
-	.quad sys_uname
+	.quad sys_newuname
 	.quad sys_modify_ldt
 	.quad compat_sys_adjtimex
 	.quad sys32_mprotect		/* 125 */
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
kernel-sysc-fix-compat-uname-machine.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch
vfs-introduce-noop_llseek.patch

