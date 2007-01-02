From: akpm@osdl.org
Subject: + uml-kill-a-compilation-warning.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:56:42 -0800
Message-ID: <200701022256.l02MuhJ7032738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41372 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965037AbXABW45 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:56:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: Kill a compilation warning
has been added to the -mm tree.  Its filename is
     uml-kill-a-compilation-warning.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: Kill a compilation warning
From: Jeff Dike <jdike@addtoit.com>

Kill a compilation warning.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/kernel/exec.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
