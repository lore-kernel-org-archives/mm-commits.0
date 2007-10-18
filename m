From: akpm@linux-foundation.org
Subject: - make-unregister_binfmt-return-void.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:31 -0700
Message-ID: <200710180652.l9I6qVNd030291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761104AbXJRHiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     Make unregister_binfmt() return void
has been removed from the -mm tree.  Its filename was
     make-unregister_binfmt-return-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make unregister_binfmt() return void
From: Alexey Dobriyan <adobriyan@sw.ru>

list_del() hardly can fail, so checking for return value is pointless
(and current code always return 0).

Nobody really cared that return value anyway.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/binfmt_elf32.c |    2 +-
 fs/exec.c                     |    3 +--
 include/linux/binfmts.h       |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/ia64/ia32/binfmt_elf32.c~make-unregister_binfmt-return-void arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~make-unregister_binfmt-return-void
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -240,7 +240,7 @@ static int __init check_elf32_binfmt(voi
 {
 	if (cpu_uses_ia32el()) {
 		printk("Please use IA-32 EL for executing IA-32 binaries\n");
-		return unregister_binfmt(&elf_format);
+		unregister_binfmt(&elf_format);
 	}
 	return 0;
 }
diff -puN fs/exec.c~make-unregister_binfmt-return-void fs/exec.c
--- a/fs/exec.c~make-unregister_binfmt-return-void
+++ a/fs/exec.c
@@ -81,12 +81,11 @@ int register_binfmt(struct linux_binfmt 
 
 EXPORT_SYMBOL(register_binfmt);
 
-int unregister_binfmt(struct linux_binfmt * fmt)
+void unregister_binfmt(struct linux_binfmt * fmt)
 {
 	write_lock(&binfmt_lock);
 	list_del(&fmt->lh);
 	write_unlock(&binfmt_lock);
-	return 0;
 }
 
 EXPORT_SYMBOL(unregister_binfmt);
diff -puN include/linux/binfmts.h~make-unregister_binfmt-return-void include/linux/binfmts.h
--- a/include/linux/binfmts.h~make-unregister_binfmt-return-void
+++ a/include/linux/binfmts.h
@@ -73,7 +73,7 @@ struct linux_binfmt {
 };
 
 extern int register_binfmt(struct linux_binfmt *);
-extern int unregister_binfmt(struct linux_binfmt *);
+extern void unregister_binfmt(struct linux_binfmt *);
 
 extern int prepare_binprm(struct linux_binprm *);
 extern int __must_check remove_arg_zero(struct linux_binprm *);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
add-kernel-notifierc-fix-2-fix-3.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
single_open-seq_release-leak-diagnostics.patch
