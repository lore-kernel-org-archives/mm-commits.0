From: akpm@linux-foundation.org
Subject: - ldisc-new-dcd_change-method-for-line-disciplines.patch removed from -mm tree
Date: Tue, 25 Nov 2008 17:04:11 -0800
Message-ID: <200811260104.mAQ14BQc030554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594AbYKZBGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@googlemail.comra


The patch titled
     ldisc: new dcd_change() method for line disciplines
has been removed from the -mm tree.  Its filename was
     ldisc-new-dcd_change-method-for-line-disciplines.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ldisc: new dcd_change() method for line disciplines
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/serial/tty.txt |    4 ++++
 include/linux/tty_ldisc.h    |   10 ++++++++++
 2 files changed, 14 insertions(+)

diff -puN Documentation/serial/tty.txt~ldisc-new-dcd_change-method-for-line-disciplines Documentation/serial/tty.txt
--- a/Documentation/serial/tty.txt~ldisc-new-dcd_change-method-for-line-disciplines
+++ a/Documentation/serial/tty.txt
@@ -100,6 +100,10 @@ write_wakeup()	-	May be called at any po
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
@@ -99,11 +99,19 @@
  *	cease I/O to the tty driver. Can sleep. The driver should
  *	seek to perform this action quickly but should wait until
  *	any pending driver I/O is completed.
+ *
+ * void (*dcd_change)(struct uart_port *port, unsigned int status,
+ * 			struct timespec *ts)
+ *
+ *	Tells the discipline that the DCD pin has changed its status and
+ *	the relative timestamp. Pointer ts can be NULL.
  */
 
 #include <linux/fs.h>
 #include <linux/wait.h>
 
+struct uart_port;
+
 struct tty_ldisc_ops {
 	int	magic;
 	char	*name;
@@ -136,6 +144,8 @@ struct tty_ldisc_ops {
 	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
+	void	(*dcd_change)(struct uart_port *, unsigned int,
+				struct timespec *);
 
 	struct  module *owner;
 	
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch

