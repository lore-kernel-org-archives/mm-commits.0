From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update.patch
 removed from -mm tree
Date: Tue, 02 Aug 2016 13:43:27 -0700
Message-ID: <57a105ef.46YRxMHsbSdzQuhs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbcHBUn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, dyoung@redhat.com, fbui@suse.com, gregkh@linuxfoundation.org, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, torvalds@linux-foundation.org, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update
has been removed from the -mm tree.  Its filename was
     printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update.patch

This patch was dropped because it was folded into printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update

Thanks for catching this, here's an updated 2/2 patch with the above
integrated and the SYSTEM_BOOTING check removed because we set
system_state to SYSTEM_RUNNING before we start init.

Link: http://lkml.kernel.org/r/20160719072344.GC25563@nazgul.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Dave Young <dyoung@redhat.com>
Cc: Franck Bui <fbui@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/printk/printk.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-add-kernel-parameter-to-control-writes-to-dev-kmsg-update
+++ a/kernel/printk/printk.c
@@ -117,8 +117,7 @@ static int __control_devkmsg(char *str)
 		devkmsg_log = DEVKMSG_LOG_MASK_DEFAULT;
 		return 9;
 	}
-	else
-		return -EINVAL;
+	return -EINVAL;
 }
 
 static int __init control_devkmsg(char *str)
@@ -741,8 +740,8 @@ static ssize_t devkmsg_write(struct kioc
 	if (devkmsg_log & DEVKMSG_LOG_MASK_OFF)
 		return len;
 
-	/* Ratelimit when not explicitly enabled or when we're not booting. */
-	if ((system_state != SYSTEM_BOOTING) && !(devkmsg_log & DEVKMSG_LOG_MASK_ON)) {
+	/* Ratelimit when not explicitly enabled. */
+	if (!(devkmsg_log & DEVKMSG_LOG_MASK_ON)) {
 		if (!___ratelimit(&user->rs, current->comm))
 			return ret;
 	}
_

Patches currently in -mm which might be from bp@suse.de are

fbdev-bfin_adv7393fb-move-driver_name-before-its-first-use.patch
ratelimit-extend-to-print-suppressed-messages-on-release.patch
printk-add-kernel-parameter-to-control-writes-to-dev-kmsg.patch

