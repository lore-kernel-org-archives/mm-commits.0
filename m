From: akpm@linux-foundation.org
Subject: + uml-sysrq-and-mconsole-fixes.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:10:03 -0700
Message-ID: <200708240010.l7O0A3Om001543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933859AbXHXAKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: sysrq and mconsole fixes
has been added to the -mm tree.  Its filename is
     uml-sysrq-and-mconsole-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: sysrq and mconsole fixes
From: Jeff Dike <jdike@addtoit.com>

Fix the passing of printk output back to the mconsole client.  The existing
code was somewhat confused, accumulating output in a buffer, but writing it
out entirely whenever a new chunk was added.  This is fixed.

The earlier include cleanups caused linux/sysrq.h to not be included - this is
fixed by adding the include back, under CONFIG_MAGIC_SYSRQ.

CONFIG_MAGIC_SYSRQ is also defaulted to on in defconfig.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/defconfig               |    2 +-
 arch/um/drivers/mconsole_kern.c |   23 +++++++++--------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff -puN arch/um/defconfig~uml-sysrq-and-mconsole-fixes arch/um/defconfig
--- a/arch/um/defconfig~uml-sysrq-and-mconsole-fixes
+++ a/arch/um/defconfig
@@ -80,7 +80,7 @@ CONFIG_BINFMT_MISC=m
 # CONFIG_HOSTFS is not set
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
-# CONFIG_MAGIC_SYSRQ is not set
+CONFIG_MAGIC_SYSRQ=y
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
 CONFIG_KERNEL_STACK_ORDER=0
diff -puN arch/um/drivers/mconsole_kern.c~uml-sysrq-and-mconsole-fixes arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-sysrq-and-mconsole-fixes
+++ a/arch/um/drivers/mconsole_kern.c
@@ -632,10 +632,9 @@ struct mconsole_output {
 static DEFINE_SPINLOCK(client_lock);
 static LIST_HEAD(clients);
 static char console_buf[MCONSOLE_MAX_DATA];
-static int console_index = 0;
 
 static void console_write(struct console *console, const char *string,
-			  unsigned len)
+			  unsigned int len)
 {
 	struct list_head *ele;
 	int n;
@@ -643,24 +642,18 @@ static void console_write(struct console
 	if (list_empty(&clients))
 		return;
 
-	while (1) {
-		n = min((size_t) len, ARRAY_SIZE(console_buf) - console_index);
-		strncpy(&console_buf[console_index], string, n);
-		console_index += n;
+	while (len > 0) {
+		n = min((size_t) len, ARRAY_SIZE(console_buf));
+		strncpy(console_buf, string, n);
 		string += n;
 		len -= n;
-		if (len == 0)
-			return;
 
 		list_for_each(ele, &clients) {
 			struct mconsole_output *entry;
 
 			entry = list_entry(ele, struct mconsole_output, list);
-			mconsole_reply_len(entry->req, console_buf,
-					   console_index, 0, 1);
+			mconsole_reply_len(entry->req, console_buf, n, 0, 1);
 		}
-
-		console_index = 0;
 	}
 }
 
@@ -690,8 +683,7 @@ static void with_console(struct mc_reque
 
 	(*proc)(arg);
 
-	mconsole_reply_len(req, console_buf, console_index, 0, 0);
-	console_index = 0;
+	mconsole_reply_len(req, "", 0, 0, 0);
 
 	spin_lock_irqsave(&client_lock, flags);
 	list_del(&entry.list);
@@ -699,6 +691,9 @@ static void with_console(struct mc_reque
 }
 
 #ifdef CONFIG_MAGIC_SYSRQ
+
+#include <linux/sysrq.h>
+
 static void sysrq_proc(void *arg)
 {
 	char *op = arg;
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
uml-fix-previous-request-size-limit-fix.patch
uml-fix-linker-script-alignment-bugs.patch
uml-fix-x86_64-core-dump-crash.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-use-64-bits-for-block-size-on-x86_64.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
