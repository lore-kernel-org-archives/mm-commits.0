From: akpm@linux-foundation.org
Subject: + kexec-sysrq-simplify-sysrq-c-handler.patch added to -mm tree
Date: Tue, 05 May 2009 15:30:08 -0700
Message-ID: <200905052230.n45MU9tB024815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbZEEWdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 18:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, brayan@yack.com.br, ebiederm@xmission.com, vgoyal@redhat.com


The patch titled
     kexec: sysrq: simplify sysrq-c handler
has been added to the -mm tree.  Its filename is
     kexec-sysrq-simplify-sysrq-c-handler.patch

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
Subject: kexec: sysrq: simplify sysrq-c handler
From: Neil Horman <nhorman@tuxdriver.com>

Currently the sysrq-c handler is bit over-engineered.  Its behavior is
dependent on a few compile time and run time factors that alter its
behavior which is really unnecessecary.

If CONFIG_KEXEC is not configured, sysrq-c, crashes the system with a NULL
pointer dereference.  If CONFIG_KEXEC is configured, it calls crash_kexec
directly, which implies that the kexec kernel will either be booted (if
its been previously loaded), or it will simply do nothing (the no kexec
kernel has been loaded).

It would be much easier to just simplify the whole thing to dereference a
NULL pointer all the time regardless of configuration.  That way, it will
always try to crash the system, and if a kexec kernel has been loaded into
reserved space, it will still boot from the page fault trap handler
(assuming panic_on_oops is set appropriately).

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Brayan Arraes <brayan@yack.com.br>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN drivers/char/sysrq.c~kexec-sysrq-simplify-sysrq-c-handler drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~kexec-sysrq-simplify-sysrq-c-handler
+++ a/drivers/char/sysrq.c
@@ -120,20 +120,17 @@ static struct sysrq_key_op sysrq_unraw_o
 #define sysrq_unraw_op (*(struct sysrq_key_op *)0)
 #endif /* CONFIG_VT */
 
-#ifdef CONFIG_KEXEC
-static void sysrq_handle_crashdump(int key, struct tty_struct *tty)
+static void sysrq_handle_crash(int key, struct tty_struct *tty)
 {
-	crash_kexec(get_irq_regs());
+	void *killer = NULL;
+	*killer = 1;
 }
 static struct sysrq_key_op sysrq_crashdump_op = {
-	.handler	= sysrq_handle_crashdump,
-	.help_msg	= "Crashdump",
-	.action_msg	= "Trigger a crashdump",
+	.handler	= sysrq_handle_crash,
+	.help_msg	= "Crash",
+	.action_msg	= "Trigger a crash",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
-#else
-#define sysrq_crashdump_op (*(struct sysrq_key_op *)0)
-#endif
 
 static void sysrq_handle_reboot(int key, struct tty_struct *tty)
 {
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
kexec-sysrq-simplify-sysrq-c-handler.patch

