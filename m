From: akpm@linux-foundation.org
Subject: + x86-correctly-wire-up-the-newuname-system-call.patch added to -mm tree
Date: Mon, 19 Apr 2010 20:55:27 -0400
Message-ID: <201004200357.o3K3v3PH026679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116Ab0DTD53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 23:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, adi@hexapodia.org, hpa@zytor.com, maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de


The patch titled
     x86: correctly wire up the newuname system call
has been added to the -mm tree.  Its filename is
     x86-correctly-wire-up-the-newuname-system-call.patch

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
x86-correctly-wire-up-the-newuname-system-call.patch

