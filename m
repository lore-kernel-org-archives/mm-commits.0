From: akpm@osdl.org
Subject: - powerpc-use-is_init.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:59 -0800
Message-ID: <200701260751.l0Q7pxCj010786@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50515 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030820AbXAZHwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:52:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, anton@samba.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: use is_init()
has been removed from the -mm tree.  Its filename was
     powerpc-use-is_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: use is_init()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use is_init() rather than hard coded pid comparison.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/powerpc/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/traps.c~powerpc-use-is_init arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~powerpc-use-is_init
+++ a/arch/powerpc/kernel/traps.c
@@ -174,7 +174,7 @@ void _exception(int signr, struct pt_reg
 	 * generate the same exception over and over again and we get
 	 * nowhere.  Better to kill it and let the kernel panic.
 	 */
-	if (current->pid == 1) {
+	if (is_init(current)) {
 		__sighandler_t handler;
 
 		spin_lock_irq(&current->sighand->siglock);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-powerpc.patch
ehca-fix-do_mmap-error-check.patch
ehca-avoid-crash-on-kthread_create-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-input.patch
git-netdev-all.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-s390.patch
git-watchdog.patch
simplify-the-stacktrace-code.patch
