From: akpm@linux-foundation.org
Subject: + uml-make-mconsole_stack-namespace-aware.patch added to -mm tree
Date: Fri, 01 Feb 2008 11:26:11 -0800
Message-ID: <200802011926.m11JQB4g027483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbYBAT0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 14:26:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, xemul@openvz.org


The patch titled
     uml: make mconsole_stack namespace-aware
has been added to the -mm tree.  Its filename is
     uml-make-mconsole_stack-namespace-aware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: make mconsole_stack namespace-aware
From: Jeff Dike <jdike@addtoit.com>

Also fixed the include syntax while I was there.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |   35 +++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-make-mconsole_stack-namespace-aware arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-make-mconsole_stack-namespace-aware
+++ a/arch/um/drivers/mconsole_kern.c
@@ -1,24 +1,25 @@
 /*
  * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
- * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2001 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
-#include "linux/console.h"
-#include "linux/ctype.h"
-#include "linux/interrupt.h"
-#include "linux/list.h"
-#include "linux/mm.h"
-#include "linux/module.h"
-#include "linux/notifier.h"
-#include "linux/reboot.h"
-#include "linux/proc_fs.h"
-#include "linux/slab.h"
-#include "linux/syscalls.h"
-#include "linux/utsname.h"
-#include "linux/workqueue.h"
-#include "linux/mutex.h"
-#include "asm/uaccess.h"
+#include <linux/console.h>
+#include <linux/ctype.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/proc_fs.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/utsname.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <asm/uaccess.h>
+
 #include "init.h"
 #include "irq_kern.h"
 #include "irq_user.h"
@@ -765,7 +766,7 @@ void mconsole_stack(struct mc_request *r
 		return;
 	}
 
-	to = find_task_by_pid(pid_requested);
+	to = find_task_by_pid_ns(pid_requested, &init_pid_ns);
 	if ((to == NULL) || (pid_requested == 0)) {
 		mconsole_reply(req, "Couldn't find that pid", 1, 0);
 		return;
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
git-x86.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
uml-smp-locking-commentary.patch
uml-implement-o_append.patch
uml-remove-fakehd.patch
uml-debug_shirq-fixes.patch
uml-add-back-config_hz.patch
uml-style-fixes-in-arch-um-sys-x86_64.patch
uml-add-newlines-to-printks.patch
uml-move-register-initialization.patch
uml-remove-unused-fields-from-mm_context.patch
uml-remove-map_cb.patch
uml-use-of-a-public-mac-is-a-warning-not-an-error.patch
uml-defconfig-tweaks.patch
uml-redo-the-calculation-of-nr_syscalls.patch
uml-make-mconsole_stack-namespace-aware.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
