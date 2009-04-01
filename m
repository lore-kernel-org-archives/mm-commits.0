From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-istallion-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:39 -0700
Message-ID: <200904011833.n31IXdjd006815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932346AbZDASg1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch istallion to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-istallion-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch istallion to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |  121 +++++++++++++++----------------------
 1 file changed, 52 insertions(+), 69 deletions(-)

diff -puN drivers/char/istallion.c~proc-tty-switch-istallion-to-proc_fops drivers/char/istallion.c
--- a/drivers/char/istallion.c~proc-tty-switch-istallion-to-proc_fops
+++ a/drivers/char/istallion.c
@@ -24,6 +24,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
+#include <linux/seq_file.h>
 #include <linux/cdk.h>
 #include <linux/comstats.h>
 #include <linux/istallion.h>
@@ -613,7 +614,6 @@ static int	stli_breakctl(struct tty_stru
 static void	stli_waituntilsent(struct tty_struct *tty, int timeout);
 static void	stli_sendxchar(struct tty_struct *tty, char ch);
 static void	stli_hangup(struct tty_struct *tty);
-static int	stli_portinfo(struct stlibrd *brdp, struct stliport *portp, int portnr, char *pos);
 
 static int	stli_brdinit(struct stlibrd *brdp);
 static int	stli_startbrd(struct stlibrd *brdp);
@@ -1893,20 +1893,10 @@ static void stli_sendxchar(struct tty_st
 	stli_cmdwait(brdp, portp, A_PORTCTRL, &actrl, sizeof(asyctrl_t), 0);
 }
 
-/*****************************************************************************/
-
-#define	MAXLINE		80
-
-/*
- *	Format info for a specified port. The line is deliberately limited
- *	to 80 characters. (If it is too long it will be truncated, if too
- *	short then padded with spaces).
- */
-
-static int stli_portinfo(struct stlibrd *brdp, struct stliport *portp, int portnr, char *pos)
+static void stli_portinfo(struct seq_file *m, struct stlibrd *brdp, struct stliport *portp, int portnr)
 {
-	char *sp, *uart;
-	int rc, cnt;
+	char *uart;
+	int rc;
 
 	rc = stli_portcmdstats(NULL, portp);
 
@@ -1918,44 +1908,50 @@ static int stli_portinfo(struct stlibrd 
 		default:uart = "CD1400"; break;
 		}
 	}
-
-	sp = pos;
-	sp += sprintf(sp, "%d: uart:%s ", portnr, uart);
+	seq_printf(m, "%d: uart:%s ", portnr, uart);
 
 	if ((brdp->state & BST_STARTED) && (rc >= 0)) {
-		sp += sprintf(sp, "tx:%d rx:%d", (int) stli_comstats.txtotal,
+		char sep;
+
+		seq_printf(m, "tx:%d rx:%d", (int) stli_comstats.txtotal,
 			(int) stli_comstats.rxtotal);
 
 		if (stli_comstats.rxframing)
-			sp += sprintf(sp, " fe:%d",
+			seq_printf(m, " fe:%d",
 				(int) stli_comstats.rxframing);
 		if (stli_comstats.rxparity)
-			sp += sprintf(sp, " pe:%d",
+			seq_printf(m, " pe:%d",
 				(int) stli_comstats.rxparity);
 		if (stli_comstats.rxbreaks)
-			sp += sprintf(sp, " brk:%d",
+			seq_printf(m, " brk:%d",
 				(int) stli_comstats.rxbreaks);
 		if (stli_comstats.rxoverrun)
-			sp += sprintf(sp, " oe:%d",
+			seq_printf(m, " oe:%d",
 				(int) stli_comstats.rxoverrun);
 
-		cnt = sprintf(sp, "%s%s%s%s%s ",
-			(stli_comstats.signals & TIOCM_RTS) ? "|RTS" : "",
-			(stli_comstats.signals & TIOCM_CTS) ? "|CTS" : "",
-			(stli_comstats.signals & TIOCM_DTR) ? "|DTR" : "",
-			(stli_comstats.signals & TIOCM_CD) ? "|DCD" : "",
-			(stli_comstats.signals & TIOCM_DSR) ? "|DSR" : "");
-		*sp = ' ';
-		sp += cnt;
-	}
-
-	for (cnt = (sp - pos); (cnt < (MAXLINE - 1)); cnt++)
-		*sp++ = ' ';
-	if (cnt >= MAXLINE)
-		pos[(MAXLINE - 2)] = '+';
-	pos[(MAXLINE - 1)] = '\n';
-
-	return(MAXLINE);
+		sep = ' ';
+		if (stli_comstats.signals & TIOCM_RTS) {
+			seq_printf(m, "%c%s", sep, "RTS");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_CTS) {
+			seq_printf(m, "%c%s", sep, "CTS");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_DTR) {
+			seq_printf(m, "%c%s", sep, "DTR");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_CD) {
+			seq_printf(m, "%c%s", sep, "DCD");
+			sep = '|';
+		}
+		if (stli_comstats.signals & TIOCM_DSR) {
+			seq_printf(m, "%c%s", sep, "DSR");
+			sep = '|';
+		}
+	}
+	seq_putc(m, '\n');
 }
 
 /*****************************************************************************/
@@ -1964,26 +1960,15 @@ static int stli_portinfo(struct stlibrd 
  *	Port info, read from the /proc file system.
  */
 
-static int stli_readproc(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int stli_proc_show(struct seq_file *m, void *v)
 {
 	struct stlibrd *brdp;
 	struct stliport *portp;
 	unsigned int brdnr, portnr, totalport;
-	int curoff, maxoff;
-	char *pos;
 
-	pos = page;
 	totalport = 0;
-	curoff = 0;
 
-	if (off == 0) {
-		pos += sprintf(pos, "%s: version %s", stli_drvtitle,
-			stli_drvversion);
-		while (pos < (page + MAXLINE - 1))
-			*pos++ = ' ';
-		*pos++ = '\n';
-	}
-	curoff =  MAXLINE;
+	seq_printf(m, "%s: version %s\n", stli_drvtitle, stli_drvversion);
 
 /*
  *	We scan through for each board, panel and port. The offset is
@@ -1996,33 +1981,31 @@ static int stli_readproc(char *page, cha
 		if (brdp->state == 0)
 			continue;
 
-		maxoff = curoff + (brdp->nrports * MAXLINE);
-		if (off >= maxoff) {
-			curoff = maxoff;
-			continue;
-		}
-
 		totalport = brdnr * STL_MAXPORTS;
 		for (portnr = 0; (portnr < brdp->nrports); portnr++,
 		    totalport++) {
 			portp = brdp->ports[portnr];
 			if (portp == NULL)
 				continue;
-			if (off >= (curoff += MAXLINE))
-				continue;
-			if ((pos - page + MAXLINE) > count)
-				goto stli_readdone;
-			pos += stli_portinfo(brdp, portp, totalport, pos);
+			stli_portinfo(m, brdp, portp, totalport);
 		}
 	}
+	return 0;
+}
 
-	*eof = 1;
-
-stli_readdone:
-	*start = page;
-	return(pos - page);
+static int stli_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stli_proc_show, NULL);
 }
 
+static const struct file_operations stli_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= stli_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*****************************************************************************/
 
 /*
@@ -4427,9 +4410,9 @@ static const struct tty_operations stli_
 	.break_ctl = stli_breakctl,
 	.wait_until_sent = stli_waituntilsent,
 	.send_xchar = stli_sendxchar,
-	.read_proc = stli_readproc,
 	.tiocmget = stli_tiocmget,
 	.tiocmset = stli_tiocmset,
+	.proc_fops = &stli_proc_fops,
 };
 
 static const struct tty_port_operations stli_port_ops = {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
sysctl-dont-take-the-use-count-of-multiple-heads-at-a-time.patch
sysctl-lockdep-support-for-sysctl-reference-counting.patch
simplify-copy_thread.patch
simplify-copy_thread-checkpatch-fixes.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch
sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

