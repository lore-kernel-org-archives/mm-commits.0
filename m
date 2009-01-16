From: akpm@linux-foundation.org
Subject: [merged] sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:34 -0800
Message-ID: <200901161916.n0GJGYxB025076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758763AbZAPTQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     sysrq: add commentary on why we use the console loglevel over using KERN_EMERG
has been removed from the -mm tree.  Its filename was
     sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq: add commentary on why we use the console loglevel over using KERN_EMERG
From: Andy Whitcroft <apw@canonical.com>

Add an explanitory comment as to why we modify the kernel console loglevel
rather than simply moving sysrq messages to KERN_EMERG level.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/char/sysrq.c~sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg
+++ a/drivers/char/sysrq.c
@@ -473,6 +473,12 @@ void __handle_sysrq(int key, struct tty_
 	unsigned long flags;
 
 	spin_lock_irqsave(&sysrq_key_table_lock, flags);
+	/*
+	 * Raise the apparent loglevel to maximum so that the sysrq header
+	 * is shown to provide the user with positive feedback.  We do not
+	 * simply emit this at KERN_EMERG as that would change message
+	 * routing in the consumers of /proc/kmsg.
+	 */
 	orig_log_level = console_loglevel;
 	console_loglevel = 7;
 	printk(KERN_INFO "SysRq : ");
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
mmc-add-modalias-linkage-for-mmc-sd-devices.patch

