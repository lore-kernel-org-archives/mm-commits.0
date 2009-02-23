From: akpm@linux-foundation.org
Subject: [merged] pm-fix-suspend_console-resume_console-to-use-only-one-semaphore.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:07:07 -0800
Message-ID: <200902232007.n1NK77Mx013469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058AbZBWUH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:07:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arve@android.com, alan@lxorguk.ukuu.org.uk, pavel@ucw.cz, rjw@sisk.pl, swetland@google.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     pm: fix suspend_console/resume_console to use only one semaphore
has been removed from the -mm tree.  Its filename was
     pm-fix-suspend_console-resume_console-to-use-only-one-semaphore.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: pm: fix suspend_console/resume_console to use only one semapho=
re
=46rom: Arve Hj=F8nnev=E5g <arve@android.com>

This fixes a race if another thread acquired the console while it was
suspended and released it after it was resumed the secondary console
semaphre would be left locked, and the primary semaphore would be relea=
sed
twice.  This in turn caused the console switch on suspend or resume to
hang forever.

Note that suspend_console does not actually lock the console for client=
s
that use acquire_console_sem, it only locks it for clients that use
try_acquire_console_sem.  If we change suspend_console to fully lock th=
e
console, then the kernel may deadlock on suspend.

Signed-off-by: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/printk.c~pm-fix-suspend_console-resume_console-to-use-=
only-one-semaphore kernel/printk.c
--- a/kernel/printk.c~pm-fix-suspend_console-resume_console-to-use-only=
-one-semaphore
+++ a/kernel/printk.c
@@ -73,7 +73,6 @@ EXPORT_SYMBOL(oops_in_progress);
  * driver system.
  */
 static DECLARE_MUTEX(console_sem);
-static DECLARE_MUTEX(secondary_console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
=20
@@ -891,12 +890,14 @@ void suspend_console(void)
 	printk("Suspending console(s) (use no_console_suspend to debug)\n");
 	acquire_console_sem();
 	console_suspended =3D 1;
+	up(&console_sem);
 }
=20
 void resume_console(void)
 {
 	if (!console_suspend_enabled)
 		return;
+	down(&console_sem);
 	console_suspended =3D 0;
 	release_console_sem();
 }
@@ -912,11 +913,9 @@ void resume_console(void)
 void acquire_console_sem(void)
 {
 	BUG_ON(in_interrupt());
-	if (console_suspended) {
-		down(&secondary_console_sem);
-		return;
-	}
 	down(&console_sem);
+	if (console_suspended)
+		return;
 	console_locked =3D 1;
 	console_may_schedule =3D 1;
 }
@@ -926,6 +925,10 @@ int try_acquire_console_sem(void)
 {
 	if (down_trylock(&console_sem))
 		return -1;
+	if (console_suspended) {
+		up(&console_sem);
+		return -1;
+	}
 	console_locked =3D 1;
 	console_may_schedule =3D 0;
 	return 0;
@@ -979,7 +982,7 @@ void release_console_sem(void)
 	unsigned wake_klogd =3D 0;
=20
 	if (console_suspended) {
-		up(&secondary_console_sem);
+		up(&console_sem);
 		return;
 	}
=20
_

Patches currently in -mm which might be from arve@android.com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
