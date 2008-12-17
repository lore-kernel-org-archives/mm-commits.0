From: akpm@linux-foundation.org
Subject: + remove-linux-hardirqh-from-asm-generic-localh-fix.patch added to -mm tree
Date: Tue, 16 Dec 2008 18:36:48 -0800
Message-ID: <200812170236.mBH2amZN028471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbYLQCg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 21:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, rmk+kernel@arm.linux.org.uk, rmk+lkml@arm.linux.org.uk, rostedt@goodmis.org


The patch titled
     remove-linux-hardirqh-from-asm-generic-localh-fix
has been added to the -mm tree.  Its filename is
     remove-linux-hardirqh-from-asm-generic-localh-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove-linux-hardirqh-from-asm-generic-localh-fix
From: Alexey Dobriyan <adobriyan@gmail.com>

On Sun, Dec 14, 2008 at 09:58:03AM -0800, Andrew Morton wrote:
> On Sun, 14 Dec 2008 13:39:41 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> > Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
> > asm/local.h, so this patch can be viewed as bringing the generic version
> > into line with the x86 version.
>
> Sure.  Includes are easy to add and hard to remove.  I'll queue it up
> and see if there's fallout.

Here is some (but not everything):

arch/avr32/kernel/traps.c:63: error: implicit declaration of function 'in_interrupt'
arch/avr32/kernel/traps.c:113: error: implicit declaration of function 'nmi_enter'
arch/avr32/kernel/traps.c:124: error: implicit declaration of function 'nmi_disable'
arch/avr32/kernel/traps.c:127: error: implicit declaration of function 'nmi_exit'
arch/sh/kernel/traps_32.c:104: error: implicit declaration of function 'in_interrupt'
arch/sparc64/kernel/sysfs.c:201: error: 'cpuinfo_sparc' undeclared (first use in this function)
arch/sparc64/kernel/mdesc.c:576: error: expected ')' before '*' token

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/traps.c |    1 +
 arch/sh/kernel/traps_32.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/avr32/kernel/traps.c~remove-linux-hardirqh-from-asm-generic-localh-fix arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~remove-linux-hardirqh-from-asm-generic-localh-fix
+++ a/arch/avr32/kernel/traps.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bug.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
 #include <linux/kdebug.h>
diff -puN arch/sh/kernel/traps_32.c~remove-linux-hardirqh-from-asm-generic-localh-fix arch/sh/kernel/traps_32.c
--- a/arch/sh/kernel/traps_32.c~remove-linux-hardirqh-from-asm-generic-localh-fix
+++ a/arch/sh/kernel/traps_32.c
@@ -13,6 +13,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
kconfig-add-module_name-shortcut.patch
proc-move-inode-comment-text-file-to-source-file.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
remove-remaining-unwinder-code.patch
remove-linux-hardirqh-from-asm-generic-localh-fix.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
sm501-fix-section-mismatches.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

