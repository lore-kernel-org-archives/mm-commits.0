From: akpm@linux-foundation.org
Subject: - tracehook-unexport-ptrace_notify.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:37 -0700
Message-ID: <200807262116.m6QLGbZF019846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722AbYGZVRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: unexport ptrace_notify
has been removed from the -mm tree.  Its filename was
     tracehook-unexport-ptrace_notify.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: unexport ptrace_notify
From: Roland McGrath <roland@redhat.com>

The ptrace_notify() function should not be called by any modules.  It was
only ever exported to be called by binfmt exec functions.  But that is no
longer necessary since fs/exec.c deals with that generically now.  There
should be no calls to ptrace_notify() from outside the core kernel.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/signal.c~tracehook-unexport-ptrace_notify kernel/signal.c
--- a/kernel/signal.c~tracehook-unexport-ptrace_notify
+++ a/kernel/signal.c
@@ -1895,7 +1895,6 @@ EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
-EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
 EXPORT_SYMBOL(send_sig_info);
 EXPORT_SYMBOL(sigprocmask);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

