From: akpm@linux-foundation.org
Subject: - ia32-emu-remove-dead-code.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:52 -0800
Message-ID: <200711192316.lAJNGqM1001806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbXKSX1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:27:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ia32-emu: remove dead code
has been removed from the -mm tree.  Its filename was
     ia32-emu-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-x86.patch
