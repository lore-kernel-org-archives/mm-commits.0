From: akpm@linux-foundation.org
Subject: [merged] proc-tty-switch-stallion-to-proc_fops.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:33:43 -0700
Message-ID: <200904011833.n31IXhDc006852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762568AbZDASgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc tty: switch stallion to ->proc_fops
has been removed from the -mm tree.  Its filename was
     proc-tty-switch-stallion-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc tty: switch stallion to ->proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |  124 +++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 75 deletions(-)

diff -puN drivers/char/stallion.c~proc-tty-switch-stallion-to-proc_fops drivers/char/stallion.c
--- a/drivers/char/stallion.c~proc-tty-switch-stallion-to-proc_fops
+++ a/drivers/char/stallion.c
@@ -32,6 +32,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
+#include <linux/seq_file.h>
 #include <linux/cd1400.h>
 #include <linux/sc26198.h>
 #include <linux/comstats.h>
@@ -1379,52 +1380,47 @@ static void stl_sendxchar(struct tty_str
 		stl_putchar(tty, ch);
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
-static int stl_portinfo(struct stlport *portp, int portnr, char *pos)
+static void stl_portinfo(struct seq_file *m, struct stlport *portp, int portnr)
 {
-	char	*sp;
-	int	sigs, cnt;
+	int	sigs;
+	char sep;
 
-	sp = pos;
-	sp += sprintf(sp, "%d: uart:%s tx:%d rx:%d",
+	seq_printf(m, "%d: uart:%s tx:%d rx:%d",
 		portnr, (portp->hwid == 1) ? "SC26198" : "CD1400",
 		(int) portp->stats.txtotal, (int) portp->stats.rxtotal);
 
 	if (portp->stats.rxframing)
-		sp += sprintf(sp, " fe:%d", (int) portp->stats.rxframing);
+		seq_printf(m, " fe:%d", (int) portp->stats.rxframing);
 	if (portp->stats.rxparity)
-		sp += sprintf(sp, " pe:%d", (int) portp->stats.rxparity);
+		seq_printf(m, " pe:%d", (int) portp->stats.rxparity);
 	if (portp->stats.rxbreaks)
-		sp += sprintf(sp, " brk:%d", (int) portp->stats.rxbreaks);
+		seq_printf(m, " brk:%d", (int) portp->stats.rxbreaks);
 	if (portp->stats.rxoverrun)
-		sp += sprintf(sp, " oe:%d", (int) portp->stats.rxoverrun);
+		seq_printf(m, " oe:%d", (int) portp->stats.rxoverrun);
 
 	sigs = stl_getsignals(portp);
-	cnt = sprintf(sp, "%s%s%s%s%s ",
-		(sigs & TIOCM_RTS) ? "|RTS" : "",
-		(sigs & TIOCM_CTS) ? "|CTS" : "",
-		(sigs & TIOCM_DTR) ? "|DTR" : "",
-		(sigs & TIOCM_CD) ? "|DCD" : "",
-		(sigs & TIOCM_DSR) ? "|DSR" : "");
-	*sp = ' ';
-	sp += cnt;
-
-	for (cnt = sp - pos; cnt < (MAXLINE - 1); cnt++)
-		*sp++ = ' ';
-	if (cnt >= MAXLINE)
-		pos[(MAXLINE - 2)] = '+';
-	pos[(MAXLINE - 1)] = '\n';
-
-	return MAXLINE;
+	sep = ' ';
+	if (sigs & TIOCM_RTS) {
+		seq_printf(m, "%c%s", sep, "RTS");
+		sep = '|';
+	}
+	if (sigs & TIOCM_CTS) {
+		seq_printf(m, "%c%s", sep, "CTS");
+		sep = '|';
+	}
+	if (sigs & TIOCM_DTR) {
+		seq_printf(m, "%c%s", sep, "DTR");
+		sep = '|';
+	}
+	if (sigs & TIOCM_CD) {
+		seq_printf(m, "%c%s", sep, "DCD");
+		sep = '|';
+	}
+	if (sigs & TIOCM_DSR) {
+		seq_printf(m, "%c%s", sep, "DSR");
+		sep = '|';
+	}
+	seq_putc(m, '\n');
 }
 
 /*****************************************************************************/
@@ -1433,30 +1429,17 @@ static int stl_portinfo(struct stlport *
  *	Port info, read from the /proc file system.
  */
 
-static int stl_readproc(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int stl_proc_show(struct seq_file *m, void *v)
 {
 	struct stlbrd	*brdp;
 	struct stlpanel	*panelp;
 	struct stlport	*portp;
 	unsigned int	brdnr, panelnr, portnr;
-	int		totalport, curoff, maxoff;
-	char		*pos;
-
-	pr_debug("stl_readproc(page=%p,start=%p,off=%lx,count=%d,eof=%p,"
-		"data=%p\n", page, start, off, count, eof, data);
+	int		totalport;
 
-	pos = page;
 	totalport = 0;
-	curoff = 0;
 
-	if (off == 0) {
-		pos += sprintf(pos, "%s: version %s", stl_drvtitle,
-			stl_drvversion);
-		while (pos < (page + MAXLINE - 1))
-			*pos++ = ' ';
-		*pos++ = '\n';
-	}
-	curoff =  MAXLINE;
+	seq_printf(m, "%s: version %s\n", stl_drvtitle, stl_drvversion);
 
 /*
  *	We scan through for each board, panel and port. The offset is
@@ -1469,46 +1452,37 @@ static int stl_readproc(char *page, char
 		if (brdp->state == 0)
 			continue;
 
-		maxoff = curoff + (brdp->nrports * MAXLINE);
-		if (off >= maxoff) {
-			curoff = maxoff;
-			continue;
-		}
-
 		totalport = brdnr * STL_MAXPORTS;
 		for (panelnr = 0; panelnr < brdp->nrpanels; panelnr++) {
 			panelp = brdp->panels[panelnr];
 			if (panelp == NULL)
 				continue;
 
-			maxoff = curoff + (panelp->nrports * MAXLINE);
-			if (off >= maxoff) {
-				curoff = maxoff;
-				totalport += panelp->nrports;
-				continue;
-			}
-
 			for (portnr = 0; portnr < panelp->nrports; portnr++,
 			    totalport++) {
 				portp = panelp->ports[portnr];
 				if (portp == NULL)
 					continue;
-				if (off >= (curoff += MAXLINE))
-					continue;
-				if ((pos - page + MAXLINE) > count)
-					goto stl_readdone;
-				pos += stl_portinfo(portp, totalport, pos);
+				stl_portinfo(m, portp, totalport);
 			}
 		}
 	}
+	return 0;
+}
 
-	*eof = 1;
-
-stl_readdone:
-	*start = page;
-	return pos - page;
+static int stl_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, stl_proc_show, NULL);
 }
 
+static const struct file_operations stl_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= stl_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*****************************************************************************/
 
 /*
@@ -2566,9 +2540,9 @@ static const struct tty_operations stl_o
 	.break_ctl = stl_breakctl,
 	.wait_until_sent = stl_waituntilsent,
 	.send_xchar = stl_sendxchar,
-	.read_proc = stl_readproc,
 	.tiocmget = stl_tiocmget,
 	.tiocmset = stl_tiocmset,
+	.proc_fops = &stl_proc_fops,
 };
 
 static const struct tty_port_operations stl_port_ops = {
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

