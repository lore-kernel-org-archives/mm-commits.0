From: akpm@linux-foundation.org
Subject: - uml-fix-a-compile-error.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:36 -0700
Message-ID: <200810202034.m9KKYasp010892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbYJTUqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangcong@zeuux.org, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix a compile error
has been removed from the -mm tree.  Its filename was
     uml-fix-a-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix a compile error
From: WANG Cong <wangcong@zeuux.org>

Fix

arch/um/sys-i386/signal.c: In function 'copy_sc_from_user':
arch/um/sys-i386/signal.c:182: warning: dereferencing 'void *' pointer
arch/um/sys-i386/signal.c:182: error: request for member '_fxsr_env' in something not a structure or union

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/sys-i386/signal.c~uml-fix-a-compile-error arch/um/sys-i386/signal.c
--- a/arch/um/sys-i386/signal.c~uml-fix-a-compile-error
+++ a/arch/um/sys-i386/signal.c
@@ -179,7 +179,8 @@ static int copy_sc_from_user(struct pt_r
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
-		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
+		err = copy_from_user(&fpx,
+			&((struct _fpstate __user *)sc.fpstate)->_fxsr_env[0],
 				     sizeof(struct user_fxsr_struct));
 		if (err)
 			return 1;
_

Patches currently in -mm which might be from wangcong@zeuux.org are

origin.patch

