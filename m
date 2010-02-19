From: akpm@linux-foundation.org
Subject: + ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:54:09 -0800
Message-ID: <201002192154.o1JLs9Wj006538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349Ab0BSVyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su


The patch titled
     ldisc n_tty: add new method n_tty_inherit_ops()
has been added to the -mm tree.  Its filename is
     ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch

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

 drivers/char/n_tty.c |    9 +++++++++
 include/linux/tty.h  |    1 +
 2 files changed, 10 insertions(+)

diff -puN drivers/char/n_tty.c~ldisc-n_tty-add-new-method-n_tty_inherit_ops drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~ldisc-n_tty-add-new-method-n_tty_inherit_ops
+++ a/drivers/char/n_tty.c
@@ -48,6 +48,7 @@
 #include <linux/audit.h>
 #include <linux/file.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 
@@ -2091,3 +2092,11 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };
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
@@ -504,6 +504,7 @@ extern void tty_ldisc_enable(struct tty_
 
 /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
+extern void n_tty_inherit_ops(struct tty_ldisc_ops *ops);
 
 /* tty_audit.c */
 #ifdef CONFIG_AUDIT
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch
pps-serial-clients-support.patch
pps-serial-clients-support-fix.patch
serial-8250-enable-pps-support.patch
serial-amba-pl010-enable-pps-support.patch

