From: akpm@linux-foundation.org
Subject: [merged] ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:12 -0400
Message-ID: <201003150704.o2F74jE4017035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759729Ab0COHFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     ldisc n_tty: add new method n_tty_inherit_ops()
has been removed from the -mm tree.  Its filename was
     ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ldisc n_tty: add new method n_tty_inherit_ops()
From: Rodolfo Giometti <giometti@linux.it>

This new method can be used to init a new struct tty_ldisc_ops as the
default tty_ldisc_N_TTY struct.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_tty.c |   17 +++++++++++++++++
 include/linux/tty.h  |    1 +
 2 files changed, 18 insertions(+)

diff -puN drivers/char/n_tty.c~ldisc-n_tty-add-new-method-n_tty_inherit_ops drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~ldisc-n_tty-add-new-method-n_tty_inherit_ops
+++ a/drivers/char/n_tty.c
@@ -48,6 +48,7 @@
 #include <linux/audit.h>
 #include <linux/file.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 
@@ -2091,3 +2092,19 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };
+
+/**
+ *	n_tty_inherit_ops	-	inherit N_TTY methods
+ *	@ops: struct tty_ldisc_ops where to save N_TTY methods
+ *
+ *	Used by a generic struct tty_ldisc_ops to easily inherit N_TTY
+ *	methods.
+ */
+
+void n_tty_inherit_ops(struct tty_ldisc_ops *ops)
+{
+	*ops = tty_ldisc_N_TTY;
+	ops->owner = NULL;
+	ops->refcount = ops->flags = 0;
+}
+EXPORT_SYMBOL_GPL(n_tty_inherit_ops);
diff -puN include/linux/tty.h~ldisc-n_tty-add-new-method-n_tty_inherit_ops include/linux/tty.h
--- a/include/linux/tty.h~ldisc-n_tty-add-new-method-n_tty_inherit_ops
+++ a/include/linux/tty.h
@@ -514,6 +514,7 @@ extern void tty_ldisc_enable(struct tty_
 
 /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
+extern void n_tty_inherit_ops(struct tty_ldisc_ops *ops);
 
 /* tty_audit.c */
 #ifdef CONFIG_AUDIT
_

Patches currently in -mm which might be from giometti@linux.it are

origin.patch

