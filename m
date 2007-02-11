From: akpm@linux-foundation.org
Subject: - uml-kill-a-compilation-warning.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:48:41 -0800
Message-ID: <200702112248.l1BMmfmk015654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668AbXBKWsn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:48:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, mm-commits@vger.kernel.org


The patch titled
     uml: Kill a compilation warning
has been removed from the -mm tree.  Its filename was
     uml-kill-a-compilation-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: Kill a compilation warning
From: Jeff Dike <jdike@addtoit.com>

Kill a compilation warning.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/kernel/exec.c~uml-kill-a-compilation-warning arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-kill-a-compilation-warning
+++ a/arch/um/kernel/exec.c
@@ -39,9 +39,9 @@ static long execve1(char *file, char __u
 		    char __user *__user *env)
 {
         long error;
+#ifdef CONFIG_TTY_LOG
 	struct tty_struct *tty;
 
-#ifdef CONFIG_TTY_LOG
 	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
 	if (tty)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-prototypes.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-um.patch
