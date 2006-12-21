From: akpm@osdl.org
Subject: + powerpc-use-is_init.patch added to -mm tree
Date: Wed, 20 Dec 2006 19:41:34 -0800
Message-ID: <200612210341.kBL3fYNp014750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422675AbWLUDln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, anton@samba.org, paulus@samba.org


The patch titled
     powerpc: use is_init()
has been added to the -mm tree.  Its filename is
     powerpc-use-is_init.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
audit-fix-kstrdup-error-check.patch
gss_spkm3-fix-error-handling-in-module-init.patch
git-acpi.patch
git-alsa.patch
powerpc-use-is_init.patch
git-drm.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

