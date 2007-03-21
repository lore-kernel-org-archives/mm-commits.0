From: akpm@linux-foundation.org
Subject: - complain-about-missing-system-calls-update.patch removed from -mm tree
Date: Wed, 21 Mar 2007 15:54:38 -0700
Message-ID: <200703212254.l2LMsccD006139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57620 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXCUWz2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, ak@suse.de, anton@samba.org, dwmw2@infradead.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Complain about missing system calls (update)
has been removed from the -mm tree.  Its filename was
     complain-about-missing-system-calls-update.patch

This patch was dropped because it was folded into complain-about-missing-system-calls.patch

------------------------------------------------------
Subject: Complain about missing system calls (update)
From: David Miller <davem@davemloft.net>

David, thanks for this __incredibly__ __useful__ patch.  I kicked it
around on sparc64 and found some more ignores to add, see below.

The vast majority of them vector to sys_ni_syscall in the i386 syscall
table.

sys_ugetrlimit is only necessary if the platform started out
using the non-SuS compliant sys_old_getrlimit()

The rest, like ioperm, iopl, modify_ldt, et al. are i386
specific.

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/missing_syscalls.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN init/missing_syscalls.c~complain-about-missing-system-calls-update init/missing_syscalls.c
--- a/init/missing_syscalls.c~complain-about-missing-system-calls-update
+++ a/init/missing_syscalls.c
@@ -18,6 +18,22 @@
 #endif
 
 /* i386-specific or historical system calls */
+#define __IGNORE_break
+#define __IGNORE_stty
+#define __IGNORE_gtty
+#define __IGNORE_ftime
+#define __IGNORE_prof
+#define __IGNORE_lock
+#define __IGNORE_mpx
+#define __IGNORE_ulimit
+#define __IGNORE_profil
+#define __IGNORE_ioperm
+#define __IGNORE_iopl
+#define __IGNORE_idle
+#define __IGNORE_modify_ldt
+#define __IGNORE_getpmsg
+#define __IGNORE_putpmsg
+#define __IGNORE_ugetrlimit
 #define __IGNORE_mmap2
 #define __IGNORE_vm86
 #define __IGNORE_vm86old
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
resend-iphase-64bit-cleanup.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
simplify-the-stacktrace-code.patch
complain-about-missing-system-calls.patch
complain-about-missing-system-calls-update.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
