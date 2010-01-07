From: akpm@linux-foundation.org
Subject: + mn10300-signal-stack-fix.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:28:19 -0800
Message-ID: <201001070028.o070SK57027639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989Ab0AGA2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msalter@redhat.com, dhowells@redhat.com


The patch titled
     mn10300: signal stack fix
has been added to the -mm tree.  Its filename is
     mn10300-signal-stack-fix.patch

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

mn10300-signal-stack-fix.patch
mn10300-objcopy-flags-fix.patch
mn10300-add-cc-clobbers-to-asm-statements.patch

