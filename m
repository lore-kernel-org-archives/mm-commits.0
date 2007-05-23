From: akpm@linux-foundation.org
Subject: - x86_64-support-poll-on-dev-mcelog-fix.patch removed from -mm tree
Date: Wed, 23 May 2007 14:47:03 -0700
Message-ID: <200705232147.l4NLl3eF001639@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755108AbXEWVrY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 17:47:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wli@holomorphy.com, ak@suse.de, bill.irwin@oracle.com, thockin@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-support-poll-on-dev-mcelog fix
has been removed from the -mm tree.  Its filename was
     x86_64-support-poll-on-dev-mcelog-fix.patch

This patch was dropped because it was folded into x86_64-support-poll-on-dev-mcelog.patch

------------------------------------------------------
Subject: x86_64-support-poll-on-dev-mcelog fix
From: William Lee Irwin III <wli@holomorphy.com>

The build fails with the following error when CONFIG_X86_MCE is not set:
arch/x86_64/kernel/built-in.o: In function `do_notify_resume':
/mnt/g/mm-2.6.22-rc2/arch/x86_64/kernel/signal.c:478: undefined reference to `mce_notify_user'
The following patch #ifdef's the offending call as a minimal fix.

Signed-off-by: William Irwin <bill.irwin@oracle.com>
Cc: Tim Hockin <thockin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86_64/kernel/signal.c~x86_64-support-poll-on-dev-mcelog-fix arch/x86_64/kernel/signal.c
--- a/arch/x86_64/kernel/signal.c~x86_64-support-poll-on-dev-mcelog-fix
+++ a/arch/x86_64/kernel/signal.c
@@ -473,9 +473,11 @@ do_notify_resume(struct pt_regs *regs, v
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+#ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
 		mce_notify_user();
+#endif /* CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
_

Patches currently in -mm which might be from wli@holomorphy.com are

i386-bigsmp-section-mismatch-fixes.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
quicklist-support-for-x86_64.patch
x86_64-support-poll-on-dev-mcelog.patch
x86_64-support-poll-on-dev-mcelog-fix.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
