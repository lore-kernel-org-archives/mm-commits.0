From: akpm@linux-foundation.org
Subject: + ia32-emu-remove-dead-code.patch added to -mm tree
Date: Mon, 12 Nov 2007 18:15:12 -0800
Message-ID: <200711130215.lAD2FCCW021508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbXKMCPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 21:15:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     ia32-emu: remove dead code
has been added to the -mm tree.  Its filename is
     ia32-emu-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia32-emu: remove dead code
From: Cyrill Gorcunov <gorcunov@gmail.com>

Remove useless second time checking of fsave argument in save_i387_ia32()
routine.  It's possible the compiler is doing the same but that is much
better to remove the dead code explicitly.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/fpu32.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/x86/ia32/fpu32.c~ia32-emu-remove-dead-code arch/x86/ia32/fpu32.c
--- a/arch/x86/ia32/fpu32.c~ia32-emu-remove-dead-code
+++ a/arch/x86/ia32/fpu32.c
@@ -174,8 +174,6 @@ int save_i387_ia32(struct task_struct *t
 	if (fsave)
 		return 0;
 	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
-	if (fsave)
-		return err ? -1 : 1;
 	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
 	err |= __copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
 			      sizeof(struct i387_fxsave_struct));
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-cifs.patch
ia32-emu-remove-dead-code.patch
