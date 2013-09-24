From: akpm@linux-foundation.org
Subject: + printk-report-console-names-during-cut-over.patch added to -mm
 tree
Date: Tue, 24 Sep 2013 16:26:00 -0700
Message-ID: <52421f88.YrVoeQpLEGOQRkjr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3IXX0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, joe@perches.com, gregkh@linuxfoundation.org, fweisbec@gmail.com, keescook@chromium.org

Subject: + printk-report-console-names-during-cut-over.patch added to -mm tree
To: keescook@chromium.org,fweisbec@gmail.com,gregkh@linuxfoundation.org,joe@perches.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:26:00 -0700


The patch titled
     Subject: printk: report console names during cut-over
has been added to the -mm tree.  Its filename is
     printk-report-console-names-during-cut-over.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-report-console-names-during-cut-over.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-report-console-names-during-cut-over.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: printk: report console names during cut-over

This reports the names of consoles as they're being disabled to help
identify which is which during cut-over.  Helps answer the question "which
boot console actually got activated?" once the regular console is running,
mostly when debugging boot console failures.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/printk/printk.c~printk-report-console-names-during-cut-over kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-report-console-names-during-cut-over
+++ a/kernel/printk/printk.c
@@ -2358,21 +2358,18 @@ void register_console(struct console *ne
 	 * users know there might be something in the kernel's log buffer that
 	 * went to the bootconsole (that they do not see on the real console)
 	 */
+	printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+		(newcon->flags & CON_BOOT) ? "boot" : "" ,
+		newcon->name, newcon->index);
 	if (bcon &&
 	    ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
 	    !keep_bootcon) {
-		/* we need to iterate through twice, to make sure we print
-		 * everything out, before we unregister the console(s)
+		/* We need to iterate through all boot consoles, to make
+		 * sure we print everything out, before we unregister them.
 		 */
-		printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
-			newcon->name, newcon->index);
 		for_each_console(bcon)
 			if (bcon->flags & CON_BOOT)
 				unregister_console(bcon);
-	} else {
-		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
-			(newcon->flags & CON_BOOT) ? "boot" : "" ,
-			newcon->name, newcon->index);
 	}
 }
 EXPORT_SYMBOL(register_console);
@@ -2382,6 +2379,10 @@ int unregister_console(struct console *c
         struct console *a, *b;
 	int res;
 
+	printk(KERN_INFO "%sconsole [%s%d] disabled\n",
+		(console->flags & CON_BOOT) ? "boot" : "" ,
+		console->name, console->index);
+
 	res = _braille_unregister_console(console);
 	if (res)
 		return res;
@@ -2421,8 +2422,6 @@ static int __init printk_late_init(void)
 
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
-			printk(KERN_INFO "turn off boot console %s%d\n",
-				con->name, con->index);
 			unregister_console(con);
 		}
 	}
_

Patches currently in -mm which might be from keescook@chromium.org are

printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
gcov-add-support-for-gcc-47-gcov-format.patch
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-add-support-for-init_array-constructors.patch
kernel-add-support-for-init_array-constructors-fix.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch

