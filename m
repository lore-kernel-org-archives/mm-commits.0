From: akpm@linux-foundation.org
Subject: + sysrq-kdump-make-sysrq-c-consistent.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:15:06 -0700
Message-ID: <200907242215.n6OMF6nS032542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbZGXWQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, brayan@yack.com.br, ebiederm@xmission.com, laijs@cn.fujitsu.com, nhorman@tuxdriver.com, oomichi@mxs.nes.nec.co.jp, vgoyal@redhat.com


The patch titled
     sysrq, kdump: make sysrq-c consistent
has been added to the -mm tree.  Its filename is
     sysrq-kdump-make-sysrq-c-consistent.patch

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
Subject: sysrq, kdump: make sysrq-c consistent
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

commit d6580a9f15238b87e618310c862231ae3f352d2d ("kexec: sysrq: simplify
sysrq-c handler") changed the behavior of sysrq-c to unconditional
dereference of NULL pointer.  So in cases with CONFIG_KEXEC, where
crash_kexec() was directly called from sysrq-c before, now it can be said
that a step of "real oops" was inserted before starting kdump.

However, in contrast to oops via SysRq-c from keyboard which results in
panic due to in_interrupt(), oops via "echo c > /proc/sysrq-trigger" will
not become panic unless panic_on_oops=1.  It means that even if dump is
properly configured to be taken on panic, the sysrq-c from proc interface
might not start crashdump while the sysrq-c from keyboard can start
crashdump.  This confuses traditional users of kdump, i.e.  people who
expect sysrq-c to do common behavior in both of the keyboard and proc
interface.

This patch brings the keyboard and proc interface behavior of sysrq-c in
line, by forcing panic_on_oops=1 before oops in sysrq-c handler.

And some updates in documentation are included, to clarify that there is
no longer dependency with CONFIG_KEXEC, and that now the system can just
crash by sysrq-c if no dump mechanism is configured.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Brayan Arraes <brayan@yack.com.br>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    7 ++++---
 drivers/char/sysrq.c    |    8 +++++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff -puN Documentation/sysrq.txt~sysrq-kdump-make-sysrq-c-consistent Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~sysrq-kdump-make-sysrq-c-consistent
+++ a/Documentation/sysrq.txt
@@ -66,7 +66,8 @@ On all -  write a character to /proc/sys
 'b'     - Will immediately reboot the system without syncing or unmounting
           your disks.
 
-'c'	- Will perform a kexec reboot in order to take a crashdump.
+'c'	- Will perform a system crash by a NULL pointer dereference.
+          A crashdump will be taken if configured.
 
 'd'	- Shows all locks that are held.
 
@@ -141,8 +142,8 @@ useful when you want to exit a program t
 re'B'oot is good when you're unable to shut down. But you should also 'S'ync
 and 'U'mount first.
 
-'C'rashdump can be used to manually trigger a crashdump when the system is hung.
-The kernel needs to have been built with CONFIG_KEXEC enabled.
+'C'rash can be used to manually trigger a crashdump when the system is hung.
+Note that this just triggers a crash if there is no dump mechanism available.
 
 'S'ync is great when your system is locked up, it allows you to sync your
 disks and will certainly lessen the chance of data loss and fscking. Note
diff -puN drivers/char/sysrq.c~sysrq-kdump-make-sysrq-c-consistent drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-kdump-make-sysrq-c-consistent
+++ a/drivers/char/sysrq.c
@@ -35,7 +35,6 @@
 #include <linux/spinlock.h>
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
-#include <linux/kexec.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 
@@ -124,9 +123,12 @@ static struct sysrq_key_op sysrq_unraw_o
 static void sysrq_handle_crash(int key, struct tty_struct *tty)
 {
 	char *killer = NULL;
+
+	panic_on_oops = 1;	/* force panic */
+	wmb();
 	*killer = 1;
 }
-static struct sysrq_key_op sysrq_crashdump_op = {
+static struct sysrq_key_op sysrq_crash_op = {
 	.handler	= sysrq_handle_crash,
 	.help_msg	= "Crash",
 	.action_msg	= "Trigger a crash",
@@ -401,7 +403,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	 */
 	NULL,				/* a */
 	&sysrq_reboot_op,		/* b */
-	&sysrq_crashdump_op,		/* c & ibm_emac driver debug */
+	&sysrq_crash_op,		/* c & ibm_emac driver debug */
 	&sysrq_showlocks_op,		/* d */
 	&sysrq_term_op,			/* e */
 	&sysrq_moom_op,			/* f */
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

kexec-fix-omitting-offset-in-extended-crashkernel-syntax.patch
sysrq-kdump-make-sysrq-c-consistent.patch

