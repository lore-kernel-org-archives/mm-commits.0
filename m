From: akpm@linux-foundation.org
Subject: [merged] mn10300-signal-stack-fix.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:17 -0800
Message-ID: <201001112019.o0BKJHwx025557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754340Ab0AKUeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:34:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: signal stack fix
has been removed from the -mm tree.  Its filename was
     mn10300-signal-stack-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: signal stack fix
From: Mark Salter <msalter@redhat.com>

This fixes a signal stack handling problem in the MN10300 arch.  When new
threads are cloned with CLONE_VM, they don't inherit the alternate signal
stack.  They do share the signal flags, though.  When deciding whether to
use an alternate stack, the arch code needs to check to make sure the task
struct contains a valid alternate stack.  This patch fixes the MN10300
arch by using the sas_ss_flags() test provided by sched.h rather than the
on_sig_stack() test which is insufficient by itself.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/kernel/signal.c~mn10300-signal-stack-fix arch/mn10300/kernel/signal.c
--- a/arch/mn10300/kernel/signal.c~mn10300-signal-stack-fix
+++ a/arch/mn10300/kernel/signal.c
@@ -264,7 +264,7 @@ static inline void __user *get_sigframe(
 
 	/* this is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (!on_sig_stack(sp))
+		if (sas_ss_flags(sp) == 0)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
_

Patches currently in -mm which might be from msalter@redhat.com are

origin.patch

