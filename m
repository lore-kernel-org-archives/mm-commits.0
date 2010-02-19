From: akpm@linux-foundation.org
Subject: + ldisc-new-dcd_change-method-for-line-disciplines.patch added to -mm tree
Date: Fri, 19 Feb 2010 13:54:07 -0800
Message-ID: <201002192154.o1JLs7H3006535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351Ab0BSVy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 16:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su


The patch titled
     ldisc: new dcd_change() method for line disciplines
has been added to the -mm tree.  Its filename is
     ldisc-new-dcd_change-method-for-line-disciplines.patch

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
Subject: ldisc: new dcd_change() method for line disciplines
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/serial/tty.txt |    4 ++++
 include/linux/tty_ldisc.h    |    8 ++++++++
 2 files changed, 12 insertions(+)

diff -puN Documentation/serial/tty.txt~ldisc-new-dcd_change-method-for-line-disciplines Documentation/serial/tty.txt
--- a/Documentation/serial/tty.txt~ldisc-new-dcd_change-method-for-line-disciplines
+++ a/Documentation/serial/tty.txt
@@ -105,6 +105,10 @@ write_wakeup()	-	May be called at any po
 			is permitted to call the driver write method from
 			this function. In such a situation defer it.
 
+dcd_change()	-	Report to the tty line the current DCD pin status
+			changes and the relative timestamp. The timestamp
+			can be NULL.
+
 
 Driver Access
 
diff -puN include/linux/tty_ldisc.h~ldisc-new-dcd_change-method-for-line-disciplines include/linux/tty_ldisc.h
--- a/include/linux/tty_ldisc.h~ldisc-new-dcd_change-method-for-line-disciplines
+++ a/include/linux/tty_ldisc.h
@@ -99,6 +99,12 @@
  *	cease I/O to the tty driver. Can sleep. The driver should
  *	seek to perform this action quickly but should wait until
  *	any pending driver I/O is completed.
+ *
+ * void (*dcd_change)(struct tty_struct *tty, unsigned int status,
+ * 			struct timespec *ts)
+ *
+ *	Tells the discipline that the DCD pin has changed its status and
+ *	the relative timestamp. Pointer ts can be NULL.
  */
 
 #include <linux/fs.h>
@@ -136,6 +142,8 @@ struct tty_ldisc_ops {
 	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
+	void	(*dcd_change)(struct tty_struct *, unsigned int,
+				struct timespec *);
 
 	struct  module *owner;
 	
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

