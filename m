From: akpm@linux-foundation.org
Subject: [merged] printk-report-console-names-during-cut-over.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:14 -0800
Message-ID: <5283e3ae.rwNFjVV3/yu+wSWD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3KMUkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, joe@perches.com, gregkh@linuxfoundation.org, fweisbec@gmail.com, keescook@chromium.org

Subject: [merged] printk-report-console-names-during-cut-over.patch removed from -mm tree
To: keescook@chromium.org,fweisbec@gmail.com,gregkh@linuxfoundation.org,joe@perches.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:14 -0800


The patch titled
     Subject: printk: report console names during cut-over
has been removed from the -mm tree.  Its filename was
     printk-report-console-names-during-cut-over.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: printk: report console names during cut-over

This reports the names of consoles as they're being disabled to help
identify which is which during cut-over.  Helps answer the question "which
boot console actually got activated?" once the regular console is running,
mostly when debugging boot console failures.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
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

origin.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

