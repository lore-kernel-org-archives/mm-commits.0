From: akpm@linux-foundation.org
Subject: + make-unregister_binfmt-return-void.patch added to -mm tree
Date: Mon, 16 Jul 2007 15:13:35 -0700
Message-ID: <200707162213.l6GMDZ4H007215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763925AbXGPWOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 18:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     Make unregister_binfmt() return void
has been added to the -mm tree.  Its filename is
     make-unregister_binfmt-return-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -275,7 +275,7 @@ static int __init check_elf32_binfmt(voi
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
@@ -66,7 +66,7 @@ struct linux_binfmt {
 };
 
 extern int register_binfmt(struct linux_binfmt *);
-extern int unregister_binfmt(struct linux_binfmt *);
+extern void unregister_binfmt(struct linux_binfmt *);
 
 extern int prepare_binprm(struct linux_binprm *);
 extern void remove_arg_zero(struct linux_binprm *);
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-sparse-false-positives-re-bug_onptr.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
