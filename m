From: akpm@linux-foundation.org
Subject: [merged] printk-git-rid-of-message-for-printk_deferred.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:07 -0700
Message-ID: <543d691b.gURyBb9i2WRRq85k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbaJNSTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markus@trippelsdorf.de, geert@linux-m68k.org, jack@suse.cz, peterz@infradead.org, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: git rid of [sched_delayed] message for printk_deferred
has been removed from the -mm tree.  Its filename was
     printk-git-rid-of-message-for-printk_deferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: printk: git rid of [sched_delayed] message for printk_deferred

Commit 458df9fd4815 ("printk: remove separate printk_sched buffers and use
printk buf instead") hardcodes printk_deferred() to KERN_WARNING and
inserts the string "[sched_delayed] " before the actual message.  However
it doesn't take into account the KERN_* prefix of the message, that now
ends up in the middle of the output:

 [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec

Fix this by just getting rid of the "[sched_delayed] " scnprintf().  The
prefix is useless since 458df9fd4815 anyway since from that moment
printk_deferred() inserts the message into the kernel printk buffer
immediately.  So if the message eventually gets printed to console, it is
printed in the correct order with other messages and there's no need for
any special prefix.  And if the kernel crashes before the message makes it
to console, then prefix in the printk buffer doesn't make the situation
any better.

Link: http://lkml.org/lkml/2014/9/14/4

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/printk/printk.c~printk-git-rid-of-message-for-printk_deferred kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-git-rid-of-message-for-printk_deferred
+++ a/kernel/printk/printk.c
@@ -1679,12 +1679,7 @@ asmlinkage int vprintk_emit(int facility
 	 * The printf needs to come first; we need the syslog
 	 * prefix which might be passed-in as a parameter.
 	 */
-	if (in_sched)
-		text_len = scnprintf(text, sizeof(textbuf),
-				     KERN_WARNING "[sched_delayed] ");
