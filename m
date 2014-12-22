From: akpm@linux-foundation.org
Subject: + printk-correct-timeout-comment-neaten-module_parm_desc.patch
 added to -mm tree
Date: Mon, 22 Dec 2014 13:20:40 -0800
Message-ID: <54988b28.1Rjr69v2je80R/ao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaLVVUl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Dec 2014 16:20:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: correct timeout comment, neaten MODULE_PARM_DESC
has been added to the -mm tree.  Its filename is
     printk-correct-timeout-comment-neaten-module_parm_desc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-correct-timeout-comment-neaten-module_parm_desc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-correct-timeout-comment-neaten-module_parm_desc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: correct timeout comment, neaten MODULE_PARM_DESC

Neaten the MODULE_PARAM_DESC message.
Use 30 seconds in the comment for the zap console locks timeout.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/printk/printk.c~printk-correct-timeout-comment-neaten-module_parm_desc kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-correct-timeout-comment-neaten-module_parm_desc
+++ a/kernel/printk/printk.c
@@ -935,8 +935,8 @@ static int __init ignore_loglevel_setup(
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
 module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
-	"print all kernel messages to the console.");
+MODULE_PARM_DESC(ignore_loglevel,
+		 "ignore loglevel setting (prints all kernel messages to the console)");
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
@@ -1419,16 +1419,16 @@ static void call_console_drivers(int lev
 }
 
 /*
- * Zap console related locks when oopsing. Only zap at most once
- * every 10 seconds, to leave time for slow consoles to print a
- * full oops.
+ * Zap console related locks when oopsing.
+ * To leave time for slow consoles to print a full oops,
+ * only zap at most once every 30 seconds.
  */
 static void zap_locks(void)
 {
 	static unsigned long oops_timestamp;
 
 	if (time_after_eq(jiffies, oops_timestamp) &&
-			!time_after(jiffies, oops_timestamp + 30 * HZ))
+	    !time_after(jiffies, oops_timestamp + 30 * HZ))
 		return;
 
 	oops_timestamp = jiffies;
_

Patches currently in -mm which might be from joe@perches.com are

printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

